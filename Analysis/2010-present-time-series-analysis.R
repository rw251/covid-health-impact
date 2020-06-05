library("TTR")
library("xts")
library(ggfortify)

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
plot.ts(weeklyTs, ylim=c(0,600000))
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
daily <- read.csv("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/data/dx-GROUP-circulatory-system.txt", header=TRUE, col.names = c("Date","NumCodes","PREV"))
daily$Date <- as.Date(as.character(daily$Date), format = "%Y-%m-%d") # read date variable as dates rather than text
daily <- daily[daily$Date < "2020-06-01", ]
DF_daily <- xts(daily$NumCodes, order.by = daily$Date) 
DF_weekly <- apply.weekly(DF_daily, FUN=sum)
DF_weekly <- DF_weekly[-1,]
DF_weekly <- head(DF_weekly, -1)
weeklyTs <- ts(DF_weekly, frequency = 365.25/7, start = c(2015, 2))
par(mfrow=c(2,1))
plot.ts(weeklyTs, ylim=c(0,100))
title("First diagnoses of circulatory diseases each week 2015-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 16, "lockdown", pos = 1, srt = 0)
plot.ts(weeklyTs, ylim=c(0,100), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("First diagnoses of circulatory diseases each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 16, "lockdown", pos = 1, srt = 0)


####### Statins
daily <- read.csv("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/data/dx--statin.txt", header=TRUE, col.names = c("Date","NumCodes","PREV"))
daily$Date <- as.Date(as.character(daily$Date), format = "%Y-%m-%d") # read date variable as dates rather than text
daily <- daily[daily$Date < "2020-06-01", ]
DF_daily <- xts(daily$NumCodes, order.by = daily$Date) 
DF_weekly <- apply.weekly(DF_daily, FUN=sum)
DF_weekly <- DF_weekly[-1,]
DF_weekly <- head(DF_weekly, -1)
weeklyTs <- ts(DF_weekly, frequency = 365.25/7, start = c(2015, 2))
par(mfrow=c(2,1))
plot.ts(weeklyTs, ylim=c(0,100))
title("First prescription of statin each week 2015-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 16, "lockdown", pos = 1, srt = 0)
plot.ts(weeklyTs, ylim=c(0,100), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("First prescription of statin each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 16, "lockdown", pos = 1, srt = 0)

####### ACEI
daily <- read.csv("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/data/dx--acei.txt", header=TRUE, col.names = c("Date","NumCodes","PREV"))
daily$Date <- as.Date(as.character(daily$Date), format = "%Y-%m-%d") # read date variable as dates rather than text
daily <- daily[daily$Date < "2020-06-01", ]
DF_daily <- xts(daily$NumCodes, order.by = daily$Date) 
DF_weekly <- apply.weekly(DF_daily, FUN=sum)
DF_weekly <- DF_weekly[-1,]
DF_weekly <- head(DF_weekly, -1)
weeklyTs <- ts(DF_weekly, frequency = 365.25/7, start = c(2015, 2))
par(mfrow=c(2,1))
plot.ts(weeklyTs, ylim=c(0,60))
title("First prescription of ACEI each week 2015-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 16, "lockdown", pos = 1, srt = 0)
plot.ts(weeklyTs, ylim=c(0,60), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("First prescription of ACEI each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 16, "lockdown", pos = 1, srt = 0)

####### clop
daily <- read.csv("C:/Users/mdehsrw9/Development/covid-health-impact/data-extraction/data/dx--clopidogrel.txt", header=TRUE, col.names = c("Date","NumCodes","PREV"))
daily$Date <- as.Date(as.character(daily$Date), format = "%Y-%m-%d") # read date variable as dates rather than text
daily <- daily[daily$Date < "2020-06-01", ]
DF_daily <- xts(daily$NumCodes, order.by = daily$Date) 
DF_weekly <- apply.weekly(DF_daily, FUN=sum)
DF_weekly <- DF_weekly[-1,]
DF_weekly <- head(DF_weekly, -1)
weeklyTs <- ts(DF_weekly, frequency = 365.25/7, start = c(2015, 2))
par(mfrow=c(2,1))
plot.ts(weeklyTs, ylim=c(0,30))
title("First prescription of clopidogrel each week 2015-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 5, "lockdown", pos = 1, srt = 0)
plot.ts(weeklyTs, ylim=c(0,30), xlim=c(2018,2021), xaxp=c(2018,2021,3))
title("First prescription of clopidogrel each week 2018-present")
abline(v = 2020.23, col = "red", lty = 3)
text(2020.23, 5, "lockdown", pos = 1, srt = 0)

