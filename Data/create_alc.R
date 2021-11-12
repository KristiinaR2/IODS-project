#Kristiina Räihä, date: 12.11.2021
#RStudio exercise #3 for the IODS course
#Data: UCI Machine Learning Repository (http://archive.ics.uci.edu/ml/dataset)

library(tidyverse)
library(dplyr)
library(GGally)
library(ggplot2)

setwd("C:/LocalData/krraiha/Opiskelu HY/Jatko-opinnot/IODS-project/Data")
getwd()

math <- read.csv2("student-mat.csv")
str(mat)

por <- read.csv2("student-por.csv")
str(por)

#Join the two data sets using all other variables than 
#"failures", "paid", "absences", "G1", "G2", "G3" 
#"as (student) identifiers. 
#Keep only the students present in both data sets (take a look at code here). 
#Explore the structure and dimensions of the joined data. (1 point)

# Define own id for both datasets
por_id <- por %>% mutate(id=1000+row_number()) 
math_id <- math %>% mutate(id=2000+row_number())

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
  
glimpse(pormath)


