


reception_BayesianMCProbs <- function(receptionData){
  countsReceptions <- as.matrix(receptionData[,2:8])
  countsReceptions <- rbind(countsReceptions, colSums(countsReceptions))
  rankScore <- as.vector(do.call(rbind, lapply(1:7, function(l) {
    d1 <- sum(countsReceptions[l,1:2])
    d2 <- sum(countsReceptions[l,3:4])
    d3 <- sum(countsReceptions[l,5:6])
    d0 <- countsReceptions[l,7]
    return(ifelse(d1+d2+d3+d0 == 0,
                  0, 
                  (1*d1+2*d2+3*d3)/(d0+d1+d2+d3)))
  })))
  
  win_probs_rotation <- do.call(rbind, lapply(1:7, function(j) {
    shape_params <- as.vector(countsReceptions[j,] + 1)
    n <- 100000
    samps <- t(mapply(function(shape) rgamma(n, shape = shape, scale = 1), shape_params))
    
    r_probs <- lapply(seq(1, 5, by = 2), function(i) {
      counts <- samps[i:(i+1), ]
      sums <- colSums(counts)
      sweep(counts, 2, sums, "/")
    })
    
    win_probs_samps <-  mapply(function(k) {
      B <- c(r_probs[[1]][1,k],
             r_probs[[2]][1,k],
             r_probs[[3]][1,k])
      B
    }, 1:n, SIMPLIFY = FALSE) 
    
    win_probs_samps <- do.call(cbind, win_probs_samps)
    win_probs_data <- cbind(rowMeans(win_probs_samps), apply(win_probs_samps, 1, sd))
    
    return(win_probs_data)
  }))
  
  win_probs_rotation <- data.frame(win_probs_rotation)
  
  colnames(win_probs_rotation) <- c("Mean", "SD")
  row.names(win_probs_rotation) <- c("Rotation 1 - R1",
                                     "Rotation 1 - R2",
                                     "Rotation 1 - R3",
                                     "Rotation 2 - R1",
                                     "Rotation 2 - R2",
                                     "Rotation 2 - R3",
                                     "Rotation 3 - R1",
                                     "Rotation 3 - R2",
                                     "Rotation 3 - R3",
                                     "Rotation 4 - R1",
                                     "Rotation 4 - R2",
                                     "Rotation 4 - R3",
                                     "Rotation 5 - R1",
                                     "Rotation 5 - R2",
                                     "Rotation 5 - R3",
                                     "Rotation 6 - R1",
                                     "Rotation 6 - R2",
                                     "Rotation 6 - R3",
                                     "All rotations - R1",
                                     "All rotations - R2",
                                     "All rotations - R3")
  
  win_probs_rotation <- win_probs_rotation %>%
    rownames_to_column("Rotation_ReceptionType") %>%
    separate(Rotation_ReceptionType, into = c("Rotation", "ReceptionType"), sep = " - ") %>%
    mutate(
      Rotation = recode(Rotation, "All rotations" = "All", 
                        "Rotation 1" = "1", "Rotation 2" = "2", 
                        "Rotation 3" = "3", "Rotation 4" = "4",
                        "Rotation 5" = "5", "Rotation 6" = "6"),
      Rotation = factor(Rotation, levels = c("1", "2", "3", "4", "5", "6", "All")),
      ReceptionType = factor(ReceptionType, levels = c("R1", "R2", "R3"))
    ) %>%
    rename(AvgWinProb = Mean, WinProbSD = SD)
  
  win_probs_rotation <- win_probs_rotation %>%
    mutate(ReceptionTypeLabel = as.factor(ifelse(ReceptionType == "R1",
                                           "Bad",
                                           ifelse(ReceptionType == "R2",
                                                  "Good",
                                                  "Perfect"))) )
  
  win_probs_rotation <- win_probs_rotation %>%
    mutate(rankScore = ifelse(Rotation == "All",
                              rankScore[7],
                              ifelse(Rotation == "1",
                                     rankScore[1],
                                     ifelse(Rotation == "2",
                                            rankScore[2],
                                            ifelse(Rotation == "3",
                                                   rankScore[3],
                                                   ifelse(Rotation == "4",
                                                          rankScore[4],
                                                          ifelse(Rotation == "5",
                                                                 rankScore[5],
                                                                 rankScore[6])))))))
  
  win_probs_rotation$ReceptionTypeLabel <- factor(win_probs_rotation$ReceptionTypeLabel,
                                            levels = c("Bad",
                                                       "Good",
                                                       "Perfect"))
  return(win_probs_rotation)
}