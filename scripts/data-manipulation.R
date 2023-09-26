# This script is an introduction to tidyverse data manipulation through Repro workshop
# Cecilia Martinez
# September 21 2023

# Load packages -----------------------------------------------------------

library(tidyr) # reshaping data
library(palmerpenguins)
library(dplyr) # dataframe manipulation

# Process data
# be explicit about assigning penguins data as an object
penguins_data <- penguins

#how to empathize with R and how R engages with data
#dataframe - common format for storing data in R
#tibble - table that is very similar to dataframe 
  #slightly different behavior than df and different under the hood
#something can be a tibble that is also a dataframe
class(penguins_data)

#data types, can check with head
  #integer
  #dbl - has decimal points
  #booleans - T/F values
  #fct - factors sorts categorical data
head(penguins_data)

# tells you the structure of something, factor --> this is avariable that has three 
# different options for what it can do 
# factor vs character string
  # R uses factors under the hood to order variables - ordinal variables 
  # powerful: you can set the order for the factor in R: so you know how it is structured
  # not all factors are ordered 
  # a factor is stored with a number associated with the value
str(penguins_data)
unique(penguins_data$species)
levels(penguins_data$island)
# can check if the order means something
is.ordered(penguins_data$island)

# R is a vectorized programming language
# you can do something to whole vector at once
# some functions you can pass to a vector, and it will understand it
# Example 
mean(penguins_data$year)
mean(penguins_data$body_mass_g, na.rm = T) #get NA, missing data in the vector, ignore NAs

# paste function --> can stick strings and text together
  # paste operation applied to every element of that vector
years_of_sampling <- paste("Year:", penguins_data$year)
  # paste does not modify the year column or overwrite it 
  # this stored as a character string

# which islands were sampled in which years: subsets data
island_year <- select(penguins_data, island, year)
str(island_year)

#pull out rows of data for all penguins on torgersen island
torgersen_penguins <- filter(penguins_data, island == "Torgersen")
str(torgersen_penguins)

#filter so that species is Adelie
adelie_sp <- filter(penguins_data, species =="Adelie")
str(adelie_sp)

#want information for all of the penguins on torgerson island but only care about sp
#and sex
torgersen_penguins_only_sexandsp <- torgersen_penguins %>% select(species, sex)
str(torgersen_penguins_only_sexandsp)

#this way is sequential manipulations, tidyverse can allow you to chain things together 
#in code paragraphs so that you run things in multiple chunks
torgersen_penguins_onechunk <- filter(penguins_data, island == "Torgersen") %>% 
  select(species, sex)

#create a new column in dataframe
#lets round the nearest integer for the bill length
torgersen_penguins <- torgersen_penguins %>% 
  mutate(rounded_bill_length = round(bill_length_mm)) %>% 
  select(species, sex, rounded_bill_length)

#calculating summary statstics and via group
#what average bill length for penguins based on species
torgersen_penguins_summary <- torgersen_penguins %>% 
  group_by(species) %>% 
  summarize(mean_bill_length = mean(rounded_bill_length, na.rm = T))

#we can group by multiple variables and also group by sex
torgersen_penguins_summary <- torgersen_penguins %>% 
  group_by(species, sex) %>% 
  summarize(mean_bill_length = mean(rounded_bill_length, na.rm = T))

#gets counts for number of individuals in each category
penguin_counts <- penguins_data %>% 
  group_by(species, sex, island) %>% 
  summarize(n = dplyr::n())
#dplyr n is doing is counting how many rows there are in each category 
  #no individuals fell into that category - so if there are no rows it drops the group 
  #and returns NA

#tidyr - data manipulation, if you want to put 0 in place of NA you can do that
penguins_wide <- penguin_counts %>% 
  pivot_wider(names_from = island, values_from = n, values_fill = 0)

#do the thing in reverse, make data long again
penguins_long <- penguins_wide %>% 
  pivot_longer(-c(species, sex), values_to = "count")
