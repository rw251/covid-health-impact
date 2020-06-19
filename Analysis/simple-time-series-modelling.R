## @knitr timeSeriesFunctions
library("xts")
library(here)

DATA_DIRECTORY <- file.path(here(), '..','covid-health-data')
ALT_DATA_DIRECTORY <- file.path(here(), 'data-extraction', 'one-off-tasks')
OUTPUT_DIRECTORY <- file.path(here(), 'outputs') # this file needs creating on the local directory

getWeeklyTimeSeries <- function(dailyData, dateFormat) {
  dailyData$Date <- as.Date(as.character(dailyData$Date), format = dateFormat) # read date variable as dates rather than text
  dailyData <- dailyData[dailyData$Date < "2020-06-01", ]
  DF_daily <- xts(dailyData$NumCodes, order.by = dailyData$Date) 
  DF_weekly <- apply.weekly(DF_daily, FUN=sum)
  return(DF_weekly)
}

getWeeklyTimeSeriesFormat1 <- function(filename, directory = DATA_DIRECTORY) {
  daily <- read.csv(file.path(directory,filename), header=TRUE, col.names = c("Date","NumCodes","PREV"))
  DF_weekly <- getWeeklyTimeSeries(daily, "%Y-%m-%d")
  weeklyTs <- ts(DF_weekly, frequency = 365.25/7, start = c(2010, 1))
  return(weeklyTs)
}

getWeeklyTimeSeriesFormat2 <- function(filename, directory = ALT_DATA_DIRECTORY) {
  # filename <- "all_since_2010.txt"
  # directory <- ALT_DATA_DIRECTORY
  daily <- read.delim(file.path(directory,filename), header=FALSE, col.names = c("Date","NumCodes"))
  DF_weekly <- getWeeklyTimeSeries(daily, "%Y%m%d")
  weeklyTs <- ts(DF_weekly, frequency = 365.25/7, start = c(2010, 2))
  return(weeklyTs)
}

getPlot <- function(data, leftMargin, minYear = 2010, showTitle = FALSE, titleText, isBigChart = FALSE, ymax) {
  options(scipen=5)
  par(mfrow=c(1,1))
  if(showTitle) {
    par(mar=c(4.5,leftMargin,3,2)+0.1)
  } else {
    par(mar=c(4.5,leftMargin,1,2)+0.1)
  }
  if(isBigChart){
    p <- plot.ts(
      data, ylim=c(0,ymax), ylab="",
      xaxt = "n", 
      xlim=c(minYear,2020 + 5/12), lwd=0.8,
      yaxp=c(0,600000,2)
    )
  } else {
    par(las=1)
    p <- plot.ts(
      data, ylim=c(0,ymax), ylab="",
      xaxt = "n", 
      xlim=c(minYear,2020 + 5/12), lwd=0.8
    )
  }
  if(showTitle) {
    title(titleText)
  }
  years <- seq(minYear, 2020, by=1)
  labels <- paste0('01/', years)
  # Add 0.04 (=15/365.25) to each axis marker so that Jan 20XX appears in mid January
  axis(1, at=years+0.04, labels)
  title(ylab="Frequency", line=leftMargin - 1)
  abline(v = 2020.23, col = "red", lty = 3)
  lockdownLabelHeight <- ymax/6.25
  if(showTitle) lockdownLabelHeight <- ymax/4.1
  text(2020.23, lockdownLabelHeight, "Lockdown", pos = 1, srt = 0)
  return(p)
}
savePlot <- function(plot, file) {
  png(file, width = 2400, pointsize = 10, height = 600, res = 300)
  plot
  dev.off()
}

generatePlot <- function(data, file, titleText = '', showTitle = FALSE, ymax, leftMargin) {
  p <- getPlot(data, leftMargin, minYear = 2015, showTitle, titleText, ymax = ymax)
  savePlot(p, file)
}
  
generatePlots <- function(data, filename, directory = OUTPUT_DIRECTORY, titleText, ymax, leftMargin = 5.5) {
  ## Do plot without title
  generatePlot(
    data, file = file.path(directory, paste0(filename, '.png')), 
    ymax = ymax, leftMargin = leftMargin
  )
  
  ## Do plot with title
  generatePlot(
    data, file = file.path(directory, paste0(filename, '-with-title.png')), 
    ymax = ymax, showTitle = TRUE, titleText = titleText, leftMargin = leftMargin
  )
}

generatePlotFrom2010 <- function(data, file, titleText = '', showTitle = FALSE, ymax) {
  p <- getPlot(data, leftMargin = 3.5, minYear = 2010, showTitle, titleText, isBigChart = TRUE, ymax = ymax)
  savePlot(p, file)
}

generatePlotsFrom2010 <- function(data, filename, directory = OUTPUT_DIRECTORY, titleText, showTitle = FALSE, ymax) {
  ## Do plot without title
  generatePlotFrom2010(data, file = file.path(directory, paste0(filename, '.png')), ymax = ymax)
  
  ## Do plot with title
  generatePlotFrom2010(data, file = file.path(directory, paste0(filename, '-with-title.png')), ymax = ymax, showTitle = TRUE, titleText = titleText)
}

## @knitr ignoreThese

####### All
codesAll <- getWeeklyTimeSeriesFormat2("all_since_2010.txt")
generatePlotsFrom2010(codesAll, filename = "codes-all", ymax=600000, titleText = 'Number of clinical codes each week 2010-present')

####### Diagnoses
codesDx <- getWeeklyTimeSeriesFormat2("all_diagnoses_since_2010_no_duplicates.txt")
generatePlots(codesDx, filename = "codes-diagnoses",ymax=10000, titleText = 'Number of diagnosis codes each week 2015-present')

####### Medications
codesRx <- getWeeklyTimeSeriesFormat2("all_medications_since_2010_no_duplicates.txt")
generatePlots(codesRx, filename = "codes-medications",ymax=140000, titleText = 'Number of prescription codes each week 2015-present')

####### Admin
codesAdmin <- getWeeklyTimeSeriesFormat2("all_admin_since_2010_no_duplicates.txt")
generatePlots(codesAdmin, filename = "codes-admin",ymax=150000, titleText = 'Number of administration codes each week 2015-present')

####### Lab tests
codesLab <- getWeeklyTimeSeriesFormat2("all_lab_tests_since_2010_no_duplicates.txt")
generatePlots(codesLab, filename = "codes-labs",ymax=120000, titleText = 'Number of laboratory test codes each week 2015-present')

####### Diagnostic procedures
codesDiagProcs <- getWeeklyTimeSeriesFormat2("all_diagnostic_procedures_since_2010_no_duplicates.txt")
generatePlots(codesDiagProcs, filename = "codes-diag-proc",ymax=12000, titleText = 'Number of diagnostic procedure codes each week 2015-present')

####### Observations / symptoms recorded
codesObs <- getWeeklyTimeSeriesFormat2("all_observations_symptoms_since_2010_no_duplicates.txt")
generatePlots(codesObs, filename = "codes-obs-symp",ymax=52000, titleText = 'Number of observation and symptom codes each week 2015-present')

####### Procedures recorded
codesProc <- getWeeklyTimeSeriesFormat2("all_procedures_since_2010_no_duplicates.txt")
generatePlots(codesProc, filename = "codes-proc",ymax=50000, titleText = 'Number of procedure codes each week 2015-present')

####### Circulatory
circTX <- getWeeklyTimeSeriesFormat1("dx-GROUP-circulatory-system.txt")
generatePlots(circTX, filename = "spec-circ",ymax=100, titleText = 'First diagnoses of circulatory diseases each week 2015-present', leftMargin = 3.5)

####### ACEI
aceiTX <- getWeeklyTimeSeriesFormat1("dx--acei.txt")
generatePlots(aceiTX, filename = "spec-circ-acei",ymax=60, titleText = 'First prescription of ACEI each week 2015-present', leftMargin = 3.5)

####### clop
clopTX <- getWeeklyTimeSeriesFormat1("dx--clopidogrel.txt")
generatePlots(clopTX, filename = "spec-circ-clop",ymax=30, titleText = 'First prescription of clopidogrel each week 2015-present', leftMargin = 3.5)

####### ccbs
ccbsTX <- getWeeklyTimeSeriesFormat1("dx--ccbs.txt")
generatePlots(ccbsTX, filename = "spec-circ-ccbs",ymax=70, titleText = 'First prescription of ccbs each week 2015-present', leftMargin = 3.5)

####### aspirin 75mg
asp75TX <- getWeeklyTimeSeriesFormat1("dx--aspirin-75.txt")
generatePlots(asp75TX, filename = "spec-circ-asp",ymax=40, titleText = 'First prescription of aspirin 75mg each week 2015-present', leftMargin = 3.5)

####### diabetes
diabTX <- getWeeklyTimeSeriesFormat1("dx-diabetes-t2dm.txt")
generatePlots(diabTX, filename = "spec-t2dm",ymax=50, titleText = 'First diagnoses of type 2 diabetes each week 2015-present', leftMargin = 3.5)

####### metformin
metfTX <- getWeeklyTimeSeriesFormat1("dx--metformin.txt")
generatePlots(metfTX, filename = "spec-t2dm-met",ymax=40, titleText = 'First prescription of metformin each week 2015-present', leftMargin = 3.5)

####### mod mental health
modmhTX <- getWeeklyTimeSeriesFormat1("dx-GROUP-mental-health-mild-moderate.txt")
generatePlots(modmhTX, filename = "spec-mental",ymax=250, titleText = 'First diagnoses of a mild/moderate mental health illness each week 2015-present', leftMargin = 4)

####### SSRI
ssriTx <- getWeeklyTimeSeriesFormat1("dx--ssri.txt")
generatePlots(ssriTx, filename = "spec-mental-ssri",ymax=100, titleText = 'First prescription of SSRI each week 2015-present', leftMargin = 4)

####### malignant cancer
cancTX <- getWeeklyTimeSeriesFormat1("dx-GROUP-cancer.txt")
generatePlots(cancTX, filename = "spec-cancer",ymax=30, titleText = 'First diagnoses of a malignant cancer each week 2015-present', leftMargin = 3.5)

####### cardiovascular
cardTX <- getWeeklyTimeSeriesFormat1("dx-GROUP-cardiovascular.txt")
generatePlots(cardTX, filename = "spec-cardio",ymax=100, titleText = 'First diagnoses of cardiovascular diseases each week 2015-present', leftMargin = 3.5)

####### cerebrovascular
cereTX <- getWeeklyTimeSeriesFormat1("dx-GROUP-cerebrovascular.txt")
generatePlots(cereTX, filename = "spec-cerbro",ymax=30, titleText = 'First diagnoses of cerebrovascular diseases each week 2015-present', leftMargin = 3.5)
