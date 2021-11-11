
#title: "IODS week2"
#author: "Kristiina Räihä"
#date: "11 11 2021"

library(tidyverse)
library(dplyr)
library(GGally)
library(ggplot2)


## 1 Reading the data


#The lrn14 data consist of 183 observation of 60 variables. 
#Most of them are integer, the last one "gender" is character string.

lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

glimpse(lrn14)
str(lrn14)
dim(lrn14)

## 2 Combining and scaling the data

#Here the a new dataset learning2014 is created combining and scaling the questions of the lrn14 data 
#in to columns "gender","Age","Attitude", "deep", "stra", "surf", "Points". 
#Observations where the exam points variable is zero were filtered. 

deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31") 
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32") 
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28") 

deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(surface_columns)

str(lrn14)

keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")

#Select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14, one_of(keep_columns))

#See the stucture of the new dataset
str(learning2014)

#Exclude observations where the exam points variable is zero.
learning2014 <- filter(learning2014, Points != 0)


## 3 Setting the working directory

#Here I set the working directory to my local data, 
#saved the data as a .csv and checked the structure of the saved data. 

setwd("C:/LocalData/krraiha/Opiskelu HY/Jatko-opinnot/IODS-project/Data")
getwd()

write.csv(learning2014, file = "learning2014.csv")
learning2014_2 <- read.csv("learning2014.csv")

str(learning2014_2)
head(learning2014_2, 10)

