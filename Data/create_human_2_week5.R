#####################################

# Kristiina Räihä
# 2.12.2021

# Introduction to Open Data Science 2021
# RStudio Exercises week5: Data wrangling continued

#####################################

# I am using the dataset tetrieved, modified and analyzed by Tuomo Nieminen 2017.

# Data: “Human development” and “Gender inequality"
# Meta files and some technical notes for these datasets can be seen here:
# http://hdr.undp.org/en/content/human-development-index-hdi
# http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf

# The data combines several indicators from most countries in the world:

# "Country" = Country name

### Health and knowledge

# "GNI" = Gross National Income per capita
# "Life.Exp" = Life expectancy at birth
# "Edu.Exp" = Expected years of schooling 
# "Mat.Mor" = Maternal mortality ratio
# "Ado.Birth" = Adolescent birth rate

### Empowerment

# "Parli.F" = Percetange of female representatives in parliament
# "Edu2.F" = Proportion of females with at least secondary education
# "Edu2.M" = Proportion of males with at least secondary education
# "Labo.F" = Proportion of females in the labour force
# "Labo.M" " Proportion of males in the labour force

# "Edu2.FM" = Edu2.F / Edu2.M
# "Labo.FM" = Labo2.F / Labo2.M

##########################

# Loading the data
library(tidyr)
library(dplyr)

human <- read.table("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt", sep = "," , header=TRUE)
str(human)
names(human)
summary(human)

# 1. Mutate the data: transform the Gross National Income (GNI) variable to numeric

human <- mutate(human, GNI = as.numeric(gsub(",",".", GNI)))

# str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric 
# = This is an alternative way to do the same as above

# 2. Exclude unneeded variables: keep only the columns matching the following variable names:
# "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F" (1 point)

keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", 
          "GNI", "Mat.Mor", "Ado.Birth", "Parli.F") # columns to keep

human <- dplyr::select(human, one_of(keep)) # selecting the 'keep' columns

complete.cases(human) # printing out a completeness indicator of the 'human' data

data.frame(human[-1], comp = complete.cases(human)) # printing out the data, completeness indicator as the last column

# 3. Removing the rows with missing values (1 point).

human_ <- filter(human, complete.cases(human)) # filter out all rows with NA values

# 4. Removing the observations which relate to regions instead of countries:
#Observations 156-162 =
#"Arab States", "East Asia and the Pacific", "Europe and Central Asia",
#"Latin America and the Caribbean", "South Asia","Sub-Saharan Africa","World"

human_1 <- human_[-c(156:162), ]

str(human_1)

# 5. Defining the row names of the data by the country names and remove the country name column from the data.

row.names(human_1) <- human_1$Country # Defining the row names of the data by the country names 

human_2 <- dplyr::select(human_1, -Country) # Removing the contry name column from the data
str(human_2) # human_2 contains 155 obs. of  8 variables

human <- human_2 # Overwriting the old "human" data
str(human)

#############################
