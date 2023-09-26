# This script is an introduction to function writing in tidyverse as part of Repro workshop
# Cecilia Martinez
# September 26 2023


# Load necessary packages -------------------------------------------------

library(readr)
library(dplyr)

# importing data for biscoe island ----------------------------------------
biscoe_dat <- read_csv("https://raw.githubusercontent.com/cct-datascience/repro-data-sci/r-lessons/lessons/7-intermediate-r-1/lesson-data/Biscoe.csv")
head(biscoe_dat)


# steps to clean data -----------------------------------------------------

# check if there are any NAs in data set, this is in dplyr package
anyNA(biscoe_dat) #TRUE, there is missing data, throw it out

# get rid of NAs, removing incomplete cases with NA omit
biscoe_dat <- biscoe_dat %>% 
  na.omit()

# calculate species and sex combo, the mean value of the each measurement column
# how do we calculate mean for these things for species and sex combinations

biscoe_dat_means <- biscoe_dat %>% 
  group_by(species, sex) %>% 
  summarize(means_bill_length = mean(bill_length_mm), 
            mean_bill_depth = mean(bill_depth_mm), 
            mean_flipper_length = mean(flipper_length_mm))

# so tidy select to perform same operation on multiple columns
  # tidy selct universe is a way to pull things from dataframe with same thigns 
  # these live in across function in select semantics

biscoe_dat_means <- biscoe_dat %>% 
  group_by(species, sex) %>% 
  summarize(across(ends_with("mm") | ends_with("g"), mean))

  # take data frame, group it, calculate themean for each of the ecolumns that end with mm
  # vertical line is the OR logical operator

# specifiying what to do with columns ~ . (output needs to be everything to the right of the tilde, . is whatever
# the data object is)
# do teh same thign with grams to convert to imperial 
# take original value and multiply it by 
biscoe_dat_means_imperial <- biscoe_dat_means %>% 
  mutate(across(ends_with("mm"), ~ . * 0.03937008, .names = "{.col}_in"),
         across(ends_with("g"), ~ . * 0.002204623, .names = "{.col}_lb"))
# take out the mm in the dataframe with column names that are mm_in
# use stringr (string replace), could use rename for individual columns or rename with for multiple columns

biscoe_dat_means_imperial <- biscoe_dat_means_imperial %>% 
  rename_with(~stringr::str_replace(., "mm_in", "in"), .cols = ends_with("mm_in")) %>% 
  rename_with(~stringr::str_replace(., "g_lb", "lb"), .cols = ends_with("g_lb"))


# we now just want imperial measurements and dont want to keep original measurements
# select only columns we created

# se the or operator

biscoe_dat_means_imperial <- biscoe_dat_means_imperial %>% 
  select(c(where(is.character) |
         ends_with("in") |
         ends_with("lb")))

biscoe_dat_means_imperial <- biscoe_dat_means_imperial %>% 
  select(c(where(is.numeric) &
             ends_with("in")))
# won't get rid of species bc it knows its pimportnat for grouping
# documentation tht is a good resource, try where, tidyselection package 

# biggest sources of nonreproducilbity is going to be having a lot of code where you have to 
# copy and paste the same operation over and over again
# if someone 
# functions allow us to increase resproducibility, portability, break scripts into somethign that humans can read and understand
# we can write functions to modularize a complicated script
  # makes it easier to debug the code
# convert the script that we just wrote into a function


# Functions ---------------------------------------------------------------

# to create a function, we give it a name
# within the crly braces, we put whatever we want function to do
# can tell it to give us back some sort of output
my_function <- function() {
  
  return("Ceci is getting better at coding")
  
}

my_function()

# most of the time, we want function to have some kind of input
  # arguments --> which need to have names
  # paste combines character string together 0 tells it to not put spaces in between things that go together
  # paste automatically puts spaces in between sections that you put together
  # paste0 gets rid of automatic spacing 


bev_function <- function(favorite_beverage = "coffee") {
  
  what_to_say <- paste0("I need ", favorite_beverage, "!")
  return(what_to_say)
}

bev_function(favorite_beverage = "tea")

#function takes whatever is needed in the argument and then plugs it in, execute the code and returns it in the end

penguin_function <- function(data_url = "https://raw.githubusercontent.com/cct-datascience/repro-data-sci/r-lessons/lessons/7-intermediate-r-1/lesson-data/Biscoe.csv"){
  
    island_dat <- read_csv(data_url)
    
    island_dat <- island_dat %>% 
      na.omit()
    
    island_dat_means <- island_dat %>% 
      group_by(species, sex) %>% 
      summarize(across(ends_with("mm") | ends_with("g"), mean))
    

    island_dat_means_imperial <- island_dat_means %>% 
      mutate(across(ends_with("mm"), ~ . * 0.03937008, .names = "{.col}_in"),
             across(ends_with("g"), ~ . * 0.002204623, .names = "{.col}_lb"))
    
    
    island_dat_means_imperial <- island_dat_means_imperial %>% 
      rename_with(~stringr::str_replace(., "mm_in", "in"), .cols = ends_with("mm_in")) %>% 
      rename_with(~stringr::str_replace(., "g_lb", "lb"), .cols = ends_with("g_lb"))
    
    
    island_dat_means_imperial <- island_dat_means_imperial %>% 
      select(c(where(is.numeric) &
                 ends_with("in")))
    return(island_dat_means_imperial)

  
}

#this function takes data url, reads it and then gives it back

function_output <- penguin_function()

# functions code, this function cleans the island data and summarizes it to species wide avarages --> and then add more later'
# functions operate like little sandobxes, scoping, nothing exists inside the function that you didnt pass to it from the arguments
# nothing escapes from the function except for what you tell it to return
torgersen_output <- penguin_function("https://github.com/cct-datascience/repro-data-sci/raw/r-lessons/lessons/7-intermediate-r-1/lesson-data/Torgersen.csv")
