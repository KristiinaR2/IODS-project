#Kristiina Räihä, date: 12.11.2021
#RStudio exercise #3 for the IODS course
#Data: UCI Machine Learning Repository (http://archive.ics.uci.edu/ml/dataset)

library(tidyverse)
library(dplyr)
library(GGally)
library(ggplot2)

setwd("C:/LocalData/krraiha/Opiskelu HY/Jatko-opinnot/IODS-project/Data")
getwd()

#math <- read.csv2("student-mat.csv") #this works also?
math <- read.table("student-mat.csv", sep = ";" , header=TRUE)
str(math)

#df math:	395 obs. of  33 variables:

#por <- read.csv2("student-por.csv")
por <- read.table("student-por.csv", sep = ";" , header=TRUE)
str(por)

#df por: 649 obs. of  33 variables

---
#This is the code from Data camp, that does not work
  
# common columns to use as identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# join the two datasets by the selected identifiers
math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))

# see the new column names
colnames(math_por)

# glimpse at the data
glimpse(math_por)

# print out the column names of 'math_por'
colnames(math_por)

# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# columns that were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column  vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# glimpse at the new combined data
glimpse(alc)

#382 rows, 33 columns 
# NOTE! There are NO 382 but 370 students that belong to both datasets
#         Original joining/merging example is erroneous!

--- 
  #Join the two data sets using all other variables than 
  #"failures", "paid", "absences", "G1", "G2", "G3" as (student) identifiers.
  
  #Keep only the students present in both data sets (take a look at code here). 
  #Explore the structure and dimensions of the joined data. (1 point)
  
  # Define own id for both datasets
por_id <- por %>% mutate(id=1000+row_number())#1000? 
math_id <- math %>% mutate(id=2000+row_number())#what is the 2000 here?

# Which columns vary in datasets
free_cols <- c("id","failures","paid","absences","G1","G2","G3")

# The rest of the columns are common identifiers used for joining the datasets
join_cols <- setdiff(colnames(por_id),free_cols)

pormath_free <- por_id %>% bind_rows(math_id) %>% select(one_of(free_cols))

# Combine datasets to one long data
#   NOTE! There are NO 382 but 370 students that belong to both datasets
#         Original joining/merging example is erroneous!

pormath <- por_id %>% 
  bind_rows(math_id) %>%
  group_by(.dots=join_cols) %>%
  summarise(                                                          
    n=n(),
    id.p=min(id),
    id.m=max(id),
    failures=round(mean(failures)),     #  Rounded mean for numerical
    paid=first(paid),                   #    and first for chars
    absences=round(mean(absences)),
    G1=round(mean(G1)),
    G2=round(mean(G2)),
    G3=round(mean(G3))%>% 
      filter(n==2, id.m-id.p>650) %>%
      inner_join(pormath_free,by=c("id.p"="id"),suffix=c("",".p")) %>%
      inner_join(pormath_free,by=c("id.m"="id"),suffix=c("",".m")) %>%
      ungroup %>% mutate(
        alc_use = (Dalc + Walc) / 2,
        high_use = alc_use > 2,
        cid=3000+row_number()
      ))

#But the above does not work either, and I don't know how to fix it:
#Error: Problem with `summarise()` column `G3`.
#i `G3 = `%>%`(...)`.
#x no applicable method for 'filter' applied to an object of class "c('double', 'numeric')"
#i The error occurred in group 1: school = "GP", sex = "F", age = 15, address = "R", famsize = "GT3", 
#Pstatus = "T", Medu = 1, Fedu = 1, Mjob = "at_home", Fjob = "other", reason = "home", 
#guardian = "mother", traveltime = 2, studytime = 4, schoolsup = "yes", famsup = "yes", activities = "yes", 
#nursery = "yes", higher = "yes", internet = "yes", romantic = "no", famrel = 3, freetime = 1, goout = 2, 
#Dalc = 1, Walc = 1, health = 1.

glimpse(pormath)
