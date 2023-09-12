
# first we read and wrangle the data to get just 1980s
source("scripts/01-wrangle.R")

# then we fit a mixed effects model
source("scripts/02-analyze.R")

#If R project file paths are not working correctly
library("here")