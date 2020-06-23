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
library('rmarkdown')
library('knitr')

## @knitr allFunctions

## Whether to display observed and expected separately or as a difference (e.g. # missed diagnoses)
displayAsDifference <- FALSE;

DATA_DIRECTORY <- file.path(here(), '..','covid-health-data')
ALT_DATA_DIRECTORY <- file.path(here(), 'data-extraction', 'one-off-tasks')
OUTPUT_DIRECTORY <- file.path(here(), 'outputs') # this file needs creating on the local directory
OUTPUT_DATA_DIRECTORY <- file.path(here(), 'data-extraction', 'data')

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
getOutputVector <- function(data) {
  observed <- getSumOfMonths(data, 1)
  expected <- getSumOfMonths(data, 11)
  upperCI <- getSumOfMonths(data, 9)
  lowerCI <- getSumOfMonths(data, 10)
  decline <- round(100*(expected - observed) / expected,1)
  declineLowerCI <- round(100*(lowerCI - observed) / lowerCI,1)
  declineUpperCI <- round(100*(upperCI - observed) / upperCI,1)
  return(c(observed, expected, lowerCI, upperCI, decline, declineLowerCI, declineUpperCI))
}
getOutputVectorForMonth <- function(data, month) {
  observed <- data[which(data$month==month & data$year=="2020"),1]
  expected <- data[which(data$month==month & data$year=="2020"),11]
  upperCI <- data[which(data$month==month & data$year=="2020"),9]
  lowerCI <- data[which(data$month==month & data$year=="2020"),10]
  decline <- round(100*(expected - observed) / expected,1)
  declineLowerCI <- round(100*(lowerCI - observed) / lowerCI,1)
  declineUpperCI <- round(100*(upperCI - observed) / upperCI,1)
  return(c(observed, expected, lowerCI, upperCI, decline, declineLowerCI, declineUpperCI))
}

getFinalOutput <- function(data, descriptionForPlotTitles) {
  output <- getOutputVector(data)
  observed <- output[1]
  expected <- output[2]
  lowerCI <- output[3]
  upperCI <- output[4]
  decline <- format(output[5], nsmall = 1)
  declineLowerCI <- format(output[6], nsmall = 1)
  declineUpperCI <- format(output[7], nsmall = 1)
  return(paste0('We observed ', observed, ' first diagnoses of ',descriptionForPlotTitles,' whilst expecting ', round(expected,0) ,' (95% CI: ',round(lowerCI,0),' to ',round(upperCI,0),') based on preceding years, a decline of ',decline,'% (95% CI: ',declineLowerCI,'% to ',declineUpperCI,'%)'))
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
  print(getFinalOutput(data, descriptionForPlotTitles))
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

processData <- function(filename, isOneOffData = FALSE) {
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
  
  # Remove incomplete months at the extremes
  dat3 <- dat1[!((dat1$month=="06" & dat1$year== "2020") | (dat1$month=="12" & dat1$year== "2009")),]
  dat3$t <- 1:length(dat3$month)
  dat3$month <- as.factor(dat3$month)
  dat3 <- as.data.frame(dat3) %>% select(inc, month, t, year)
  dat3$date <- as.Date(as.yearmon(paste(as.numeric(as.character(dat3$year)), as.numeric(as.character(dat3$month)),sep="-")))
  
  return(dat3)
}

fitModel <- function(allData) {
  # Remove data from March 2020 onwards
  modelData <- head(allData, -3)
  
  ## Fit the model, predict the outcomes
  fit <- glm.nb(inc~ month + t, data = modelData) # could use offset as number of consultations each month
  
  allData <- cbind(allData, predict(fit, allData, type = "link", se.fit=TRUE))
  allData <- within(allData, {
    pred <- exp(fit)
    LL <- exp(fit - 1.96 * se.fit)
    UL <- exp(fit + 1.96 * se.fit)
  })
  return(allData)
}

saveChart <- function(plot, descriptionForPlotTitles, fileSuffix = "inc_10_20.png") {
  ggsave(plot=plot+ expand_limits(y = 0), path=OUTPUT_DIRECTORY, filename = paste(descriptionForPlotTitles,fileSuffix))
}

saveWithTitle <- function(plot, yLabel, descriptionForPlotTitles) {
  plot <- plot +
    labs(x = "Time (month/year)", y = yLabel, color = "Year", title = paste("Predicted and observed incidence of", descriptionForPlotTitles,"condition in 2019 and 2020"))
  
  ggsave(plot+ expand_limits(y = 0), path=OUTPUT_DIRECTORY, filename = paste(descriptionForPlotTitles,"inc_19_20_with_title.png"), width=8, dpi=300)
}

plotChart <- function(allData, descriptionForPlotTitles, yLabel, justLastTwoYears = FALSE) {
  if(justLastTwoYears) {
    g2 <- allData %>% filter(year=="2020" | year=="2019") %>% ggplot(aes(x=date, y=inc))  + geom_line(aes(x=date, y=inc, color = "Observed")) +
      geom_ribbon(aes(ymax = UL, ymin = LL), alpha= 0.1) +
      geom_line(aes(x=date, y=pred, color= "Predicted")) +
      labs(x = "Time (month/year)", y = yLabel, color = "Year", title = "") +
      theme_light() +
      scale_colour_manual(name=NULL, values = c("blue", "black")) +
      scale_x_date(labels = date_format("%m/%Y"), date_breaks = "2 months") +
      theme(legend.position = "bottom")
    g2
    return(g2)
  } else {
    g1 <- allData  %>% ggplot(aes(x=date, y=inc))  + geom_line(aes(x=date, y=inc, color = "Observed")) + 
      geom_ribbon(aes(ymax = UL, ymin = LL), alpha= 0.1) +  
      geom_line(aes(x=date, y=pred, color= "Predicted")) +
      labs(x = "Time (month/year)", y = yLabel, color = "Year", title = "") + 
      theme_light() +
      scale_colour_manual(name=NULL, values = c("blue", "black")) +
      scale_x_date(labels = date_format("%m/%Y"), breaks = "12 months") +
      theme(legend.position = "bottom")
    g1
    return(g1)
  }
}

updateTable <- function(allData,descriptionForPlotTitles) {
  output <- getOutputVector(allData)
  outputMarch <- getOutputVectorForMonth(allData, "03")
  outputApril <- getOutputVectorForMonth(allData, "04")
  outputMay <- getOutputVectorForMonth(allData, "05")
  outputTableMatrixAll <<- rbind(outputTableMatrixAll, c(descriptionForPlotTitles,round(output[2]), paste(round(output[3]), 'to', round(output[4])), output[1], paste0(format(output[5], nsmall = 1), '%'), paste0(format(output[6], nsmall = 1),'% to ',format(output[7], nsmall = 1),'%'))) 
  outputTableMatrixMarch <<- rbind(outputTableMatrixMarch, c(descriptionForPlotTitles,round(outputMarch[2]), paste(round(outputMarch[3]), 'to', round(outputMarch[4])), outputMarch[1], paste0(format(outputMarch[5], nsmall = 1), '%'), paste0(format(outputMarch[6], nsmall = 1),'% to ',format(outputMarch[7], nsmall = 1),'%'))) 
  outputTableMatrixApril <<- rbind(outputTableMatrixApril, c(descriptionForPlotTitles,round(outputApril[2]), paste(round(outputApril[3]), 'to', round(outputApril[4])), outputApril[1], paste0(format(outputApril[5], nsmall = 1), '%'), paste0(format(outputApril[6], nsmall = 1),'% to ',format(outputApril[7], nsmall = 1),'%'))) 
  outputTableMatrixMay <<- rbind(outputTableMatrixMay, c(descriptionForPlotTitles,round(outputMay[2]), paste(round(outputMay[3]), 'to', round(outputMay[4])), outputMay[1], paste0(format(outputMay[5], nsmall = 1), '%'), paste0(format(outputMay[6], nsmall = 1),'% to ',format(outputMay[7], nsmall = 1),'%'))) 
}

writeRedactedData <- function(data, filename) {
  redacted <- data %>% select(date, inc)
  redacted$inc[redacted$inc < 10] <- 0
  write.table(redacted, file.path(OUTPUT_DATA_DIRECTORY, filename), append = FALSE, sep = "\t", dec = ".", row.names = FALSE, col.names = TRUE)
}

processFile <- function (filename, descriptionForPlotTitles, yLabel, isOneOffData = FALSE) {
  
  # filename<-'dx-diabetes-t2dm.txt'
  # isOneOffData = FALSE
  
  allData <- processData(filename, isOneOffData = isOneOffData)
  writeRedactedData(allData, filename)
  allData <- fitModel(allData)
  
  ## Plot and save 
  plot1 <- plotChart(allData, descriptionForPlotTitles, yLabel)
  plot2 <- plotChart(allData, descriptionForPlotTitles, yLabel, justLastTwoYears = TRUE)
  saveChart(plot1, descriptionForPlotTitles)
  saveChart(plot2, descriptionForPlotTitles, fileSuffix = "inc_19_20.png")
  saveWithTitle(plot1, yLabel, descriptionForPlotTitles)

  allData$test <- paste( eval(round(allData$pred,3)), "(CI:",eval(round(allData$LL,3)), "-",eval(round(allData$UL,3)),")")

  print(descriptionForPlotTitles)
  if(displayAsDifference) {
    print(c("Month", "Missed Diagnoses", "LowerCI", "UpperCI"))  
  } else {
    print(c("Month", "Observed", "Expected", "LowerCI", "UpperCI"))    
  }
  displayOutputForMonth(allData, "03")
  displayOutputForMonth(allData, "04")
  displayOutputForMonth(allData, "05")
  displayTotal(allData,descriptionForPlotTitles);
  updateTable(allData,descriptionForPlotTitles);
}

initialiseTable <- function() {
  outputTableMatrixAll <<- matrix(nrow = 0, ncol = 6)
  outputTableMatrixMarch <<- matrix(nrow = 0, ncol = 6)
  outputTableMatrixApril <<- matrix(nrow = 0, ncol = 6)
  outputTableMatrixMay <<- matrix(nrow = 0, ncol = 6)
}

finaliseTableAll <- function() {
  colnames(outputTableMatrixAll) <- c(
    "First Diagnosis / Prescription",
    "Expected cases (March – May 2020)",
    "95% confidence interval for expected cases",
    "Observed cases (March – May 2020)",
    "Reduction in observed cases compared with expected",
    "95% confidence interval for reduction in observed cases"
  )
  outputTable <- as.table(outputTableMatrixAll)
  return(outputTable)
}
finaliseTableMarch <- function() {
  colnames(outputTableMatrixMarch) <- c(
    "First Diagnosis / Prescription",
    "Expected cases (March 2020)",
    "95% confidence interval for expected cases",
    "Observed cases (March 2020)",
    "Reduction in observed cases compared with expected",
    "95% confidence interval for reduction in observed cases"
  )
  outputTable <- as.table(outputTableMatrixMarch)
  return(outputTable)
}
finaliseTableApril <- function() {
  colnames(outputTableMatrixApril) <- c(
    "First Diagnosis / Prescription",
    "Expected cases (April 2020)",
    "95% confidence interval for expected cases",
    "Observed cases (April 2020)",
    "Reduction in observed cases compared with expected",
    "95% confidence interval for reduction in observed cases"
  )
  outputTable <- as.table(outputTableMatrixApril)
  return(outputTable)
}
finaliseTableMay <- function() {
  colnames(outputTableMatrixMay) <- c(
    "First Diagnosis / Prescription",
    "Expected cases (May 2020)",
    "95% confidence interval for expected cases",
    "Observed cases (May 2020)",
    "Reduction in observed cases compared with expected",
    "95% confidence interval for reduction in observed cases"
  )
  outputTable <- as.table(outputTableMatrixMay)
  return(outputTable)
}

## @knitr ignoreThese

initialiseTable()
processFile('dx-diabetes-t2dm.txt', 'Type 2 Diabetes', yLabel='Frequency of first diagnosis')
processFile('dx--metformin.txt', 'Metformin', yLabel='Frequency of first prescription')
processFile('dx-GROUP-circulatory-system.txt', 'Circulatory System Diseases', yLabel='Frequency of first diagnosis')
processFile('dx--aspirin-75.txt', 'Aspirin 75mg', yLabel='Frequency of first prescription')
processFile('dx--ccbs.txt', 'CCB', yLabel='Frequency of first prescription')
processFile('dx--acei.txt', 'ACE Inhibitors', yLabel='Frequency of first prescription')
processFile('dx--clopidogrel.txt', 'Clopidogrel', yLabel='Frequency of first prescription')
processFile('dx-GROUP-mental-health-mild-moderate.txt', 'Common mental health problems', yLabel='Frequency of first diagnosis')
processFile('dx--ssri.txt', 'SSRI', yLabel='Frequency of first prescription')
processFile('dx-GROUP-cancer.txt', 'Malignant cancer', yLabel='Frequency of first diagnosis')
print(finaliseTableAll())
print(finaliseTableMarch())
print(finaliseTableApril())
print(finaliseTableMay())

processFile('all_since_2010.txt', 'All clinical codes', yLabel='Frequency', isOneOffData = TRUE)
processFile('all_medications_since_2010_no_duplicates.txt', 'Prescriptions', yLabel='Frequency', isOneOffData = TRUE)
processFile('all_diagnoses_since_2010_no_duplicates.txt', 'Diagnoses', yLabel='Frequency', isOneOffData = TRUE)

rmarkdown::render(file.path(here(), 'Analysis', 'supp-material.Rmd'), output_dir = OUTPUT_DIRECTORY)
