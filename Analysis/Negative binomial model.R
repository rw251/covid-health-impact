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

here()

DATA_DIRECTORY <- file.path(here(), 'data-extraction', 'data/')
OUTPUT_DIRECTORY <- file.path(here(), 'outputs') # this file needs creating on the local directory

## load data info
# I created a csv with the names of the data files in column 1 and description in column 2
# The descriptioin is then used to generate the title of the plots
dl <- read_csv(paste0(DATA_DIRECTORY, "/Data_list.csv"))

for(i in seq_along(dl)){
  data_name <- dl[i,1]
  data_desc <- dl[i,2]
  
  dat <- read.delim(file.path(DATA_DIRECTORY,paste0(data_name,".txt")), sep = ',')
  print(names(dat))

  #### Process data
  dat$inc <- dat[,2] # this should be the incidence variable (make sure incidence is always second and prevelence is third variable)
  dat$prev <- dat[,3]
  
  dat <- dat[,-c(2,3)]
  dat$Date <- as.Date(as.character(dat$Date), format = "%Y-%m-%d") # read date variable as dates rather than text
  
  
  dat <- dat %>%
    mutate(
      year = substr(Date,  1, 4),
      month = substr(Date,  6, 7),
      day = substr(Date, 9, 10)) 
  
  dat1 <- dat %>% group_by(year, month) %>% summarise(n=n(), inc = sum(inc), prev = sum(prev))
  
  
  # Remove data from 2020
  #dat2<-dat1[!(dat1$year== "2020"),]
  dat2<-dat1[!(dat1$month== "03" & dat1$year== "2020"| dat1$month== "04" & dat1$year== "2020" | 
                 dat1$month== "05" & dat1$year== "2020" | dat1$month== "06" & dat1$year== "2020"),]
  dat2 <- dat2[-1,]
  # add time variable
  dat2$t <- 1:length(dat2$month)
  
  dat2$month <- as.factor(dat2$month)
  
  #dat3<-dat1[!(dat1$month=="06" & dat1$year== "2020"),] excludes june 2020 but use below code which excludes first and last row
  dat3 <- dat1[c(-1,-length(dat1$inc)),]
  dat3$t <- 1:length(dat3$month)
  dat3$month <- as.factor(dat3$month)
  dat3$t <- 1:length(dat3$month)
  
  dat2 <- as.data.frame(dat2)
  dat3 <- as.data.frame(dat3[-length(dat3$month),])
  d1 <- dat2 %>% select(inc, month, t, year) 
  d2 <- dat3 %>% select(inc, month, t, year) 
  d2$date <- as.Date(as.yearmon(paste(as.numeric(as.character(d2$year)), as.numeric(as.character(d2$month)),sep="-")))
  
  ## Fit the model, predict the outcomes
  fit <- glm.nb(inc~ month + t, data = d1) # could use offset as number of consultations each month
  
  d2 <- cbind(d2, predict(fit, d2, type = "link", se.fit=TRUE))
  d2 <- within(d2, {
    pred <- exp(fit)
    LL <- exp(fit - 1.96 * se.fit)
    UL <- exp(fit + 1.96 * se.fit)
  })
  
  ## Plot and save 
  g1 <- d2  %>% ggplot(aes(x=date, y=inc))  + geom_line(aes(x=date, y=inc, color = "Observed")) + 
    geom_ribbon(aes(ymax = UL, ymin = LL), alpha= 0.1) +  
    geom_line(aes(x=date, y=pred, color= "Predicted")) +
    labs(x = "Time (month/year)", y = "Incidence", color = "Year", title = paste("Predicted and observed incidence of", data_desc,"between 2010 and 2020")) + 
    theme_light() +
    scale_colour_manual(name=NULL, values = c("blue", "black")) +
    scale_x_date(labels = date_format("%m/%Y"), breaks = "12 months")
  
  
  ggsave(plot=g1, path=OUTPUT_DIRECTORY, filename = paste(data_desc,"inc_10_20.png"))
  
   g2 <- d2 %>% filter(year=="2020" | year=="2019") %>% ggplot(aes(x=date, y=inc))  + geom_line(aes(x=date, y=inc, color = "Observed")) +
     geom_ribbon(aes(ymax = UL, ymin = LL), alpha= 0.1) +
     geom_line(aes(x=date, y=pred, color= "Predicted")) +
     labs(x = "Time (month/year)", y = "Incidence", color = "Year", title = paste("Predicted and observed incidence of", data_desc,"condition in 2019 and 2020")) +
     theme_light() +
     scale_colour_manual(name=NULL, values = c("blue", "black")) +
     scale_x_date(labels = date_format("%m/%Y"), date_breaks = "2 months")
  
   ggsave(g2, path=OUTPUT_DIRECTORY, filename = paste(data_desc,"inc_19_20.png"))

  d2$test <- paste( eval(round(d2$pred,3)), "(CI:",eval(round(d2$LL,3)), "-",eval(round(d2$UL,3)),")")

  print(paste("The observed and predicted incidence of", data_desc, "in March 2020 was",
              paste( eval(d2[which(d2$month=="03" & d2$year=="2019"),1]),"and", 
                     paste( eval(d2[which(d2$month=="03" & d2$year=="2019"),12]),"respectively", sep = ','))))

  print(paste("The observed and predicted incidence of", data_desc, "in April 2020 was",
              paste( eval(d2[which(d2$month=="04" & d2$year=="2019"),1]),"and", 
                     paste( eval(d2[which(d2$month=="03" & d2$year=="2019"),12]),"respectively", sep = ','))))
  
  print(paste("The observed and predicted incidence of", data_desc, "in May 2020 was",
              paste( eval(d2[which(d2$month=="05" & d2$year=="2019"),1]),"and", 
                     paste( eval(d2[which(d2$month=="03" & d2$year=="2019"),12]),"respectively", sep = ','))))
}
###

#
#
#
###
##
#
#