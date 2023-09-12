# This script reads and wrangles data to prepare for analyses
# Cecilia Martinez
# 2023-09-06

# Load Packages -----------------------------------------------------------
library(readr)
library(dplyr)


# Read in Data ------------------------------------------------------------

# Read in the csv file
gapminder <- read_csv("data/raw_data/gapminder_data.csv")
# read_csv vs read.csv (with underscore readr package, tells you if there are any weird problems)
# readr is in the tidyverse
head(gapminder)
str(gapminder)


# Wrangle Data ------------------------------------------------------------

gap_1980s <- filter(gapminder, year >= 1980, year < 1990)

gap_big <- filter(gapminder, pop > 10000000)


# Write data ------------------------------------------------------------

write_csv(gap_1980s, "data/processed_data/gapminder_1980s.csv")

write_rds(gap_1980s, "data/processed_data/gapminder_1980s.rds")
# can save any r object as an rds
