
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

# Explore the datasets: see the structure and dimensions of the data.
#Create summaries of the variables. (1 point)

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


#Look at the meta files and rename the variables with (shorter) descriptive names. (1 point)

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


#Mutate the “Gender inequality” data and create two new variables.
#The first one should be the ratio of Female and Male populations with 
#secondary education in each country. (i.e. edu2F / edu2M). 
#The second new variable should be the ratio of labour force participation of 
#females and males in each country (i.e. labF / labM). (1 point)

gii1 <- gii%>%
  mutate(GII.Rank=GII.Rank,
         Country= Country,
         GII_index= Gender.Inequality.Index..GII.,
         MMR= Maternal.Mortality.Ratio,
         ABR=Adolescent.Birth.Rate,
         Rep_per= Percent.Representation.in.Parliament,
         Fem_2nd_ed= Population.with.Secondary.Education..Female.,
         Male_2nd_ed= Population.with.Secondary.Education..Male.,
         Fem_labour= Labour.Force.Participation.Rate..Female.,
         Male_labour= Labour.Force.Participation.Rate..Male.)

str(gii1)

gii2 <- gii1%>%
  mutate()


#Join together the two datasets using the variable Country as the identifier. 
#Keep only the countries in both data sets (Hint: inner join). 
#The joined data should have 195 observations and 19 variables. 
#Call the new joined data "human" and save it in your data folder. (1 point)


# Join the data sets

# First: define columns that vary in data sets
vary_cols <- c("failures","paid","absences","G1","G2","G3")

# Second: pick the columns which are used as identifiers of respondents
join_cols <- setdiff(colnames(math_data), vary_cols)

# Third: merge the two data sets with inner_join verb and add suffixes
math_por <- inner_join(math_data, por_data, by = join_cols, suffix = c(".math", ".por"))

# the joined data 'math_por' has:
## 370 rows and 39 columns; i.e. 370 observations (students) of 39 variables
## the varying 6 variables have suffixes .por and .math identifying from which data set their are
dim(math_por)
str(math_por)
colnames(math_por)


# create a new data frame with only the joined variables
human <- select(math_por, one_of(join_cols))

write.csv("human.csv")



