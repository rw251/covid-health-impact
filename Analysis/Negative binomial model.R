library(MASS)
library(dplyr)
library(conflicted)
conflict_prefer("select", "dplyr")
conflict_prefer("filter", "dplyr")
library(here)
library(ggplot2)
library(scales)
library(zoo)
library(readr)

here()

## Whether to display observed and expected separately or as a difference (e.g. # missed diagnoses)
displayAsDifference <- FALSE;

DATA_DIRECTORY <- file.path(here(), 'data-extraction', 'data/')
ALT_DATA_DIRECTORY <- file.path(here(), 'data-extraction', 'one-off-tasks/')
OUTPUT_DIRECTORY <- file.path(here(), 'outputs') # this file needs creating on the local directory

getRawOutputForMonth <- function(data, month) {
  if(displayAsDifference) {
    return (c(
      as.numeric(month),
      data[which(data$month==month & data$year=="2020"),11] - data[which(data$month==month & data$year=="2020"),1],
      data[which(data$month==month & data$year=="2020"),10] - data[which(data$month==month & data$year=="2020"),1],
      data[which(data$month==month & data$year=="2020"),9] - data[which(data$month==month & data$year=="2020"),1]
    )
    )
  } else {
    return (c(
      as.numeric(month),
      data[which(data$month==month & data$year=="2020"),1],
      round(data[which(data$month==month & data$year=="2020"),11], 0),
      round(data[which(data$month==month & data$year=="2020"),10], 0),
      round(data[which(data$month==month & data$year=="2020"),9], 0)
      )
    )
  }
}
getSumOfMonths <- function(data, column) {
  return(data[which(data$month=="03" & data$year=="2020"),column]+data[which(data$month=="04" & data$year=="2020"),column]+data[which(data$month=="05" & data$year=="2020"),column])
}
getFinalOutput <- function(data, descriptionForPlotTitles) {
  observed <- getSumOfMonths(data, 1)
  expected <- getSumOfMonths(data, 11)
  upperCI <- getSumOfMonths(data, 9)
  lowerCI <- getSumOfMonths(data, 10)
  decline <- format(round(100*(expected - observed) / expected,1), nsmall = 1)
  declineLowerCI <- format(round(100*(lowerCI - observed) / lowerCI,1), nsmall = 1)
  declineUpperCI <- format(round(100*(upperCI - observed) / upperCI,1), nsmall = 1)
  print(paste0('we observed ', observed, ' first diagnoses of ',descriptionForPlotTitles,' whilst expecting ', round(expected,0) ,' (95% CI: ',round(lowerCI,0),' to ',round(upperCI,0),') based on preceding years, a decline of ',decline,'% (95% CI: ',declineLowerCI,'% to ',declineUpperCI,'%)'))
}
getRoundedOutputForMonth <- function(data, month, digits = 0) {
  return(round(getRawOutputForMonth(data, month), digits = digits))
}
displayOutputForMonth <- function(data, month) {
  print(getRoundedOutputForMonth(data, month))
}
displayTotal <- function(data, descriptionForPlotTitles) {
  print(
    round(getRawOutputForMonth(data, "03") + getRawOutputForMonth(data, "04") + getRawOutputForMonth(data, "05"),0)
  )
  print(
      (data[which(data$month=="03" & data$year=="2020"),1] +
       data[which(data$month=="04" & data$year=="2020"),1] +
       data[which(data$month=="05" & data$year=="2020"),1]) / 
      (data[which(data$month=="03" & data$year=="2020"),11] +
       data[which(data$month=="04" & data$year=="2020"),11] +
       data[which(data$month=="05" & data$year=="2020"),11])
  )
  getFinalOutput(data, descriptionForPlotTitles)
}

getData <- function(filename) {
  dat <- read.delim(file.path(DATA_DIRECTORY,filename), sep = ',')
  
  #### Process data
  dat$inc <- dat[,2] # this should be the incidence variable (make sure incidence is always second)
  dat <- dat[,-c(2,3)]
  dat$Date <- as.Date(as.character(dat$Date), format = "%Y-%m-%d") # read date variable as dates rather than text
  return(dat)
}

getOneOffData <- function(filename) {
  # filename <- 'all_since_2010.txt'
  dat <- read.delim(file.path(ALT_DATA_DIRECTORY,filename), sep = '\t', col.names = c('Date', 'inc'), header = FALSE)
  
  #### Process data
  dat$Date <- as.Date(as.character(dat$Date), format = "%Y%m%d") # read date variable as dates rather than text
  dat <- dat[dat$Date < "2020-06-08", ]
  return(dat)
}

processFile <- function (filename, descriptionForPlotTitles, yLabel, isOneOffData = FALSE) {

  if(isOneOffData) {
    dat <- getOneOffData(filename)
  } else {
    dat <- getData(filename)
  }

  dat <- dat %>%
    mutate(
      year = substr(Date,  1, 4),
      month = substr(Date,  6, 7),
      day = substr(Date, 9, 10)) 
  
  dat1 <- dat %>% group_by(year, month) %>% summarise(n=n(), inc = sum(inc))
  
  
  # Remove data from March 2020 onwards
  dat2<-dat1[!(dat1$month== "03" & dat1$year== "2020"| dat1$month== "04" & dat1$year== "2020" | 
                 dat1$month== "05" & dat1$year== "2020" | dat1$month== "06" & dat1$year== "2020"),]
  dat2 <- dat2[-1,]
  
  # add time variable
  dat2$t <- 1:length(dat2$month)
  dat2$month <- as.factor(dat2$month)
  
  # Exclude months at extremes
  dat3<-dat1[!((dat1$month=="06" & dat1$year== "2020") | (dat1$month=="12" & dat1$year== "2009")),]
  dat3$t <- 1:length(dat3$month)
  dat3$month <- as.factor(dat3$month)
  dat3$t <- 1:length(dat3$month)
  
  dat2 <- as.data.frame(dat2)
  dat3 <- as.data.frame(dat3[-length(dat3$month)-1,])
  d1 <- dat2 %>% select(inc, month, t, year) 
  d2 <- dat3 %>% select(inc, month, t, year) 
  d2$date <- as.Date(as.yearmon(paste(as.numeric(as.character(d2$year)), as.numeric(as.character(d2$month)),sep="-")))
  
  ## Fit the model, predict the outcomes
  fit <- glm.nb(inc~ month + t, data = d1) # could use offset as number of consultations each month
  
  d2 <- cbind(d2, predict(fit, d2, type = "link", se.fit=TRUE))
  d2 <- within(d2, {
    pred <- exp(fit)
    LL <- exp(fit - 1.96 * se.fit)
    UL <- exp(fit + 1.96 * se.fit)
  })
  
  ## Plot and save 
  g1 <- d2  %>% ggplot(aes(x=date, y=inc))  + geom_line(aes(x=date, y=inc, color = "Observed")) + 
    geom_ribbon(aes(ymax = UL, ymin = LL), alpha= 0.1) +  
    geom_line(aes(x=date, y=pred, color= "Predicted")) +
    labs(x = "Time (month/year)", y = 'yLabel', color = "Year", title = paste("Predicted and observed incidence of", 'descriptionForPlotTitles',"between 2010 and 2020")) + 
    theme_light() +
    scale_colour_manual(name=NULL, values = c("blue", "black")) +
    scale_x_date(labels = date_format("%m/%Y"), breaks = "12 months")
  g1
  
  ggsave(plot=g1+ expand_limits(y = 0), path=OUTPUT_DIRECTORY, filename = paste(descriptionForPlotTitles,"inc_10_20.png"))
  
   g2 <- d2 %>% filter(year=="2020" | year=="2019") %>% ggplot(aes(x=date, y=inc))  + geom_line(aes(x=date, y=inc, color = "Observed")) +
     geom_ribbon(aes(ymax = UL, ymin = LL), alpha= 0.1) +
     geom_line(aes(x=date, y=pred, color= "Predicted")) +
     labs(x = "Time (month/year)", y = 'yLabel', color = "Year", title = "") +
     theme_light() +
     scale_colour_manual(name=NULL, values = c("blue", "black")) +
     scale_x_date(labels = date_format("%m/%Y"), date_breaks = "2 months")
   g2
  
   ggsave(g2+ expand_limits(y = 0), path=OUTPUT_DIRECTORY, filename = paste(descriptionForPlotTitles,"inc_19_20.png"), width=8, dpi=300)
   
   g2 <- g2 +
    labs(x = "Time (month/year)", y = yLabel, color = "Year", title = paste("Predicted and observed incidence of", descriptionForPlotTitles,"condition in 2019 and 2020"))
   
   ggsave(g2+ expand_limits(y = 0), path=OUTPUT_DIRECTORY, filename = paste(descriptionForPlotTitles,"inc_19_20_with_title.png"), width=8, dpi=300)

  d2$test <- paste( eval(round(d2$pred,3)), "(CI:",eval(round(d2$LL,3)), "-",eval(round(d2$UL,3)),")")

  print(descriptionForPlotTitles)
  if(displayAsDifference) {
    print(c("Month", "Missed Diagnoses", "LowerCI", "UpperCI"))  
  } else {
    print(c("Month", "Observed", "Expected", "LowerCI", "UpperCI"))    
  }
  displayOutputForMonth(d2, "03")
  displayOutputForMonth(d2, "04")
  displayOutputForMonth(d2, "05")
  displayTotal(d2,descriptionForPlotTitles);
}

processFile('dx-diabetes-t2dm.txt', 'Type 2 Diabetes', yLabel='Frequency of first diagnosis')
processFile('dx--metformin.txt', 'Metformin', yLabel='Frequency of first prescription')
processFile('dx-GROUP-circulatory-system.txt', 'Circulatory System Diseases', yLabel='Frequency of first diagnosis')
processFile('dx--aspirin-75.txt', 'Aspirin 75mg', yLabel='Frequency of first prescription')
processFile('dx--ccbs.txt', 'CCB', yLabel='Frequency of first prescription')
processFile('dx--acei.txt', 'ACE Inhibitors', yLabel='Frequency of first prescription')
processFile('dx--clopidogrel.txt', 'Clopidogrel', yLabel='Frequency of first prescription')
processFile('dx-GROUP-mental-health-mild-moderate.txt', 'Moderate mental illnesses', yLabel='Frequency of first diagnosis')
processFile('dx--ssri.txt', 'SSRI', yLabel='Frequency of first prescription')
processFile('dx-GROUP-cancer.txt', 'Malignant cancer', yLabel='Frequency of first diagnosis')

processFile('all_since_2010.txt', 'All clinical codes', yLabel='Frequency', isOneOffData = TRUE)
processFile('all_medications_since_2010_no_duplicates.txt', 'Prescriptions', yLabel='Frequency', isOneOffData = TRUE)
processFile('all_diagnoses_since_2010_no_duplicates.txt', 'Diagnoses', yLabel='Frequency', isOneOffData = TRUE)