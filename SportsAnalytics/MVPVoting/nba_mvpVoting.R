#------------------------------------------------------------------------------------

#Title: Predicting MVP votes 

#------------------------------------------------------------------------------------

#Author: Louis Nass

#------------------------------------------------------------------------------------

#Description: Here we develop several models to predict NBA MVP votes for players in
# the 2018-19 NBA season. We use individual season data for players and predict the
# log of their expected number of votes. We do this considering models trained on 
# historical data ranging from 1980 to 2018, then models that are trained on subsets
# of data from each decade ('80's, '90's, '00's, and '10's). We then compare the 
# significant predictors from each model and estimate the MVP votes according to each
# model.

#------------------------------------------------------------------------------------

#Installing necessary packages
library(tidyverse)
library(ggplot2)

#Loading our training data
nba_playerData_train <- tibble(read_csv("datasets_193124_429163_mvp_votings.csv"))

#Loading our testing data
nba_playerData_test <- tibble(read_csv("datasets_193124_429163_test_data.csv"))

#Data pre-processing:
#We consider adjusted votes received to account for varying levels of votes over
# multiple seasons. 
nba_playerData_train <- nba_playerData_train %>%
  mutate(votes_adjusted = round(max(votes_max)*award_per))

#Subseting the training data into different decades:
#80's
nba_playerData80_train <- nba_playerData_train %>%
  filter(season %in% c("1980-81",
                       "1981-82",
                       "1982-83",
                       "1983-84",
                       "1984-85",
                       "1985-86",
                       "1986-87",
                       "1987-88",
                       "1988-89",
                       "1989-90"))

#90's
nba_playerData90_train <- nba_playerData_train %>%
  filter(season %in% c("1990-91",
                       "1991-92",
                       "1992-93",
                       "1993-94",
                       "1994-95",
                       "1995-96",
                       "1996-97",
                       "1997-98",
                       "1998-99",
                       "1999-00"))

#00's
nba_playerData00_train <- nba_playerData_train %>%
  filter(season %in% c("2000-01",
                       "2001-02",
                       "2002-03",
                       "2003-04",
                       "2004-05",
                       "2005-06",
                       "2006-07",
                       "2007-08",
                       "2008-09",
                       "2009-10"))

#10's
nba_playerData10_train <- nba_playerData_train %>%
  filter(season %in% c("2010-11",
                       "2011-12",
                       "2012-13",
                       "2013-14",
                       "2014-15",
                       "2015-16",
                       "2016-17",
                       "2017-18"))


#We observe histograms of the adjusted votes:
hist(nba_playerData_train$votes_adjusted,
     freq = TRUE, 
     main = 'Distribution of adjusted votes received',
     xlab = 'Adjusted votes received')

hist(log(nba_playerData_train$votes_adjusted),
     freq = TRUE, 
     main = 'Distribution of log of adjusted votes received',
     xlab = 'Log of adjusted votes received')

#We see that the votes received are heavily left skewed, but when we take the 
# log of the adjusted votes the distribution is more even, hence we will assume that
# the votes received are poisson distributed.

#Model definitions and summaries:
#80's
nba_mvpModel80 <- glm(votes_adjusted ~.-player-season-votes_first-points_max-points_won-award_share-award_per, 
                      family = "poisson", 
                      data = nba_playerData80_train)

summary(nba_mvpModel80)

#90's
nba_mvpModel90 <- glm(votes_adjusted ~.-player-season-votes_first-points_max-points_won-award_share-award_per, 
                      family = "poisson", 
                      data = nba_playerData90_train)

summary(nba_mvpModel90)

#00's
nba_mvpModel00 <- glm(votes_adjusted ~.-player-season-votes_first-points_max-points_won-award_share-award_per, 
                      family = "poisson", 
                      data = nba_playerData00_train)

summary(nba_mvpModel00)

#10's
nba_mvpModel10 <- glm(votes_adjusted ~.-player-season-votes_first-points_max-points_won-award_share-award_per, 
                      family = "poisson", 
                      data = nba_playerData10_train)

summary(nba_mvpModel10)

#All
nba_mvpModelAll <- glm(votes_adjusted ~.-player-season-votes_first-points_max-points_won-award_share-award_per, 
                      family = "poisson", 
                      data = nba_playerData_train)

summary(nba_mvpModelAll)

#Predict MVP votes for test data across different models:
#Here we will replace any NA values with 0 in our test data
nba_playerData_test[is.na(nba_playerData_test)] = 0

#80's 
mvp_votes80 <- exp(predict(nba_mvpModel80,
                       new = nba_playerData_test))

#90's 
mvp_votes90 <- exp(predict(nba_mvpModel90,
                       new = nba_playerData_test))

#00's 
mvp_votes00 <- exp(predict(nba_mvpModel00,
                       new = nba_playerData_test))

#10's 
mvp_votes10 <- exp(predict(nba_mvpModel10,
                       new = nba_playerData_test))

#All 
mvp_votesAll <- exp(predict(nba_mvpModelAll,
                       new = nba_playerData_test))


#Our predicted MVP votes for each model
nba_playerData_test <- nba_playerData_test %>%
  mutate(predicted_votes_all = mvp_votesAll, 
         predicted_votes_80 = mvp_votes80, 
         predicted_votes_90 = mvp_votes90, 
         predicted_votes_00 = mvp_votes00, 
         predicted_votes_10 = mvp_votes10)


