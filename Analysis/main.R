#install.packages("httr")
library(httr)
library(here)
library(dplyr)
library(ggplot2)

DATA_DIRECTORY <- file.path(here(), 'data-extraction', 'data');
OUTPUT_DIRECTORY <- file.path(here(), 'outputs');

loadDataFromFile <- function(filename, directory = DATA_DIRECTORY) {
  return(read.delim(file.path(directory, filename), sep = ','))
}

processData <- function(dat) {
  dat$inc <- dat[,2] # this should be the incidence variable (make sure incidence is always second and prevelence is third variable)
  dat$prev <- dat[,3]

  dat <- dat[,-c(2,3)]
  dat$Date <- as.Date(as.character(dat$Date), format = "%Y-%m-%d") # read date variable as dates rather than text

  dat$month<- strftime(dat$Date, "%m")

  dat <- dat %>%
    mutate(
      year = substr(Date,  1, 4),
      month = substr(Date,  6, 7),
      day = substr(Date, 9, 10)) 
    
  dat1 <- dat %>% group_by(year, month) %>% summarise(n=n(), inc = sum(inc), prev = sum(prev))

  # Revove data from the current month as it is not complete
  dat2<-dat1[!(dat1$month=="05" & dat1$year== "2020"),]

  return(dat2)
}

getIncidencePlot <- function(data) {
  return(data %>% ggplot(aes(x=month, y=inc, group=year, color=year)) + geom_line() + 
    labs(x = "Time (month)", y = "Incidence", color = "Year", title = " Incidence of depression each month between 2015 and 2020") + 
    theme_light())
}

drawIncidencePlot <- function(data, filename, directory = OUTPUT_DIRECTORY) {
  plot <- getIncidencePlot(data)
  ggsave(file.path(directory, paste(filename, 'incidence', 'png', sep=".")),plot)
}

getPrevalencePlot <- function(data) {
  return(data %>% ggplot(aes(x=month, y=prev, group=year, color=year)) + geom_line(size=1.25) + 
    labs(x = "Time (month)", y = "Prevalence", color = "Year", title = "Prevalence of depression each month between 2015 and 2020") + 
    theme_light())
}

drawPrevalencePlot <- function(data, filename, directory = OUTPUT_DIRECTORY) {
  plot <- getPrevalencePlot(data);  
  ggsave(file.path(OUTPUT_DIRECTORY, paste(filename, 'prevalence', 'png', sep=".")),plot)
}

# For each file in data directory that starts with "dx"
for(file in list.files(DATA_DIRECTORY, pattern = "^dx")) {
  cat('\nDoing ', file, '\n');
  # load the file into R
  rawData <- loadDataFromFile(file)

  # Process the data into the correct format
  processedData <- processData(rawData)

  drawIncidencePlot(processedData, file);
  drawPrevalencePlot(processedData, file);
}