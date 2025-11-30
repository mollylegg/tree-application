clean_it <- function(data_set){
  #changed to include pitcher name
  all_data <- data_set[,c("pitchno", "date", "pitchofpa","batterside", "taggedpitchtype",
                          "pitchcall", "relspeed", "spinrate", "inducedvertbreak",
                          "horzbreak", "pitcherteam", "platelocside", "pitcher")]
  
  all_data$success <- "F"
  all_data$relspeed <- as.numeric(all_data$relspeed)
  all_data$spinrate <- as.numeric(all_data$spinrate)
  all_data$inducedvertbreak <- as.numeric(all_data$inducedvertbreak)
  all_data$horzbreak <- as.numeric(all_data$horzbreak)
  all_data$taggedpitchtype <- as.factor(all_data$taggedpitchtype)
  all_data$platelocside <- as.numeric(all_data$platelocside)
  all_data <- all_data[all_data$taggedpitchtype != "Undefined",]
  all_data <- all_data[all_data$taggedpitchtype != "Other",]
  
  for (i in 1:nrow(all_data)) {
    
    
    #change ALL fb types to "Fastball"
    if(all_data[i,5] == "Sinker"){
      all_data[i,5] = "Fastball"
    } else if(all_data[i,5] == "FourSeamFastBall"){
      all_data[i,5] = "Fastball"
    } else if(all_data[i,5] == "TwoSeamFastBall"){
      all_data[i,5] = "Fastball"
    }
    
    
    #define success
    if(all_data[i,6] == "StrikeCalled"){
      all_data[i,14] <- "S"
    } else if(all_data[i,6] == "StrikeSwinging"){
      all_data[i,14] <- "S"
    } else if(all_data[i,6] == "FoulBall"){
      all_data[i,14] <- "S"
    }
    
  }
  
  all_data <- na.omit(all_data)
  
  dates <- unique(all_data$date)
  #i'd have to add other pitch types to be general
  date_avgs <- data.frame(matrix(NA, nrow = 0, ncol = 5))
  colnames(date_avgs) <- c("Date", "FBvelo", "FBrpm", "FBivb", "FBhb")
  for(i in 1:(length(dates))){
    date_avgs[i,1] = dates[i]
    all_day = all_data[all_data$date == dates[i],]
    fbs = all_day[all_day$taggedpitchtype == "Fastball",]
    
    #fb
    date_avgs[i,2] = mean(fbs$relspeed)
    date_avgs[i,3] = mean(fbs$spinrate)
    date_avgs[i,4] = mean(fbs$inducedvertbreak)
    date_avgs[i,5] = mean(fbs$horzbreak)
  }
  
  all_data_cleaned <- all_data
  #15
  all_data_cleaned$diff_fb_speed <- 0
  #16
  all_data_cleaned$diff_fb_spin <- 0
  #17
  all_data_cleaned$diff_fb_ivb <- 0
  #18
  all_data_cleaned$diff_fb_hb <- 0
  all_data_cleaned$diff_prev_speed <- 0
  all_data_cleaned$diff_prev_spin <- 0
  all_data_cleaned$diff_prev_ivb <- 0
  all_data_cleaned$diff_prev_hb <- 0
  
  
  
  #subtracting fbs
  for(k in 1:nrow(all_data_cleaned)){
    today = all_data_cleaned[k,2]
    yuh = date_avgs[date_avgs$Date == today,]

    
    all_data_cleaned[k,15] <- all_data_cleaned[k,7] - yuh[1,2]
    all_data_cleaned[k,16] <- all_data_cleaned[k,8] - yuh[1,3]
    all_data_cleaned[k,17] <- all_data_cleaned[k,9] - yuh[1,4]
    all_data_cleaned[k,18] <- all_data_cleaned[k,10] - yuh[1,5]
  }
  
  for(i in 2:nrow(all_data_cleaned)){
    j = i -1
    all_data_cleaned[i,19] <- all_data_cleaned[i,7] - all_data_cleaned[j,7]
    all_data_cleaned[i,20] <- all_data_cleaned[i,8] - all_data_cleaned[j,8]
    all_data_cleaned[i,21] <- all_data_cleaned[i,9] - all_data_cleaned[j,9]
    all_data_cleaned[i,22] <- all_data_cleaned[i,10] - all_data_cleaned[j,10]
  }
  
  
  
  
  return(all_data_cleaned)
}
