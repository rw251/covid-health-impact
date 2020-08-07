# This helps non-R users run the project without configuring R

# First we add the local ./lib directory to the R library path
currentLibPaths <- .libPaths()
currentLibPaths <- c(currentLibPaths, './lib')
.libPaths(currentLibPaths)

# Then we declare the packages that we need
list.of.packages <- c("ggplot2", "httr", "dplyr", "here", "conflicted", "xts", "readr", "rmarkdown", "knitr", "svglite", "ciTools")

# We check to see which if any are already installed, and if not we install them locally
# to the ./lib directory
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, 'lib', repos = c('https://cran.ma.imperial.ac.uk/', 'https://www.stats.bris.ac.uk/R/'))

# Add pandoc to path (only works on windows - must change for other environments)
Sys.setenv(RSTUDIO_PANDOC="C:\\Program Files\\RStudio\\bin\\pandoc")

# Now we execute the main code knowing that all packages are installed
#source("./Analysis/main.R")
source("./Analysis/simple-time-series-modelling.R")
source("./Analysis/negative-binomial-modelling.R")