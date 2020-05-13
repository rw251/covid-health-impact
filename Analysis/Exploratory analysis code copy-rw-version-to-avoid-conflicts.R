#install.packages("httr")
library(httr)
library(here)
library(dplyr)
library(ggplot2)

here() # this should return the location of this saved R file. If not close R and open the file directly from file explorer

doSomething <- function(filename) {
  # load the file into R
  dat <- read.delim(here('data-extraction', 'data', filename), sep = ',')

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

  p1 <- dat2 %>% ggplot(aes(x=month, y=inc, group=year, color=year)) + geom_line() + 
    labs(x = "Time (month)", y = "Incidence", color = "Year", title = " Incidence of depression each month between 2015 and 2020") + 
    theme_light()

  p2 <- dat2 %>% ggplot(aes(x=month, y=prev, group=year, color=year)) + geom_line(size=1.25) + 
    labs(x = "Time (month)", y = "Prevalence", color = "Year", title = "Prevalence of depression each month between 2015 and 2020") + 
    theme_light()

  ggsave(here('outputs',paste(filename, 'incidence', 'png', sep=".")),p1)
  ggsave(here('outputs',paste(filename, 'prevalence', 'png', sep=".")),p2)
}

files <- list.files(here('data-extraction', 'data'))

for(file in files) {
  doSomething(file)
}
