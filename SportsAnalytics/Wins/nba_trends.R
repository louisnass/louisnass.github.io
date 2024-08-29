#------------------------------------------------------------------------------------

#Title: Linear models discovering play-style trends in historical NBA data

#------------------------------------------------------------------------------------

#Author: Louis Nass

#------------------------------------------------------------------------------------

#Description: Here we will determine which predictors are significant in predicting
# team wins for NBA teams across different decades. We first download the data then
# we generate linear models from each subset of the data using the same predictors.
# We then compare the models, observe which predictors are significant, and comment
# how they play style in the NBA has evolved. We limit ourselves to only 2 point and
# 3 point shots allowed and made. We hypothesize that defense will be more significant
# in earlier years and that offense, particularly 3 point makes, will be more 
# significant in present season.

#------------------------------------------------------------------------------------

#Installing necessary packages
library(tidyverse)
library(ggplot2)

#Loading the data as a dataframe, downloaded from Kaggle
nbaData <- read.csv("basketball_teams.csv")

#Establishing output and input variables

#Output variable: total wins
nbaData$wins <- nbaData$awayWon + nbaData$homeWon

#Input variables, two point baskets made and allowed:
#Two-point baskets made
nbaData$o_2pm <- nbaDatat$o_fgm - nbaData$o_3pm

#Two-point baskets allowed
nbaData$d_2pm <- nbaData$d_fgm - nbaData$d_3pm

#Data pre-processing:

#Subsetting by decade: (We will observe the same 4 seasons accross decades)
#80's
nbaData_80 <- subset(NBA,
                     year >= 1985 & year < 1988,
                     select = c(name, 
                                o_2pm, 
                                o_3pm, d_2pm,d_3pm,wins))

#90's
nbaData_90 <- subset(NBA,
                     year >= 1995 & year < 1998,
                     select = c(name, 
                                o_2pm, 
                                o_3pm, d_2pm,d_3pm,wins))

#00's
nbaData_00 <- subset(NBA,
                     year >= 2005 & year < 2008,
                     select = c(name, 
                                o_2pm, 
                                o_3pm, d_2pm,d_3pm,wins))

#Observing univariate data:
#80's
hist(nbaData_80$o_2pm)
hist(nbaData_80$d_2pm)
hist(nbaData_80$o_3pm)
hist(nbaData_80$d_3pm)
hist(nbaData_80$wins)

#90's
hist(nbaData_90$o_2pm)
hist(nbaData_90$d_2pm)
hist(nbaData_90$o_3pm)
hist(nbaData_90$d_3pm)
hist(nbaData_90$wins)

#00's
hist(nbaData_00$o_2pm)
hist(nbaData_00$d_2pm)
hist(nbaData_00$o_3pm)
hist(nbaData_00$d_3pm)
hist(nbaData_00$wins)

#The data appears approximately normal!

#Observeing interactions between predictors:
#80's
pairs(nbaData_80)

#90's
pairs(nbaData_90)

#00's
pairs(nbaData_00)

#We observe that the correlations among predictors is minimal

#Creating the linear models, observing significant predictors and observing the 
# residuals and leverage plots:
#80's
nbaModel80 <- lm(wins ~ o_2pm + o_3pm + d_2pm + d_3pm,
                 data = nbaData_80)

summary(nbaModel80)

plot(nbaModel80)

#90's
nbaModel90 <- lm(wins ~ o_2pm + o_3pm + d_2pm + d_3pm,
                 data = nbaData_90)

summary(nbaModel90)

plot(nbaModel90)

#00's
nbaModel00 <- lm(wins ~ o_2pm + o_3pm + d_2pm + d_3pm,
                 data = nbaData_00)

summary(nbaModel00)

plot(nbaModel00)

