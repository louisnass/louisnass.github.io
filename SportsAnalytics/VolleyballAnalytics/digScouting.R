#----------------------------------------------------------------------------------

#Title: Team and player evaluations from point-win probabilities and dig-scores

#----------------------------------------------------------------------------------

#Author: Louis Nass

#----------------------------------------------------------------------------------

#Description: Here we compare point-win probabilities and dig-scores to leverage
# playstyles and to establish strategy. Further, these tools can be used to 
# evaluate player preformance 

#----------------------------------------------------------------------------------
library(tidyverse)
library(ggplot2)
library(matrixStats)
source("dig_BayesianMCProbs.R")

#Here we compute the point-win probabilities and the dig-scores by rotations for teams
# and individual players:

dig_teamData <- read.csv("digDataSample.csv")
dig_teamProbs <- dig_BayesianMCProbs(dig_teamData)

ggplot(dig_teamProbs, aes(x = Rotation, y = AvgWinProb)) +
  geom_bar(stat = "identity", position = "dodge", fill = "#008080") +
  geom_errorbar(aes(ymin = AvgWinProb - WinProbSD, ymax = AvgWinProb + WinProbSD), 
                position = position_dodge(width = 0.9), width = 0.25) +
  geom_text(aes(label = paste0(round(AvgWinProb * 100, 1), "%"), y = 0.1), 
            position = position_dodge(width = 0.9), vjust = 1.5, hjust = 0.5) +
  facet_wrap(~ DigTypeLabel, ncol = 1) +
  labs(title = "Point-win probability by dig-type and rotation - SAMPLE TEAM",
       x = "Rotation",
       y = "Probability") +
  ylim(0, 1) +  
  theme_minimal()

sumSampleTeam <- dig_teamProbs %>%
  group_by(Rotation) %>%
  summarise(meanRankScore = mean(rankScore))
ggplot(sumSampleTeam, aes(x = factor(Rotation), y = meanRankScore)) +
  geom_bar(stat = "identity",  fill = "#6B8E23") +
  geom_text(aes(label = round(meanRankScore, 3)), 
            vjust = -0.5) +
  labs(title = "Dig-score by rotation - SAMPLE TEAM",
       x = "Rotation",
       y = "Dig-Score") +
  theme_minimal() +
  ylim(0, 2.5) + 
  theme(legend.position = "none")




dig_player1Data <- read.csv("digData_playerSample.csv")
dig_player1Probs <- dig_BayesianMCProbs(dig_player1Data)

ggplot(dig_player1Probs, aes(x = Rotation, y = AvgWinProb)) +
  geom_bar(stat = "identity", position = "dodge", fill = "#008080") +
  geom_errorbar(aes(ymin = AvgWinProb - WinProbSD, ymax = AvgWinProb + WinProbSD), 
                position = position_dodge(width = 0.9), width = 0.25) +
  geom_text(aes(label = paste0(round(AvgWinProb * 100, 1), "%"), y = 0.1), 
            position = position_dodge(width = 0.9), vjust = 1.5, hjust = 0.5) +
  facet_wrap(~ DigTypeLabel, ncol = 1) +
  labs(title = "Point-win probability by dig-type and rotation - SAMPLE PLAYER 1",
       x = "Rotation",
       y = "Probability") +
  ylim(0, 1) +  
  theme_minimal()

sumSamplePlayer1 <- dig_player1Probs %>%
  group_by(Rotation) %>%
  summarise(meanRankScore = mean(rankScore))
ggplot(sumSamplePlayer1, aes(x = factor(Rotation), y = meanRankScore)) +
  geom_bar(stat = "identity",  fill = "#6B8E23") +
  geom_text(aes(label = round(meanRankScore, 3)), 
            vjust = -0.5) +
  labs(title = "Dig-score by rotation - SAMPLE PLAYER 1",
       x = "Rotation",
       y = "Dig-Score") +
  theme_minimal() +
  ylim(0, 2.5) + 
  theme(legend.position = "none")



dig_player2Data <- read.csv("digData_player2Sample.csv")
dig_player2Probs <- dig_BayesianMCProbs(dig_player2Data)

ggplot(dig_player2Probs, aes(x = Rotation, y = AvgWinProb)) +
  geom_bar(stat = "identity", position = "dodge", fill = "#008080") +
  geom_errorbar(aes(ymin = AvgWinProb - WinProbSD, ymax = AvgWinProb + WinProbSD), 
                position = position_dodge(width = 0.9), width = 0.25) +
  geom_text(aes(label = paste0(round(AvgWinProb * 100, 1), "%"), y = 0.1), 
            position = position_dodge(width = 0.9), vjust = 1.5, hjust = 0.5) +
  facet_wrap(~ DigTypeLabel, ncol = 1) +
  labs(title = "Point-win probability by dig-type and rotation - SAMPLE PLAYER 2",
       x = "Rotation",
       y = "Probability") +
  ylim(0, 1) +  
  theme_minimal()

sumSamplePlayer2 <- dig_player2Probs %>%
  group_by(Rotation) %>%
  summarise(meanRankScore = mean(rankScore))
ggplot(sumSamplePlayer2, aes(x = factor(Rotation), y = meanRankScore)) +
  geom_bar(stat = "identity",  fill = "#6B8E23") +
  geom_text(aes(label = round(meanRankScore, 3)), 
            vjust = -0.5) +
  labs(title = "Dig-score by rotation - SAMPLE PLAYER 2",
       x = "Rotation",
       y = "Dig-Score") +
  theme_minimal() +
  ylim(0, 2.5) + 
  theme(legend.position = "none")

