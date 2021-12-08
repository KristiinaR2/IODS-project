#####################################

# Kristiina Räihä
# 8.12.2021

# Introduction to Open Data Science 2021
# RStudio Exercises week6: Analysis of longitudinal data
# Data wrangling

#####################################

library(tidyverse)
library(dplyr)
library(data.table) 

# 1. The data

# The 'BPRS' data consists of 40 observations (rows) of 11 variables (int):
# "treatment" (1,2) "subject" (1-20)  
# "week0", "week1", "week2", "week3", "week4", "week5", "week6", "week7", "week8"

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep = " ", header = TRUE)
str(BPRS)
names(BPRS)
summary(BPRS)

# Factor treatment & subject
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

# Converting to long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
glimpse(BPRSL)

# Extracting the week number
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))

# The 'rats' data consists of 16 observations of 13 variables (int):
# "ID" (1-16) "Group" (1-3)  
# "WD1"   "WD8"   "WD15"  "WD22"  "WD29"  "WD36"  "WD43"  
# "WD44"  "WD50"  "WD57"  "WD64" 


# read the RATS data
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')

# Factor variables ID and Group
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

#Converting the data to long form
RATSL <- RATS %>% gather(key = WD, value = Weight, -ID, -Group)

# Add a Time variable to RATS
RATSL <- RATSL %>% mutate(Time = as.integer(substr(WD,3,4)))


# 4. Compairing the long and the wide data

# The difference between long and wide form data is that in the wide format, 
# the (repeated) responses will be in a single row, and each response is in a 
# separate column. In the long format, each row is one time point per observation, 
# so observations will have data in multiple rows. The variables that 
# do not change across time will have the same value in all the rows.

# In the BPRS (wide) the subjects have one row for the values of the different weeks, 
# as in BPRSL (long) the subjects values of bprs follow one week-column that 
# indicates the number of the measurement, and the values are grouped by the 
# treatment time.

View(BPRSL)
View(BPRS)
str(BPRSL)
str(BPRS)

# In the RATS (wide) the rats have one row for the weight of different times, 
# as in RATSL (long) the values of weight follow the time-column that 
# indicates the time of the measurement. In this data the values are grouped 
# by the ID. 

View(RATSL)
View(RATS)
str(RATSL)
str(RATS)



  
