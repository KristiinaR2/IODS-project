
# Kristiina Räihä
# 24.11.2021

# Introduction to Open Data Science 2021
# RStudio Exercises week4: Data wrangling for week 5

## Data: “Human development” and “Gender inequality"
#Meta files and some technical notes for these datasets can be seen here:
# http://hdr.undp.org/en/content/human-development-index-hdi
# http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf


#The datasets 
library(dplyr)
library(tidyverse)

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")


# The data frame hd (Human development) consists of 195 observations of 8 variables
# 195 rows/ 8 columns. 
str(hd) 
dim(hd)
summary(hd)

# The data frame hd (Human development) consists of 195 observations of 10 variables
# 195 rows/ 10 columns. 
str(gii)
dim(gii)
summary(gii)


#Renaming the variables with (shorter) descriptive names.

colnames(gii)

gii1 <- rename(gii,
               GII_index=Gender.Inequality.Index..GII., 
               MMR=Maternal.Mortality.Ratio,
               ABR=Adolescent.Birth.Rate,
               Rep_per=Percent.Representation.in.Parliament,
               Fem_2nd_ed=Population.with.Secondary.Education..Female.,
               Male_2nd_ed=Population.with.Secondary.Education..Male.,
               Fem_labour=Labour.Force.Participation.Rate..Female.,
               Male_labour=Labour.Force.Participation.Rate..Male.)

str(gii1)

colnames(hd)

hd1 <- rename(hd,
        HDI.Rank=HDI.Rank,
         Country= Country,
         HDI= Human.Development.Index..HDI.,
         LExp=Life.Expectancy.at.Birth,
         Ex_ed= Expected.Years.of.Education,
         Y_ed_mean=Mean.Years.of.Education,
         GNI_capita=Gross.National.Income..GNI..per.Capita,
         GNI_HDI = GNI.per.Capita.Rank.Minus.HDI.Rank)

str(hd1)

#Mutated the “Gender inequality” data and created two new variables: 
#FM_ratio_2nd_ed and FM_ratio_labor.
#The first one is the ratio of Female and Male populations with 
#secondary education in each country and the second 
#the ratio of labour force participation of females and males in each country. 

gii2 <- gii1%>%
  mutate(FM_ratio_2nd_ed= Fem_2nd_ed/Male_2nd_ed,
         FM_ratio_labor= Fem_labour/Male_labour)

str(gii2)

# Joining the data and saving it as a .csv to the IODS-data file

library(data.table)
dt1 <- data.table(hd1, key = "Country") 
dt2 <- data.table(gii2, key = "Country")

human <- dt1[dt2]

# the joined data 'hd_gii_joined' has 195 observations and 19 columns
str(human)
dim(human)
colnames(human)

setwd("C:/LocalData/krraiha/Opiskelu HY/Jatko-opinnot/IODS-project/data")
write.csv(human, "human.csv")




