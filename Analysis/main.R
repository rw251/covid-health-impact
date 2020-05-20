#install.packages("httr")
library(httr)
library(here)
library(dplyr)
library(ggplot2)
library(cowplot)

DATA_DIRECTORY <- file.path(here(), 'data-extraction', 'data')
OUTPUT_DIRECTORY <- file.path(here(), 'outputs')

# important covid-19 events
events <- data.frame(
  "Date" = as.Date(c("2020-01-30", "2020-03-05", "2020-03-23")), 
  "Event" = c("First UK case","First UK death","UK lockdown")
)
events$year<- "2020"
events$month <- strftime(events$Date, "%m")
events$day <- strftime(events$Date, "%d")
events$monthX <- as.numeric(events$month) + as.numeric(events$day) / 31 # approx location
events$week <- ceiling(as.numeric(strftime(events$Date, "%j")) / 7) # define days 1-7 as week 1, 8-14 as week 2 etc.
events$weekX <- 1 + as.numeric(strftime(events$Date, "%j")) / 7

loadDataFromFile <- function(filename, directory = DATA_DIRECTORY) {
  return(read.delim(file.path(directory, filename), sep = ','))
}

processData <- function(dat) {
  dat$inc <- dat[,2] # this should be the incidence variable (make sure incidence is always second and prevelence is third variable)
  dat$prev <- dat[,3]

  dat <- dat[,-c(2,3)]
  dat$Date <- as.Date(as.character(dat$Date), format = "%Y-%m-%d") # read date variable as dates rather than text

  dat$month <- strftime(dat$Date, "%m")
  dat$week <- ceiling(as.numeric(strftime(dat$Date, "%j")) / 7) # define days 1-7 as week 1, 8-14 as week 2 etc.

  dat <- dat %>%
    mutate(
      year = substr(Date,  1, 4),
      month = substr(Date,  6, 7),
      day = substr(Date, 9, 10))

  groupedByMonth <- dat %>% group_by(year, month) %>% summarise(n=n(), inc = sum(inc), prev = sum(prev))
  groupedByWeek <- dat %>% group_by(year, week) %>% summarise(n=n(), inc = sum(inc), prev = sum(prev))

  # Revove data from the current month and current week as it is not complete
  today <- Sys.time()
  monthToday<-strftime(today, "%m")
  weekToday<-ceiling(as.numeric(strftime(today, "%j")) / 7)
  lastWeek<-weekToday-1
  groupedByMonth<-groupedByMonth[!(groupedByMonth$month==monthToday & groupedByMonth$year== "2020"),]
  groupedByWeek<-groupedByWeek[!(groupedByWeek$week==weekToday & groupedByWeek$year== "2020"),]
  groupedByWeek<-groupedByWeek[!(groupedByWeek$week==lastWeek & groupedByWeek$year== "2020"),]

  # Remove week 53
  groupedByWeek<-groupedByWeek[!(groupedByWeek$week==53),]

  return(list(groupedByWeek, groupedByMonth))
}

getTimeUnit = function(dat) {
  timeUnit<-'month'
  if('week' %in% colnames(dat)) {
    timeUnit<-'week'
  }
  return(timeUnit);
}

getAverageOfPreviousYears = function(dat) {
  # We're either grouping by the week or the month column
  timeUnit<-getTimeUnit(dat);
  previousYearsAveraged<-as.data.frame(dat 
    %>% filter(year != "2020") 
    %>% group_by_(.dots = list(timeUnit)) 
    %>% summarise(incSD=sd(inc, na.rm=TRUE), prevSD=sd(prev, na.rm=TRUE), inc = mean(inc), prev=mean(prev),n=n(), year='2015-2019 average')
  )
  thisYear<-as.data.frame(dat
    %>% filter(year=="2020") 
    %>% group_by_(.dots = list(timeUnit)) 
    %>% select_(.dots = list(timeUnit, 'inc', 'prev')) 
    %>% mutate(year='2020', incSD=0, prevSD=0, n =1)
  )
  return(rbind(previousYearsAveraged, thisYear))
}

getIncidencePlot <- function(data, lowerCaseCondition, timeUnit = getTimeUnit(data), title = paste("Incidence of", lowerCaseCondition, "each", timeUnit, "between 2015 and 2020")) {

  # line from 2020 line upwards by 10
  maxInc <- max(data$inc)
  # events$ymin <- merge(data[, c("inc", timeUnit, "year")], events, by=c(timeUnit,"year"))$inc
  events$ymin <- 0
  events$ymax <- maxInc * 1.1

  # plot event labels at the correct point (e.g. not at week or month start)
  eventXPosition = paste(timeUnit, 'X', sep='');

  return(data %>% ggplot(aes_string(x=timeUnit, y='inc', group='year', color='year'))
    + geom_ribbon(aes(ymax = inc + incSD, ymin = pmax(0, inc - incSD)), fill='black',alpha=0.1,colour=NA)
    + geom_line()
    + labs(x = paste("Time (", timeUnit, ")"), y = "Incidence", color = "Year", title = title)
    + theme_light()

    # Events
    + geom_segment(data = events, mapping=aes_string(y='ymin', x=eventXPosition, xend=eventXPosition, yend='ymax'), colour='black')
    + geom_point(data = events, mapping=aes_string(x=eventXPosition, y='ymax'), size=1, colour='black')
    # + geom_label(data = events, mapping=aes_string(x=eventXPosition, y='ymax', label='Event', group=NA, color=NA), hjust=-0.1, vjust=0.1, size=3)
  )
}

drawIncidencePlot <- function(data, lowerCaseCondition, conditionNameDashed, directory = OUTPUT_DIRECTORY) {
  plot <- getIncidencePlot(data, lowerCaseCondition)
  plotFilename <- paste(conditionNameDashed, 'incidence', 'png', sep=".")
  ggsave(file.path(directory, plotFilename),plot + expand_limits(y = 0))
}

getPrevalencePlot <- function(data, lowerCaseCondition, timeUnit = getTimeUnit(data), title = paste("Prevalence of", lowerCaseCondition, "each", timeUnit, "between 2015 and 2020")) {
  # line from 2020 line upwards by 10
  maxPrev <- max(data$prev)
  # events$ymin <- merge(data[, c("prev", timeUnit, "year")], events, by=c(timeUnit,"year"))$prev
  events$ymin <- 0
  events$ymax <- maxPrev * 1.1

  # plot event labels at the correct point (e.g. not at week or month start)
  eventXPosition = paste(timeUnit, 'X', sep='');

  return(data %>% ggplot(aes_string(x=timeUnit, y='prev', group='year', color='year'))
    + geom_ribbon(aes(ymax = prev + prevSD, ymin = pmax(0, prev - prevSD), fill="95% CI of 2015-2019"), fill='black',alpha=0.1,colour=NA)
    + geom_line(size=1.25)
    + labs(x = paste("Time (", timeUnit, ")"), y = "Prevalence", color = "Year", title = title)
    + theme_light()

    # Events
    + geom_segment(data = events, mapping=aes_string(y='ymin', x=eventXPosition, xend=eventXPosition, yend='ymax'), colour='black')
    + geom_point(data = events, mapping=aes_string(x=eventXPosition, y='ymax'), size=1, colour='black')
    # + geom_label(data = events, mapping=aes_string(x=eventXPosition, y='ymax', label='Event', group=NA, color=NA), hjust=-0.1, vjust=0.1, size=3)
  )
}

drawPrevalencePlot <- function(data, lowerCaseCondition, conditionNameDashed, directory = OUTPUT_DIRECTORY) {
  plot <- getPrevalencePlot(data, lowerCaseCondition)
  plotFilename <- paste(conditionNameDashed, 'prevalence', 'png', sep=".")
  ggsave(file.path(directory, plotFilename),plot + expand_limits(y = 0))
}

drawCombinedPlotWithWeekAndMonth <- function(dataByWeek, dataByMonth, conditionNameLowerCase, conditionNameDashed, directory = OUTPUT_DIRECTORY) {

  incPlotByWeek <- getIncidencePlot(dataByWeek, conditionNameLowerCase, title = 'Incidence')
  incPlotByMonth <- getIncidencePlot(dataByMonth, conditionNameLowerCase, title = 'Incidence')
  prevPlotByWeek <- getPrevalencePlot(dataByWeek, conditionNameLowerCase, title = 'Prevalence')
  prevPlotByMonth <- getPrevalencePlot(dataByMonth, conditionNameLowerCase, title = 'Prevalence')

  plot_row_1 <- plot_grid(incPlotByWeek + expand_limits(y = 0), prevPlotByWeek + expand_limits(y = 0), labels = "AUTO")
  plot_row_2 <- plot_grid(incPlotByMonth + expand_limits(y = 0), prevPlotByMonth + expand_limits(y = 0), labels = "AUTO")

  titleText <- paste("Incidence and prevalence of", conditionNameLowerCase, "between 2015 and 2020")

  if(conditionNameLowerCase == "GROUP cancer") {
    titleText <- "Presenting incidence and prevalence of all malignant cancers 2015 to 2020"        
  } else if(conditionNameLowerCase == "GROUP cardiovascular") {
    titleText <- "Presenting incidence and prevalence of cardiovascular diagnoses 2015 to 2020"      
  } else if(conditionNameLowerCase == "GROUP mental health mild moderate") {
    titleText <- "Presenting incidence and prevalence of mild and moderate mental health conditions (anxiety and depression) 2015 to 2020"      
  } else if(conditionNameLowerCase == "GROUP mental health severe") {
    titleText <- "Presenting incidence and prevalence of severe mental health conditions (schizophrenia and bipolar) 2015 to 2020"      
  } 

  # now add the title
  title <- ggdraw() + 
    draw_label(
      titleText,
      fontface = 'bold',
      x = 0,
      hjust = 0
    ) +
    theme(
      # add margin on the left of the drawing canvas,
      # so title is aligned with left edge of first plot
      plot.margin = margin(0, 0, 0, 7)
    )
  plot <- plot_grid(
    title, plot_row_1, plot_row_2,
    ncol = 1,
    # rel_heights values control vertical title margins
    rel_heights = c(0.1, 1, 1)
  )

  plotFilename <- paste(conditionNameDashed, 'png', sep=".")
  save_plot(file.path(directory, plotFilename), plot, ncol = 2, base_height = 5)
}

drawCombinedPlot <- function(data, conditionNameLowerCase, conditionNameDashed, directory = OUTPUT_DIRECTORY) {
  timeUnit<-getTimeUnit(data);

  incPlot <- getIncidencePlot(data, conditionNameLowerCase, title = 'Incidence')
  prevPlot <- getPrevalencePlot(data, conditionNameLowerCase, title = 'Prevalence')

  plot_row <- plot_grid(incPlot + expand_limits(y = 0), prevPlot + expand_limits(y = 0), labels = "AUTO")

  # now add the title
  title <- ggdraw() + 
    draw_label(
      paste("Incidence and prevalence of", conditionNameLowerCase, "each", timeUnit, "between 2015 and 2020"),
      fontface = 'bold',
      x = 0,
      hjust = 0
    ) +
    theme(
      # add margin on the left of the drawing canvas,
      # so title is aligned with left edge of first plot
      plot.margin = margin(0, 0, 0, 7)
    )
  plot <- plot_grid(
    title, plot_row,
    ncol = 1,
    # rel_heights values control vertical title margins
    rel_heights = c(0.1, 1)
  )

  plotFilename <- paste(conditionNameDashed, timeUnit, 'png', sep=".")
  save_plot(file.path(directory, plotFilename), plot, ncol = 2)
}

# For some reason a Rplots.pdf is generated unless you call this
# see https://stackoverflow.com/a/38605858/596639
pdf(NULL)

# For each file in data directory that starts with "dx"
for(file in list.files(DATA_DIRECTORY, pattern = "^dx")) {

  conditionNameDashed <- substr(file, 4, nchar(file) - 4)
  conditionNameParts <- strsplit(conditionNameDashed, '-')[[1]]
  conditionNameLowerCase <- paste(conditionNameParts, collapse=" ")
  conditionNameUpperCase <- paste(toupper(substr(conditionNameParts,0,1)), substr(conditionNameParts,2,nchar(conditionNameParts)), sep="", collapse=" ")

  cat('Doing ', conditionNameLowerCase, '\n')
  # load the file into R
  rawData <- loadDataFromFile(file)

  # Process the data into the correct format
  processedData <- processData(rawData)
  processedDataGroupedByWeek = processedData[[1]]
  processedDataGroupedByMonth = processedData[[2]]
  averagedDataByMonth <- getAverageOfPreviousYears(processedDataGroupedByMonth)
  averagedDataByWeek <- getAverageOfPreviousYears(processedDataGroupedByWeek)

  # drawIncidencePlot(processedDataGroupedByWeek, conditionNameLowerCase, conditionNameDashed)
  # drawPrevalencePlot(processedDataGroupedByWeek, conditionNameLowerCase, conditionNameDashed)

  # drawCombinedPlot(averagedDataByMonth, conditionNameLowerCase, conditionNameDashed)
  # drawCombinedPlot(averagedDataByWeek, conditionNameLowerCase, conditionNameDashed)
  drawCombinedPlotWithWeekAndMonth(averagedDataByWeek, averagedDataByMonth, conditionNameLowerCase, conditionNameDashed)
}
