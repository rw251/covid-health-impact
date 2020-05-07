#install.packages("httr")
library(httr)
library(here)
library(dplyr)
library(ggplot2)

here() # this should return the location of this saved R file. If not close R and open the file directly from file explorer

# download file from git
gitrepo <- "https://github.com/rw251/covid-health-impact/blob/master/data-extraction/data/" # page where data is stored
filename <- "dx-depression.txt" # name of the file to download

gitrepo <- gsub("github.com", "raw.githubusercontent.com", gitrepo) # changes file name so it downloads the data and not the html file
gitrepo <- gsub("blob/", "", gitrepo)

download.file(paste0(gitrepo,filename), 
              destfile = here(paste(filename)), method = "curl")

# load the downloaded git file into R
dat <- read.delim(here(paste(filename)), sep = ',')

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

#dat1 <- dat %>% group_by(year) %>% summarise(n=n(), a = sum(inc))

#dat1 <- dat %>% filter(year==2015)
#sum(dat1$inc)

dat1 <- dat %>% group_by(year, month) %>% summarise(n=n(), inc = sum(inc), prev = sum(prev))

# ggplot(dat1, aes(x=month, y=inc, color=year)) + geom_line()
# 
# 
# ggplot(dat1, aes(x=month, y=inc, group=year, color=year)) + geom_line() + 
#   labs(x = "Time (month)", y = "Incidence", color = "Year") + 
#   theme_light()

# Revove data from the current month as it is not complete
dat2<-dat1[!(dat1$month=="05" & dat1$year== "2020"),]
# ggplot(dat2, aes(x=month, y=inc, group=year, color=year)) + geom_line() + 
#   labs(x = "Time (month)", y = "Incidence", color = "Year") + 
#   theme_light()

dat2 %>% ggplot(aes(x=month, y=inc, group=year, color=year)) + geom_line() + 
  labs(x = "Time (month)", y = "Incidence", color = "Year", title = " Incidence of depression each month between 2015 and 2020") + 
  theme_light()

dat2 %>% ggplot(aes(x=month, y=prev, group=year, color=year)) + geom_line(size=1.25) + 
  labs(x = "Time (month)", y = "Prevalence", color = "Year", title = "Prevalence of depression each month between 2015 and 2020") + 
  theme_light()

# Take the 5 year average and plot that vs 2020


#### Now try COPD ####
gitrepo <- "https://github.com/rw251/covid-health-impact/blob/master/data-extraction/data/" # page where data is stored
filename <- "dx-copd.txt" # name of the file to download

gitrepo <- gsub("github.com", "raw.githubusercontent.com", gitrepo) # changes file name so it downloads the data and not the html file
gitrepo <- gsub("blob/", "", gitrepo)

download.file(paste0(gitrepo,filename), 
              destfile = here(paste(filename)), method = "curl")

# load the downloaded git file into R
dat <- read.delim(here(paste(filename)), sep = ',')

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

dat2<-dat1[!(dat1$month=="05" & dat1$year== "2020"),]

dat2 %>% ggplot(aes(x=month, y=inc, group=year, color=year)) + geom_line(size=1.25) + 
  labs(x = "Time (month)", y = "Incidence", color = "Year", title = " Incidence of COPD each month between 2015 and 2020") + 
  theme_light()

dat2 %>% ggplot(aes(x=month, y=prev, group=year, color=year)) + geom_line(size=1.25) + 
  labs(x = "Time (month)", y = "Prevalence", color = "Year", title = "Prevalence of COPD each month between 2015 and 2020") + 
  theme_light()
#

#### Now try stroke ####
gitrepo <- "https://github.com/rw251/covid-health-impact/blob/master/data-extraction/data/" # page where data is stored
filename <- "dx-stroke.txt" # name of the file to download

gitrepo <- gsub("github.com", "raw.githubusercontent.com", gitrepo) # changes file name so it downloads the data and not the html file
gitrepo <- gsub("blob/", "", gitrepo)

download.file(paste0(gitrepo,filename), 
              destfile = here(paste(filename)), method = "curl")

# load the downloaded git file into R
dat <- read.delim(here(paste(filename)), sep = ',')

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

dat2<-dat1[!(dat1$month=="05" & dat1$year== "2020"),]

dat2 %>% ggplot(aes(x=month, y=inc, group=year, color=year)) + geom_line(size=1.25) + 
  labs(x = "Time (month)", y = "Incidence", color = "Year", title = " Incidence of stroke each month between 2015 and 2020") + 
  theme_light()

dat2 %>% ggplot(aes(x=month, y=prev, group=year, color=year)) + geom_line(size=1.25) + 
  labs(x = "Time (month)", y = "Prevalence", color = "Year", title = "Prevalence of stroke each month between 2015 and 2020") + 
  theme_light()


#### Now try asthma ####
gitrepo <- "https://github.com/rw251/covid-health-impact/blob/master/data-extraction/data/" # page where data is stored
filename <- "dx-asthma.txt" # name of the file to download

gitrepo <- gsub("github.com", "raw.githubusercontent.com", gitrepo) # changes file name so it downloads the data and not the html file
gitrepo <- gsub("blob/", "", gitrepo)

download.file(paste0(gitrepo,filename), 
              destfile = here(paste(filename)), method = "curl")

# load the downloaded git file into R
dat <- read.delim(here(paste(filename)), sep = ',')

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

dat2<-dat1[!(dat1$month=="05" & dat1$year== "2020"),]

dat2 %>% ggplot(aes(x=month, y=inc, group=year, color=year)) + geom_line(size=1.25) + 
  labs(x = "Time (month)", y = "Incidence", color = "Year", title = " Incidence of asthma each month between 2015 and 2020") + 
  theme_light()

dat2 %>% ggplot(aes(x=month, y=prev, group=year, color=year)) + geom_line(size=1.25) + 
  labs(x = "Time (month)", y = "Prevalence", color = "Year", title = "Prevalence of asthma each month between 2015 and 2020") + 
  theme_light()

#

#### Now try self harm ####
gitrepo <- "https://github.com/rw251/covid-health-impact/blob/master/data-extraction/data/" # page where data is stored
filename <- "dx-self-harm.txt" # name of the file to download

gitrepo <- gsub("github.com", "raw.githubusercontent.com", gitrepo) # changes file name so it downloads the data and not the html file
gitrepo <- gsub("blob/", "", gitrepo)

download.file(paste0(gitrepo,filename), 
              destfile = here(paste(filename)), method = "curl")

# load the downloaded git file into R
dat <- read.delim(here(paste(filename)), sep = ',')

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

dat2<-dat1[!(dat1$month=="05" & dat1$year== "2020"),]

dat2 %>% ggplot(aes(x=month, y=inc, group=year, color=year)) + geom_line(size=1.25) + 
  labs(x = "Time (month)", y = "Incidence", color = "Year", title = " Incidence of self harm each month between 2015 and 2020") + 
  theme_light()

dat2 %>% ggplot(aes(x=month, y=prev, group=year, color=year)) + geom_line(size=1.25) + 
  labs(x = "Time (month)", y = "Prevalence", color = "Year", title = "Prevalence of self harm each month between 2015 and 2020") + 
  theme_light()


#



#
