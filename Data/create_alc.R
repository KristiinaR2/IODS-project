#Kristiina Räihä
#Date: 12.11.2021
#This is a data "create_alc.R" from https://archive.ics.uci.edu/ml/datasets/Student+Performance
#

library(tidyverse)
library(dplyr)
library(GGally)
library(ggplot2)

setwd("C:/LocalData/krraiha/Opiskelu HY/Jatko-opinnot/IODS-project/Data")
getwd()

student_mat <- read.csv("student-mat.csv")
str(student_mat)


