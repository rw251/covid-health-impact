#install.packages("httr")
library(httr)
library(here)
library(dplyr)
library(ggplot2)
library(cowplot)

DATA_DIRECTORY <- file.path(here(), 'data-extraction', 'data')
OUTPUT_DIRECTORY <- file.path(here(), 'outputs')

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

getIncidencePlot <- function(data, lowerCaseCondition, title = paste("Incidence of", lowerCaseCondition, "each month between 2015 and 2020")) {
  return(data %>% ggplot(aes(x=month, y=inc, group=year, color=year)) + geom_line() + 
    labs(x = "Time (month)", y = "Incidence", color = "Year", title = title) + 
    theme_light())
}

drawIncidencePlot <- function(data, lowerCaseCondition, conditionNameDashed, directory = OUTPUT_DIRECTORY) {
  plot <- getIncidencePlot(data, lowerCaseCondition)
  plotFilename <- paste(conditionNameDashed, 'incidence', 'png', sep=".")
  ggsave(file.path(directory, plotFilename),plot + expand_limits(y = 0))
}

getPrevalencePlot <- function(data, lowerCaseCondition, title = paste("Prevalence of", lowerCaseCondition, "each month between 2015 and 2020")) {
  return(data %>% ggplot(aes(x=month, y=prev, group=year, color=year)) + geom_line(size=1.25) + 
    labs(x = "Time (month)", y = "Prevalence", color = "Year", title = title) + 
    theme_light())
}

drawPrevalencePlot <- function(data, lowerCaseCondition, conditionNameDashed, directory = OUTPUT_DIRECTORY) {
  plot <- getPrevalencePlot(data, lowerCaseCondition)
  plotFilename <- paste(conditionNameDashed, 'prevalence', 'png', sep=".")
  ggsave(file.path(directory, plotFilename),plot + expand_limits(y = 0))
}

drawCombinedPlot <- function(data, conditionNameLowerCase, conditionNameDashed, directory = OUTPUT_DIRECTORY) {
  incPlot <- getIncidencePlot(data, conditionNameLowerCase, title = 'Incidence')
  prevPlot <- getPrevalencePlot(data, conditionNameLowerCase, title = 'Prevalence')

  plot_row <- plot_grid(incPlot + expand_limits(y = 0), prevPlot + expand_limits(y = 0), labels = "AUTO")

  # now add the title
  title <- ggdraw() + 
    draw_label(
      paste("Incidence and prevalence of", conditionNameLowerCase, "each month between 2015 and 2020"),
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

  plotFilename <- paste(conditionNameDashed, 'combined', 'png', sep=".")
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

  drawIncidencePlot(processedData, conditionNameLowerCase, conditionNameDashed)
  drawPrevalencePlot(processedData, conditionNameLowerCase, conditionNameDashed)

  drawCombinedPlot(processedData, conditionNameLowerCase, conditionNameDashed)
}