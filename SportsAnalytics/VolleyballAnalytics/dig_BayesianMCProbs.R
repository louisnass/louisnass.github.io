#----------------------------------------------------------------------------------

#Title: Bayesian estimation of point-win probabilities from ranked digs

#----------------------------------------------------------------------------------

#Author: Louis Nass

#----------------------------------------------------------------------------------

#Description: Here we estimate the point-win probabilities associated to various
# ranked-digs from collected data. We use a Bayesian approach to estimate
# transition probabilities in our absorbing Markov-Chain model. This allows us to 
# estimate the point-win probabilities with limited observations. We assume that 
# the number of occurrences of transitions are distributed as a Gamma random variable
# where the shape is the number of observed transitions and the shape equals 1 for
# each transition. Then, for each ranked dig, we normalize the Gamma random variables
# to estimate the transition probabilities. We repeat this for 100000 draws of the 
# Gamma distribution. Then we compute the mean and standard deviation of the
# point-win probabilities, with the associated dig-score for each rotation.

#----------------------------------------------------------------------------------

#Input: observed volleyball data, transition counts between out-of-system digs, 
# in-system with limited attack options digs, in-system with all attack options digs,
# dig-errors, point-wins, and point-losses for each rotation and across all 
# rotations. 

#Output: Dataframe with point-win probabilities for each rotation, the assocaited
# dig-type and the dig-score.

#----------------------------------------------------------------------------------


dig_BayesianMCProbs <- function(digData){
  colInd <- c(2, 4, 6, 8, 10, 12, 14)
  win_probs_rotation <- c()
  win_probs_rotation <- do.call(rbind, lapply(colInd, function(j) {
    shape_params <- digData[1:18, j] + 1
    n <- 100000
    samps <- t(mapply(function(shape) rgamma(n, shape = shape, scale = 1), shape_params))
    
    d_probs <- lapply(seq(1, 13, by = 6), function(i) {
      counts <- samps[i:(i+5), ]
      sums <- colSums(counts)
      sweep(counts, 2, sums, "/")
    })
    
    win_probs_samps <- mapply(function(k) {
      QR <- rbind(c(0, 0, 0, 0, 0, 1),
                  d_probs[[1]][, k],
                  d_probs[[2]][, k],
                  d_probs[[3]][, k])
      Q <- QR[, 1:4]
      N <- solve(diag(4) - Q)
      R <- QR[, 5:6]
      B <- N %*% R
      B[2:4, 1]
    }, 1:n, SIMPLIFY = FALSE)
    
    win_probs_samps <- do.call(cbind, win_probs_samps)
    win_probs_data <- cbind(rowMeans(win_probs_samps), apply(win_probs_samps, 1, sd))
    
    return(win_probs_data)
  }))
  win_probs_rotation <- data.frame(win_probs_rotation)
  
  colnames(win_probs_rotation) <- c("Mean", "SD")
  row.names(win_probs_rotation) <- c("All rotations - D1",
                                     "All rotations - D2",
                                     "All rotations - D3",
                                     "Rotation 1 - D1",
                                     "Rotation 1 - D2",
                                     "Rotation 1 - D3",
                                     "Rotation 2 - D1",
                                     "Rotation 2 - D2",
                                     "Rotation 2 - D3",
                                     "Rotation 3 - D1",
                                     "Rotation 3 - D2",
                                     "Rotation 3 - D3",
                                     "Rotation 4 - D1",
                                     "Rotation 4 - D2",
                                     "Rotation 4 - D3",
                                     "Rotation 5 - D1",
                                     "Rotation 5 - D2",
                                     "Rotation 5 - D3",
                                     "Rotation 6 - D1",
                                     "Rotation 6 - D2",
                                     "Rotation 6 - D3")
  
  win_probs_rotation <- win_probs_rotation %>%
    rownames_to_column("Rotation_DigType") %>%
    separate(Rotation_DigType, into = c("Rotation", "DigType"), sep = " - ") %>%
    mutate(
      Rotation = recode(Rotation, "All rotations" = "All", 
                        "Rotation 1" = "1", "Rotation 2" = "2", 
                        "Rotation 3" = "3", "Rotation 4" = "4",
                        "Rotation 5" = "5", "Rotation 6" = "6"),
      Rotation = factor(Rotation, levels = c("1", "2", "3", "4", "5", "6", "All")),
      DigType = factor(DigType, levels = c("D1", "D2", "D3"))
    ) %>%
    rename(AvgWinProb = Mean, WinProbSD = SD)
  
  win_probs_rotation <- win_probs_rotation %>%
    mutate(DigTypeLabel = as.factor(ifelse(DigType == "D1",
                                           "Out-of-system dig",
                                           ifelse(DigType == "D2",
                                                  "In-system, limited attack options",
                                                  "In-system, all attack options"))) )
  
  win_probs_rotation <- win_probs_rotation %>%
    mutate(rankScore = ifelse(Rotation == "All",
                              digData[20, 3],
                              ifelse(Rotation == "1",
                                     digData[20, 5],
                                     ifelse(Rotation == "2",
                                            digData[20, 7],
                                            ifelse(Rotation == "3",
                                                   digData[20, 9],
                                                   ifelse(Rotation == "4",
                                                          digData[20, 11],
                                                          ifelse(Rotation == "5",
                                                                 digData[20, 13],
                                                                 digData[20, 15])))))))
  
  win_probs_rotation$DigTypeLabel <- factor(win_probs_rotation$DigTypeLabel,
                                            levels = c("Out-of-system dig",
                                                       "In-system, limited attack options",
                                                       "In-system, all attack options"))
  return(win_probs_rotation)
}