#install.packages("httr")
library(httr)
library(here)
library(dplyr)
library(ggplot2)
library(cowplot)

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

getIncidencePlot <- function(data, lowerCaseCondition) {
  return(data %>% ggplot(aes(x=month, y=inc, group=year, color=year)) + geom_line() + 
    labs(x = "Time (month)", y = "Incidence", color = "Year", title = paste("Incidence of", lowerCaseCondition, "each month between 2015 and 2020")) + 
    theme_light())
}

drawIncidencePlot <- function(data, lowerCaseCondition, conditionNameDashed, directory = OUTPUT_DIRECTORY) {
  plot <- getIncidencePlot(data, lowerCaseCondition)
  ggsave(file.path(directory, paste(conditionNameDashed, 'incidence', 'png', sep=".")),plot)
}

getPrevalencePlot <- function(data, lowerCaseCondition) {
  return(data %>% ggplot(aes(x=month, y=prev, group=year, color=year)) + geom_line(size=1.25) + 
    labs(x = "Time (month)", y = "Prevalence", color = "Year", title = paste("Prevalence of", lowerCaseCondition, "each month between 2015 and 2020")) + 
    theme_light())
}

drawPrevalencePlot <- function(data, lowerCaseCondition, conditionNameDashed, directory = OUTPUT_DIRECTORY) {
  plot <- getPrevalencePlot(data, lowerCaseCondition);  
  ggsave(file.path(directory, paste(conditionNameDashed, 'prevalence', 'png', sep=".")),plot)
}

drawCombinedPlot <- function(data, conditionNameLowerCase, conditionNameDashed, directory = OUTPUT_DIRECTORY) {
  incPlot <- getIncidencePlot(data, conditionNameLowerCase);
  prevPlot <- getPrevalencePlot(data, conditionNameLowerCase);

  combined <- plot_grid(incPlot, prevPlot, labels = "AUTO")
  save_plot(file.path(directory, paste(conditionNameDashed, 'combined', 'png', sep=".")), combined, ncol = 2)
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

  cat('Doing ', conditionNameLowerCase, '\n');
  # load the file into R
  rawData <- loadDataFromFile(file)

  # Process the data into the correct format
  processedData <- processData(rawData)

  drawIncidencePlot(processedData, conditionNameLowerCase, conditionNameDashed);
  drawPrevalencePlot(processedData, conditionNameLowerCase, conditionNameDashed);

  drawCombinedPlot(processedData, conditionNameLowerCase, conditionNameDashed);
}