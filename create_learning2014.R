
#title: "IODS week2"
#author: "Kristiina Räihä"
#date: "8 11 2021"


install.packages("GGally")
install.packages("ggResidpanel")

library(tidyverse)
library(dplyr)
library(GGally)
library(ggplot2)


## 1


#The lrn14 data consist of 183 observation of 60 variables. 
#Most of them are integer, the last one "gender" is character string.

lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

glimpse(lrn14)
str(lrn14)
dim(lrn14)

## 2 

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

# select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14, one_of(keep_columns))

# see the stucture of the new dataset
str(learning2014)

#Exclude observations where the exam points variable is zero.

learning2014 <- filter(learning2014, Points != 0)
learning2014


## 3

#Here I set the working directory to my local data, 
#saved the data as a .csv and checked the structure of the saved data. 

setwd("C:/LocalData/krraiha/Opiskelu HY/Jatko-opinnot/IODS-project/Data")
getwd()

write.csv(learning2014, file = "learning2014.csv")
learning2014_2 <- read.csv("learning2014.csv")

str(learning2014_2)
head(learning2014_2, 10)


## 1

#The data consists of 166 observations (rows) of 8 variables (columns). 
#The variables are: X (rownumber), Gender (chr: "F", "M"), Age (int), Attitude (int), 
#deep (dbl), stra (dbl), surf (dbl), Points (int). 
#I mutated the variable gender as a factor, and dropped the X column (the row numbers). 

learning2014_2

glimpse(learning2014_2)
str(learning2014_2)

#Mutated the gender as a factor. 
learning2014_3 <- learning2014_2%>%
  mutate(gender = as.factor(gender))

#deleted the X variable (rownumber)
learning2014_3 <- select(learning2014_3, -X)

glimpse(learning2014_3)
str(learning2014_3)


## 2

#First I explored the data with couple of scatter matrix.
#What I noticed was that the distributions of age (mean 25) are skewed to the right, 
#as most of the subjects are close to 20 years. 
#The rest of variables are quite normally distributed taking into account the sample size. 
#The gender variable has more observation in F(n=110), than in M(n=56), that might affect the distributions. 
#There are no too high correlations between the variables (collinearity) besides the the variables surf and stra, 
#that seem to measure same thing, as their correlation is 1? 
  

scattermatrix1 <- pairs(learning2014_3[-1], col = learning2014_3$gender)

#just for comparison without the upper panel
scattermatrix2 <- pairs(learning2014_3[,c(2:7)], col = learning2014_3$gender, pch = 20, cex=0.4, upper.panel=NULL)
scattermatrix2

matrix3 <- ggpairs(learning2014_3, mapping = aes(col = gender, alpha = 0.3), lower = list(combo = wrap("facethist", bins = 20)))

gender_n <- learning2014_3%>%
  group_by(gender)%>%
  summarise(n=n())%>%
  ungroup()

gender_n
summary(learning2014_3)
scattermatrix2
matrix3

#The gender variable has more observation in F(n=110), than in M(n=56), that affects the distributions. The distributions of age (mean 25) are skewed to the right, as most of the subjects are close to 20 years. The variables are quite normally distributed taking into account the sample size. 


## 3

#First I printed the correlation matrix again, and decided to choose the following variables to the model
#y (dependent) = Points
#x (explanatory) = Attitude, deep, surf

#The first model (fit) indicated that only the attitude (***) was statistically significant explanatory variable. 
#Next I removed the deep and surf, and entered gender and stra (fit1).
#Still the attitude is the only one that is significant, so I will continue with the model fit2: Points (y)~Attitude (x).


#the correlations in a separate df here as a reminder
correlations <- round(cor(learning2014_3[,c(2:7)]), 2)
correlations

fit <- lm(Points ~ Attitude + deep + surf, data = learning2014_3)
summary(fit)

#Entered the gender and stra as x. 

fit1 <- lm(Points ~ Attitude + gender + stra, data = learning2014_3)
summary(fit1)

#Left the Attitude as x. 

fit2 <- lm(Points ~ Attitude, data = learning2014_3)
summary(fit2)

qplot(Attitude, Points, data = learning2014_3) + geom_smooth(method = "lm")


## 4

#The results of the model "fit2" indicate, that attitude is a statistically significant explanatory variable 
#(F(1,164)=38.61, p<.001)for the students points.
#The adjusted R-squared is 0.1856, so the attitude predicts 19% of the variation of students points.  

summary(fit2)


## 5
  
#The residual plots show that the residuals of the observations are not related to the fitted values, 
#and they occur on both sides of zero (= assumption that the size of error does not depend on explanatory variables). 
#The distribution of residual terms follows more or less a normal distribution, 
#and the Q-Q plot is almost a straight line: (=assumptions of the errors being normally distributed).
#Also a noticable thing is, that there seems to be couple of outliers, that might affect the regression. 


library(ggResidpanel)
resid_panel(fit2)

par(mfrow = c(2,2))
plot(fit2, which = c(1,2,5))

