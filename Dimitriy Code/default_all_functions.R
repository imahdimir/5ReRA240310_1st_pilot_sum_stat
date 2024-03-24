################################################################################################################################
################################################################################################################################
################################################################################################################################
# Summary: File containing the functions for mean-matched benchmarking (plus variations), bootstrapping, TLS-regression, and other things.
################################################################################################################################
################################################################################################################################
################################################################################################################################



signif_w_trails <- function(x,digits){
  rounded <- signif(x, digits)
  return_var <- rep(NA, length(rounded))
  for(num in 1:length(rounded)){
    minus <- 1
    if (rounded[num] < 0){
      minus <- -1
      rounded[num] <- -1*rounded[num]
    }
    before_decimal <- gsub("([^.]+)[.].*", "\\1", rounded[num])
    if (before_decimal == "0"){
      before_decimal <- ""
    }
    if (grepl("\\.", rounded[num])){
      after_decimal <- gsub(".*[.]([^.]+)", "\\1", rounded[num])
    }
    else{
      after_decimal <- ""
    }
    rounded[num] <- minus*rounded[num]
    if (nchar(before_decimal) + nchar(after_decimal) < digits){
      return_var[num] <- sprintf(paste0("%.", digits - nchar(before_decimal), "f"), rounded[num])
    }
    else{
      return_var[num] <- rounded[num]
    }
  }
  return(return_var)
}



# Mean matched benchmarking
mean_matched_benchmarking <- function(target_ratings, calibration_ratings, dataset_included,name_new_dataset,dataset_CQ_means){
  # target_ratings <- target_aspect
  # calibration_ratings <- calibration_full
  # dataset_included <- data

  #   Get target data additional to the calibration ratings used 
  data_cut_target           <-  data.frame(dataset_included[,target_ratings])
  data_cut_calibration      <-  dataset_included[,calibration_ratings]
  
  #   Create storage for weights
  number_of_calibrationquestion <- as.numeric(data.frame(dim(data_cut_calibration))[2,1])
  number_of_targets <- as.numeric(data.frame(dim(data_cut_target))[2,1])
  weight_storage = ones(number_of_calibrationquestion,number_of_targets)
  weight_storage_transpose = ones(number_of_targets,number_of_calibrationquestion)
  
      
  #   Get target data means additional to the calibration rating pendant
  data_means_target        <-  data.frame(ifelse(number_of_targets==1,data.frame(mean(data_cut_target, na.rm=TRUE)),  data.frame(mean_rating_per_target=colMeans(data_cut_target[,], na.rm=TRUE))))

  #   Set new rankings equal the old ratings 
  data_meanmatched_target_new=data.frame(data_cut_target)

  #   Start a loop for creating the optimal weights for all targets:
  for(i in 1:number_of_targets) { 
    #   Additional partition to make the function work for 1 single target rating as well
    data_target_sub <- ifelse(number_of_targets==1,data_means_target ,data_means_target[i,])
    #   Required values for the optimal weighting:
    length_C = number_of_calibrationquestion
    length_C_inverse = 1/number_of_calibrationquestion
    onevector = data.matrix(ones(number_of_calibrationquestion,1))
    onevector_transposed = t(onevector)
    mu_BigC <- data.matrix(data.frame(calibratio_means=colMeans(dataset_CQ_means[,], na.rm = TRUE)))
    mu_BigC_transposed <- t(mu_BigC)
    
    
    #   Formula for the optimal weights (see econometric model for this)
    apart1 <- mu_BigC_transposed%*%mu_BigC
    apart2 <- as.numeric(data_target_sub)*mu_BigC_transposed%*%onevector
    apart3 <- onevector_transposed%*%onevector%*%mu_BigC_transposed%*%mu_BigC
    apart4 <- mu_BigC_transposed%*%onevector%*%onevector_transposed%*%mu_BigC
    apart5 <- apart1-apart2
    apart6 <- apart3-apart4
    apart7 <- apart5/apart6
    apart8 <- onevector%*%apart7
    bpart1 <- as.numeric(data_target_sub)*onevector_transposed%*%onevector
    bpart2 <- onevector_transposed%*%mu_BigC
    bpart3 <- apart6
    bpart4 <- (bpart1-bpart2)/bpart3
    bpart5 <- mu_BigC%*%bpart4
    cpart1 <- (apart8+bpart5) #this is the optimal weighting vector
    cpart2 <- t(cpart1)
    cpart_check <- sum(cpart1) #  Check to see if the weights sum up to 1
    nam2 <- paste("check_for_target_", i, sep = "")
    assign(nam2, cpart_check)
  
    #   Store the weights inside the previously created matrices. First "if" for a single target rating and secon "else" for multiple target ratings at the same time
    if (number_of_targets==1){
      weight_storage <- cpart1
      weight_storage_transpose <- cpart2
      
      #create the benchmarked aspect ratings
      data_meanmatched_target_new <- data.frame(data_meanmatched_target_new)-as.matrix(weight_storage_transpose)%*%as.matrix(t(data_cut_calibration))
      
    } else {
   
      weight_storage[,i] <- cpart1
     
      weight_storage_transpose[i,] <- cpart2
      
      #create the benchmarked aspect ratings
      ###
      # Matrix multiplication creates too many NA's#
      ###
      
      data_meanmatched_target_new[,i]  <- data.frame(data_meanmatched_target_new[,i])-as.matrix(t(weight_storage_transpose[i,]))%*%as.matrix(t(data_cut_calibration))
      # This step generates lots of  NA's
    }
    
  }
  #   export the new mean-matched target ratings to global environment under pre-specified name
  assign(name_new_dataset, data_meanmatched_target_new, envir = .GlobalEnv)
  assign(paste0("weight_",name_new_dataset), weight_storage, envir = .GlobalEnv)
}

################################################################################################################################

# Mean matched benchmarking with manual means
mean_matched_benchmarking_manualmeans <- function(target_ratings, 
                                                  calibration_ratings, 
                                                  dataset_included,name_new_dataset,manual_means){
  
  # target_ratings <- target_aspect
  # calibration_ratings <- calibration_full
  # dataset_included <- data
  
  #   Get target data additional to the calibration ratings used 
  data_cut_target           <-  data.frame(dataset_included[,target_ratings])
  data_cut_calibration      <-  dataset_included[,calibration_ratings]
  
  #   Create storage for weights
  number_of_calibrationquestion <- as.numeric(data.frame(dim(data_cut_calibration))[2,1])
  number_of_targets <- as.numeric(data.frame(dim(data_cut_target))[2,1])
  weight_storage = ones(number_of_calibrationquestion,number_of_targets)
  weight_storage_transpose = ones(number_of_targets,number_of_calibrationquestion)
  
  #   Get target data means additional to the calibration rating pendant
  data_means_target        <-  data.frame(manual_means)
  
  #   Set new rankings equal the old ratings 
  data_meanmatched_target_new=data.frame(data_cut_target)
  
  #   Start a loop for creating the optimal weights for all targets:
  for(i in 1:number_of_targets) { 
    #   Additional partition to make the function work for 1 single target rating as well
    data_target_sub <- ifelse(number_of_targets==1,data_means_target ,data_means_target[i,])
    #   Required values for the optimal weighting:
    length_C = number_of_calibrationquestion
    length_C_inverse = 1/number_of_calibrationquestion
    onevector = data.matrix(ones(number_of_calibrationquestion,1))
    onevector_transposed = t(onevector)
    mu_BigC <- data.matrix(data.frame(calibratio_means=colMeans(data_cut_calibration[,], na.rm = TRUE)))
    mu_BigC_transposed <- t(mu_BigC)
    mean_smallc <-  (length_C_inverse) * onevector_transposed %*% mu_BigC
    var_mean_c <-  (length_C_inverse) * mu_BigC_transposed %*% mu_BigC - (mean_smallc*mean_smallc)
    
    
    #   Formula for the optimal weights (see econometric model for this)
    apart1 <- mu_BigC_transposed%*%mu_BigC
    apart2 <- as.numeric(data_target_sub)*mu_BigC_transposed%*%onevector
    apart3 <- onevector_transposed%*%onevector%*%mu_BigC_transposed%*%mu_BigC
    apart4 <- mu_BigC_transposed%*%onevector%*%onevector_transposed%*%mu_BigC
    apart5 <- apart1-apart2
    apart6 <- apart3-apart4
    apart7 <- apart5/apart6
    apart8 <- onevector%*%apart7
    bpart1 <- as.numeric(data_target_sub)*onevector_transposed%*%onevector
    bpart2 <- onevector_transposed%*%mu_BigC
    bpart3 <- apart6
    bpart4 <- (bpart1-bpart2)/bpart3
    bpart5 <- mu_BigC%*%bpart4
    cpart1 <- (apart8+bpart5) #this is the optimal weighting vector
    cpart2 <- t(cpart1)
    cpart_check <- sum(cpart1) #  Check to see if the weights sum up to 1
    nam2 <- paste("check_for_target_", i, sep = "")
    assign(nam2, cpart_check)
    
    #   Store the weights inside the previously created matrices. First "if" for a single target rating and secon "else" for multiple target ratings at the same time
    if (number_of_targets==1){
      weight_storage <- cpart1
    
      weight_storage_transpose <- cpart2
  
      #create the benchmarked aspect ratings
      data_meanmatched_target_new <- data.frame(data_meanmatched_target_new)-as.matrix(weight_storage_transpose)%*%as.matrix(t(data_cut_calibration))
      
    } else {
      
      weight_storage[,i] <- cpart1
     
      weight_storage_transpose[i,] <- cpart2
      
      #create the benchmarked aspect ratings
      data_meanmatched_target_new[,i]  <- data.frame(data_meanmatched_target_new[,i])-as.matrix(t(weight_storage_transpose[i,]))%*%as.matrix(t(data_cut_calibration))
    }
    
  }
  #   export the new mean-matched target ratings to global environment under pre-specified name
  assign(name_new_dataset, data_meanmatched_target_new, envir = .GlobalEnv)
 
  assign(paste0("weight_",name_new_dataset), weight_storage, envir = .GlobalEnv)
  
  
}

################################################################################################################################

# Mean matched benchmark
mean_matched_benchmark <- function(target_ratings, calibration_ratings, dataset_included,name_new_dataset){
  
  #   Get target data additional to the calibration ratings used 
  data_cut_target           <-  data.frame(dataset_included[,target_ratings])
  data_cut_calibration      <-  dataset_included[,calibration_ratings]
  
  #   Create storage for weights
  number_of_calibrationquestion <- as.numeric(data.frame(dim(data_cut_calibration))[2,1])
  number_of_targets <- as.numeric(data.frame(dim(data_cut_target))[2,1])
  weight_storage = ones(number_of_calibrationquestion,number_of_targets)
  weight_storage_transpose = ones(number_of_targets,number_of_calibrationquestion)
  
  #   Get target data means additional to the calibration rating pendant
  data_means_target        <-  data.frame(ifelse(number_of_targets==1,data.frame(mean(data_cut_target, na.rm=TRUE)),  data.frame(mean_rating_per_target=colMeans(data_cut_target[,], na.rm=TRUE))))
  #   Set new rankings equal the old ratings 
  data_meanmatched_target_new=data.frame(data_cut_target)
  
  #   Start a loop for creating the optimal weights for all targets:
  for(i in 1:number_of_targets) { 
    #   Additional partition to make the function work for 1 single target rating as well
    data_target_sub <- ifelse(number_of_targets==1,data_means_target ,data_means_target[i,])
    #   Required values for the optimal weighting:
    length_C = number_of_calibrationquestion
    length_C_inverse = 1/number_of_calibrationquestion
    onevector = data.matrix(ones(number_of_calibrationquestion,1))
    onevector_transposed = t(onevector)
    mu_BigC <- data.matrix(data.frame(calibratio_means=colMeans(data_cut_calibration[,], na.rm = TRUE)))
    mu_BigC_transposed <- t(mu_BigC)
    mean_smallc <-  (length_C_inverse) * onevector_transposed %*% mu_BigC
    var_mean_c <-  (length_C_inverse) * mu_BigC_transposed %*% mu_BigC - (mean_smallc*mean_smallc)
    
    
    #   Formula for the optimal weights (see econometric model for this)
    apart1 <- mu_BigC_transposed%*%mu_BigC
    apart2 <- as.numeric(data_target_sub)*mu_BigC_transposed%*%onevector
    apart3 <- onevector_transposed%*%onevector%*%mu_BigC_transposed%*%mu_BigC
    apart4 <- mu_BigC_transposed%*%onevector%*%onevector_transposed%*%mu_BigC
    apart5 <- apart1-apart2
    apart6 <- apart3-apart4
    apart7 <- apart5/apart6
    apart8 <- onevector%*%apart7
    bpart1 <- as.numeric(data_target_sub)*onevector_transposed%*%onevector
    bpart2 <- onevector_transposed%*%mu_BigC
    bpart3 <- apart6
    bpart4 <- (bpart1-bpart2)/bpart3
    bpart5 <- mu_BigC%*%bpart4
    cpart1 <- (apart8+bpart5) #this is the optimal weighting vector
    cpart2 <- t(cpart1)
    cpart_check <- sum(cpart1) #  Check to see if the weights sum up to 1
    nam2 <- paste("check_for_target_", i, sep = "")
    assign(nam2, cpart_check)
    
    #   Store the weights inside the previously created matrices. First "if" for a single target rating and secon "else" for multiple target ratings at the same time
    if (number_of_targets==1){
      weight_storage <- cpart1
      weight_storage_transpose <- cpart2
      
      #create the benchmarks
      data_meanmatched_target_new <- as.matrix(weight_storage_transpose)%*%as.matrix(t(data_cut_calibration))
      data_meanmatched_target_new <- data.frame(t(data_meanmatched_target_new))
    } else {
      
      weight_storage[,i] <- cpart1
      weight_storage_transpose[i,] <- cpart2
      
      #create the benchmarks
      data_meanmatched_target_new[,i]  <- t(as.matrix(t(weight_storage_transpose[i,]))%*%as.matrix(t(data_cut_calibration)))
    }
    
  }
  #   export the new mean-matched target ratings to global environment under pre-specified name
  assign(name_new_dataset, data_meanmatched_target_new, envir = .GlobalEnv)
}

################################################################################################################################

# Naive benchmarking (weighting everything equally)
naive_benchmarking <- function(target_ratings, calibration_ratings, dataset_included,name_new_dataset,dataset_for_CQ_Means){
  
  # target_ratings <- target_aspect
  # calibration_ratings <- calibration_full
  # dataset_included <- data
  
  #   Get target data additional to the calibration ratings used 
  data_cut_target           <-  data.frame(dataset_included[,target_ratings])
  data_cut_calibration      <-  dataset_included[,calibration_ratings]
  
  #   Create storage for weights
  number_of_calibrationquestion <- as.numeric(data.frame(dim(data_cut_calibration))[2,1])
  number_of_targets <- as.numeric(data.frame(dim(data_cut_target))[2,1])
  weight_storage = ones(number_of_calibrationquestion,number_of_targets)
  weight_storage_transpose = ones(number_of_targets,number_of_calibrationquestion)
  
  #   Get target data means additional to the calibration rating pendant
  data_means_target        <-  data.frame(ifelse(number_of_targets==1,data.frame(mean(data_cut_target, na.rm=TRUE)),  data.frame(mean_rating_per_target=colMeans(data_cut_target[,], na.rm=TRUE))))
  #   Set new rankings equal the old ratings 
  data_meanmatched_target_new=data.frame(data_cut_target)
  
  #   Start a loop for creating the optimal weights for all targets:
  for(i in 1:number_of_targets) { 
    
    # Additional partition to make the function work for 1 single target rating as well
    data_target_sub <- ifelse(number_of_targets==1,data_means_target ,data_means_target[i,])
    
    # Naive weighting vector
    length_C_inverse = 1/number_of_calibrationquestion
    onevector = data.matrix(ones(number_of_calibrationquestion,1))
    cpart1 <- onevector*length_C_inverse #this is the naive weighting vector
    cpart2 <- t(cpart1)
    
    #   Store the weights inside the previously created matrices. First "if" for a single target rating and secon "else" for multiple target ratings at the same time
    if (number_of_targets==1){
      weight_storage <- cpart1
      weight_storage_transpose <- cpart2
      
      #create the benchmarked aspect ratings
      data_meanmatched_target_new <- data.frame(data_meanmatched_target_new)-as.matrix(weight_storage_transpose)%*%as.matrix(t(data_cut_calibration))
      
    } else {
      
      weight_storage[,i] <- cpart1
      weight_storage_transpose[i,] <- cpart2
      
      #create the benchmarked aspect ratings
      data_meanmatched_target_new[,i]  <- data.frame(data_meanmatched_target_new[,i])-as.matrix(t(weight_storage_transpose[i,]))%*%as.matrix(t(data_cut_calibration))
    }
    
  }
  #   export the new mean-matched target ratings to global environment under pre-specified name
  assign(name_new_dataset, data_meanmatched_target_new, envir = .GlobalEnv)
}

################################################################################################################################

# Naive benchmark (weighting everything equally)
naive_benchmark <- function(target_ratings, calibration_ratings, dataset_included,name_new_dataset,dataset_for_CQ_Means){
  
  # target_ratings <- target_aspect
  # calibration_ratings <- calibration_full
  # dataset_included <- data
  
  #   Get target data additional to the calibration ratings used 
  data_cut_target           <-  data.frame(dataset_included[,target_ratings])
  data_cut_calibration      <-  dataset_included[,calibration_ratings]
  
  #   Create storage for weights
  number_of_calibrationquestion <- as.numeric(data.frame(dim(data_cut_calibration))[2,1])
  number_of_targets <- as.numeric(data.frame(dim(data_cut_target))[2,1])
  weight_storage = ones(number_of_calibrationquestion,number_of_targets)
  weight_storage_transpose = ones(number_of_targets,number_of_calibrationquestion)
  
  #   Get target data means additional to the calibration rating pendant
  data_means_target        <-  data.frame(ifelse(number_of_targets==1,data.frame(mean(data_cut_target, na.rm=TRUE)),  data.frame(mean_rating_per_target=colMeans(data_cut_target[,], na.rm=TRUE))))

  #   Set new rankings equal the old ratings 
  data_meanmatched_target_new=data.frame(data_cut_target)
  
  #   Start a loop for creating the optimal weights for all targets:
  for(i in 1:number_of_targets) { 
    
    # Additional partition to make the function work for 1 single target rating as well
    data_target_sub <- ifelse(number_of_targets==1,data_means_target ,data_means_target[i,])
    
    # Naive weighting vector
    length_C_inverse = 1/number_of_calibrationquestion
    onevector = data.matrix(ones(number_of_calibrationquestion,1))
    cpart1 <- onevector*length_C_inverse #this is the naive weighting vector
    cpart2 <- t(cpart1)
    
    #   Store the weights inside the previously created matrices. First "if" for a single target rating and secon "else" for multiple target ratings at the same time
    if (number_of_targets==1){
      weight_storage <- cpart1
      weight_storage_transpose <- cpart2
      
      #create the benchmarks
      data_meanmatched_target_new <- data.frame(0*data_meanmatched_target_new)+as.matrix(weight_storage_transpose)%*%as.matrix(t(dataset_for_CQ_Means))
      
    } else {
      
      weight_storage[,i] <- cpart1
      weight_storage_transpose[i,] <- cpart2
      
      #create the benchmarks
      data_meanmatched_target_new[,i]  <- data.frame(0*data_meanmatched_target_new[,i])+as.matrix(t(weight_storage_transpose[i,]))%*%as.matrix(t(dataset_for_CQ_Means))
    }
    
  }
  #   export the new mean-matched target ratings to global environment under pre-specified name
  assign(name_new_dataset, data_meanmatched_target_new, envir = .GlobalEnv)
}

################################################################################################################################

#   Define function used for mean matched benchmarking
mean_matched_benchmarking_advanced <- function(target_ratings, calibration_ratings, dataset_included,name_new_dataset,dataset_for_CQ_Means){
  
  target_ratings <- target_aspect
  calibration_ratings <- calibration_full
  # dataset_included <- data
 
  
  # Packages useful for this method
  packages <- c("psych")
  new.packages <- packages[!(packages %in% installed.packages()[, "Package"])]
  if(length(new.packages)) install.packages(new.packages)
  lapply(packages, library, character.only = TRUE)
  
  #   Get target data additional to the calibration ratings used 
  data_cut_target           <-  data.frame(dataset_included[,target_ratings])
  data_cut_calibration      <-  dataset_included[,calibration_ratings]
  
  #   Create storage for weights
  number_of_calibrationquestion <- as.numeric(data.frame(dim(data_cut_calibration))[2,1])
  number_of_targets <- as.numeric(data.frame(dim(data_cut_target))[2,1])
  weight_storage = ones(number_of_calibrationquestion,number_of_targets)
  weight_storage_transpose = ones(number_of_targets,number_of_calibrationquestion)
  
  #   Get target data means additional to the calibration rating pendant. Use harmonic means.
  data_means_target         <-  data.frame(ifelse(number_of_targets==1,data.frame(mean(data_cut_target, na.rm=TRUE)),  data.frame(mean_rating_per_target=colMeans(data_cut_target[,], na.rm=TRUE))))
  data_sd_individuals       <- transform(data_cut_calibration, SD=apply(data_cut_calibration,1, sd, na.rm = TRUE))[,c("SD")]
  if(min(data_sd_individuals)==0) {
    for (q in 1:length(data_sd_individuals)) {
      data_sd_individuals[q] <- max(data_sd_individuals[q],1)
    } 
  }
  
  # And do the same thing for the reference population.
  data_sd_individuals_CQ_means       <- transform(dataset_for_CQ_Means, SD=apply(dataset_for_CQ_Means,1, sd, na.rm = TRUE))[,c("SD")]
  if(min(data_sd_individuals_CQ_means)==0) {
    for (q in 1:length(data_sd_individuals_CQ_means)) {
      data_sd_individuals_CQ_means[q] <- max(data_sd_individuals_CQ_means[q],1)
    } 
  }
  
  # Mean is calculated from reference pop.
  harmonic_mean_sd          <- harmonic.mean(data_sd_individuals_CQ_means)
  beta_weight               <- harmonic_mean_sd/data_sd_individuals
  
  #   Set new rankings equal the old ratings 
  data_meanmatched_target_new=data.frame(data_cut_target)
  
  #   Start a loop for creating the optimal weights for all targets:
  for(i in 1:number_of_targets) { 
    #   Additional partition to make the function work for 1 single target rating as well
    data_target_sub <- ifelse(number_of_targets==1,data_means_target ,data_means_target[i,])
    #   Required values for the optimal weighting:
    length_C = number_of_calibrationquestion
    length_C_inverse = 1/number_of_calibrationquestion
    onevector = data.matrix(ones(number_of_calibrationquestion,1))
    onevector_transposed = t(onevector)
    mu_BigC <- data.matrix(data.frame(calibratio_means=colMeans(dataset_for_CQ_Means[,], na.rm = TRUE)))
    mu_BigC_transposed <- t(mu_BigC)
    mean_smallc <-  (length_C_inverse) * onevector_transposed %*% mu_BigC
    var_mean_c <-  (length_C_inverse) * mu_BigC_transposed %*% mu_BigC - (mean_smallc*mean_smallc)
    
    #   Formula for the optimal weights (see econometric model for this)
    apart1 <- mu_BigC_transposed%*%mu_BigC
    apart2 <- as.numeric(data_target_sub)*mu_BigC_transposed%*%onevector
    apart3 <- onevector_transposed%*%onevector%*%mu_BigC_transposed%*%mu_BigC
    apart4 <- mu_BigC_transposed%*%onevector%*%onevector_transposed%*%mu_BigC
    apart5 <- apart1-apart2
    apart6 <- apart3-apart4
    apart7 <- apart5/apart6
    apart8 <- onevector%*%apart7
    bpart1 <- as.numeric(data_target_sub)*onevector_transposed%*%onevector
    bpart2 <- onevector_transposed%*%mu_BigC
    bpart3 <- apart6
    bpart4 <- (bpart1-bpart2)/bpart3
    bpart5 <- mu_BigC%*%bpart4
    cpart1 <- (apart8+bpart5) #this is the optimal weighting vector
    cpart2 <- t(cpart1)
    cpart_check <- sum(cpart1) #  Check to see if the weights sum up to 1
    nam2 <- paste("check_for_target_", i, sep = "")
    assign(nam2, cpart_check)
    
    #   Store the weights inside the previously created matrices. First "if" for a single target rating and secon "else" for multiple target ratings at the same time
    if (number_of_targets==1){
      weight_storage <- cpart1
      weight_storage_transpose <- cpart2
      
      #create the benchmarked aspect ratings
      data_meanmatched_target_new <- data.frame(data_meanmatched_target_new)-as.matrix(weight_storage_transpose)%*%as.matrix(t(data_cut_calibration))
      
    } else {
      
      weight_storage[,i] <- cpart1
      weight_storage_transpose[i,] <- cpart2
      
      #create the benchmarked aspect ratings
      data_meanmatched_target_new[,i]   <- data.frame(data_meanmatched_target_new[,i])-as.matrix(t(weight_storage_transpose[i,]))%*%as.matrix(t(data_cut_calibration))
    }
    
    #Everything is the same up to here. Now, we use the harmonic means of betas to correct for the stretcher as well.
    data_meanmatched_target_new[,i]   <- data_meanmatched_target_new[,i]* beta_weight
  }
  #   export the new mean-matched target ratings to global environment under pre-specified name
  assign(name_new_dataset, data_meanmatched_target_new, envir = .GlobalEnv)
  detach("package:psych", unload=TRUE)
  
}

################################################################################################################################

#   Define function used for mean matched benchmarking
mean_matched_benchmark_advanced <- function(target_ratings, calibration_ratings, dataset_included,name_new_dataset){
  
  #   Packages useful
  packages <- c("psych")
  new.packages <- packages[!(packages %in% installed.packages()[, "Package"])]
  if(length(new.packages)) install.packages(new.packages)
  lapply(packages, library, character.only = TRUE)
  
  
  # target_ratings <- target_aspect
  # calibration_ratings <- calibration_full
  # dataset_included <- data
  
  #   Get target data additional to the calibration ratings used 
  data_cut_target           <-  data.frame(dataset_included[,target_ratings])
  data_cut_calibration      <-  dataset_included[,calibration_ratings]
  
  #   Create storage for weights
  number_of_calibrationquestion <- as.numeric(data.frame(dim(data_cut_calibration))[2,1])
  number_of_targets <- as.numeric(data.frame(dim(data_cut_target))[2,1])
  weight_storage = ones(number_of_calibrationquestion,number_of_targets)
  weight_storage_transpose = ones(number_of_targets,number_of_calibrationquestion)
  
  #   Get target data means additional to the calibration rating pendant. Use harmonic means.
  data_means_target         <-  data.frame(ifelse(number_of_targets==1,data.frame(mean(data_cut_target, na.rm=TRUE)),  data.frame(mean_rating_per_target=colMeans(data_cut_target[,], na.rm=TRUE))))
  data_means_calibrations   <-  data.frame(mean_rating_per_calibration=colMeans(data_cut_calibration[,], na.rm=TRUE))
  data_sd_individuals       <- data.frame(transform(data_cut_calibration, SD=apply(data_cut_calibration,1, sd, na.rm = TRUE))[,c("SD")])
  harmonic_mean_sd          <- harmonic.mean(data_sd_individuals)
  beta_weight               <- harmonic_mean_sd/data_sd_individuals
  
  #   Set new rankings equal the old ratings 
  data_meanmatched_target_new=data.frame(data_cut_target)
  data_meanmatched_target_new_2 <- data_meanmatched_target_new
  
  #   Start a loop for creating the optimal weights for all targets:
  for(i in 1:number_of_targets) { 
    #   Additional partition to make the function work for 1 single target rating as well
    data_target_sub <- ifelse(number_of_targets==1,data_means_target ,data_means_target[i,])
    #   Required values for the optimal weighting:
    length_C = number_of_calibrationquestion
    length_C_inverse = 1/number_of_calibrationquestion
    onevector = data.matrix(ones(number_of_calibrationquestion,1))
    onevector_transposed = t(onevector)
    mu_BigC <- data.matrix(data.frame(calibratio_means=colMeans(data_cut_calibration[,], na.rm = TRUE)))
    mu_BigC_transposed <- t(mu_BigC)
    mean_smallc <-  (length_C_inverse) * onevector_transposed %*% mu_BigC
    var_mean_c <-  (length_C_inverse) * mu_BigC_transposed %*% mu_BigC - (mean_smallc*mean_smallc)
    
    
    #   Formula for the optimal weights (see econometric model for this)
    apart1 <- mu_BigC_transposed%*%mu_BigC
    apart2 <- as.numeric(data_target_sub)*mu_BigC_transposed%*%onevector
    apart3 <- onevector_transposed%*%onevector%*%mu_BigC_transposed%*%mu_BigC
    apart4 <- mu_BigC_transposed%*%onevector%*%onevector_transposed%*%mu_BigC
    apart5 <- apart1-apart2
    apart6 <- apart3-apart4
    apart7 <- apart5/apart6
    apart8 <- onevector%*%apart7
    bpart1 <- as.numeric(data_target_sub)*onevector_transposed%*%onevector
    bpart2 <- onevector_transposed%*%mu_BigC
    bpart3 <- apart6
    bpart4 <- (bpart1-bpart2)/bpart3
    bpart5 <- mu_BigC%*%bpart4
    cpart1 <- (apart8+bpart5) #this is the optimal weighting vector
    cpart2 <- t(cpart1)
    cpart_check <- sum(cpart1) #  Check to see if the weights sum up to 1
    nam2 <- paste("check_for_target_", i, sep = "")
    assign(nam2, cpart_check)
    
    #   Store the weights inside the previously created matrices. First "if" for a single target rating and secon "else" for multiple target ratings at the same time
    if (number_of_targets==1){
      weight_storage <- cpart1
      weight_storage_transpose <- cpart2
      
      #create the benchmarked aspect ratings
      data_meanmatched_target_new <- data.frame(data_meanmatched_target_new)-as.matrix(weight_storage_transpose)%*%as.matrix(t(data_cut_calibration))
      
    } else {
      
      weight_storage[,i] <- cpart1
      weight_storage_transpose[i,] <- cpart2
      
      #create the benchmarked aspect ratings
      data_meanmatched_target_new[,i]   <- data.frame(data_meanmatched_target_new[,i])-as.matrix(t(weight_storage_transpose[i,]))%*%as.matrix(t(data_cut_calibration))
    }
    
    #Everything is the same up to here. Now, we use the harmonic means of betas to correct for the stretcher as well.
    data_meanmatched_target_new[,i]   <- data_meanmatched_target_new[,i]* beta_weight
    
    #To get the actual benchmark, just subtract the benchmarked ratings from the reported ratings
    data_meanmatched_target_new_2[,i] <- data_meanmatched_target_new_2[,i]-data_meanmatched_target_new[,i]
  }
  #   export the new mean-matched target ratings to global environment under pre-specified name
  assign(name_new_dataset, data_meanmatched_target_new_2, envir = .GlobalEnv)
  detach("package:psych", unload=TRUE)
  
}


#Function to do basic MMB correction
calibration_demean <- function(self_ratings, self_rat_var = "rating", self_id_var = "asp_id", self_worker_var = "workerNum",
                               cal_ratings, cal_rat_var = "rating", cal_id_var = "cal_id", cal_worker_var = "workerNum"){
  #Change names
  setnames(self_ratings, c(self_rat_var, self_id_var, self_worker_var), c("rating_uncorrected", "asp_id", "workerNum"))
  setnames(cal_ratings, c(cal_rat_var, cal_id_var, cal_worker_var), c("rating", "cal_id", "workerNum"))
  
  #Get stats needed for theta weights calculation
  self_ratings[, mu_j := mean(rating_uncorrected), asp_id] ## Jeff: Need to generalize this to permit manually specified means.
  cal_ratings[, n_ci := .N, workerNum]
  cal_ratings[, mu_c := mean(rating), cal_id]
  
  #Drop people who don't have calibration ratings
  self_workers <- unique(self_ratings$workerNum)
  cal_workers <- unique(cal_ratings$workerNum)
  missing_workers <- self_workers[!self_workers %in% cal_workers]
  if(length(missing_workers) > 0) print(paste0("Dropping workers (no calibration ratings): ", paste(missing_workers, collapse = ", ")))
  self_ratings <- self_ratings[!workerNum %in% missing_workers]
  
  #Function that returns the corrected rating after doing MMB
  mmb_correction <- function(mu_j, r_ij, worker_id, cal_ratings){
    #Get calibration rating data
    n_c <- cal_ratings[workerNum == worker_id]$n_ci[1]
    mu_c <- cal_ratings[workerNum == worker_id]$mu_c
    r_ic <- cal_ratings[workerNum == worker_id]$rating
    #Get weight matrix for each person, for a *vector* of mu_j values, and fixed mu_c and n_c
    theta_vector <- function(mu_j_temp){    
      theta_ij <- ((n_c-1)*var(mu_c))^(-1)*
        (rep((sum(mu_c^2)/n_c - mu_j_temp*mean(mu_c)), n_c) + (mu_j_temp - mean(mu_c))*mu_c)
    }
    theta_matrix_i <- sapply(mu_j, theta_vector) #n_cal by n_aspect matrix
    #Correct ratings
    r_corrected <- r_ij - t(theta_matrix_i) %*% r_ic
    return(r_corrected)
  }
  
  #Do the correction for each worker
  self_ratings[, rating_mmb := mmb_correction(mu_j = mu_j,
                                              r_ij = rating_uncorrected,
                                              worker_id = workerNum[1],
                                              cal_ratings = cal_ratings),
               workerNum]
  
  #Return the self ratings with the corrected values
  return(self_ratings)
}

################################################################################################################################

# TLS regression (from the web)
tls <- function(formula,data,...){
  M <- model.frame(formula, data)
  d <- prcomp(cbind(M[,2], M[,1]))$rotation
  dfx <- c(mean(M[,1])-mean(M[,2])*(d[2,1]/d[1,1]), d[2,1]/d[1,1])
  
  # Bootstrapped intervals
  bootFun <- function(datax, ind, formula) {
    dx <- datax[ind,]
    Mx <- model.frame(formula, dx)
    dm <- prcomp(cbind(Mx[,2], Mx[,1]))$rotation
    c(mean(Mx[,1])-mean(Mx[,2])*(dm[2,1]/dm[1,1]), dm[2,1]/dm[1,1])
  } 
  bootTls <- boot(data=data, statistic=bootFun, R=1000, formula=formula) # Bootstrapped to get SEs
  dfx <- list(dfx,bootTls$t[,1],bootTls$t[,2])
  class(dfx) <- "TLS"
  dfx  # Return
}

#' Internal prediction functions for tls smooth
#' 
#' @param model Input model
#' @param xseq x-values used for prediction
#' @param se Predict error or not
#' @param level Confidence level
#' @export
predictdf.TLS <- function(model, xseq, se, level) {
  pred <- as.numeric(model[[1]] %*% t(cbind(1, xseq)))
  if(se) {
    preds <- sapply(1:length(model[[2]]), function(x) as.numeric(c(model[[2]][x],model[[3]][x]) %*% t(cbind(1, xseq))))
    data.frame(
      x = xseq,
      y = pred,
      ymin = apply(preds, 1, function(x) quantile(x, probs = (1-level)/2)),
      ymax = apply(preds, 1, function(x) quantile(x, probs = 1-((1-level)/2)))
    )
  } else {
    return(data.frame(x = xseq, y = pred))
  }
}

################################################################################################################################

# Bootstrapping for an OLS regression outputting the bootstrapped coefficient and SE. If some sample is perfectly collinear, we just kick this regressor out of the RHS and regress on the -1 regressors.
bootstrap_dominic_OLS_SEs <- function(bootstrap_number, pvalue_correction_method){
  
  # pvalue_correction_method <- "fdr"
  # bootstrap_number <- 10000
  # dataset <- data_input1
  # colnames(dataset)[1] <- "average_aspect"
  
  storage_estimates <- data.frame(zeros((length(data_input0)-1),1))
  
  colnames(data_input0)[1] <- "average_aspect"
  
  regression_average_0<- lm(average_aspect ~ ., data_input0, na.action=na.omit)
  coefficients_0 <-  as.data.frame(coefficients(regression_average_0))
  # coefficients_test <- coefficients_0
  # coefficients_test[2,] <- NA
  # coefficients_test <- drop_na(coefficients_test)
  names <- data.frame(data.frame(row.names(coefficients_0))[-1,])#Drop intercept name
  colnames(names) <- "Demographics"
  assign("names", names, envir = .GlobalEnv)
  data_length <- dim(data_input0)[1]-0
  
  for (i in 1:bootstrap_number) {
    set.seed(i)
    data_boot <- data_input0[sample(1:data_length,data_length,replace=TRUE),]
    regression_OLS<- lm(average_aspect ~ ., data_boot, na.action=na.omit)
    
    coefficients_OLS <-  as.data.frame(coefficients(regression_OLS))
    coefficients_OLS <- data.frame(coefficients_OLS[-1,]) #Drop intercept coefficient
    colnames(coefficients_OLS) <- "Coefficient"
    
    storage_estimates <- cbind(storage_estimates, coefficients_OLS)
    
  }
  storage_estimates <- storage_estimates[,-1]
  
  mean_coeff <- data.frame(coefficients_0)
  sd_coeff <- data.frame(matrixStats::rowSds(as.matrix(storage_estimates), na.rm = TRUE))
  coeff_data <- cbind(mean_coeff, sd_coeff)
  colnames(coeff_data) <- c("Coefficient", "SE")
  
  z_values <- data.frame(coeff_data$Coefficient/coeff_data$SE)
  pvalues <- apply(z_values, 1, function(x) 2*pnorm(-abs(x)))
  pvalues_fdr <- data.frame(p.adjust(pvalues, method=pvalue_correction_method))

  coeff_data <- cbind(coeff_data, pvalues_fdr)
  colnames(coeff_data)[3] <- "FDR_Pvalue"
  
  #Put stars for significance (10, 5, 1%)
  coeff_data$Coefficient <- ifelse(coeff_data$FDR_Pvalue<0.01, paste0(signif_w_trails(coeff_data$Coefficient,digits=3), "***"),  ifelse(coeff_data$FDR_Pvalue<0.05, paste0(signif_w_trails(coeff_data$Coefficient,digits=3), "**"),  ifelse(coeff_data$FDR_Pvalue<0.1, paste0(signif_w_trails(coeff_data$Coefficient,digits=3), "*"),  paste0(signif_w_trails(coeff_data$Coefficient,digits=3), ""))))
  
  #Put Coefficient with stars and SE in same columns
  aspect_0avg_table_add <- data.frame(paste0(coeff_data$Coefficient, " (",signif_w_trails(coeff_data$SE, digits=3) ,")"))
  
  assign("aspect_0avg_table_add", aspect_0avg_table_add, envir = .GlobalEnv)
  
}

# Rewriting Dominic's bootstrapping function -- allows for more general parameters, less strict about global vars
bootstrap_dimitriy_OLS_SEs <- function(data_input,
                                       LHS_var, RHS_vars,
                                       bootstrap_number=100,
                                       pvalue_correction_method="fdr",
                                       drop_p_values = F,
                                       est_decimals = 10,
                                       se_decimals = 10,
                                       pval_decimals = 10,
                                       automatic_stars = F,
                                       OLS_formula = as.formula("LHS ~ ."),
                                       include_constant = F){
  #bootstrap_number <- bootstrap_number_main
  
  data_input0 <- data_input[, c(LHS_var, RHS_vars)]
  
  if((length(RHS_vars) > 1) & (OLS_formula == as.formula("LHS ~ ."))) {
    # Band-aid solution for now -- may want to rewrite drop_perfectcollinearities
    short_names_input <<- RHS_vars
    long_names_input <<- RHS_vars
    data_input0_wocollinear <- drop_perfectcollinearities(data_input0)
  } else {
    data_input0_wocollinear = data_input0
  }
  N_after_collinear <- dim(data_input0_wocollinear)[1]
  
  # Adjusting for custom formulas
  if (OLS_formula == as.formula("LHS ~ .")) {
    storage_estimates <- data.frame(zeros((length(data_input0_wocollinear)-1),1))
    colnames(data_input0_wocollinear)[1] <- "LHS"
  } else {
    N_storage = (str_count(as.character(OLS_formula)[3], "[+]") + 1) + str_count(as.character(OLS_formula)[3], "[*]") + as.numeric(include_constant)
    storage_estimates <- data.frame(zeros(N_storage,1))
  }
  
  regression_average_0<- lm(OLS_formula, data_input0_wocollinear, na.action=na.omit)
  coefficients_0 <-  as.data.frame(coefficients(regression_average_0))
  true_f_statistic <<- summary(regression_average_0)$fstatistic
  #coefficients_0 <- drop_na(coefficients_0)
  if (include_constant) {
    names <- data.frame(data.frame(row.names(coefficients_0)))#Drop intercept name
  } else {
    names <- data.frame(data.frame(row.names(coefficients_0))[-1,])#Drop intercept name
  }
  length_check <- dim(coefficients_0)[1]-(!include_constant)
  colnames(names) <- "Demographics"
  assign("names", names, envir = .GlobalEnv)
  data_length <- dim(data_input0_wocollinear)[1]-0
  set.seed(42)
  f_test_values <<- c()
  for (i in 1:bootstrap_number) {
    
    data_boot <- data_input0_wocollinear[sample(1:data_length,data_length,replace=TRUE),]
    if(i==1) data_boot <- data_input0_wocollinear
    data_boot <<-data_boot
    regression_OLS<- lm(OLS_formula, data_boot, na.action=na.omit)
    coefficients_OLS <-  as.data.frame(coefficients(regression_OLS))
    if (!include_constant) {
      coefficients_OLS <- data.frame(coefficients_OLS[-1,]) #Drop intercept coefficient
    }
    summary_regg <- summary(regression_OLS)
    coefficients_OLS <- drop_na(coefficients_OLS)
    f_stat_vec <- summary_regg$fstatistic # Degrees of freedom and value
    
    
    f_test_values <<- c(f_test_values,f_stat_vec[[1]])
    colnames(coefficients_OLS) <- "Coefficient"
    length_boot <- dim(coefficients_OLS)[1]-0
    
    if(length_boot<length_check){
      i <- i-1
      
      coefficients_print <-  as.data.frame(coefficients(regression_OLS))
      coefficients_print <- rownames(coefficients_print)[is.na(coefficients_print)]
    }
    
    if(length_boot==length_check){
      
      storage_estimates <- cbind(storage_estimates, coefficients_OLS)
    }
    #storage_estimates
    
  }
  storage_estimates <- storage_estimates[,-1]
  
  #print(q)
  assign("N_after_collinear", N_after_collinear, envir = .GlobalEnv)
  
  if (include_constant) {
    mean_coeff <- data.frame(coefficients(regression_average_0))
  } else {
    mean_coeff <- data.frame(coefficients(regression_average_0)[-1])
  }
  coeffs_Global <<- mean_coeff # Useful.
  # print("Coefficient point estimate line 835")
  #  print(nrow(mean_coeff))
  
  sd_coeff <- data.frame(matrixStats::rowSds(as.matrix(storage_estimates), na.rm = TRUE))
  #  print("SD point estimate line 839")
  #  print(nrow(sd_coeff))
  coeff_data <- cbind(mean_coeff, sd_coeff)
  colnames(coeff_data) <- c("Coefficient", "SE")
  
  z_values <- data.frame(coeff_data$Coefficient/coeff_data$SE)
  
  pvalues <- apply(z_values, 1, function(x) 2*pnorm(-abs(x)))
  
  # Don't include certain things for FDR correction
  to_correct <- !(names$Demographics %in% drop_p_values) # True/False vector
  pvalues[to_correct] <- p.adjust(pvalues[to_correct], method=pvalue_correction_method)
  pvalues_fdr <- data.frame(pvalues)
  
  coeff_data <- cbind(coeff_data, pvalues_fdr)
  colnames(coeff_data)[3] <- "FDR_Pvalue"
  
  # Put stars for significance (10, 5, 1%) (if desired)
  # Otherwise, just round
  if (automatic_stars) {
    coeff_data$Coefficient <- mapply(significance_stars,
                                     format(round(coeff_data$Coefficient, digits = est_decimals), nsmall = est_decimals), 
                                     coeff_data$FDR_Pvalue)
  } else {
    coeff_data$Coefficient <- format(round(coeff_data$Coefficient, digits = est_decimals), nsmall = est_decimals)
  }
  #coeff_data$Coefficient <- ifelse(coeff_data$FDR_Pvalue<0.01, paste0(signif_w_trails(coeff_data$Coefficient,digits=3), "***"),  ifelse(coeff_data$FDR_Pvalue<0.05, paste0(signif_w_trails(coeff_data$Coefficient,digits=3), "**"),  ifelse(coeff_data$FDR_Pvalue<0.1, paste0(signif_w_trails(coeff_data$Coefficient,digits=3), "*"),  paste0(signif_w_trails(coeff_data$Coefficient,digits=3), ""))))
  # coeff_data$Coefficient <- ifelse(coeff_data$FDR_Pvalue<0.01, paste0(round(coeff_data$Coefficient,digits=1), "***"),  ifelse(coeff_data$FDR_Pvalue<0.05, paste0(round(coeff_data$Coefficient,digits=1), "**"),  ifelse(coeff_data$FDR_Pvalue<0.1, paste0(round(coeff_data$Coefficient,digits=1), "*"),  paste0(round(coeff_data$Coefficient,digits=1), ""))))
  
  #Put Coefficient with stars and SE in same columns
  # output_table_1col <- data.frame(paste0(coeff_data$Coefficient, " (",signif_w_trails(coeff_data$SE, digits=3) ,")"))
  output_table_1col <- data.frame(coef_se=paste0(coeff_data$Coefficient, " (",
                                                 format(round(coeff_data$SE, digits=se_decimals), nsmall=se_decimals) ,")"))
  
  output_table_2cols <- data.frame(coef=coeff_data$Coefficient,
                                   se=format(round(coeff_data$SE, digits=se_decimals), nsmall=se_decimals))
  
  
  output_table_3cols  <- data.frame(coef=coeff_data$Coefficient,
                                    se=format(round(coeff_data$SE, digits=se_decimals), nsmall = se_decimals),
                                    pval=format(round(pvalues, digits=pval_decimals),nsmall=pval_decimals))
  
  assign("output_table_2cols", output_table_2cols, envir = .GlobalEnv)
  assign("output_table_3cols", output_table_3cols, envir = .GlobalEnv)
  assign("output_table_1col", output_table_1col, envir = .GlobalEnv)
  # print("function done, 875")
}
################################################################################################################################
#data_input_collinearity <- data_input
drop_perfectcollinearities <- function(data_input_collinearity){
  collinearity_safe <- TRUE
  
  data_regressor_collinearity <- data_input_collinearity[,1]
 
 
  data_RHS_collinearity <- data_input_collinearity[,short_names_input]

  
  # print(summary(data_RHS_collinearity[,14])[6])
   
  for (l in 1:dim(data_RHS_collinearity)[2]) {
    #  print(l)
    # print("1")
    # print(summary(data_RHS_collinearity[,l])[1])
    # print("6")
    
    collinearity_safe <- c(collinearity_safe,TRUE)
    collinearity_safe[(l+1)] <- ifelse(min(data_RHS_collinearity[,l],na.rm=TRUE)==max(data_RHS_collinearity[,l],na.rm=TRUE),FALSE,TRUE)
  }
  
  collinearity_safe <- collinearity_safe[2:length(collinearity_safe)]
  
  
  data_output_collinearity <<- cbind(data_regressor_collinearity,data_RHS_collinearity[,collinearity_safe])
  
  
  
  long_names_input_postcollinear <- long_names_input[collinearity_safe]
  short_names_input_postcollinear <- short_names_input[collinearity_safe]
  
  nas_longnames <- length(data.frame(long_names_input_postcollinear)[is.na(long_names_input_postcollinear),])
  long_names_input_postcollinear <-long_names_input_postcollinear[1:(length(long_names_input_postcollinear)-nas_longnames)]
  short_names_input_postcollinear <-short_names_input_postcollinear[1:(length(short_names_input_postcollinear)-nas_longnames)]
  
  assign("long_names_input_postcollinear",long_names_input_postcollinear,envir = .GlobalEnv)
  assign("short_names_input_postcollinear",short_names_input_postcollinear,envir = .GlobalEnv)
  assign("data_output_collinearity",data_output_collinearity,envir = .GlobalEnv)
  data_output_collinearity
  
}

################################################################################################################################


# Bootstrapping for an OLS regression outputting the bootstrapped coefficient and SE in a nice way with corrected p-values.
# If some sample is perfectly collinear, throw away the sample (and print out the seed of the sample)
# Allows you to specify which p-values to not include when FDR-correcting.
#Moose
bootstrap_dominic_OLS_SEs_replacecollinears <- function(bootstrap_number, pvalue_correction_method,drop_p_values,
                                                        round_digits=1){
  #bootstrap_number <- bootstrap_number_main
  
  
  if(length(short_names_input) > 1) {
  data_input0_wocollinear <- drop_perfectcollinearities(data_input0)
  } else {
    data_input0_wocollinear = data_input0
  }
  N_after_collinear <- dim(data_input0_wocollinear)[1]
  
  
  storage_estimates <- data.frame(zeros((length(data_input0_wocollinear)-1),1))
  
  colnames(data_input0_wocollinear)[1] <- "average_aspect"
  
  regression_average_0<- lm(average_aspect ~ ., data_input0_wocollinear, na.action=na.omit)
  coefficients_0 <-  as.data.frame(coefficients(regression_average_0))
  true_f_statistic <<- summary(regression_average_0)$fstatistic
  #coefficients_0 <- drop_na(coefficients_0)
  names <- data.frame(data.frame(row.names(coefficients_0))[-1,])#Drop intercept name
  length_check <- dim(coefficients_0)[1]-1
  colnames(names) <- "Demographics"
  assign("names", names, envir = .GlobalEnv)
  data_length <- dim(data_input0_wocollinear)[1]-0
  set.seed(42)
  f_test_values <<- c()
  for (i in 1:bootstrap_number) {
    
    data_boot <- data_input0_wocollinear[sample(1:data_length,data_length,replace=TRUE),]
    if(i==1) data_boot <- data_input0_wocollinear
        data_boot <<-data_boot
    regression_OLS<- lm(average_aspect ~ ., data_boot, na.action=na.omit)
    coefficients_OLS <-  as.data.frame(coefficients(regression_OLS))
    coefficients_OLS <- data.frame(coefficients_OLS[-1,]) #Drop intercept coefficient
    summary_regg <- summary(regression_OLS)
    coefficients_OLS <- drop_na(coefficients_OLS)
    f_stat_vec <- summary_regg$fstatistic # Degrees of freedom and value
  
    
    f_test_values <<- c(f_test_values,f_stat_vec[[1]])
    colnames(coefficients_OLS) <- "Coefficient"
    lentgh_boot <- dim(coefficients_OLS)[1]-0
    
    if(lentgh_boot<length_check){
      

      i <- i-1
      
      coefficients_print <-  as.data.frame(coefficients(regression_OLS))
      coefficients_print <- rownames(coefficients_print)[is.na(coefficients_print)]
   
      
    }
    
    if(lentgh_boot==length_check){
      
      storage_estimates <- cbind(storage_estimates, coefficients_OLS)
    }
    #storage_estimates
    
  }
  storage_estimates <- storage_estimates[,-1]
  
  #print(q)
  assign("N_after_collinear", N_after_collinear, envir = .GlobalEnv)
  
  mean_coeff <- data.frame(coefficients(regression_average_0)[-1])
  coeffs_Global <<- mean_coeff # Useful.
 # print("Coefficient point estimate line 835")
#  print(nrow(mean_coeff))

  sd_coeff <- data.frame(matrixStats::rowSds(as.matrix(storage_estimates), na.rm = TRUE))
#  print("SD point estimate line 839")
#  print(nrow(sd_coeff))
  coeff_data <- cbind(mean_coeff, sd_coeff)
  colnames(coeff_data) <- c("Coefficient", "SE")
  
  z_values <- data.frame(coeff_data$Coefficient/coeff_data$SE)
  
  pvalues <- apply(z_values, 1, function(x) 2*pnorm(-abs(x)))
  raw_vals =pvalues
  # Don't include certain things for FDR correction
  to_correct <- !(names$Demographics %in% drop_p_values) # True/False vector
  pvalues[to_correct] <- p.adjust(pvalues[to_correct], method=pvalue_correction_method)
  

  
  pvalues_fdr <- data.frame(pvalues)

  coeff_data <- cbind(coeff_data, pvalues_fdr)
  colnames(coeff_data)[3] <- "FDR_Pvalue"
  
  #Put stars for significance (10, 5, 1%)

  # Formatting Coefficient
  coeff_data %<>%
    mutate(Coefficient = ifelse(as.numeric(format(round(as.numeric(Coefficient), digits = round_digits), nsmall = round_digits)) == 0,
                       signif_w_trails(as.numeric(Coefficient),digits=round_digits),
                       format(round(as.numeric(Coefficient), digits = round_digits), nsmall = round_digits)))
  #coeff_data$Coefficient <- ifelse(coeff_data$FDR_Pvalue<0.01, paste0(signif_w_trails(coeff_data$Coefficient,digits=3), "***"),  ifelse(coeff_data$FDR_Pvalue<0.05, paste0(signif_w_trails(coeff_data$Coefficient,digits=3), "**"),  ifelse(coeff_data$FDR_Pvalue<0.1, paste0(signif_w_trails(coeff_data$Coefficient,digits=3), "*"),  paste0(signif_w_trails(coeff_data$Coefficient,digits=3), ""))))
  # coeff_data$Coefficient <- ifelse(coeff_data$FDR_Pvalue<0.01, paste0(round(coeff_data$Coefficient,digits=round_digits), "***"),
  #                                  ifelse(coeff_data$FDR_Pvalue<0.05, paste0(round(coeff_data$Coefficient,digits=round_digits), "**"),
  #                                         ifelse(coeff_data$FDR_Pvalue<0.1, paste0(round(coeff_data$Coefficient,digits=round_digits), "*"),
  #                                                paste0(round(coeff_data$Coefficient,digits=round_digits), ""))))
  coeff_data$Coefficient <- ifelse(coeff_data$FDR_Pvalue<0.01, paste0(coeff_data$Coefficient, "***"),
                                   ifelse(coeff_data$FDR_Pvalue<0.05, paste0(coeff_data$Coefficient, "**"),
                                          ifelse(coeff_data$FDR_Pvalue<0.1, paste0(coeff_data$Coefficient, "*"),
                                                 paste0(coeff_data$Coefficient, ""))))

  #Put Coefficient with stars and SE in same columns
  coeff_data %<>% mutate(SE_ = SE)
  coeff_data %<>%
    mutate(SE = ifelse(as.numeric(format(round(as.numeric(SE), digits = round_digits), nsmall = round_digits)) == 0,
                       signif_w_trails(as.numeric(SE),digits=round_digits),
                       format(round(as.numeric(SE), digits = round_digits), nsmall = round_digits)))
  
  # aspect_0avg_table_add <- data.frame(paste0(coeff_data$Coefficient, "<br>(",signif_w_trails(coeff_data$SE, digits=round_digits) ,")"))
  aspect_0avg_table_add <- data.frame(paste0(coeff_data$Coefficient, "<br>(",coeff_data$SE ,")"))
 
  aspect_0avg_table_add_pvals <- data.frame(coef_se = paste0(coeff_data$Coefficient, "<br>(",coeff_data$SE ,")"),
                                                  raw_pvals = raw_vals)
  # aspect_0avg_table_add_diff_cols <- data.frame(coef=coeff_data$Coefficient,
  #                                               se=round(coeff_data$SE, digits=round_digits))
  aspect_0avg_table_add_diff_cols <- data.frame(coef=coeff_data$Coefficient,
                                                se=coeff_data$SE)
  
  
  # aspect_coeffs_SEs_0avg_table_add  <- cbind(coeff_data$Coefficient,signif_w_trails(coeff_data$SE, digits=3), signif_w_trails(pvalues, digits=2))
  aspect_coeffs_SEs_0avg_table_add  <- cbind(coeff_data$Coefficient,signif_w_trails(coeff_data$SE_, digits=3), signif_w_trails(pvalues, digits=2))
 
  aspect_coeffs_SEs_0avg_table_add <- as.data.frame(aspect_coeffs_SEs_0avg_table_add)
  
  assign("aspect_0avg_table_add_diff_cols", aspect_0avg_table_add_diff_cols, envir = .GlobalEnv)
  assign("aspect_coeffs_SEs_0avg_table_add", aspect_coeffs_SEs_0avg_table_add, envir = .GlobalEnv)
  assign("aspect_coeffs_SEs_0avg_table_add", aspect_coeffs_SEs_0avg_table_add, envir = .GlobalEnv)
  #assign("skipped", j, envir = .GlobalEnv)
  assign("aspect_0avg_table_add", aspect_0avg_table_add, envir = .GlobalEnv)
  assign("aspect_0avg_table_add_pvals", aspect_0avg_table_add_pvals, envir = .GlobalEnv)
  
 # print("function done, 875")
}

# 
# mean_list_precedented <-c("dem_log_income_psp", "degree_highschool", "degree_some_college", "degree_graduate", "ethn_black_african_american",  "ethn_hispanic_latino_spanish","ethn_asian","employ_not_employed", "region_reside_west", "hhchildren_1more", "hhchildren_5more")
# mean_list_unprecedented <-c("age_demean", "age_demean_2", "male", "married_not_no_partner", "married_not_with_partner",  "employ_part", "employ_other", "region_reside_northeast", "region_reside_south", "religiousAttendance_number", "hhsize_2more", "hhsize_3more", "hhsize_5more","hhsize_10more" ) # "employ_out_of_labor_force" nobody
# sd_list_precedented <-c("age_demean", "age_demean_2", "dem_log_income_psp", "degree_highschool", "degree_some_college", "degree_graduate", "ethn_black_african_american",  "ethn_hispanic_latino_spanish","ethn_asian","employ_not_employed", "hhchildren_1more", "hhchildren_5more")
# sd_list_unprecedented <-c("male", "married_not_no_partner","married_not_with_partner",  "employ_part", "employ_other", "region_reside_northeast","region_reside_west", "region_reside_south","religiousAttendance_number", "hhsize_2more", "hhsize_3more", "hhsize_5more","hhsize_10more" ) # "employ_out_of_labor_force" nobody
# 
# aspect_0avg_table_add <- coeff_data
# 
# 
# precedented_list <- mean_list_precedented
# unprecedented_list <- mean_list_unprecedented
# data_input <- data_regression_means
# correction_method <- correction_method_main
# bootstrap_number <- bootstrap_number_main
# LHS_var <- "mean_calibration"
# division_precedented_unprecedented_yes_no <- division_precedented_unprecedented_yes_no_main

# Bootstrapping for an OLS regression outputting ONLY the bootstrapped coefficient and SE. If some sample is perfectly collinear, throw away the sample (and print out the seed of the sample)
bootstrap_OLS_MeanSe_precedentedunprecedented_replacecollinears <- function(bootstrap_number, data_input, LHS_var, correction_method, division_precedented_unprecedented_yes_no, precedented_list, unprecedented_list){
  
  data_input_collinearity <<- data_input
  a <- drop_perfectcollinearities(data_input_collinearity)
  
  length_demographics <- dim(data_output_collinearity)[2]-1
  
  storage_estimates <- data.frame(zeros((length_demographics),1))
  
  regression_average<- lm(data_output_collinearity[,1] ~ ., data_output_collinearity[,2:(length_demographics+1)], na.action=na.omit)
  coefficients <-  as.data.frame(coefficients(regression_average))
  names <- data.frame(data.frame(row.names(coefficients))[-1,])#Drop intercept name
  length_check <- dim(coefficients)[1]-1
  colnames(names) <- "Demographics"
  assign("names", names, envir = .GlobalEnv)
  data_length <- dim(data_output_collinearity)[1]-0
  
  storename_scatterplot_coefficients <- paste0("coefficients_of_",LHS_var)
  assign(storename_scatterplot_coefficients, coefficients, envir = .GlobalEnv)
  
  j=0
  
  #x <- ifelse(bootstrap_number>2355, c(1:2354, 2356:bootstrap_number), 1:bootstrap_number)
  
  for (i in 1:bootstrap_number) {
    set.seed(i)
    data_boot <- data_output_collinearity[sample(1:data_length,data_length,replace=TRUE),]
    regression_OLS<- lm(data_boot[,1] ~ ., data_boot[,2:(length_demographics+1)], na.action=na.omit)
    coefficients_OLS <-  as.data.frame(coefficients(regression_OLS))
    coefficients_OLS <- data.frame(coefficients_OLS[-1,]) #Drop intercept coefficient
    coefficients_OLS <- drop_na(coefficients_OLS)
    colnames(coefficients_OLS) <- "Coefficient"
    lentgh_boot <- dim(coefficients_OLS)[1]-0
    
    if(lentgh_boot<length_check){
      #print(i)
      j=j+1
      coefficients_print <-  as.data.frame(coefficients(regression_OLS))
      coefficients_print <- rownames(coefficients_print)[is.na(coefficients_print)]
      #print(coefficients_print)
    }
    
    if(lentgh_boot==length_check){
      storage_estimates <- cbind(storage_estimates, coefficients_OLS)
    }
    storage_estimates
    
  }
  storage_estimates <- storage_estimates[,-1]
  
  bootstrap_number_adjustedtop_expectation <- bootstrap_number/(dim(storage_estimates)[2]/bootstrap_number) 
  
  print(bootstrap_number_adjustedtop_expectation)
  
  for (i in (bootstrap_number+1):bootstrap_number_adjustedtop_expectation) {
    set.seed(i)
    data_boot <- data_output_collinearity[sample(1:data_length,data_length,replace=TRUE),]
    regression_OLS<- lm(data_boot[,1] ~ ., data_boot[,2:(length_demographics+1)], na.action=na.omit)
    coefficients_OLS <-  as.data.frame(coefficients(regression_OLS))
    coefficients_OLS <- data.frame(coefficients_OLS[-1,]) #Drop intercept coefficient
    coefficients_OLS <- drop_na(coefficients_OLS)
    colnames(coefficients_OLS) <- "Coefficient"
    lentgh_boot <- dim(coefficients_OLS)[1]-0
    
    if(lentgh_boot<length_check){
      j=j+1
      coefficients_print <-  as.data.frame(coefficients(regression_OLS))
      coefficients_print <- rownames(coefficients_print)[is.na(coefficients_print)]
    }
    
    if(lentgh_boot==length_check){
      storage_estimates <- cbind(storage_estimates, coefficients_OLS)
    }
    storage_estimates
  }
  
  mean_coeff <- data.frame(rowMeans(storage_estimates, na.rm = TRUE))
  sd_coeff <- data.frame(matrixStats::rowSds(as.matrix(storage_estimates), na.rm = TRUE))
  coeff_data <- cbind(mean_coeff, sd_coeff)
  colnames(coeff_data) <- c("Coefficient", "SE")
  names <- as.matrix(unfactor(names))
  rownames(coeff_data) <-names
  
  z_values <- data.frame(coeff_data$Coefficient/coeff_data$SE)
  pvalues <- data.frame(apply(z_values, 1, function(x) 2*pnorm(-abs(x))))
  pvalues_nonmatrix <- apply(z_values, 1, function(x) 2*pnorm(-abs(x)))
  rownames(pvalues) <-names
  
  if(division_precedented_unprecedented_yes_no==FALSE){
    
    pvalues <- data.frame(p.adjust(pvalues_nonmatrix, method=correction_method))
    
    coeff_data <- cbind(coeff_data, pvalues)
    colnames(coeff_data)[3] <- "adjusted_pvalues"
    coeff_data <- cbind(data.frame(row.names(coeff_data)),coeff_data)
  }
  
  if(division_precedented_unprecedented_yes_no==TRUE){
    
    #   Adjust the p-values to FDR with splitting up into precedented and unprecedented hypotheses.
    pvalues_precedented <- (pvalues)[precedented_list,]
    pvalues_unprecedented <- (pvalues)[unprecedented_list,]
    fdr_precedented <- as.data.frame(p.adjust(pvalues_precedented, method =correction_method))
    fdr_unprecedented <- as.data.frame(p.adjust(pvalues_unprecedented, method =correction_method))
    colnames(fdr_precedented) <- "adjusted_pvalues"
    rownames(fdr_precedented) <- precedented_list
    colnames(fdr_unprecedented)<- colnames(fdr_precedented)
    rownames(fdr_unprecedented) <- unprecedented_list
    pvalues_fdr <- rbind(fdr_precedented, fdr_unprecedented)
    coeff_data <- merge(coeff_data, pvalues_fdr, by=0, sort=FALSE)
    
  }
  
  
  
  #Put stars for significance (10, 5, 1%)
  coeff_data$Coefficient <- ifelse(coeff_data$adjusted_pvalues<0.01, paste0(signif_w_trails(coeff_data$Coefficient,digits=3), "***"),  ifelse(coeff_data$adjusted_pvalues<0.05, paste0(signif_w_trails(coeff_data$Coefficient,digits=3), "**"),  ifelse(coeff_data$adjusted_pvalues<0.1, paste0(signif_w_trails(coeff_data$Coefficient,digits=3), "*"),  paste0(signif_w_trails(coeff_data$Coefficient,digits=3), ""))))
  
  #Put Coefficient with stars and SE in same columns
  aspect_0avg_table_add <- data.frame(paste0(coeff_data$Coefficient, " (",signif_w_trails(coeff_data$SE, digits=3) ,")"))
  rownames(aspect_0avg_table_add) <- rownames(coeff_data)
  assign("skipped", j, envir = .GlobalEnv)
  assign("aspect_0avg_table_add", aspect_0avg_table_add, envir = .GlobalEnv)
  
}




####    Bootstrap for moments on moments regressions      ####
bootstrap_moments_OLS_SEs <- function(bootstrap_number, data_input_moments, LHS_input_moments,RHS_onaspectmean,RHS_oncalibrationmean,RHS_onaspectsd,RHS_oncalibrationsd,beginning_table){
  
  # bootstrap_number <- 1000
  # data_input_moments <- moments_aspectboth_calibrationboth
  # LHS_input_moments <- "SD_Aspect"
  # RHS_oncalibrationsd <- TRUE
  # RHS_oncalibrationmean <- FALSE
  # RHS_onaspectmean   <- FALSE
  # RHS_onaspectsd   <- FALSE
  #
  # 
  
  LHS <- data.frame(data_input_moments[,LHS_input_moments])
  colnames(LHS) <- LHS_input_moments
  
  data_length <- dim(LHS)[1]-0
  
  RHS <- data.frame(zeros(data_length,1))
  
  if(RHS_oncalibrationmean==TRUE){
    RHS_add <- data.frame(data_input_moments[,"Mean_Calibration"])
    colnames(RHS_add) <- "Mean_Calibration"
    RHS <- cbind(RHS,RHS_add)
  }  
  if(RHS_oncalibrationsd==TRUE){
    RHS_add <- data.frame(data_input_moments[,"SD_Calibration"])
    colnames(RHS_add) <- "SD_Calibration"
    RHS <- cbind(RHS,RHS_add)
  }  
  if(RHS_onaspectmean==TRUE){
    RHS_add <- data.frame(data_input_moments[,"Mean_Aspect"])
    colnames(RHS_add) <- "Mean_Aspect"
    RHS <- cbind(RHS,RHS_add)
  } 
  if(RHS_onaspectsd==TRUE){
    RHS_add <- data.frame(data_input_moments[,"SD_Aspect"])
    colnames(RHS_add) <- "SD_Aspect"
    RHS <- cbind(RHS,RHS_add)
  }
  
  RHS_new <- data.frame(RHS[,-1])
  colnames(RHS_new)[1] <- colnames(RHS)[2]
  
  
  
  regression_moments<- lm(LHS[,] ~ ., RHS_new, na.action=na.omit)
  coefficients_0 <-  as.data.frame(coefficients(regression_moments))
  # coefficients_test <- coefficients_0
  # coefficients_test[2,] <- NA
  # coefficients_test <- drop_na(coefficients_test)
  names <- data.frame(data.frame(row.names(coefficients_0))[-1,])#Drop intercept name
  colnames(names) <- "Moments"
  assign("names", names, envir = .GlobalEnv)
  
  regression_moments_LHSRHS <- cbind(LHS,RHS_new)
  storage_estimates <- data.frame(zeros((length(regression_moments_LHSRHS)-1),1))
  
  for (i in 1:bootstrap_number) {
    set.seed(i)
    data_boot <- regression_moments_LHSRHS[sample(1:data_length,data_length,replace=TRUE),]
    regression_moments<- lm(data_boot[,1] ~ ., data.frame(data_boot[,2:dim(data_boot)[2]]), na.action=na.omit)
    
    coefficients_OLS <-  as.data.frame(coefficients(regression_moments))
    coefficients_OLS <- data.frame(coefficients_OLS[-1,]) #Drop intercept coefficient
    colnames(coefficients_OLS) <- "Coefficient"
    
    storage_estimates <- cbind(storage_estimates, coefficients_OLS)
    
  }
  storage_estimates <- storage_estimates[,-1]
  
  mean_coeff <- data.frame(rowMeans(storage_estimates, na.rm = TRUE))
  sd_coeff <- data.frame(matrixStats::rowSds(as.matrix(storage_estimates), na.rm = TRUE))
  coeff_data <- cbind(mean_coeff, sd_coeff)
  colnames(coeff_data) <- c("Coefficient", "SE")
  
  z_values <- data.frame(coeff_data$Coefficient/coeff_data$SE)
  pvalues <- apply(z_values, 1, function(x) 2*pnorm(-abs(x)))
  
  coeff_data <- cbind(coeff_data, pvalues)
  colnames(coeff_data)[3] <- "Pvalue"
  
  #Put stars for significance (10, 5, 1%)
  coeff_data$Coefficient <- ifelse(coeff_data$Pvalue<0.001, paste0(signif_w_trails(coeff_data$Coefficient,digits=3), "***"),  ifelse(coeff_data$Pvalue<0.01, paste0(signif_w_trails(coeff_data$Coefficient,digits=3), "**"),  ifelse(coeff_data$Pvalue<0.05, paste0(signif_w_trails(coeff_data$Coefficient,digits=3), "*"),  paste0(signif_w_trails(coeff_data$Coefficient,digits=3), ""))))
  
  #Put Coefficient with stars and SE in same columns
  moment_table_add <- data.frame(paste0(coeff_data$Coefficient, " (",signif_w_trails(coeff_data$SE, digits=3) ,")"))
  
  rownames(moment_table_add) <- t((names))
  colnames(moment_table_add) <- "Coefficient_SE"
  
  moment_table_add <- unfactor(moment_table_add)
  
  if(RHS_oncalibrationsd==FALSE){
    coeff_add <- data.frame(Coefficient_SE=NA)
    rownames(coeff_add) <- "SD_Calibration"
    moment_table_add <- rbind(moment_table_add,coeff_add)
  }  
  if(RHS_oncalibrationmean==FALSE){
    coeff_add <- data.frame(Coefficient_SE=NA)
    rownames(coeff_add) <- "Mean_Calibration"
    moment_table_add <- rbind(moment_table_add,coeff_add)
  }  
  if(RHS_onaspectsd==FALSE){
    coeff_add <- data.frame(Coefficient_SE=NA)
    rownames(coeff_add) <- "SD_Aspect"
    moment_table_add <- rbind(moment_table_add,coeff_add)
  }  
  if(RHS_onaspectmean==FALSE){
    coeff_add <- data.frame(Coefficient_SE=NA)
    rownames(coeff_add) <- "Mean_Aspect"
    moment_table_add <- rbind(moment_table_add,coeff_add)
  }  
  
  moment_table_add <- data.frame(moment_table_add[order(rownames(moment_table_add)),])
  
  rownames(moment_table_add) <- c("Mean_Aspect", "Mean_Calibration","SD_Aspect", "SD_Calibration" )
  
  if(beginning_table==TRUE){
    moment_table <- moment_table_add
  }
  
  if(beginning_table==FALSE){
    moment_table <- cbind(moment_table,moment_table_add)
  }
  
  
  assign("moment_table", moment_table, envir = .GlobalEnv)
  
}


# Useful for getting the z-score of a psych scale, or other battery of questions
# Takes in a dataset, the column name , any reversecoded columns, the max rating, the min rating, and the name of the index.


# df <- data.frame (first_column  = c(5,4,5),
#                   second_column = c(1,0,1)
#                  
# )
# columns = c("first_column", "second_column")
# reversecoded = c(1)
# min_rating = 0
# max_rating = 5
# name = 'test'
aggregate_and_z_score <- function(new_data_set,columns,reversecoded,max_rating,min_rating,name) {

  new_data_set[, columns] <- sapply(new_data_set[, columns], as.numeric)
 
  if(length(reversecoded) > 0) {
    reversecoded_cols = columns[reversecoded]
    non_reverse_coded = setdiff(columns, reversecoded_cols)
    percent_reverse_coded =  length(reversecoded) / length(columns)
    new_data_set[,reversecoded_cols]  <- max_rating + min_rating -new_data_set[,reversecoded_cols] 
    
    
    # Equal weighting .
    if( length(non_reverse_coded) > 1 & length(reversecoded_cols) > 1) {
      print("B")
      reweighted =   (0.5 / (1-percent_reverse_coded) ) * rowSums(new_data_set[,non_reverse_coded]) + 
        (0.5 / percent_reverse_coded)  * rowSums(new_data_set[,reversecoded_cols])
    } else if(length(non_reverse_coded) > 1 & length(reversecoded_cols) == 1) {
      print("R")
      
      reweighted =   (0.5 / (1-percent_reverse_coded) ) * rowSums(new_data_set[,non_reverse_coded]) + 
        (0.5 / percent_reverse_coded)  * new_data_set[,reversecoded_cols]
    } else if( length(non_reverse_coded) == 1 & length(reversecoded_cols) > 1) {
      print("N")
      reweighted =   (0.5 / (1-percent_reverse_coded) ) *new_data_set[,non_reverse_coded] + 
        (0.5 / percent_reverse_coded)  * rowSums(new_data_set[,reversecoded_cols])
    } else  {
      print("Z")
      reweighted =   new_data_set[,non_reverse_coded] + 
        new_data_set[,reversecoded_cols]
    }
    reweightName <- paste0(name,"Reweighted")
    new_data_set[,reweightName] <- reweighted
  }
 
   
  newname <- paste0(name,"Sum")

  new_data_set[,newname] <- rowSums(new_data_set[,columns]) # Currently not removing NA's

 
  
  dataf <<-new_data_set

  newname<<-newname
 
  things<<- (new_data_set[,newname] - mean(new_data_set[,newname],na.rm=TRUE)) / sd(unlist(new_data_set[,newname]),na.rm=TRUE)

  new_data_set[,paste0(newname,"_Z_score")] <- (new_data_set[,newname] - mean(new_data_set[,newname],na.rm=TRUE)) / sd(unlist(new_data_set[,newname]),na.rm=TRUE)

  return(new_data_set)  
}

# output = aggregate_and_z_score(df, columns, reversecoded, max_rating, min_rating, name)

detect_NA_in_regression <- function(linear_model) {
  m_coefs = data.frame(linear_model$coefficients)
  colnames(m_coefs) = c("coefs")
  m_coefs$names = rownames(m_coefs)
  m_coefs_na = m_coefs[is.na(m_coefs$coefs),]
  m_coefs_na_cols = m_coefs_na$names
  print("The following columns show NA because there are too few observations where the dummy = 1:")
  print(m_coefs_na_cols)
  m_coefs_na_cols
}

yes_1_no_0 <- function(dataframe,col) {
  output <- gsub("Yes", 1, dataframe[,col])
  output <- gsub("No", 0, output)
  return( as.numeric(output))
}

betas_and_alphas <- function(inputdf,calibrations,gamma_val,df_to_get_means_from,mturk_sample = T) {
  
  if (mturk_sample) {
    all <-inputdf$workerNum
  } else {
    all <-inputdf$uasnum
  }
  alpha_hat_CQs<-c()
  beta_hat_CQs <- c()
  for (z in all) {
    if (mturk_sample) {
      regression_data_person_CQ_real <- data.frame(cbind(t(inputdf[inputdf$workerNum == z,calibrations]),colMeans(df_to_get_means_from[,calibrations],na.rm=TRUE)))
    } else {
      regression_data_person_CQ_real <- data.frame(cbind(t(inputdf[inputdf$uasnum == z,calibrations]),colMeans(df_to_get_means_from[,calibrations],na.rm=TRUE)))
    }
    regression_data_person_CQ_real <- regression_data_person_CQ_real - gamma_val
    colnames(regression_data_person_CQ_real) <- c("LHS", "RHS")
    if(sum(!is.na(regression_data_person_CQ_real$LHS)) == 0 | sum(!is.na(regression_data_person_CQ_real$RHS)) == 0) {
      alpha_hat_CQs  <- c(alpha_hat_CQs,NA)
      beta_hat_CQs <- c(beta_hat_CQs,NA)
    }
    
    else {
      
      regression_person_CQ_real <- lm(LHS~RHS, regression_data_person_CQ_real)
      alpha_hat_CQs  <- c(alpha_hat_CQs,regression_person_CQ_real$coefficients[[1]])
      beta_hat_CQs <- c(beta_hat_CQs,regression_person_CQ_real$coefficients[[2]])
    }
    
    
  }
  return(list(beta_hat_CQs,alpha_hat_CQs))
}

betas_and_alphas_and_sigma_etas <- function(inputdf,calibrations,gamma_val,df_to_get_means_from,mturk_sample = T) {
  if (mturk_sample) {
    all <-inputdf$workerNum
  } else {
    all <-inputdf$uasnum
  }
  alpha_hat_CQs<-c()
  beta_hat_CQs <- c()
  sigma_eta_hat_CQs <- c()
  for (z in all) {
    if (mturk_sample) {
      regression_data_person_CQ_real <- data.frame(cbind(t(inputdf[inputdf$workerNum == z,calibrations]),colMeans(df_to_get_means_from[,calibrations],na.rm=TRUE)))
    } else {
      regression_data_person_CQ_real <- data.frame(cbind(t(inputdf[inputdf$uasnum == z,calibrations]),colMeans(df_to_get_means_from[,calibrations],na.rm=TRUE)))
    }
    regression_data_person_CQ_real <- regression_data_person_CQ_real - gamma_val
    colnames(regression_data_person_CQ_real) <- c("LHS", "RHS")
    if(sum(!is.na(regression_data_person_CQ_real$LHS)) == 0 | sum(!is.na(regression_data_person_CQ_real$RHS)) == 0) {
      alpha_hat_CQs  <- c(alpha_hat_CQs,NA)
      beta_hat_CQs <- c(beta_hat_CQs,NA)
      sigma_eta_hat_CQs <- c(sigma_eta_hat_CQs, NA)
    }
    
    else {
      regression_person_CQ_real <- lm(LHS~RHS, regression_data_person_CQ_real)
      alpha_hat_CQs  <- c(alpha_hat_CQs,regression_person_CQ_real$coefficients[[1]])
      beta_hat_CQs <- c(beta_hat_CQs,regression_person_CQ_real$coefficients[[2]])
      
      summary_regression_person_CQ_real <- summary(regression_person_CQ_real)
      sigma_eta_person <- summary_regression_person_CQ_real$sigma
      sigma_eta_hat_CQs <- c(sigma_eta_hat_CQs, sigma_eta_person)
    }
    
    
  }
  return(list(beta_hat_CQs, alpha_hat_CQs, sigma_eta_hat_CQs))
}



gamma <- function(input_df, calibrations,df_to_get_means_from ) {
  alpha_hat_CQs <- c()
  beta_hat_CQs <- c()
  All <- input_df$workerNum
  means <- colMeans(df_to_get_means_from[,calibrations],na.rm=TRUE)
  for (z in All) {
    regression_data_person_CQ_real <- data.frame(cbind(t(input_df[input_df$workerNum == z,calibrations]),means))
    colnames(regression_data_person_CQ_real) <- c("LHS", "RHS")
    if(sum(!is.na(regression_data_person_CQ_real$LHS)) == 0 | sum(!is.na(regression_data_person_CQ_real$RHS)) == 0) {
      alpha_hat_CQs  <- c(alpha_hat_CQs,NA)
      beta_hat_CQs <- c(beta_hat_CQs,NA)
    } else {
      regression_person_CQ_real <- lm(LHS~RHS, regression_data_person_CQ_real)
      alpha_hat_CQs  <- c(alpha_hat_CQs,regression_person_CQ_real$coefficients[[1]])
      beta_hat_CQs <- c(beta_hat_CQs,regression_person_CQ_real$coefficients[[2]])
    }
    
  }
  return( -cov(alpha_hat_CQs,beta_hat_CQs,use = "complete.obs")/var(beta_hat_CQs,use = "complete.obs"))
  
}

CI_correlation_string<- function(data_in,col1,col2,digits_choice=2) {
  
  b3 <- boot(data_in, 
             statistic = function(data_in, i) {
               cor(data_in[i, col1], data_in[i, col2], method='pearson')
             },
             R = 1000
  )
  CI_correlation <- boot.ci(b3, type = c("perc"))$percent[4:5]
  to_round <- c(b3$t0,CI_correlation)
  return(signif_w_trails(to_round, digits_choice))
}





CI_corrected_correlation_string<- function(data_in,col1,col2,obs_1, obs_2,dig_choice) {
  
  b3 <- boot(data_in, 
             statistic = function(data_in, i) {
               part1 <- cov(data_in[i,col1], data_in[i,col2])
               part2 <- var(data_in[i,col1])
               part3 <- part2/obs_1
               part4 <- var(data_in[i,col2])
               part5 <- part4/obs_2
               part6 <- sqrt(part4-part5)*sqrt(part2-part3)
               part7 <- part1/part6
               corr_corrected <- part7
               corr_corrected <- min(corr_corrected,1)
               return(corr_corrected)
             },
             R = 1000
  )
  CI_corrected_correlation <- boot.ci(b3, type = c("perc"))$percent[4:5]
  to_round <- c(b3$t0,CI_corrected_correlation)
  return(signif_w_trails(to_round, dig_choice))
}
# Function to create today's directory if it doesn't exist
create_today_directory <- function(path, year = FALSE) {
  if (year == FALSE){
    today_dir_name = paste0(month.name[month(today())], day(today()))
  } else {
    today_dir_name = paste0(month.name[month(today())], day(today()), year(today()))
  }
  
  # Check if input path ends with "/"
  if (str_sub(path, -1, -1) == "/") {
    output_dir_path = paste0(path, today_dir_name)
  } else {
    output_dir_path = paste0(path, "/", today_dir_name)
  }
  
  print("Now creating directory, if doesn't already exist: ")
  print(output_dir_path)
  
  # Creating directory if doesn't exist
  ifelse(!dir.exists(file.path(output_dir_path)), dir.create(file.path(output_dir_path)), print("Directory exists"))
  
  # Output directory path
  paste0(output_dir_path, "/")
}

# Function to create string of today's date
create_today_string <- function(full_month_name = FALSE, year = TRUE) {
  if (full_month_name == TRUE) {
    if (year == FALSE){
      today_str = paste0(month.name[month(today())], day(today()))
    } else {
      today_str = paste0(month.name[month(today())], day(today()), year(today()))
    }
  } else {
    if (year == FALSE){
      today_str = paste0(month(today()), "-", day(today()))
    } else {
      today_str = paste0(month(today()), "-", day(today()), "-", year(today()))
    }
  }
  
  # Output directory path
  today_str
}






bootstrap_jeffrey_OLS_IV_CQs_SEs <- function(bootstrap_number,lhs_1, lhs_2,
                                             rhs_1, rhs_2, iv_1,iv_2,
                                             coeffs, regress_data, average=TRUE){
  # Inputs: The lefthand-side variable for up to 2 IV regressions, as well as the RHS and the IVs for those two regressions.
  # bootstrap_number: The number of bootstraps to run to get SEs
  # coeffs: Indices of the coefficient to get
  # average: Whether to return  the average of the coefficients (with its SE) or not
  
  
  coeffs_df <- data.frame(matrix(ncol = 0, nrow = length(coeffs)))
  
  
  
  data_length <- dim(regress_data)[1]-0
  
  for (i in 1:bootstrap_number) {
    set.seed(i)
    
    data_boot <- regress_data[sample(1:data_length,data_length,replace=TRUE),]
    
    
    if(length(rhs_1) == length(iv_1) & length(iv_1) == 2) {
      # Tricky way to get variabilized LHS and RHS and IVs (requires only two IVs)
      regression_1<-eval(bquote(ivreg( .(as.symbol(lhs_1)) ~ 
                                         .(as.symbol(rhs_1[1])) +.(as.symbol(rhs_1[2])) | 
                                         .(as.symbol(iv_1[1])) +.(as.symbol(iv_1[2])) , data= data_boot,na.action=na.omit)))
      
      
      
      regression_2 <-eval(bquote(ivreg( .(as.symbol(lhs_2)) ~ 
                                          .(as.symbol(rhs_2[1])) +.(as.symbol(rhs_2[2])) | 
                                          .(as.symbol(iv_2[1])) +.(as.symbol(iv_2[2])) , data= data_boot,na.action=na.omit)))
      
    }
    
    else if (length(rhs_1) == length(iv_1) & length(iv_1) == 1) {
      # Tricky way to get variabilized LHS and RHS and IVs (requires only two IVs)
      regression_1<-eval(bquote(ivreg( .(as.symbol(lhs_1)) ~ 
                                         .(as.symbol(rhs_1[1]))  | 
                                         .(as.symbol(iv_1[1]))  , data= data_boot,na.action=na.omit)))
      
      
      
      regression_2 <-eval(bquote(ivreg( .(as.symbol(lhs_2)) ~ 
                                          .(as.symbol(rhs_2[1])) | 
                                          .(as.symbol(iv_2[1]))  , data= data_boot,na.action=na.omit)))
      
    }
    
    
    summ_1 <- summary(regression_1)
    slope_1 <- summ_1$coefficients[coeffs,1]
    summ_2 <- summary(regression_2)
    slope_2 <- summ_2$coefficients[coeffs,1]
    point_estimate <- (slope_1+slope_2)/2
    # coeffs_bootstrapping <- c(coeffs_bootstrapping,point_estimate)
    coeffs_df <- cbind(coeffs_df,point_estimate)
  }
  
  
  mean_coeff <- data.frame(rowMeans(coeffs_df, na.rm = TRUE))
  sd_coeff <- data.frame(matrixStats::rowSds(as.matrix(coeffs_df), na.rm = TRUE))
  coeff_data <- cbind(mean_coeff, sd_coeff)
  colnames(coeff_data) <- c("Coefficient", "SE")
  
  z_values <- data.frame(coeff_data$Coefficient/coeff_data$SE)
  pvalues <- apply(z_values, 1, function(x) 2*pnorm(-abs(x)))
  coeff_data <- cbind(coeff_data,pvalues)
  
  
  return (coeff_data)
  
  
}

# Pass in filepath "path" to create desired directory
# If base_or_output == "output": if path is of form "[output_dir]/dir1/dir2", then 
# "[output_dir]/dir1/dir2" will be created
# If path is of form "dir1/dir2", then "[output_dir]/dir1/dir2" will still be created
# If base_or_output == "base", then will be similar, but with "[base_dir]" instead of "[output_dir]"
create_directory_if_empty <- function(path, output_dir = default_output, base_dir = base_wd, base_or_output = "output") {
  if (grepl(output_dir, path, fixed = TRUE)) {
    print(paste0("Output dir ",  output_dir, " in given path"))
    print(strsplit(path, output_dir, fixed = TRUE))
    dirs_to_add = strsplit(path, output_dir, fixed = TRUE)[[1]]
    subdirectories = strsplit(dirs_to_add, "/")[[2]]
  } else if (grepl(base_dir, path, fixed = TRUE)) {
    print(paste0("Base dir ",  base_dir, " in given path"))
    print(strsplit(path, base_dir, fixed = TRUE))
    dirs_to_add = strsplit(path, base_dir, fixed = TRUE)[[1]]
    subdirectories = strsplit(dirs_to_add, "/")[[2]]
    base_or_output = "base"
  } else {
    print(paste0("Output dir ",  output_dir, " and base dir ", base_dir, " not in given path"))
    dirs_to_add = path
    subdirectories = strsplit(dirs_to_add, "/")[[1]]
  }
  
  print("Subdirectories:")
  print(subdirectories)
  
  if (base_or_output == "output") {
    curr_dir = output_dir
  } else {
    curr_dir = base_dir
  }
  
  for (subdir in subdirectories) {
    print(subdir)
    if (str_sub(curr_dir, -1, -1) == "/") {
      curr_dir = paste0(curr_dir, subdir, "/")
    } else if (subdir == "") {
      curr_dir = paste0(curr_dir, subdir)
    } else {
      curr_dir = paste0(curr_dir, "/", subdir, "/")
    }
    
    print(curr_dir)
    
    # Creating directory if doesn't exist
    ifelse(!dir.exists(file.path(curr_dir)), dir.create(file.path(curr_dir)), print("Directory exists"))
  }
  
  print("Created directory directory, if doesn't already exist: ")
  print(curr_dir)
  # 
  # # Creating directory if doesn't exist
  # ifelse(!dir.exists(file.path(output_dir_path)), dir.create(file.path(output_dir_path)), print("Directory exists"))
  # 
  # # Output directory path
  # paste0(output_dir_path, "/")
}


wrapper <- function(x, ...) 
{
  paste(strwrap(x, ...), collapse = "\n")
}




remove_columns_baseline <- function(a_big_dataset){
  a_big_dataset<-a_big_dataset %>% select(-contains("Relationship.Person"))
  a_big_dataset<-a_big_dataset %>% select(-contains("Age."))
  a_big_dataset<-a_big_dataset %>% select(-contains("grit_0"))
  a_big_dataset<-a_big_dataset %>% select(-contains("humor_0"))
  a_big_dataset<-a_big_dataset %>% select(-contains("ethnicity.text."))
  a_big_dataset<-a_big_dataset %>% select(-contains("module_"))
  a_big_dataset<-a_big_dataset %>% select(-contains("text_"))
  a_big_dataset<-a_big_dataset %>% select(-contains("sid_"))
  a_big_dataset<-a_big_dataset %>% select(-contains("xid_"))
  a_big_dataset<-a_big_dataset %>% select(-contains("nid_"))
  a_big_dataset<-a_big_dataset %>% select(-contains("rating_"))
  a_big_dataset<-a_big_dataset %>% select(-contains("pv_"))
  a_big_dataset<-a_big_dataset %>% select(-contains("iv_0"))
  a_big_dataset<-a_big_dataset %>% select(-contains("color_"))
  a_big_dataset<-a_big_dataset %>% select(-contains(c("Crime00","Curviness00", "Information00", "Region_Size_A00","Blackness00")))
  a_big_dataset <- a_big_dataset %>% select(-contains("triple"))
  return(a_big_dataset)
}


get_SSU_CQs <- function(dictionary, aspect) {
 
  dictionary$Calibration_group <- tolower(dictionary$Calibration_group )
  dictionary <- dictionary[dictionary$Scale_frame == "Possible",]
 # dictionary <- dplyr::filter(dictionary, grepl("Kingpin",Rationale_short))
  dictionary <- dplyr::filter(dictionary, !grepl("Reverse",Rationale_short))
    if(aspect=="local_safety") {
      aspect<-"local_no_crime"
    }
  
    if(aspect=="information_access") {
      aspect<-"information"
    }
  
  if(aspect=="green_space") {
    aspect<-"green_spaces"
  }
  
  if(aspect=="sleep_quality") {
    aspect<-"sleep"
  }
  
  if(aspect=="challenge") {
    aspect<-"rise"
  }
    CQ_Dict_Special <- dictionary[dictionary$Calibration_group == aspect, ]
   
  return(CQ_Dict_Special$Calibration_ID)
}







# To create continual "numbering" for Fielding Waves, but with letters
letters_continual_order <- function(num) {
  final <- c()
  for (i in c(1:num)) {
    div_num = floor(i / 26)
    mod_num = i %% 26
    
    to_append = paste0(paste(rep("Z", div_num), collapse = ""), LETTERS[mod_num])
    final <- c(final, to_append)
    # print(final)
  }
  final
}



get_bottomlessA_analysis_CQs <- function(file_path) {
 
  in_dictionary <- read.csv(file_path)
  in_dictionary <- in_dictionary[in_dictionary$Possible==1,]
  in_dictionary <- in_dictionary[in_dictionary$ReverseCodedBlock==0,]
  in_dictionary <- in_dictionary[in_dictionary$Placebo==0,] # This means Placebo Block! There are a few non Placebo questions on the placebo block, but dropped them anyway.
  in_dictionary <- in_dictionary[in_dictionary$Rationale_short!=0,]  
  in_dictionary <- in_dictionary[in_dictionary$TripleGroup!="rating_Cuteness_A",]
  in_dictionary <- in_dictionary[in_dictionary$TripleGroup!="rating_Ripeness_A",]
  in_dictionary <- in_dictionary[in_dictionary$Calibration_ID!="rating_Breathe_BL",]
  in_dictionary <- in_dictionary[in_dictionary$Calibration_ID!="rating_Eat_SL",]
  in_dictionary <- in_dictionary[in_dictionary$Calibration_ID!="rating_No_Anxiety_SL_NONSELF",]
  in_dictionary <- in_dictionary[in_dictionary$Calibration_ID!="rating_No_Anxiety_SM_NONSELF",]
  in_dictionary <- in_dictionary[in_dictionary$Calibration_ID!="rating_No_Anxiety_SH_NONSELF",]
  in_dictionary$Calibration_ID
}

get_bottomless_block_29_30_complete_responders <- function(input_path, all_30_blocks = F) {
  all_bottomless = read_labelled_csv(paste0(input_path, "4000_WideCleanedBottomless.csv"))
  all_bottomless[all_bottomless == -999] <- NA
  
  CQ_dict = read.csv(paste0(input_path, "/4000_CQ_Dictionary_Bottomless.csv"))
  CQ_dict = CQ_dict[CQ_dict$Calibration_ID != "rating_Eat_SL",]
  CQ_dict = CQ_dict[CQ_dict$Calibration_ID != "rating_Breathe_BL",]
  aspect_dict = read.csv(paste0(input_path, "/4000_Aspect_Dictionary_Bottomless.csv"))
  aspect_dict$Aspect = gsub("B_", "", aspect_dict$Aspect)
  # Need to create the first_29 variable
  if (!("first_29" %in% colnames(aspect_dict))) {
    print("first_29 not in there!")
    aspect_dict$first_29 <- rowSums(aspect_dict[, c("baseline", paste0("block", c(1:28)))])
    aspect_dict %<>% mutate(first_29 = ifelse(first_29 > 0, 1, 0))
  }
  aspects_block_29_and_less = aspect_dict[aspect_dict$first_29==1,"Aspect"]
  aspects_block_30_and_less = aspect_dict$Aspect
  
  swb_dict =  read.csv(paste0(input_path, "/BottomlessListOfStandardSWB.csv"))
  swb_dict_29 = swb_dict[swb_dict$Block < 30, ]
  swb_qs_block_30_and_less = swb_dict$Questions
  swb_qs_block_29_and_less = swb_dict_29$Questions
  swb_df <- read.csv(paste0(input_path,"4000_WideCleanedBottomlessStandardSWBs.csv"))
  swb_workers_or_less = swb_df[complete.cases(swb_df[,swb_qs_block_29_and_less]),"workerNum"]
  swb_30_workers_or_less = swb_df[complete.cases(swb_df[,swb_qs_block_30_and_less]),"workerNum"]
  
  all_CQs_block_30_and_less = CQ_dict$Calibration_ID
  all_CQs_block_30_and_less = setdiff(all_CQs_block_30_and_less, c("rating_Eat_SL"))
  all_CQs_block_30_and_less = setdiff(all_CQs_block_30_and_less, c("rating_Breathe_BL"))
  
  all_CQs_block_29_and_less = CQ_dict[CQ_dict$Bottomless_block %in% c(1:29), "Calibration_ID"]
  all_CQs_block_29_and_less = setdiff(all_CQs_block_29_and_less, c("rating_Eat_SL"))
  all_CQs_block_29_and_less = setdiff(all_CQs_block_29_and_less, c("rating_Breathe_BL"))
  
  complete_aspect_workers = all_bottomless[complete.cases(all_bottomless[,aspects_block_30_and_less]) , "workerNum"] 
  complete_CQ_workers = all_bottomless[complete.cases(all_bottomless[,all_CQs_block_30_and_less]) , "workerNum"] 
  all_CQs_and_aspects = intersect(complete_aspect_workers,complete_CQ_workers)
  complete_responders_30  = intersect(all_CQs_and_aspects,swb_30_workers_or_less)
  
  complete_aspect_workers = all_bottomless[complete.cases(all_bottomless[,aspects_block_29_and_less]) , "workerNum"] 
  complete_CQ_workers = all_bottomless[complete.cases(all_bottomless[,all_CQs_block_29_and_less]) , "workerNum"] 
  all_CQs_and_aspects = intersect(complete_aspect_workers,complete_CQ_workers)
  complete_responders  = intersect(all_CQs_and_aspects,swb_workers_or_less)
  
  file_path_intermediate_data <- paste0(base_wd, "/Dropbox/whatisagoodlife/~ Levels paper/Replication package/Data/Intermediate/")
  complete_responders_check <- read_csv(paste0(file_path_intermediate_data, "complete_responders.csv"))$x
  complete_responders_30_check <- read_csv(paste0(file_path_intermediate_data, "block_30_complete_responders.csv"))$x
  
  failed_check <- setdiff(complete_responders, complete_responders_check)
  if (length(failed_check) > 0) {
    "Mismatch with complete responders of Blocks 1-29! Must check!"
  }
  failed_check_30 <- setdiff(complete_responders_30, complete_responders_30_check)
  if (length(failed_check_30) > 0) {
    "Mismatch with complete responders of Blocks 1-30! Must check!"
  }
  
  if (all_30_blocks) {
    print("Returning complete responders of all Blocks, 1-30!")
    ret_val <- complete_responders_30
  } else {
    print("Returning complete responders of Blocks 1-29!")
    ret_val <- complete_responders
  }
  ret_val
}

DistanceBetweenLineAndPoint <- function(x_0,y_0, x_1,y_1,x_2,y_2) { # Line defined by the points:  x_1,y_1,x_2,y_2
  
  numerator = abs((x_2-x_1)*(y_1-y_0) - (x_1-x_0)*(y_2-y_1))
  denominator = sqrt( (x_2-x_1)^2 + (y_2-y_1)^2  )
  return(numerator/denominator)
  print(numerator/denominator)
  stop()
  
  
}

DistanceBetweenPoints <- function(x_0,y_0, x_1,y_1) { # Line defined by the points:  x_1,y_1,x_2,y_2
  
  
  return(sqrt( (x_1-x_0)^2 + (y_1-y_0)^2  ))
  
  
}




#### Special U-shape test code ####

#Two-line test app 0.52
# Last update 2018 11 23
#	Written by Uri Simonsohn (urisohn@gmail.com)
#	This is the exact code behind the two-line online app (http://webstimate.org/twolines/)
#	If you see any errors or have questions people contact me directly.
#
####################################################################################
#

#WARNING: THIS WILL INSTALL PACKAGES IF YOU DON'T HAVE THEM
list.of.packages <- c("mgcv", "stringr","sandwich","lmtest")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(mgcv)         #This library has the additive model with smoothing function 
library(stringr)      #To process strings in the function
library(sandwich)     #For robust standard errors
library(lmtest)       #To run linear tests


#OUTLINE
#Function 1 - rp(p)       Reformat p-value for printing on chart
#Function 2 - eval2()     Reads a variable name and assigns the values to another variable (useful for processing formulas and creating temporary variables)
#Function 3 - reg2()      Interrupted regression with entered formula plus cutoff point
#Function 4 - twolines()  Run two-lines test, relying on functions 1 and 2 as well

################################################################################
#Function 1 - rp(p)       Reformat p-value for printing on chart
rp=function(p) if (p<.0001)  return("p<.0001")  else  return(paste0("p=", sub("^(-?)0.", "\\1.", sprintf("%.4f", p))))

#Function 2 - eval2()   evaluate a string as a function
eval2=function(string) eval(parse(text=string))  #Function that evaluates a variable"
#if x.f="x1", then x=eval2(x.f)  will populate x with the values of x1

#Function 3 - two-line regression with glm() so that it has heteroskedastic robust standard errors
reg2=function(f,xc,graph=1,family="gaussian")
{
  #Syntax: 
  #f: formula as in y~x1+x2+x3
  #The first predictor is the one the u-shape is tested on
  #xc: where to set the breakpoint, a number
  #link: 
  #       Gaussian for OLS 
  #       binomial for probit
  
  #(1) Extract variable names from formula  
  #1.1 Get the formulas
  y.f=all.vars(f)[1]                  #DV
  x.f=all.vars(f)[2]                  #Variable on which the u-shape shall be tested
  #Number of variables
  var.count=length(all.vars(f))       #How many total variables, including y and x
  #Entire model, except the first predictor
  if (var.count>2) nox.f=drop.terms(terms(f),dropx=1,keep.response = T)  
  
  
  #1.2 Grab the two key variables to be used, xu and yu
  xu=eval2(x.f)  #xu is the key predictor predicted to be u-shaped
  yu=eval2(y.f)  #yu is the dv 
  
  #1.3 Replace formula for key predictor so that it accommodates possibly discrete values, gam() breaks down if x has few possible values unless one restricts it, done automatically
  #1.3.1 Count number of unique x values
  unique.x=length(unique(xu))   #How many unique values x has
  #1.3.2 New function segment for x
  sx.f=paste0("s(",x.f,",bs='cr', k=min(10,",unique.x,"))" )
  
  #1.4 xc is included in the first line
  xlow1  =ifelse(xu<=xc,xu-xc,0)   #xlow=x-xc when x<xc, 0 otherwise
  xhigh1=ifelse(xu>xc,xu-xc,0)     #xhigh=x when x<xmax, 0 otherwise
  high1 =ifelse(xu>xc,1,0)         #high dummy, allows interruption
  
  #1.5 Now include xc in second line
  xlow2=ifelse(xu<xc,xu-xc,0)     
  xhigh2=ifelse(xu>=xc,xu-xc,0)     
  high2=ifelse(xu>=xc,1,0)         
  
  #(2) Run interrupted regressions
  #2.1 Generate formulas  replacing the single predictor x, with the 3 new variables
  #If there were covariates, grab them an copy-paste them after the 3 new variables
  if (var.count>2)
  {
    glm1.f=update(nox.f,~ xlow1+xhigh1+high1+.)  #update takes a formula and adds elements to it, by putting the . at the end, it will paste the existing variables after the new 3 variables
    glm2.f=update(nox.f,~ xlow2+xhigh2+high2+.)
  }
  #If there were no covariates, just run the 3 variable model
  if (var.count==2)
  {
    glm1.f=as.formula("yu~ xlow1+xhigh1+high1")  
    glm2.f=as.formula("yu~ xlow2+xhigh2+high2") 
  }
  #2.2 Run them  
  glm1=glm(as.formula(format(glm1.f)),family=family)
  glm2=glm(as.formula(format(glm2.f)),family=family)
  
  #2.3 Compute robust standard errors
  rob1=coeftest(glm1, vcov=vcovHC(glm1,"HC3"))  #Until 2018 03 20 I was using HC3, but they sometimes generate errors, so i switched it to HC1
  rob2=coeftest(glm2, vcov=vcovHC(glm2,"HC3"))
  
  #Sometimes HC3 gives NA values (for very sparse or extreme data), check and if that's the case change method
  msg=""
  if (is.na(rob1[2,4])) 
  {
    rob1=coeftest(glm1, vcov=vcovHC(glm1,"HC1"))  
    msg=paste0(msg,"\nFor line 1 the heteroskedastic standard errors HC3 resulted in an error thus we used HC1 instead.")
  }
  if (is.na(rob2[2,4])) 
  {
    rob2=coeftest(glm2, vcov=vcovHC(glm2,"HC1"))  
    msg=paste0(msg,"\nFor line 2 the heteroskedastic standard errors HC3 resulted in an error thus we used HC1 instead.")
  }
  
  #2.4 Slopes
  b1=as.numeric(rob1[2,1])
  b2=as.numeric(rob2[3,1])
  
  #2.5 Test statistics, z-values 
  z1=as.numeric(rob1[2,3])
  z2=as.numeric(rob2[3,3])
  
  #2.6 p-values
  p1=as.numeric(rob1[2,4])
  p2=as.numeric(rob2[3,4])
  
  
  #3) Is the u-shape significant?
  u.sig =ifelse(b1*b2<0 & p1<.05 & p2<.05,1,0)                     
  
  #4) Plot results
  if (graph==1) {
    
    #4.1 General colors and parameters
    pch.dot=1          #Dot for scatterplot (data)
    #col.l1='blue2'     #Color of straight line 1
    col.l1='dodgerblue3'
    col.l2='firebrick'      #Color of straight line 2
    col.fit='gray50'   #Color of fitted smooth line
    
    col.div="green3"   #Color of vertical line
    lty.l1=1           #Type of line 1
    lty.l2=1           #Type of line 2
    lty.fit=2          #Type of smoothed line
    
    #4.2) Estimate smoother 
    if (var.count>2)
    {
      gam.f=paste0(format(nox.f),"+",sx.f)   #add the modified smoother version of x into the formula
      gams=gam(as.formula(gam.f),link=link)  #now actually run the smoother
    }
    
    if (var.count==2)
    {
      gams=gam(as.formula(paste0("yu~",sx.f)),link=link)  #now actually run the smoother
    }
    
    #Get dots of raw data 
    #4.3) If no covariates, there are two variables, and y.dots  is the y values
    if (var.count==2) yobs=yu
    
    #4.4) If covariates present, yobs is the fitted value with u(x) at mean, need new.data() with variables at means
    if (var.count>2) {
      
      #4.4.1) Put observed data into matrix
      data.obs=as.data.frame(matrix(nrow=length(xu),ncol=var.count))
      colnames(data.obs)=all.vars(f)
      #4.4.2 Populate the dataset with the observed variables
      for (i in 1:(var.count)) data.obs[,i]=eval(as.name(all.vars(f)[i])) 
      
      
      #4.4.3) Drop observations with missing values on any of the variables
      data.obs=na.omit(data.obs)
      
      #4.4.4) Create data where u(x) is at sample means to get residuals based on rest of models to act as yobs
      #Recall: columns 1 & 2 have y and u(x) in obs.data
      data.xufixed    =data.obs  
      data.xufixed[,2]=mean(data.obs[,2])   #Note, the 1st predictor, 2nd columns, is always the one hypothesized to be u-shaped
      #replace it with the mean value of the predictor
      #5.4.5) Create data where u(x) is obs, and all else at sample means
      data.otherfixed = data.obs     #start with original value
      #Replace all RHS with mean, except the u(x)
      #for (i in 3:var.count) data.otherfixed[,i]=mean(data.obs[,i])  #changed on 2018 11 23 to allow having factors() as predictors, their "midpoint" value is used, sometimes that value is more meaningfully a median point than others 
      for (i in 3:var.count) {  #loop over covariates
        xt=sort(data.obs[,i]) #create auxiliary variable that has those values sorted
        n=length(xt)          #see how many observations there are
        xm=xt[round(n/2,0)]   #take the midpoint value (this will work with ordinal and factor data, but with factor it can be arbitrary)
        data.otherfixed[,i]=xm #Replace with that value in the dataset used for fitted value
      }
      #4.4.6) Get yobs with covariates
      #First the fitted value
      yhat.xufixed=predict.gam(gams,newdata = data.xufixed)
      #Substract fitted value from observed y, and shift it with constant so that it has same mean as original y
      yobs =yu-yhat.xufixed
      yobs=yobs+mean(yu)-mean(yobs)  #Adjust to have the same mean
    } #End if for covariates that requires computes y.obs instead of using real y.
    
    #4.5) First line (x,y) coordinates
    #     offset1=mean(yobs[xu<=xc])-min(xu)*b1-(xc-min(xu))/2*b1
    #     x.l1=c(min(xu),xc)
    #     y.l1=c(min(xu)*b1+offset1,xc*b1+offset1)
    #     
    #     #4.6) First line (x,y) coordinates
    # 		offset2=mean(yobs[xu>=xc])-xc*b2-(max(xu)-xc)/2*b2
    # 		x.l2=c(xc,max(xu))
    # 		y.l2=c(xc*b2+offset2,max(xu)*b2+offset2)
    
    #4.7) Get yhat.smooth
    #Without covariates, just fit the observed data
    if (var.count==2)  yhat.smooth=predict.gam(gams) 
    #With covariates, fit at observed means
    if (var.count>2)  yhat.smooth=predict.gam(gams,newdata = data.otherfixed)
    #Substract fitted value from observed y
    offset3 = mean(yobs-yhat.smooth)
    yhat.smooth=yhat.smooth+offset3
    
    #4.8) Coordinates for top and bottom end of chart
    y1   =max(yobs,yhat.smooth)  #highest point
    y0   =min(yobs,yhat.smooth)  #lowest point
    yr   =y1-y0                  #range
    y0   =y0-.3*yr               #new lowest. 30% lower
    
    #xs
    x1   =max(xu)  
    x0   =min(xu)  
    xr   =x1-x0                              
    
    #4.9) Plot
    #4.9.1) Figure out coordinates for arrows so that they fit
    
    par(mar=c(5.4,4.1,.5,2.1))
    plot(xu[xu<xc],yobs[xu<xc],cex=.75,col=col.l1,pch=pch.dot,las=1,
         ylim=c(y0,y1),
         xlim=c(min(xu),max(xu)),
         xlab="",
         ylab="")  #Range of y has extra 30% to add labels
    
    points(xu[xu>xc],yobs[xu>xc],cex=.75, col=col.l2)
    
    #Axis labels
    mtext(side=1,line=2.75,x.f,font=2)
    mtext(side=2,line=2.75,y.f,font=2)
    
    #4.10) Smoothed line
    #lines(xu[order(xu)],yhat.smooth[order(xu)],col=col.fit,lwd=2,lty=lty.fit)
    
    #4.10 - New 2018 05 25
    lines(xu[order(xu)],yhat.smooth[order(xu)],col=col.fit,lty=2,lwd=2)
    
    #4.10.2 Arrow 1
    xm1=(xc+x0)/2
    x0.arrow.1=xm1-.1*xr
    x1.arrow.1=xm1+.1*xr
    y0.arrow.1=y0+.1*yr
    y1.arrow.1=y0+.1*yr+ b1*(x1.arrow.1-x0.arrow.1)
    
    #Move arrow if it is too short
    if (x0.arrow.1<x0+.1*xr) x0.arrow.1=x0          
    
    #Move arrow if it covers text
    gap.1=(min(y0.arrow.1,y1.arrow.1)-(y0+.1*yr))
    if (gap.1<0) {
      y0.arrow.1=y0.arrow.1-gap.1
      y1.arrow.1=y1.arrow.1-gap.1
    }
    
    arrows(x0=x0.arrow.1,x1=x1.arrow.1,y0=y0.arrow.1,y1=y1.arrow.1,col=col.l1,lwd=2)
    
    #4.10.3 Text under arrow 1
    xm1=max(xm1,x0+.20*xr)
    text(xm1,y0+.025*yr,
         paste0("Average slope 1:\nb = ",round(b1,2),", z = ",round(z1,2),", ",rp(p1)),col=col.l1)     
    
    #4.10.3 Arrow 2
    x0.arrow.2=xc+(x1-xc)/2-.1*xr
    x1.arrow.2=xc+(x1-xc)/2+.1*xr
    y0.arrow.2=y1.arrow.1
    y1.arrow.2=y0.arrow.2 + b2*(x1.arrow.2-x0.arrow.2)
    
    gap.2=(min(y0.arrow.2,y1.arrow.2)-(y0+.1*yr))
    if (gap.2<0) {
      y0.arrow.2=y0.arrow.2-gap.2
      y1.arrow.2=y1.arrow.2-gap.2
    }
    
    
    #Shorten arrow if it is too close to the end
    x1.arrow.2=min(x1.arrow.2,x1)
    if (x0.arrow.2<xc) x0.arrow.2=xc
    
    xm2=xc+(x1-xc)/2
    xm2=min(xm2,x1-.2*xr)
    
    
    arrows(x0=x0.arrow.2,x1=x1.arrow.2,y0=y0.arrow.2,y1=y1.arrow.2,col=col.l2,lwd=2)
    text(xm2,y0+.025*yr,
         paste0("Average slope 2:\nb = ",round(b2,2),", z = ",round(z2,2),", ",rp(p2)),col=col.l2)     
    
    
    
    #4.13 Division line
    lines(c(xc,xc),c(y0+.35*yr,y1),col=col.div,lty=lty.fit)
    text(xc,y0+.3*yr,round(xc,2),col=col.div)
  }#End: if  graph==1
  
  #5 list with results
  res=list(b1=b1,p1=p1,b2=b2,p2=p2,u.sig=u.sig,xc=xc,z1=z1,z2=z2,
           glm1=glm1,glm2=glm2,rob1=rob1,rob2=rob2,msg=msg)  #Output list with all those parameters, betas, z-values, p-values and significance for u
  
  if (graph==1) res$yhat.smooth=yhat.smooth
  #output it      
  res
}  #End of reg2() function


#Function 4- 
twolines=function(f,graph=1,link="gaussian",data=NULL,pngfile="")  {
  attach(data)
  
  #(1) Extract variable names   
  #1.1 Get the formulas
  y.f=all.vars(f)[1]                  #DV
  x.f=all.vars(f)[2]                  #Variable on which the u-shape shall be tested
  print("x.f")
  print(x.f)
  print("y.f")
  print(y.f)
  #Number of variables
  var.count=length(all.vars(f))  #How many predictors in addition to the key predictor?
  #Entire model, except the first predictor
  if (var.count>2) nox.f=drop.terms(terms(f),dropx=1,keep.response = T)  
  
  #1.1.5 Drop missing value for any the variables being used
  #all variables in the regression
  vars=all.vars(f)    
  #Vector with columns associated with those variable names inthe uploaded dataset
  cols=c()
  for (var in vars) cols=c(cols, which(names(data)==var))
  #Set of complete observations
  print("cols")
  print(cols)
  full.rows=complete.cases(data[,cols])    
  
  #Drop missing rows
  data=data[full.rows,]
  detach(data)          #Detach the full dataset
  attach(data)          #Attach the one without missing values in key variables
  
  
  #1.2 Grab the two key variables to be used, xu and yu
  xu=eval2(x.f)  #xu is the key predictor predicted to be u-shaped
  yu=eval2(y.f)  #yu is the dv 
  
  #1.3 Replace formula for key predictor so that it accommodates  possibly discrete values
  #1.3.1 Count number of unique x values
  unique.x=length(unique(xu))   #How many unique values x has
  #1.3.2 New function segment for x
  sx.f=paste0("s(",x.f,",bs='cr', k=min(10,",unique.x,"))" )
  
  #2 Run smoother 
  #2.1 Define the formula to be run based on whether there are covariates
  if (var.count>2)  gam.f=paste0(format(nox.f),"+",sx.f)      #with covariates
  if (var.count==2) gam.f=paste0("yu~",sx.f)                  #without
  #2.2 Now run it
  gams=gam(as.formula(gam.f),link=link)  #so this is a general additive model with the main specification entered
  #but we make the first predictor, the one that will be tested for having a u-shaped effect
  #be estimated with a completely flexible functional form.
  
  
  
  #(3) Generate yobs (dots)
  #3.1 If no covariates, yobs is the actually observed data
  if (var.count==2) yobs=yu
  
  #3.2 If covariates present, yobs is the fitted value with u(x) at mean, need new.data() with variables at means
  if (var.count>2) {
    
    #3.3 Put observed data into matrix
    data.obs=as.data.frame(matrix(nrow=length(xu),ncol=var.count))          #Empty datafile
    colnames(data.obs)=all.vars(f)                                          #Name variables
    for (i in 1:(var.count)) data.obs[,i]=eval(as.name(all.vars(f)[i]))     #fill in data
    
    #3.4 Drop observations with missing values on any of the variables
    data.obs=na.omit(data.obs)
    
    #3.5 Create data where xu is at sample means to get residuals based on rest of models to act as yobs
    #Recall: columns 1 & 2 have y and u(x) in obs.data
    data.xufixed    =data.obs  
    data.xufixed[,2]=mean(data.obs[,2])   #Note, the 1st predictor, 2nd columns, is always the one hypothesized to be u-shaped
    #replace it with the mean value of the predictor
    
    #3.6 Get yobs with covariates
    #First the fitted value
    ##add the modified smoother version of x into the formula
    yhat.xufixed=predict.gam(gams,newdata = data.xufixed)        #get fitted values at means for covariates
    
    #3.7 Substract fitted value from observed y
    yobs = yu-yhat.xufixed
    
    #3.8 Create data where u(x) is obs, and all else at sample means
    data.otherfixed              = data.obs     #start with original value
    #3.9 Replace all covariates with their mean for fitting data at sample means
    for (i in 3:var.count)  data.otherfixed[,i]=mean(data.obs[,i])  
  } #End if covariates are present to compute yobs 
  
  
  
  #4) Get the fitted values at sample means for covariates
  #4.1) Get predicted values into list
  if (var.count>2)   g.fit=predict.gam(gams,newdata = data.otherfixed,se.fit=TRUE)  #predict with covariates at means
  if (var.count==2)  g.fit=predict.gam(gams,se.fit=TRUE)
  
  #4.2) Take out the fitted itself
  y.hat=g.fit$fit
  #4.3) Now the SE
  y.se =g.fit$se.fit
  
  
  #5) Most extreme fitted value
  #5.1) Determine if function is at first decreasing (potential u-shape)  vs. increaseing (potentially inverted U)  (potential u-shape) orinverted u shaped using quadratic regression
  #to know if we are looking for max or min
  
  xu2=xu^2                                                  #Square x term, xu is the 1st predictor re-cpded
  if (var.count>2)  lmq.f=update(nox.f,~xu+xu2+.)           #Add to function with covariates   (put first, before covariates)
  if (var.count==2) lmq.f=yu~xu+xu2                         #
  lmq=lm(as.formula(format(lmq.f)))               #Estimate the quadratic regression
  bqs=lmq$coefficients                            #Get the point estimates
  bx1= bqs[2]                                     #point estimate for effect of x
  bx2=bqs[3]                                      #point estimate for effect of x^2
  x0=min(xu)                                      #lowest x-value
  s0=bx1+2*bx2*x0                                 #estimated slope at the lowest x-value
  if (s0>0)  shape='inv-ushape'                   #if the quadratic is increasing at the lowest point, the could be inverted u-shape
  if (s0<=0) shape='ushape'                       #if it is decreaseing, then it could be a regular u-shape
  
  
  #5.2 Get the middle 80% of data to avoid an extreme cutoff
  x10=quantile(xu,.1)
  x90=quantile(xu,.9)
  middle=(xu>x10 & xu<x90)       #Don't consider extreme values for cutoff
  x.middle=xu[middle]       
  
  #5.3 Restrict y.hat to middle    
  y.hat=y.hat[middle]
  y.se=y.se[middle]
  
  #5.4 Find upper and lower band
  y.ub=y.hat+y.se            #+SE is for flat max
  y.lb=y.hat-y.se            #-SE is for flat min
  
  #5.5 Find most extreme y-hat
  if (shape=='inv-ushape') y.most=max(y.hat)   #if potentially inverted u-shape, use the highest y-hat as the most extrme
  if (shape=='ushape')     y.most=min(y.hat)   #if potential u-shaped, then the lowest instead
  
  #5.6 x-value associated with the most extreme value
  x.most=x.middle[match(y.most, y.hat)]       
  
  #5.7 Find flat regions
  if (shape=='inv-ushape') flat=(y.ub>y.most)
  if (shape=='ushape')     flat=(y.lb<y.most) 
  xflat=x.middle[flat]
  
  #6 RUN TWO LINE REGRESSIONS
  #6.1 First an interrupted regression at the midpoint of the flat region
  rmid=reg2(f,xc=median(xflat),graph=0)  #Two line regression at the median point of flat maximum
  
  p1 = rmid$p1
  p2 = rmid$p2
  
  b1 = rmid$b1
  b2 = rmid$b2
  
  
  #6.2  Get z1 and z2, statistical strength of both lines at the midpoint 
  z1=abs(rmid$z1)             
  z2=abs(rmid$z2)             
  
  #6.3 Adjust breakpoint based on z1,z2
  xc=quantile(xflat,z2/(z1+z2))  
  
  #6.4 Regression split based on adjusted based on z1,z2    
  #Save to png? (option set at the beggining by giving png a name)
  if (pngfile!="") png(pngfile, width=2000,height=1500,res=300) 
  #Run the two lines
  res=reg2(as.formula(format(f)),xc=xc,graph=graph)
  #Save to png? (close)
  if (pngfile!="") dev.off()
  
  
  
  #7 Add other results obtained before to the output (some of these are read by the server and included in the app)
  # res$yobs       = yobs
  # res$y.hat      = y.hat
  # res$y.ub       = y.ub
  # res$y.lb       = y.lb
  # res$y.most     = y.most
  # res$x.most     = x.most
  # res$f          = format(f)
  # res$bx1        = bx1           #linear effect in quadratic regression
  # res$bx2        = bx2           #quadratic
  # res$minx       = min(xu)       #lowest x value
  # res$midflat    = median(xflat)
  res$midz1      = abs(rmid$z1)
  res$midz2      = abs(rmid$z2)
  # 
  # res$b1      = b1 #slope1
  # res$b2      = b2 #slope2
  # 
  # res$p1      = p1 #p-val1
  # res$p2      = p2 #p-val2
  on.exit(detach(data))
  res
} #End function



# Extract cutoff point, two average slopes, and their p-value from Simonsohn test
twolines_extract=function(f,graph=1,link="gaussian",data=NULL,pngfile="")  {
  attach(data)
  
  #(1) Extract variable names   
  #1.1 Get the formulas
  y.f=all.vars(f)[1]                  #DV
  x.f=all.vars(f)[2]                  #Variable on which the u-shape shall be tested
  #Number of variables
  var.count=length(all.vars(f))  #How many predictors in addition to the key predictor?
  #Entire model, except the first predictor
  if (var.count>2) nox.f=drop.terms(terms(f),dropx=1,keep.response = T)  
  
  #1.1.5 Drop missing value for any the variables being used
  #all variables in the regression
  vars=all.vars(f)    
  #Vector with columns associated with those variable names inthe uploaded dataset
  cols=c()
  for (var in vars) cols=c(cols, which(names(data)==var))
  #Set of complete observations
  full.rows=complete.cases(data[,cols])    
  
  #Drop missing rows
  data=data[full.rows,]
  detach(data)          #Detach the full dataset
  attach(data)          #Attach the one without missing values in key variables
  
  
  #1.2 Grab the two key variables to be used, xu and yu
  xu=eval2(x.f)  #xu is the key predictor predicted to be u-shaped
  yu=eval2(y.f)  #yu is the dv 
  
  #1.3 Replace formula for key predictor so that it accommodates  possibly discrete values
  #1.3.1 Count number of unique x values
  unique.x=length(unique(xu))   #How many unique values x has
  #1.3.2 New function segment for x
  sx.f=paste0("s(",x.f,",bs='cr', k=min(10,",unique.x,"))" )
  
  #2 Run smoother 
  #2.1 Define the formula to be run based on whether there are covariates
  if (var.count>2)  gam.f=paste0(format(nox.f),"+",sx.f)      #with covariates
  if (var.count==2) gam.f=paste0("yu~",sx.f)                  #without
  #2.2 Now run it
  gams=gam(as.formula(gam.f),link=link)  #so this is a general additive model with the main specification entered
  #but we make the first predictor, the one that will be tested for having a u-shaped effect
  #be estimated with a completely flexible functional form.
  
  
  
  #(3) Generate yobs (dots)
  #3.1 If no covariates, yobs is the actually observed data
  if (var.count==2) yobs=yu
  
  #3.2 If covariates present, yobs is the fitted value with u(x) at mean, need new.data() with variables at means
  if (var.count>2) {
    
    #3.3 Put observed data into matrix
    data.obs=as.data.frame(matrix(nrow=length(xu),ncol=var.count))          #Empty datafile
    colnames(data.obs)=all.vars(f)                                          #Name variables
    for (i in 1:(var.count)) data.obs[,i]=eval(as.name(all.vars(f)[i]))     #fill in data
    
    #3.4 Drop observations with missing values on any of the variables
    data.obs=na.omit(data.obs)
    
    #3.5 Create data where xu is at sample means to get residuals based on rest of models to act as yobs
    #Recall: columns 1 & 2 have y and u(x) in obs.data
    data.xufixed    =data.obs  
    data.xufixed[,2]=mean(data.obs[,2])   #Note, the 1st predictor, 2nd columns, is always the one hypothesized to be u-shaped
    #replace it with the mean value of the predictor
    
    #3.6 Get yobs with covariates
    #First the fitted value
    ##add the modified smoother version of x into the formula
    yhat.xufixed=predict.gam(gams,newdata = data.xufixed)        #get fitted values at means for covariates
    
    #3.7 Substract fitted value from observed y
    yobs = yu-yhat.xufixed
    
    #3.8 Create data where u(x) is obs, and all else at sample means
    data.otherfixed              = data.obs     #start with original value
    #3.9 Replace all covariates with their mean for fitting data at sample means
    for (i in 3:var.count)  data.otherfixed[,i]=mean(data.obs[,i])  
  } #End if covariates are present to compute yobs 
  
  
  
  #4) Get the fitted values at sample means for covariates
  #4.1) Get predicted values into list
  if (var.count>2)   g.fit=predict.gam(gams,newdata = data.otherfixed,se.fit=TRUE)  #predict with covariates at means
  if (var.count==2)  g.fit=predict.gam(gams,se.fit=TRUE)
  
  #4.2) Take out the fitted itself
  y.hat=g.fit$fit
  #4.3) Now the SE
  y.se =g.fit$se.fit
  
  
  #5) Most extreme fitted value
  #5.1) Determine if function is at first decreasing (potential u-shape)  vs. increaseing (potentially inverted U)  (potential u-shape) orinverted u shaped using quadratic regression
  #to know if we are looking for max or min
  
  xu2=xu^2                                                  #Square x term, xu is the 1st predictor re-cpded
  if (var.count>2)  lmq.f=update(nox.f,~xu+xu2+.)           #Add to function with covariates   (put first, before covariates)
  if (var.count==2) lmq.f=yu~xu+xu2                         #
  lmq=lm(as.formula(format(lmq.f)))               #Estimate the quadratic regression
  bqs=lmq$coefficients                            #Get the point estimates
  bx1= bqs[2]                                     #point estimate for effect of x
  bx2=bqs[3]                                      #point estimate for effect of x^2
  x0=min(xu)                                      #lowest x-value
  s0=bx1+2*bx2*x0                                 #estimated slope at the lowest x-value
  if (s0>0)  shape='inv-ushape'                   #if the quadratic is increasing at the lowest point, the could be inverted u-shape
  if (s0<=0) shape='ushape'                       #if it is decreaseing, then it could be a regular u-shape
  
  
  #5.2 Get the middle 80% of data to avoid an extreme cutoff
  x10=quantile(xu,.1)
  x90=quantile(xu,.9)
  middle=(xu>x10 & xu<x90)       #Don't consider extreme values for cutoff
  x.middle=xu[middle]       
  
  #5.3 Restrict y.hat to middle    
  y.hat=y.hat[middle]
  y.se=y.se[middle]
  
  #5.4 Find upper and lower band
  y.ub=y.hat+y.se            #+SE is for flat max
  y.lb=y.hat-y.se            #-SE is for flat min
  
  #5.5 Find most extreme y-hat
  if (shape=='inv-ushape') y.most=max(y.hat)   #if potentially inverted u-shape, use the highest y-hat as the most extrme
  if (shape=='ushape')     y.most=min(y.hat)   #if potential u-shaped, then the lowest instead
  
  #5.6 x-value associated with the most extreme value
  x.most=x.middle[match(y.most, y.hat)]       
  
  #5.7 Find flat regions
  if (shape=='inv-ushape') flat=(y.ub>y.most)
  if (shape=='ushape')     flat=(y.lb<y.most) 
  xflat=x.middle[flat]
  
  #6 RUN TWO LINE REGRESSIONS
  # 6.1 First an interrupted regression at the midpoint of the flat region
  rmid = reg2(f, xc = median(xflat), graph = 0)  # Two line regression at the median point of flat maximum
  
  # 6.2 Get z1 and z2, statistical strength of both lines at the midpoint
  z1 = abs(rmid$z1)
  z2 = abs(rmid$z2)
  
  # 6.3 Adjust breakpoint based on z1, z2
  xc = quantile(xflat, z2 / (z1 + z2))
  
  # 6.4 Regression split based on adjusted based on z1, z2
  res = reg2(as.formula(format(f)), xc = xc, graph = 0)
  
  b1 = res$b1
  b2 = res$b2
  p1 = res$p1
  p2 = res$p2
  
  on.exit(detach(data))
  
  # Return a vector with xc, b1, b2, p1, and p2
  vector <- c(xc, b1, p1, b2, p2)
  vector <- c(vector[[1]], vector[c(2:5)]) # fixes formatting (removes %)
} #End function




pretty_name <- function(name_to_change) {
  
  if(name_to_change == "average_30") {
    return("'Mean across personal aspect ratings'")
  } else if (name_to_change=="average_33") {
    return("'Mean across all aspect ratings'")
  } else if(name_to_change == "satisfaction") {
    return("'Life Satisfaction'")
  } else {
    splitted = paste(unlist(str_split(name_to_change, "_")),collapse = " ") # Replace "_" with space (I realize this could probably be coded more simply)
    splitted = paste0("'", splitted, "'") # add single quotes.
    return(str_to_title(splitted))   # Uppercase first letters of each word
  } 
  
}


# We use this function for factor analysis. 
  # "repair" to assure the matrix I put into PCA is positive semi-definite. 
  #There's no guarantee of this if we don't do this step, 
  #since subtracting from a var-cov matrix may make the new matrix no longer positive semi-definite.
  #Tushar implemented this originally and gave this citation for the method. 
  #Steps to this, if the input matrix isn't PSD, are the following.  


  # 3a) Go through each of the eigenvalues, and for the i_th largest eigenvalue "repair" that 
        #eigenvalue by replacing it with the larger of (i) and (ii), where
      #(i) is the original unrepaired eigenvalue and
      #(ii) is 0.01 if i=1,  and 10^[-sqrt(i+1)] if i >=2). 
  # 3b) Denote V as the matrix containing the eigenvectors of the "unrepaired" var-cov matrix, i.e. the input matrix
  # 3c) Denote D as the diagonal matrix containing the new "repaired" eigenvalues.
  # 3d) Set the new var-cov matrix to be V D V'
cov_repair <- function(cov_matrix){
  varnames <- dimnames(cov_matrix)
  E <- eigen(cov_matrix, symmetric = T)
  if(min(E$values) < 0){
    V <- E$vectors
    D <- E$values
    D_repaired <- pmax(D, c(.01, 10^-(sqrt(2:length(D)))) ) #Maximum of the eigenvalue, and a small positive number
    print(D_repaired == D)
    cov_matrix <- V %*% diag(D_repaired) %*% t(V)
    dimnames(cov_matrix) <- varnames
  }
  return(cov_matrix)
}

# Put stars for significance
# Older version (less flexibility)
stars <- function(p_value_to_check, coefficient_in) {
  return(ifelse(p_value_to_check<0.01, paste0(signif_w_trails(coefficient_in,digits=3), "***"),  ifelse(p_value_to_check<0.05, paste0(signif_w_trails(coefficient_in,digits=3), "**"),  ifelse(p_value_to_check<0.1, paste0(signif_w_trails(coefficient_in,digits=3), "*"),  paste0(signif_w_trails(coefficient_in,digits=3), "")))))
  
}

# Newer version (more flexibility)
# Useful for when you're doing bespoke multiple hypothesis correction (e.g. on LHS)
significance_stars <- function(str, p_val,
                               three_star_cutoff = 0.01,
                               two_star_cutoff = 0.05,
                               one_star_cutoff = 0.1,
                               space_between = "") {
  final_str <- str
  if (!is.na(p_val)) {
    if (p_val < three_star_cutoff) {
      final_str <- paste0(str, space_between, "***")
    } else if (p_val < two_star_cutoff) {
      final_str <- paste0(str, space_between, "**")
    } else if (p_val < one_star_cutoff) {
      final_str <- paste0(str, space_between, "*")
    }
  } else {
    final_str = NA
  }
  
  final_str
}







# Bootstrap function
bootstrap_corr <- function(data, index) {
  thing <<- data
  x <- data[index, 1]
  y <- data[index, 2]
  x_new <- data[index, 3]
  y_new<- data[index, 4]
  
  error_corrected_corr = Cov(x,y) / sqrt(Cov(x,x_new)*Cov(y,y_new) )
  
  return(error_corrected_corr)
}

# Calculate the bootstrap confidence intervals
calculate_bootstrap_ci <- function(data,  R = 1000, conf_level = 0.95) {

  boot_result <- boot(data, statistic = bootstrap_corr, R = R)
  
  conf_int <- boot.ci(boot_result, type = "perc", conf = conf_level)
  return(conf_int)
}


# Helper functions for the difference-of-means (Welch's t-test)
t_stat_welch <- function(mu1, mu2, s1, s2, n1, n2) {
  (mu1 - mu2) / sqrt( (s1 * s1 / n1) + (s2 * s2 / n2) )
}
se_welch <- function(s1, s2, n1, n2) {
  sqrt( (s1 * s1 / n1) + (s2 * s2 / n2) )
}
df_welch <- function(s1, s2, n1, n2) {
  ( ((s1 * s1 /n1) + (s2 * s2 / n2))^2 ) / ( (s1 * s1 / n1)^2/(n1-1) + (s2 * s2 / n2)^2/(n2-1) )
} 
p_val_welch <- function(tt, df) {
  2*pt(-abs(tt),df)
}

count_n <- function(vec) {
  sum(as.numeric(!is.na(vec)))
}
