# -------------------------------------------------------------------------------------------
# Title: Sample volleyball scouting reports
# 
# Author: Louis Nass
# 
# Date: September 25, 2024
# -------------------------------------------------------------------------------------------
#   
# Description: Here we apply a Bayesian Markov Chain to estimate the win probabilities of
#   digs based on ranks. The digs are given a grade (0-3) depending on the offensive 
#   opprotunity after the play, 0 being an error, 3 resulting in an in-system attack with
#   all potential attacking opprotunities. We track transition counts and sample from 
#   Gamma random variables to estimate a distribution of point-win probabilities. We apply 
#   a similar process for receptions and consider the efficiency of attacks based on the 
#   defender's ability to dig player attacks. We also define a dig- and reception- score that
#   is based from baseball's slugging percentage. This metric evaluates how well a player 
#   handles an opponent's attack to setup their own team. Here we have replaced the names
#   of teams and player's to provide an example of a scouting report.
#   
# ------------------------------------------------------------------------------------------
#     
# Input: data volley file with plays from recent match
#   
# Output: Figures for team and player dig, reception and attack efficiency
# 
# -----------------------------------------------------------------------------------------
 

#Read CSV file with sample data 
teamPlays <- read_csv('teamPlaysSample.csv')

#Define team and players of interest for digs, receptions, and attack efficiency
teamName <- "Team 1"

teamAbbr <- teamName

playerNumberDig <- c(1, 4)

playerNameDig <- c("Player 1", "Player 2")

playerNumberReception <- playerNumberDig

playerNameReception <- playerNameDig

playerNumberAttacker <- playerNumberDig

playerNameAttacker <- playerNameDig

#Prepare data for Markov Chain
digData <- teamPlays %>%
  group_by(point_id) %>%
  mutate(home_rotation = as.factor((7 - home_setter_position)%%6 + 1),
         away_rotation = as.factor((7 - visiting_setter_position)%%6 +1),
         home_pointWin = ifelse(point_won_by == home_team,
                                1,
                                0),
         away_pointWin = ifelse(point_won_by == visiting_team,
                                1,
                                0),
         digAttackerName = case_when(
           skill == 'Dig' & lag(skill) == 'Attack' ~ lag(player_name),
           skill == 'Dig' & lag(skill) == 'Block' & lag(skill, 2) == 'Attack' ~ lag(player_name, 2),
           .default = 'NA'))%>%
  ungroup() %>%
  filter(skill == "Dig",
         evaluation_code != "!") %>%
  mutate(digRank = ifelse(evaluation_code == "=",
                          "D0",
                          ifelse(evaluation_code == "-",
                                 "D1",
                                 ifelse(evaluation_code == "+",
                                        "D2",
                                        "D3")))) %>%
  select(team,
         home_team,
         visiting_team,
         match_id,
         point_id,
         home_rotation,
         away_rotation,
         set_number,
         home_pointWin,
         away_pointWin,
         player_number,
         player_name,
         digAttackerName,
         evaluation_code,
         digRank
  ) 

digData$home_rotation <- factor(digData$home_rotation, levels = c('1', '2', '3', '4', '5', '6'))

digData$away_rotation <- factor(digData$away_rotation, levels = c('1', '2', '3', '4', '5', '6'))

teamDigData <- digData %>%
  filter(team == teamName) %>%
  mutate(rotation = ifelse(home_team == teamName,
                           home_rotation,
                           away_rotation),
         pointWin = ifelse((home_team == teamName & home_pointWin ==1 ) | (visiting_team == teamName & away_pointWin ==1),
                           1,
                           0))%>%
  arrange(match_id, 
          point_id, 
          desc(row_number())) %>%
  group_by(match_id,
           point_id) %>%
  mutate(digResult = ifelse(
    row_number() == 1, 
    if_else(pointWin == 1, "W", "L"),
    lag(digRank))) %>%
  ungroup() %>%
  mutate(digToResult = as.factor(paste(digRank,
                                       digResult,
                                       sep = "-")),
         dummy = 1) %>%
  pivot_wider(names_from = digToResult, 
              values_from = dummy, 
              values_fill = 0, 
              values_fn = sum) 


oppTeamDigData <- digData %>%
  filter(team != teamName)  %>%
  mutate(rotation = ifelse(home_team == teamName,
                           home_rotation,
                           away_rotation),
         pointWin = ifelse((home_team != teamName & home_pointWin ==1 ) | (visiting_team != teamName & away_pointWin ==1),
                           1,
                           0))%>%
  arrange(match_id, 
          point_id, 
          desc(row_number())) %>%
  group_by(match_id,
           point_id) %>%
  mutate(digResult = ifelse(
    row_number() == 1, 
    if_else(pointWin == 1, "W", "L"),
    lag(digRank))) %>%
  ungroup() %>%
  mutate(digToResult = as.factor(paste(digRank,
                                       digResult,
                                       sep = "-")),
         dummy = 1) %>%
  pivot_wider(names_from = digToResult, 
              values_from = dummy, 
              values_fill = 0, 
              values_fn = sum) 



full_rotations <- as.factor(1:6)

digResultsOrdered <- c("D1-D0",
                       "D1-D1",
                       "D1-D2",
                       "D1-D3",
                       "D1-W",
                       "D1-L",
                       "D2-D0",
                       "D2-D1",
                       "D2-D2",
                       "D2-D3",
                       "D2-W",
                       "D2-L",
                       "D3-D0",
                       "D3-D1",
                       "D3-D2",
                       "D3-D3",
                       "D3-W",
                       "D3-L",
                       "D0-L")
#Load Markov Chain Function
source("dig_BayesianMCProbs.R")
#Comppute and generate figures for players and team
transitionDigCountsTeam <- teamDigData %>%
  select(rotation, 
         all_of(digResultsOrdered))%>%
  group_by(rotation) %>%
  summarise(across(1:19, sum, na.rm = TRUE))

teamDigProbs <- dig_BayesianMCProbs(transitionDigCountsTeam)

ggplot(teamDigProbs, aes(x = Rotation, y = AvgWinProb, fill = DigTypeLabel)) +
        geom_bar(stat = "identity", position = "dodge") +
        geom_errorbar(aes(ymin = (AvgWinProb) - WinProbSD, ymax = (AvgWinProb) + WinProbSD), 
                      position = position_dodge(width = 0.9), width = 0.25) +
        geom_text(aes(label = paste0(round((AvgWinProb) * 100, 1), "%"), y = (AvgWinProb) -  WinProbSD), 
                  position = position_dodge(width = 0.9), vjust = 1.5, hjust = 0.5) +
        labs(title = paste0(teamName," dig-type point-win probability by rotation"),
             x = paste0(teamAbbr, " rotation"),
             y = "Probability") +
        ylim(0, 1) +  
        theme_minimal()

sumDigTeam <- teamDigProbs %>%
  group_by(Rotation) %>%
  summarise(meanRankScore = mean(rankScore))



  ggplot(sumDigTeam, aes(x = factor(Rotation), y = meanRankScore, fill = meanRankScore)) +
    geom_bar(stat = "identity") +
    geom_text(aes(label = round(meanRankScore, 3)), 
              vjust = -0.5) +
    scale_fill_gradient(low = "blue", high = "red", limits = c(0.5, 3)) +
    labs(title = paste0(teamAbbr, " dig-score by rotation"),
         x = paste0(teamAbbr, " rotation"),
         y = "Dig-Score") +
    theme_minimal() +
    ylim(0, 3) 


if(length(playerNameDig)>0){
  for(j in 1:length(playerNameDig)){
    transitionDigCountsPlayer <- teamDigData %>%
      filter(player_name == playerNameDig[j]) %>%
      select(rotation, 
             all_of(digResultsOrdered)) %>%
      group_by(rotation) %>%
      summarise(across(1:19, sum, na.rm = TRUE))
    
    missingRotations <- setdiff(full_rotations, transitionDigCountsPlayer$rotation)
    
    
    for (rotation in missingRotations) {
      new_row <- data.frame(rotation = factor(rotation, levels = levels(transitionDigCountsPlayer$rotation)),
                            matrix(rep(0, 19), ncol = 19))
      
      colnames(new_row) <- c("rotation", digResultsOrdered)
      
      transitionDigCountsPlayer <- rbind(transitionDigCountsPlayer, new_row)
    }
    
    transitionDigCountsPlayer <- transitionDigCountsPlayer %>%
      arrange(rotation)
    
    
    playerDigProbs <- dig_BayesianMCProbs(transitionDigCountsPlayer)
    
    
    
    print(  ggplot(playerDigProbs, aes(x = Rotation, y =AvgWinProb, fill = DigTypeLabel)) +
        geom_bar(stat = "identity", position = "dodge") +
        geom_errorbar(aes(ymin = (AvgWinProb) - WinProbSD, ymax = (AvgWinProb) + WinProbSD), 
                      position = position_dodge(width = 0.9), width = 0.25) +
        geom_text(aes(label = paste0(round((AvgWinProb) * 100, 1), "%"), y = (AvgWinProb) - WinProbSD), 
                  position = position_dodge(width = 0.9), vjust = 1.5, hjust = 0.5) +
        labs(title = paste0("Dig-type point-win probability by rotation - ", playerNumberDig[j], " ", teamAbbr),
             x = paste0(teamAbbr," rotation"),
             y = "Probability") +
        ylim(0, 1) +  
        theme_minimal()
    )
    
    
    
    
    
    sumDigPlayer <- playerDigProbs %>%
      group_by(Rotation) %>%
      summarise(meanRankScore = mean(rankScore))
    
    
    
     print( ggplot(sumDigPlayer, aes(x = factor(Rotation), y = meanRankScore, fill = meanRankScore)) +
        geom_bar(stat = "identity") +
        geom_text(aes(label = round(meanRankScore, 3)), 
                  vjust = -0.5) +
        scale_fill_gradient(low = "blue", high = "red", limits = c(0.5, 3)) +
        labs(title = paste0("Dig-score by rotation - ", playerNumberDig[j], " ",teamAbbr),
             x = paste0(teamAbbr," rotation"),
             y = "Dig-Score") +
        theme_minimal() +
        ylim(0, 3) 
     )
    
  }
}
 #Load reception Markov Chain 
  source("reception_BayesianMCProbs.R")
  #Data preparation for reception
  teamReceptionData <- teamPlays %>%
    mutate(rotation = as.factor(ifelse(home_team == teamName,
                                       (7-home_setter_position)%%6 +1,
                                       (7-visiting_setter_position)%%6 +1)),
           pointWin = ifelse(point_won_by == teamName,
                             1,
                             0)) %>%
    filter(team == teamName, 
           skill == "Reception") %>%
    mutate(receptionRank = ifelse(evaluation_code == "=",
                                  "R0",
                                  ifelse((evaluation_code == "-") | 
                                           (evaluation_code == "/"),
                                         "R1",
                                         ifelse((evaluation_code == "+") |
                                                  (evaluation_code == "!"),
                                                "R2",
                                                "R3")))) %>%
    select(match_id,
           point_id,
           rotation,
           set_number,
           pointWin,
           player_number,
           player_name,
           evaluation_code,
           receptionRank
    ) %>%
    group_by(match_id,
             point_id) %>%
    mutate(receptionResult = 
             if_else(pointWin == 1, 
                     "W", 
                     "L")) %>%
    ungroup() %>%
    mutate(receptionToResult = as.factor(paste(receptionRank,
                                               receptionResult,
                                               sep = "-")),
           dummy = 1) %>%
    pivot_wider(names_from = receptionToResult, 
                values_from = dummy, 
                values_fill = 0, 
                values_fn = sum) %>%
    mutate(across(11:17, ~ as.numeric(as.character(.))))
  
  receptionResultsOrdered <- c("R1-W",
                               "R1-L",
                               "R2-W",
                               "R2-L",
                               "R3-W",
                               "R3-L",
                               "R0-L")
  
  transitionReceptionCountsTeam <- teamReceptionData %>%
    select(rotation, 
           all_of(receptionResultsOrdered))%>%
    group_by(rotation) %>%
    summarise(across(1:7, sum, na.rm = TRUE))
  
  #computing point-win probabilities for team and player receptions
  teamReceptionProbs <- reception_BayesianMCProbs(transitionReceptionCountsTeam)
  
  ggplot(teamReceptionProbs, aes(x = Rotation, y = AvgWinProb, fill = ReceptionTypeLabel)) +
          geom_bar(stat = "identity", position = "dodge") +
          geom_errorbar(aes(ymin = (AvgWinProb) - WinProbSD, ymax = (AvgWinProb) + WinProbSD), 
                        position = position_dodge(width = 0.9), width = 0.25) +
          geom_text(aes(label = paste0(round((AvgWinProb) * 100, 1), "%"), y = (AvgWinProb) -  WinProbSD), 
                    position = position_dodge(width = 0.9), vjust = 1.5, hjust = 0.5) +
          labs(title = paste0(teamName," reception-type point-win probability by rotation"),
               x = paste0(teamAbbr, " rotation"),
               y = "Probability") +
          ylim(0, 1) +  
          theme_minimal()
  
  sumReceptionTeam <- teamReceptionProbs %>%
    group_by(Rotation) %>%
    summarise(meanRankScore = mean(rankScore))
    ggplot(sumReceptionTeam, aes(x = factor(Rotation), y = meanRankScore, fill = meanRankScore)) +
      geom_bar(stat = "identity") +
      geom_text(aes(label = round(meanRankScore, 3)), 
                vjust = -0.5) +
      scale_fill_gradient(low = "blue", high = "red", limits = c(0.5, 3)) +
      labs(title = paste0(teamAbbr, " reception-score by rotation"),
           x = paste0(teamAbbr, " rotation"),
           y = "Dig-Score") +
      theme_minimal() +
      ylim(0, 3) 
  
  if(length(playerNameReception)>0){
    for(j in 1:length(playerNameReception)){
        transitionReceptionCountsPlayer <- teamReceptionData %>%
        filter(player_name == playerNameReception[j]) %>%
        select(rotation, 
               all_of(receptionResultsOrdered)) %>%
        group_by(rotation) %>%
        summarise(across(1:7, sum, na.rm = TRUE))
      
      missingRotations <- setdiff(full_rotations, transitionReceptionCountsPlayer$rotation)
      
      
      for (rotation in missingRotations) {
        new_row <- data.frame(rotation = factor(rotation, levels = levels(transitionReceptionCountsPlayer$rotation)),
                              matrix(rep(0, 7), ncol = 7))
        
        colnames(new_row) <- c("rotation", receptionResultsOrdered)
        
        transitionReceptionCountsPlayer <- rbind(transitionReceptionCountsPlayer, new_row)
      }
      
      transitionReceptionCountsPlayer <- transitionReceptionCountsPlayer %>%
        arrange(rotation)
      
      
      playerReceptionProbs <- reception_BayesianMCProbs(transitionReceptionCountsPlayer)
      
      
   print(   ggplot(playerReceptionProbs, aes(x = Rotation, y =AvgWinProb, fill = ReceptionTypeLabel)) +
          geom_bar(stat = "identity", position = "dodge") +
          geom_errorbar(aes(ymin = (AvgWinProb) - WinProbSD, ymax = (AvgWinProb) + WinProbSD), 
                        position = position_dodge(width = 0.9), width = 0.25) +
          geom_text(aes(label = paste0(round((AvgWinProb) * 100, 1), "%"), y = (AvgWinProb) - WinProbSD), 
                    position = position_dodge(width = 0.9), vjust = 1.5, hjust = 0.5) +
          labs(title = paste0("Reception-type point-win probability by rotation - ", playerNumberReception[j], " ", teamAbbr),
               x = paste0(teamAbbr," rotation"),
               y = "Probability") +
          ylim(0, 1) +  
          theme_minimal()
   )
      sumReceptionPlayer <- playerReceptionProbs %>%
        group_by(Rotation) %>%
        summarise(meanRankScore = mean(rankScore))
      
      
     print( ggplot(sumReceptionPlayer, aes(x = factor(Rotation), y = meanRankScore, fill = meanRankScore)) +
          geom_bar(stat = "identity") +
          geom_text(aes(label = round(meanRankScore, 3)), 
                    vjust = -0.5) +
          scale_fill_gradient(low = "blue", high = "red", limits = c(0.5, 3)) +
          labs(title = paste0("Reception-score by rotation - ", playerNumberReception[j], " ",teamAbbr),
               x = paste0(teamAbbr," rotation"),
               y = "Dig-Score") +
          theme_minimal() +
          ylim(0, 3) 
     )
      }
  }  

#Now we consider attack efficiency and comupte point-win percentage for attacker's
#based on opponent dig-trends
        
        transitionDigCountsOppTeam <- oppTeamDigData %>%
          select(rotation, 
                 all_of(digResultsOrdered))%>%
          group_by(rotation) %>%
          summarise(across(1:19, sum, na.rm = TRUE))
        
        oppTeamDigProbs <- dig_BayesianMCProbs(transitionDigCountsOppTeam)
        
        ggplot(oppTeamDigProbs, aes(x = Rotation, y = 1-AvgWinProb, fill = DigTypeLabel)) +
                geom_bar(stat = "identity", position = "dodge") +
                geom_errorbar(aes(ymin = (1-AvgWinProb) - WinProbSD, ymax = (1-AvgWinProb) + WinProbSD), 
                              position = position_dodge(width = 0.9), width = 0.25) +
                geom_text(aes(label = paste0(round((1-AvgWinProb) * 100, 1), "%"), y = (1-AvgWinProb) -  WinProbSD), 
                          position = position_dodge(width = 0.9), vjust = 1.5, hjust = 0.5) +
                labs(title = paste0(teamName," attack-win probability against opponent dig-type and rotation"),
                     x = paste0(teamAbbr," rotation"),
                     y = "Probability") +
                ylim(0, 1) +  
                theme_minimal()
        
        
        
        sumDigOppTeam <- oppTeamDigProbs %>%
          group_by(Rotation) %>%
          summarise(meanRankScore = mean(rankScore))
        
          ggplot(sumDigOppTeam, aes(x = factor(Rotation), y = meanRankScore, fill = meanRankScore)) +
            geom_bar(stat = "identity") +
            geom_text(aes(label = round(meanRankScore, 3)), 
                      vjust = -0.5) +
            scale_fill_gradient(low = "blue", high = "red", limits = c(0.5, 3)) +
            labs(title = paste0("Opponent dig-score by rotation - from ",teamAbbr, " attacks"),
                 x = "Attacking team rotation",
                 y = "Dig-Score") +
            theme_minimal() +
            ylim(0, 3) 
        
        
        if(length(playerNameAttacker)>0){
          for(j in 1:length(playerNameAttacker)){
            
            transitionOppDigCountsPlayer <- oppTeamDigData %>%
              filter(digAttackerName == playerNameAttacker[j]) %>%
              select(rotation, 
                     all_of(digResultsOrdered)) %>%
              group_by(rotation) %>%
              summarise(across(1:19, sum, na.rm = TRUE))
            
            missingRotations <- setdiff(full_rotations, transitionOppDigCountsPlayer$rotation)
            
            
            for (rotation in missingRotations) {
              new_row <- data.frame(rotation = factor(rotation, levels = levels(transitionOppDigCountsPlayer$rotation)),
                                    matrix(rep(0, 19), ncol = 19))
              
              colnames(new_row) <- c("rotation", digResultsOrdered)
              
              transitionOppDigCountsPlayer <- rbind(transitionOppDigCountsPlayer, new_row)
            }
            
            transitionOppDigCountsPlayer <- transitionOppDigCountsPlayer %>%
              arrange(rotation)
            
            oppPlayerDigProbs <- dig_BayesianMCProbs(transitionOppDigCountsPlayer)
            
         print(   ggplot(oppPlayerDigProbs, aes(x = Rotation, y =1-AvgWinProb, fill = DigTypeLabel)) +
                geom_bar(stat = "identity", position = "dodge") +
                geom_errorbar(aes(ymin = (1-AvgWinProb) - WinProbSD, ymax = (1-AvgWinProb) + WinProbSD), 
                              position = position_dodge(width = 0.9), width = 0.25) +
                geom_text(aes(label = paste0(round((1-AvgWinProb) * 100, 1), "%"), y = (1-AvgWinProb) - WinProbSD), 
                          position = position_dodge(width = 0.9), vjust = 1.5, hjust = 0.5) +
                labs(title = paste0("Attack point-win probability by dig-type and rotation - ", playerNumberAttacker[j], " ", teamAbbr, " attacks"),
                     x = paste0(teamAbbr," rotation"),
                     y = "Probability") +
                ylim(0, 1) +  
                theme_minimal()
         )   
            
            sumDigOppPlayer <- oppPlayerDigProbs %>%
              group_by(Rotation) %>%
              summarise(meanRankScore = mean(rankScore))
            
             print( ggplot(sumDigOppPlayer, aes(x = factor(Rotation), y = meanRankScore, fill = meanRankScore)) +
                geom_bar(stat = "identity") +
                geom_text(aes(label = round(meanRankScore, 3)), 
                          vjust = -0.5) +
                scale_fill_gradient(low = "blue", high = "red", limits = c(0.5, 3)) +
                labs(title = paste0("Opponent dig-score by rotation - ", playerNumberAttacker[j], " ",teamAbbr, " attacks"),
                     x = "Attacking team rotation",
                     y = "Dig-Score") +
                theme_minimal() +
                ylim(0, 3) 
             ) 
          
           }
        }
