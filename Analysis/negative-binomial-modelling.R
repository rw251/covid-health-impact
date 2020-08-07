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
library('svglite')
library('ciTools')

# Need to change the following if updating
dateForAnalysisAsString<-"2020-06-01" # Must be 1st of a month

## @knitr allFunctions
dateForAnalysis<-as.Date(dateForAnalysisAsString, format='%Y-%m-%d')
analysisYearAsString<-format(dateForAnalysis, '%Y')
analysisYear<-as.numeric(analysisYearAsString)
lastYear<-analysisYear - 1
lastYearAsString<-toString(lastYear)
analysisMonthAsString<-format(dateForAnalysis, '%m')
analysisMonth<-as.numeric(analysisMonthAsString)

analysisYearMarch = as.Date(paste0(analysisYearAsString,"-03-01"))
monthsMarchToAnalysisData<-head(seq(analysisYearMarch, dateForAnalysis, by="months"),-1)

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
      data[which(data$month==month & data$year==analysisYearAsString),11] - data[which(data$month==month & data$year==analysisYearAsString),1],
      data[which(data$month==month & data$year==analysisYearAsString),10] - data[which(data$month==month & data$year==analysisYearAsString),1],
      data[which(data$month==month & data$year==analysisYearAsString),9] - data[which(data$month==month & data$year==analysisYearAsString),1]
    )
    )
  } else {
    return (c(
      as.numeric(month),
      data[which(data$month==month & data$year==analysisYearAsString),1],
      round(data[which(data$month==month & data$year==analysisYearAsString),11], 0),
      round(data[which(data$month==month & data$year==analysisYearAsString),10], 0),
      round(data[which(data$month==month & data$year==analysisYearAsString),9], 0)
      )
    )
  }
}
getSumOfMonths <- function(data, column) {
  tot <- 0
  for(i in seq_along(monthsMarchToAnalysisData)) {
    monthAsString <- format(monthsMarchToAnalysisData[i],'%m')
    tot <- tot + data[which(data$month==monthAsString & data$year==analysisYearAsString),column]
  }
  return(tot)
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
  observed <- data[which(data$month==month & data$year==analysisYearAsString),1]
  expected <- data[which(data$month==month & data$year==analysisYearAsString),11]
  upperCI <- data[which(data$month==month & data$year==analysisYearAsString),9]
  lowerCI <- data[which(data$month==month & data$year==analysisYearAsString),10]
  decline <- round(100*(expected - observed) / expected,1)
  declineLowerCI <- round(100*(lowerCI - observed) / lowerCI,1)
  declineUpperCI <- round(100*(upperCI - observed) / upperCI,1)
  return(c(observed, expected, lowerCI, upperCI, decline, declineLowerCI, declineUpperCI))
}
getRoundedOutputForMonth <- function(data, month, digits = 0) {
  return(round(getRawOutputForMonth(data, month), digits = digits))
}

getData <- function(filename) {
  dat <- read.delim(file.path(DATA_DIRECTORY,filename), sep = ',')
  
  #### Process data
  dat$inc <- dat[,2] # this should be the incidence variable (make sure incidence is always second)
  dat <- dat[,-c(2,3)]
  dat$Date <- as.Date(as.character(dat$Date), format = "%Y-%m-%d") # read date variable as dates rather than text
  dat <- dat %>% filter(Date <= dateForAnalysis)
  return(dat)
}

getOneOffData <- function(filename) {
  # filename <- 'all_since_2010.txt'
  dat <- read.delim(file.path(ALT_DATA_DIRECTORY,filename), sep = '\t', col.names = c('Date', 'inc'), header = FALSE)
  
  #### Process data
  dat$Date <- as.Date(as.character(dat$Date), format = "%Y%m%d") # read date variable as dates rather than text
  dat <- dat[dat$Date < dateForAnalysisAsString, ]
  return(dat)
}

processData <- function(filename, isOneOffData = FALSE) {
  if(isOneOffData) {
    dat <- getOneOffData(filename)
  } else {
    # filename<-'dx-diabetes-t2dm.txt'
    dat <- getData(filename)
  }
  
  dat <- dat %>%
    mutate(
      year = substr(Date,  1, 4),
      month = substr(Date,  6, 7),
      day = substr(Date, 9, 10)) 
  
  dat1 <- dat %>% group_by(year, month) %>% summarise(n=n(), inc = sum(inc))
  
  # Remove incomplete months at the extremes
  dat3 <- dat1[!((dat1$month==analysisMonthAsString & dat1$year== analysisYearAsString) | (dat1$month=="12" & dat1$year== "2009")),]
  dat3$t <- 1:length(dat3$month)
  dat3$month <- as.factor(dat3$month)
  dat3 <- as.data.frame(dat3) %>% select(inc, month, t, year)
  dat3$date <- as.Date(as.yearmon(paste(as.numeric(as.character(dat3$year)), as.numeric(as.character(dat3$month)),sep="-")))
  
  return(dat3)
}

fitModel <- function(allData) {
  # Remove data from March 2020 onwards
  modelData <- head(allData, 3 - analysisMonth)
  
  # old
  # fit <- glm.nb(inc~ month + t, data = modelData) # could use offset as number of consultations each month
  # 
  # allData <- cbind(allData, predict(fit, allData, type = "link", se.fit=TRUE))
  # allData <- within(allData, {
  #   pred <- exp(fit)
  #   LL <- exp(fit - 1.96 * se.fit)
  #   UL <- exp(fit + 1.96 * se.fit)
  # })
  
  # Fit the model, predict the outcomes
  fit <- glm.nb(inc~ as.factor(month) + t, data = modelData) # could use offset as number of consultations each month

  allData <- cbind(allData, predict(fit, allData, type="response", se.fit = TRUE, interval= "prediction")) # Use type as reponse saves exponentiating later
  allData <- within(allData, {
    pred <- fit
  })
  allData <- add_pi(allData, fit, names = c("LL", "UL"))
  
  ## Data wrangling for ggplot
  altData<-allData
  altData$val<-altData$pred
  allData$val<-allData$inc
  altData$line <- ''
  allData$line <- 'expected'
  allData<-rbind(allData,altData)
  allData$CI<-'95% confidence interval on expected value'
  
  return(allData)
}

saveChart <- function(plot, descriptionForPlotTitles, fileSuffix = "inc_10_20.svg") {
  ggsave(plot=plot+ expand_limits(y = 0), path=OUTPUT_DIRECTORY, filename = paste(descriptionForPlotTitles,fileSuffix))
}

saveWithTitle <- function(plot, yLabel, descriptionForPlotTitles) {
  plot <- plot +
    labs(x = "Time (month/year)", y = yLabel, color = "Year", title = paste("Expected and observed incidence of", descriptionForPlotTitles,"condition in",lastYearAsString,"and",analysisYearAsString))
  
  ggsave(plot+ expand_limits(y = 0), path=OUTPUT_DIRECTORY, filename = paste(descriptionForPlotTitles,"inc_19_20_with_title.svg"), width=8, dpi=300)
}

## Testing in RStudio
# myData <- processData('dx-diabetes-t2dm.txt', isOneOffData = FALSE)
# myData <- fitModel(myData)
# plotChart(myData, 'Type 2 Diabetes', yLabel='Frequency of first diagnosis')
# plotChart(myData, 'Type 2 Diabetes', yLabel='Frequency of first diagnosis', justLastTwoYears = TRUE)

## The padding with spaces of "Observed" e.g. with \u00A0 is a hack to get the spacing between the
## legends correct. Briefly the "fill" legend for the CI and the "line" legend for the observed and expected
## are separated by a gap that we can't control (to my knowledge), so instead we want to increase the gap between
## Observed and Expected in the legend to match. Hence the space padding. However as we're savig to svg simply using
## a ' ' doesn't work as svg ignores it. Hence the unicode \u00A0 to force the space.
plotChart <- function(allData, descriptionForPlotTitles, yLabel, justLastTwoYears = FALSE) {
  if(justLastTwoYears) {
    g2 <- allData %>% filter(year==analysisYearAsString | year==lastYearAsString) %>% ggplot(aes(x=date, y=val))  + 
      geom_line(aes(x=date, y=pred, color= "Expected")) +
      geom_line(aes(x=date, y=inc, color = "Observed\u00A0\u00A0\u00A0\u00A0")) +
      scale_colour_manual(name=NULL, breaks=c('Observed\u00A0\u00A0\u00A0\u00A0','Expected'), values = c('Observed\u00A0\u00A0\u00A0\u00A0' = "blue", 'Expected' = "black")) +
      
      geom_ribbon(aes(ymax = UL, ymin = LL, fill=CI), alpha= 0.1) +
      scale_fill_manual(name=NULL, values = c(rgb(0, 0, 0, alpha = 0, maxColorValue = 255), "black")) +
      guides(colour = guide_legend(order = 1), CI = guide_legend(order = 2)) +
      
      labs(x = "Time (month/year)", y = yLabel, color = "Year", title = "") +
      theme_light() +
      scale_x_date(labels = date_format("%m/%Y"), date_breaks = "2 months") +
      theme(legend.position = "bottom", legend.spacing.x = unit(0.1, 'cm'), legend.key.width = unit(1, "cm"))
    g2
    return(g2)
  } else {
    g1 <- allData  %>% ggplot(aes(x=date, y=val))   + 
      geom_line(aes(x=date, y=pred, color= "Expected")) +
      geom_line(aes(x=date, y=inc, color = "Observed\u00A0\u00A0\u00A0\u00A0")) +
      scale_colour_manual(name=NULL, breaks=c('Observed\u00A0\u00A0\u00A0\u00A0','Expected'), values = c('Observed\u00A0\u00A0\u00A0\u00A0' = "blue", 'Expected' = "black")) +
      
      geom_ribbon(aes(ymax = UL, ymin = LL, fill=CI), alpha= 0.1) +
      scale_fill_manual(name=NULL, values = c(rgb(0, 0, 0, alpha = 0, maxColorValue = 255), "black")) +
      guides(colour = guide_legend(order = 1), CI = guide_legend(order = 2)) +
      
      labs(x = "Time (month/year)", y = yLabel, color = "Year", title = "") + 
      theme_light() +
      scale_x_date(labels = date_format("%m/%Y"), breaks = "12 months") +
      theme(legend.position = "bottom", legend.spacing.x = unit(0.1, 'cm'), legend.key.width = unit(1, "cm"))
    g1
    return(g1)
  }
}

updateTable <- function(allData,descriptionForPlotTitles) {
  # descriptionForPlotTitles='tet'
  localData <- allData %>% filter(line=="expected")
  output <- getOutputVector(localData)
  
  outputTableMatrixAll <<- rbind(outputTableMatrixAll, c(descriptionForPlotTitles,output[1]$inc, paste0(round(output[4]$pred), ' (', round(output[3]$LL), ' to ', round(output[2]$UL),')'), paste0(format(output[7]$pred, nsmall = 1), '% (',format(output[6]$LL, nsmall = 1),'% to ',format(output[5]$UL, nsmall = 1),'%)')))
  
  for(i in seq_along(monthsMarchToAnalysisData)) {
    monthAsString <- format(monthsMarchToAnalysisData[i],'%m')
    assign(paste0('output', monthAsString), getOutputVectorForMonth(localData, monthAsString))
    assign(paste0('outputTableMatrix', monthAsString), rbind(get(paste0('outputTableMatrix', monthAsString)), c(descriptionForPlotTitles,get(paste0('output', monthAsString))[1]$inc, paste0(round(get(paste0('output', monthAsString))[4]$pred), ' (', round(get(paste0('output', monthAsString))[3]$LL), ' to ', round(get(paste0('output', monthAsString))[2]$UL),')'), paste0(format(get(paste0('output', monthAsString))[7]$pred, nsmall = 1), '% (',format(get(paste0('output', monthAsString))[6]$LL, nsmall = 1),'% to ', format(get(paste0('output', monthAsString))[5]$UL, nsmall = 1),'%)'))), envir = .GlobalEnv)
  }
}

writeRedactedData <- function(data, filename) {
  redacted <- data %>% select(date, inc)
  redacted$inc[redacted$inc < 10] <- 0
  write.table(redacted, file.path(OUTPUT_DATA_DIRECTORY, filename), append = FALSE, sep = "\t", dec = ".", row.names = FALSE, col.names = TRUE)
}

processFile <- function (filename, descriptionForPlotTitles, yLabel, isOneOffData = FALSE) {

  # filename<-'dx-diabetes-t2dm.txt'
  # isOneOffData = FALSE
  # yLabel <- 'a y label'
  
  allData <- processData(filename, isOneOffData = isOneOffData)
  writeRedactedData(allData, filename)
  allData <- fitModel(allData)
  
  ## Plot and save 
  plot1 <- plotChart(allData, descriptionForPlotTitles, yLabel)
  plot2 <- plotChart(allData, descriptionForPlotTitles, yLabel, justLastTwoYears = TRUE)
  saveChart(plot1, descriptionForPlotTitles)
  saveChart(plot2, descriptionForPlotTitles, fileSuffix = "inc_19_20.svg")
  saveWithTitle(plot1, yLabel, descriptionForPlotTitles)

  allData$test <- paste( eval(round(allData$pred,3)), "(CI:",eval(round(allData$LL,3)), "-",eval(round(allData$UL,3)),")")

  print(descriptionForPlotTitles)
  if(displayAsDifference) {
    print(c("Month", "Missed Diagnoses", "LowerCI", "UpperCI"))  
  } else {
    print(c("Month", "Observed", "Expected", "LowerCI", "UpperCI"))    
  }
  updateTable(allData,descriptionForPlotTitles);
}

outputTableMatrixAll <- matrix(nrow = 0, ncol = 4)
for(i in seq_along(monthsMarchToAnalysisData)) {
  monthAsString <- format(monthsMarchToAnalysisData[i],'%m')
  assign(paste0('outputTableMatrix', monthAsString), matrix(nrow = 0, ncol = 4))
}

initialiseTable <- function() {
  outputTableMatrixAll <- matrix(nrow = 0, ncol = 4)
  for(i in seq_along(monthsMarchToAnalysisData)) {
    monthAsString <- format(monthsMarchToAnalysisData[i],'%m')
    assign(paste0('outputTableMatrix', monthAsString), matrix(nrow = 0, ncol = 4), envir = .GlobalEnv)
  }
}

getNameOfLastAnalysisMonth <- function(){ 
  months <- c("January","February", "March","April","May","June","July","August","September","October","November","December")
  return(months[as.numeric(format(tail(monthsMarchToAnalysisData,1),'%m'))])
}

finaliseTableAll <- function() {
  lastAnalysisMonth<-getNameOfLastAnalysisMonth();
  colnames(outputTableMatrixAll) <- c(
    "First Diagnosis / Prescription",
    paste0("Observed cases between March – ",lastAnalysisMonth," ", analysisYearAsString),
    paste0("Expected cases between March – ",lastAnalysisMonth," ", analysisYearAsString, " (95% CI)"),
    paste0("Percentage reduction between the expected and observed cases between March - ",lastAnalysisMonth," ", analysisYearAsString, " (95% CI)")
  )
  outputTable <- as.table(outputTableMatrixAll)
  return(outputTable)
}
finaliseTableForMonth <- function(month) {
  months <- c("January","February", "March","April","May","June","July","August","September","October","November","December")
  localMatrix <- get(paste0('outputTableMatrix', month))
  colnames(localMatrix) <- c(
    "First Diagnosis / Prescription",
    paste0("Observed cases during ",months[as.numeric(month)]," ", analysisYearAsString),
    paste0("Expected cases between during ",months[as.numeric(month)]," ", analysisYearAsString, " (95% CI)"),
    paste0("Percentage reduction between the expected and observed cases during ",months[as.numeric(month)]," ", analysisYearAsString, " (95% CI)")
  )
  outputTable <- as.table(localMatrix)
  return(outputTable)
}
finaliseTables <- function() {
  for(i in seq_along(monthsMarchToAnalysisData)) {
    monthAsString <- format(monthsMarchToAnalysisData[i],'%m')
    print(finaliseTableForMonth(monthAsString))
  }
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
finaliseTables()

processFile('all_since_2010.txt', 'All clinical codes', yLabel='Frequency', isOneOffData = TRUE)
processFile('all_medications_since_2010_no_duplicates.txt', 'Prescriptions', yLabel='Frequency', isOneOffData = TRUE)
processFile('all_diagnoses_since_2010_no_duplicates.txt', 'Diagnoses', yLabel='Frequency', isOneOffData = TRUE)

rmarkdown::render(file.path(here(), 'Analysis', 'supp-material.Rmd'), output_dir = OUTPUT_DIRECTORY)
rmarkdown::render(file.path(here(), 'Analysis', 'ccg-report.Rmd'), output_dir = OUTPUT_DIRECTORY)
# rmarkdown::render(file.path(here(), 'Analysis', 'test.Rmd'), output_dir = OUTPUT_DIRECTORY)
