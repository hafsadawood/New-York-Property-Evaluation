#Import the libraries
library(tidyverse)
library(readxl)
library(dplyr)
library(data.table)
library(ggplot2)

#read the data

nyProperty = fread("data/NY property 1 million.csv", sep = ",")


# Create a dataset for all the missing ZIP Codes
zipMissing = nyProperty %>%
  filter(is.na(ZIP)) %>%
  select(RECORD, OWNER, STADDR, STORIES, FULLVAL, ZIP) %>%
  mutate(ADDR = paste0(STADDR, ", NY, USA"))

# Write it to a file to perform web scraping
#write.csv(zipMissing, file = "data/zipMissing.csv")

# Performed webscraping for the missing ZIP codes in Python
zipReplaced = fread("data/zipReplaced.csv", sep = ",")

# Number of rows without a ZIP Code
sum(is.na(zipReplaced$ZIP))

# Replace the empty ZIP codes with "00000"
zipReplaced$ZIP[is.na(zipReplaced$ZIP)] <- "00000"

# Change the ZIP code in NY property dataset from int to character
nyProperty$ZIP = as.character(nyProperty$ZIP)



#Replace the missing ZIP codes in nyProperty from zipReplaced

nyProperty$ZIP [is.na(nyProperty$ZIP)] = zipReplaced$ZIP[zipReplaced$RECORD %in% nyProperty$RECORD]

#Check for any missing ZIP codes in nyProperty
sum(is.na(nyProperty$ZIP))


#Verify the ZIP codes in nyProperty by comparing with zipReplaced
nyProperty %>%
  select(RECORD, ZIP) %>%
  filter(RECORD ==1048569)

zipReplaced %>%
  select(RECORD, ZIP) %>%
  filter(RECORD ==1048569)

