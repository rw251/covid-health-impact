library("TTR")
library("xts")
library(ggfortify)

getWeeklyTimeSeriesFormat1 <- function(filename) {
  daily <- read.csv(filename, header=TRUE, col.names = c("Date","NumCodes","PREV"))
  daily$Date <- as.Date(as.character(daily$Date), format = "%Y-%m-%d") # read date variable as dates rather than text
  daily <- daily[daily$Date < "2020-06-01", ]
  DF_daily <- xts(daily$NumCodes, order.by = daily$Date) 
  DF_weekly <- apply.weekly(DF_daily, FUN=sum)
  DF_weekly <- head(DF_weekly, -1)
  weeklyTs <- ts(DF_weekly, frequency = 365.25/7, start = c(2010, 1))
  return(weeklyTs)
}

####### All
daily <- read.delim("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/one-off-tasks/all_since_2010.txt", header=FALSE, col.names = c("Date","NumCodes"))
daily$Date <- as.Date(as.character(daily$Date), format = "%Y%m%d") # read date variable as dates rather than text
daily <- daily[daily$Date < "2020-06-01", ]
DF_daily <- xts(daily$NumCodes, order.by = daily$Date) 
DF_weekly <- apply.weekly(DF_daily, FUN=sum)
DF_weekly <- DF_weekly[-1,]
DF_weekly <- head(DF_weekly, -1)
weeklyTs <- ts(DF_weekly, frequency = 365.25/7, start = c(2010, 2))
par(mfrow=c(2,1))
ggplot(weeklyTs, ylim=c(0,600000))
title("Number of clinical codes each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 100000, "lockdown", pos = 1, srt = 0)
plot.ts(weeklyTs, ylim=c(0,600000), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("Number of clinical codes each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 100000, "lockdown", pos = 1, srt = 0)

####### Admin
daily <- read.delim("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/one-off-tasks/all_admin_since_2010_no_duplicates.txt", header=FALSE, col.names = c("Date","NumCodes"))
daily$Date <- as.Date(as.character(daily$Date), format = "%Y%m%d") # read date variable as dates rather than text
daily <- daily[daily$Date < "2020-06-01", ]
DF_daily <- xts(daily$NumCodes, order.by = daily$Date) 
DF_weekly <- apply.weekly(DF_daily, FUN=sum)
DF_weekly <- DF_weekly[-1,]
DF_weekly <- head(DF_weekly, -1)
weeklyTs <- ts(DF_weekly, frequency = 365.25/7, start = c(2010, 2))
par(mfrow=c(2,1))
plot.ts(weeklyTs, ylim=c(0,150000))
title("Number of administration codes each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 30000, "lockdown", pos = 1, srt = 0)
plot.ts(weeklyTs, ylim=c(0,150000), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("Number of administration codes each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 30000, "lockdown", pos = 1, srt = 0)

####### Lab tests
daily <- read.delim("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/one-off-tasks/all_lab_tests_since_2010_no_duplicates.txt", header=FALSE, col.names = c("Date","NumCodes"))
daily$Date <- as.Date(as.character(daily$Date), format = "%Y%m%d") # read date variable as dates rather than text
daily <- daily[daily$Date < "2020-06-01", ]
DF_daily <- xts(daily$NumCodes, order.by = daily$Date) 
DF_weekly <- apply.weekly(DF_daily, FUN=sum)
DF_weekly <- DF_weekly[-1,]
DF_weekly <- head(DF_weekly, -1)
weeklyTs <- ts(DF_weekly, frequency = 365.25/7, start = c(2010, 2))
par(mfrow=c(2,1))
plot.ts(weeklyTs, ylim=c(0,120000))
title("Number of laboratory test codes each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 15000, "lockdown", pos = 1, srt = 0)
plot.ts(weeklyTs, ylim=c(0,120000), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("Number of laboratory test codes each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 15000, "lockdown", pos = 1, srt = 0)


####### Diagnoses
daily <- read.delim("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/one-off-tasks/all_diagnoses_since_2010_no_duplicates.txt", header=FALSE, col.names = c("Date","NumCodes"))
daily$Date <- as.Date(as.character(daily$Date), format = "%Y%m%d") # read date variable as dates rather than text
daily <- daily[daily$Date < "2020-06-01", ]
DF_daily <- xts(daily$NumCodes, order.by = daily$Date) 
DF_weekly <- apply.weekly(DF_daily, FUN=sum)
DF_weekly <- DF_weekly[-1,]
DF_weekly <- head(DF_weekly, -1)
weeklyTs <- ts(DF_weekly, frequency = 365.25/7, start = c(2010, 2))
par(mfrow=c(2,1))
plot.ts(weeklyTs, ylim=c(0,10000))
title("Number of diagnosis codes each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 1500, "lockdown", pos = 1, srt = 0)
plot.ts(weeklyTs, ylim=c(0,10000), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("Number of diagnosis codes each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 1500, "lockdown", pos = 1, srt = 0)

####### Medications
daily <- read.delim("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/one-off-tasks/all_medications_since_2010_no_duplicates.txt", header=FALSE, col.names = c("Date","NumCodes"))
daily$Date <- as.Date(as.character(daily$Date), format = "%Y%m%d") # read date variable as dates rather than text
daily <- daily[daily$Date < "2020-06-01", ]
DF_daily <- xts(daily$NumCodes, order.by = daily$Date) 
DF_weekly <- apply.weekly(DF_daily, FUN=sum)
DF_weekly <- DF_weekly[-1,]
DF_weekly <- head(DF_weekly, -1)
weeklyTs <- ts(DF_weekly, frequency = 365.25/7, start = c(2010, 2))
par(mfrow=c(2,1))
plot.ts(weeklyTs, ylim=c(0,140000))
title("Number of medication codes each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 20000, "lockdown", pos = 1, srt = 0)
plot.ts(weeklyTs, ylim=c(0,140000), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("Number of medication codes each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 20000, "lockdown", pos = 1, srt = 0)

####### Diagnostic procedures
daily <- read.delim("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/one-off-tasks/all_diagnostic_procedures_since_2010_no_duplicates.txt", header=FALSE, col.names = c("Date","NumCodes"))
daily$Date <- as.Date(as.character(daily$Date), format = "%Y%m%d") # read date variable as dates rather than text
daily <- daily[daily$Date < "2020-06-01", ]
DF_daily <- xts(daily$NumCodes, order.by = daily$Date) 
DF_weekly <- apply.weekly(DF_daily, FUN=sum)
DF_weekly <- DF_weekly[-1,]
DF_weekly <- head(DF_weekly, -1)
weeklyTs <- ts(DF_weekly, frequency = 365.25/7, start = c(2010, 2))
par(mfrow=c(2,1))
plot.ts(weeklyTs, ylim=c(0,12000))
title("Number of diagnostic procedure codes each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 500, "lockdown", pos = 2, srt = 0)
plot.ts(weeklyTs, ylim=c(0,12000), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("Number of diagnostic procedure codes each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 500, "lockdown", pos = 2, srt = 0)

####### Observations / symptoms recorded
daily <- read.delim("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/one-off-tasks/all_observations_symptoms_since_2010_no_duplicates.txt", header=FALSE, col.names = c("Date","NumCodes"))
daily$Date <- as.Date(as.character(daily$Date), format = "%Y%m%d") # read date variable as dates rather than text
daily <- daily[daily$Date < "2020-06-01", ]
DF_daily <- xts(daily$NumCodes, order.by = daily$Date) 
DF_weekly <- apply.weekly(DF_daily, FUN=sum)
DF_weekly <- DF_weekly[-1,]
DF_weekly <- head(DF_weekly, -1)
weeklyTs <- ts(DF_weekly, frequency = 365.25/7, start = c(2010, 2))
par(mfrow=c(2,1))
plot.ts(weeklyTs, ylim=c(0,52000))
title("Number of observation and symptom codes each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 7000, "lockdown", pos = 1, srt = 0)
plot.ts(weeklyTs, ylim=c(0,52000), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("Number of observation and symptom codes each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 7000, "lockdown", pos = 1, srt = 0)

####### Procedures recorded
daily <- read.delim("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/one-off-tasks/all_procedures_since_2010_no_duplicates.txt", header=FALSE, col.names = c("Date","NumCodes"))
daily$Date <- as.Date(as.character(daily$Date), format = "%Y%m%d") # read date variable as dates rather than text
daily <- daily[daily$Date < "2020-06-01", ]
DF_daily <- xts(daily$NumCodes, order.by = daily$Date) 
DF_weekly <- apply.weekly(DF_daily, FUN=sum)
DF_weekly <- DF_weekly[-1,]
DF_weekly <- head(DF_weekly, -1)
weeklyTs <- ts(DF_weekly, frequency = 365.25/7, start = c(2010, 2))
par(mfrow=c(2,1))
plot.ts(weeklyTs, ylim=c(0,50000))
title("Number of procedure codes each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 7000, "lockdown", pos = 1, srt = 0)
plot.ts(weeklyTs, ylim=c(0,50000), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("Number of procedure codes each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 7000, "lockdown", pos = 1, srt = 0)

####### Circulatory
circTX <- getWeeklyTimeSeriesFormat1("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/data/dx-GROUP-circulatory-system.txt")
par(mfrow=c(2,1))
plot.ts(circTX, ylim=c(0,100))
title("First diagnoses of circulatory diseases each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 13, "lockdown", pos = 1, srt = 0)
plot.ts(circTX, ylim=c(0,100), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("First diagnoses of circulatory diseases each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 13, "lockdown", pos = 1, srt = 0)


####### Statins
statTX <- getWeeklyTimeSeriesFormat1("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/data/dx--statin.txt")
par(mfrow=c(2,1))
plot.ts(statTX, ylim=c(0,100))
title("First prescription of statin each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 13, "lockdown", pos = 1, srt = 0)
plot.ts(statTX, ylim=c(0,100), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("First prescription of statin each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 13, "lockdown", pos = 1, srt = 0)

####### ACEI
aceiTX <- getWeeklyTimeSeriesFormat1("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/data/dx--acei.txt")
par(mfrow=c(2,1))
plot.ts(aceiTX, ylim=c(0,60))
title("First prescription of ACEI each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 8, "lockdown", pos = 1, srt = 0)
plot.ts(aceiTX, ylim=c(0,60), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("First prescription of ACEI each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 8, "lockdown", pos = 1, srt = 0)

####### clop
clopTX <- getWeeklyTimeSeriesFormat1("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/data/dx--clopidogrel.txt")
par(mfrow=c(2,1))
plot.ts(clopTX, ylim=c(0,30))
title("First prescription of clopidogrel each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 5, "lockdown", pos = 1, srt = 0)
plot.ts(clopTX, ylim=c(0,30), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("First prescription of clopidogrel each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 5, "lockdown", pos = 1, srt = 0)

####### diabetes
diabTX <- getWeeklyTimeSeriesFormat1("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/data/dx-GROUP-diabetes.txt")
par(mfrow=c(2,1))
plot.ts(diabTX, ylim=c(0,50))
title("First diagnosis of any diabetes each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 8, "lockdown", pos = 1, srt = 0)
plot.ts(diabTX, ylim=c(0,50), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("First diagnosis of any diabetes each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 8, "lockdown", pos = 1, srt = 0)

####### metformin
metfTX <- getWeeklyTimeSeriesFormat1("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/data/dx--metformin.txt")
par(mfrow=c(2,1))
plot.ts(metfTX, ylim=c(0,40))
title("First prescription of metformin each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 5, "lockdown", pos = 1, srt = 0)
plot.ts(metfTX, ylim=c(0,40), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("First prescription of metformin each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 5, "lockdown", pos = 1, srt = 0)

####### mod mental health
modmhTX <- getWeeklyTimeSeriesFormat1("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/data/dx-GROUP-mental-health-mild-moderate.txt")
par(mfrow=c(2,1))
plot.ts(modmhTX, ylim=c(0,250))
title("First diagnosis of a mild/moderate mental health condition each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 20, "lockdown", pos = 1, srt = 0)
plot.ts(modmhTX, ylim=c(0,250), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("First diagnosis of a mild/moderate mental health condition each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 20, "lockdown", pos = 1, srt = 0)

####### SSRI
ssriTx <- getWeeklyTimeSeriesFormat1("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/data/dx--ssri.txt")
par(mfrow=c(2,1))
plot.ts(ssriTx, ylim=c(0,100))
title("First prescription of SSRI each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 15, "lockdown", pos = 1, srt = 0)
plot.ts(ssriTx, ylim=c(0,100), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("First prescription of SSRI each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 15, "lockdown", pos = 1, srt = 0)

####### severe mental health
sevmhTX <- getWeeklyTimeSeriesFormat1("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/data/dx-GROUP-mental-health-severe.txt")
par(mfrow=c(2,1))
plot.ts(sevmhTX, ylim=c(0,20))
title("First diagnosis of a severe mental health condition each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 20, "lockdown", pos = 1, srt = 0)
plot.ts(sevmhTX, ylim=c(0,20), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("First diagnosis of a severe mental health condition each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 20, "lockdown", pos = 1, srt = 0)


####### malignant cancer
cancTX <- getWeeklyTimeSeriesFormat1("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/data/dx-GROUP-cancer.txt")
par(mfrow=c(2,1))
plot.ts(cancTX, ylim=c(0,30))
title("First diagnosis of a malignant cancer each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 32, "lockdown", pos = 1, srt = 0)
plot.ts(cancTX, ylim=c(0,30), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("First diagnosis of a malignant cancer each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 32, "lockdown", pos = 1, srt = 0)


####### cardiovascular
cardTX <- getWeeklyTimeSeriesFormat1("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/data/dx-GROUP-cardiovascular.txt")
par(mfrow=c(2,1))
plot.ts(cardTX, ylim=c(0,100))
title("First diagnoses of cardiovascular diseases each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 13, "lockdown", pos = 1, srt = 0)
plot.ts(cardTX, ylim=c(0,100), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("First diagnoses of cardiovascular diseases each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 13, "lockdown", pos = 1, srt = 0)

####### cerebrovascular
cereTX <- getWeeklyTimeSeriesFormat1("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/data/dx-GROUP-cerebrovascular.txt")
par(mfrow=c(2,1))
plot.ts(cereTX, ylim=c(0,30))
title("First diagnoses of cerebrovascular diseases each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 13, "lockdown", pos = 1, srt = 0)
plot.ts(cereTX, ylim=c(0,30), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("First diagnoses of cerebrovascular diseases each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 13, "lockdown", pos = 1, srt = 0)

####### selfharm
harmTx <- getWeeklyTimeSeriesFormat1("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/data/dx--self-harm.txt")
par(mfrow=c(2,1))
plot.ts(harmTx, ylim=c(0,20))
title("First diagnosis of self harm each week 2010-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 15, "lockdown", pos = 1, srt = 0)
plot.ts(harmTx, ylim=c(0,20), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("First diagnosis of self harm each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 15, "lockdown", pos = 1, srt = 0)