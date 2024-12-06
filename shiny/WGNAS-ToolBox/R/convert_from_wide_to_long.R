###########################################
###########################################
### Redefining the functions requied to
### build the dataframes from the functions
##########################################
##########################################


###########################################
# Function to perform the transformation
###########################################

function_list_database <- function(x){
  #x corresponds to Data_nimble[i] or Const_nimble[i] i.e. an element of the lists
  type <- tab_meta_new[tab_meta_new$var_mod == names(x), "type_object"]
  
  df <- switch(as.character(type),
               matrix = from_mat_to_database(x),
               vector = from_vect_to_database(x),
               single_value = from_sv_to_database(x), 
               array = from_array_to_database(x),
               stop(cat('Type unknown for object ', names(x), '\n'))
  )
  return(df)
}

###########################################
# Dealing with MATRICES
###########################################
from_mat_to_database <- function(x) { #x corresponds to Data_nimble[i] or Const_nimble[i] i.e. an element of the lists
  
  #data_wide <- as.data.frame(x)
  data_wide <- as.data.frame(as.matrix(x[[1]]))
  
  if ((tab_meta_new[tab_meta_new$var_mod == names(x), "name_dim1"]=="Year") && (tab_meta_new[tab_meta_new$var_mod == names(x), "dim1"]==49)){
    data_wide <- data_wide[-(48:49),]
  }
  
  if (tab_meta_new[tab_meta_new$var_mod == names(x), "name_dim2"]=="Stock unit"){
    colnames(data_wide) <- tab_label$SU_ab
  } else if (tab_meta_new[tab_meta_new$var_mod == names(x), "name_dim2"]=="Stock unit NEC"){
    colnames(data_wide) <- tab_label$SU_ab[tab_label$Complex2=="NEC"]
  } else if (tab_meta_new[tab_meta_new$var_mod == names(x), "name_dim2"]=="Stock unit NAC"){
    colnames(data_wide) <- tab_label$SU_ab[tab_label$Complex2=="NAC"]
  }else if (tab_meta_new[tab_meta_new$var_mod == names(x), "name_dim2"]=="Stock_unit_SouthernNEC"){
    colnames(data_wide) <- tab_label$SU_ab[tab_label$Complex1=="Southern_NEC"]
  }else if (tab_meta_new[tab_meta_new$var_mod == names(x), "name_dim2"]=="Stock_unit_NorthernNEC"){
    colnames(data_wide) <- tab_label$SU_ab[tab_label$Complex1=="Northern_NEC"]
  }else if (tab_meta_new[tab_meta_new$var_mod == names(x), "name_dim2"]=="Atlantic"){
    colnames(data_wide) <- tab_label$Complex3
  }else if (tab_meta_new[tab_meta_new$var_mod == names(x), "name_dim2"]=="Complex"){
    colnames(data_wide) <- unique(tab_label$Complex2)
  }
  
  if (tab_meta_new[tab_meta_new$var_mod == names(x), "name_dim1"]=="Stock unit"){
    rownames(data_wide) <- tab_label$SU_ab
    data_wide$year <- NA
    
  }else if ((tab_meta_new[tab_meta_new$var_mod == names(x), "name_dim1"]=="Year") && (tab_meta_new[tab_meta_new$var_mod == names(x), "dim1"]==7)){
    data_wide$year <- seq(1964,1970)
  }else{
    data_wide$year <- Year}
  data_long <- gather(data = data_wide, area, value, -year, factor_key=TRUE)
  data_long$value <- as.numeric(data_long$value)
  data_long$var_mod <- names(x)
  
  if(data_long$var_mod[1] %in% tab_meta_new$var_mod) {
    data_long$age <- rep(tab_meta_new[tab_meta_new$var_mod == data_long$var_mod[1], "ages"], nrow(data_long))
    data_long$type <- rep(tab_meta_new[tab_meta_new$var_mod == data_long$var_mod[1], "type"], nrow(data_long))
    data_long$metric <- rep(tab_meta_new[tab_meta_new$var_mod == data_long$var_mod[1], "metric"], nrow(data_long))
    data_long$location <- rep(tab_meta_new[tab_meta_new$var_mod == data_long$var_mod[1], "locations"], nrow(data_long))
  }
  
  data_long <- data_long[,c("year", "type", "age", "area","location","metric", "value", "var_mod")]
  return(data_long)
}
###########################################
# Dealing with VECTORS
###########################################
from_vect_to_database <- function(x) { 
  
  if(tab_meta_new[tab_meta_new$var_mod == names(x), "type_object"] == "vector" && tab_meta_new[tab_meta_new$var_mod == names(x), "dim1"] == 47) {
    data_wide <- as.data.frame(x) 
    colnames(data_wide) <- "value"
    data_wide$area <- rep("Atlantic", nrow(data_wide))
    data_wide$year <- Year
  }else if(tab_meta_new[tab_meta_new$var_mod == names(x), "type_object"] == "vector" && tab_meta_new[tab_meta_new$var_mod == names(x), "dim1"] == 25) {
    data_wide <- as.data.frame(x)
    colnames(data_wide) <- "value"
    data_wide$area <- SU_ab
    data_wide$year <- rep(NA, nrow(data_wide))}
  
  data_wide$var_mod <- rep(names(x), nrow(data_wide))
  
  if(data_wide$var_mod[1] %in% tab_meta_new$var_mod) {
    data_wide$age <- rep(tab_meta_new[tab_meta_new$var_mod == data_wide$var_mod[1], "ages"], nrow(data_wide))
    data_wide$type <- rep(tab_meta_new[tab_meta_new$var_mod == data_wide$var_mod[1], "type"], nrow(data_wide))
    data_wide$metric <- rep(tab_meta_new[tab_meta_new$var_mod == data_wide$var_mod[1], "metric"], nrow(data_wide))
    data_wide$location <- rep(tab_meta_new[tab_meta_new$var_mod == data_wide$var_mod[1], "locations"], nrow(data_wide))
  }
  
  data_long <- data_wide[,c("year", "type", "age", "area","location","metric", "value", "var_mod")]
  
  return(data_long)
}
###########################################
# Dealing with SINGLE VALUES
###########################################
from_sv_to_database <- function(x) { #x corresponds to Data_nimble[i] or Const_nimble[i] i.e. an element of the lists
  
  if(tab_meta_new[tab_meta_new$var_mod == names(x), "type_object"] == "single_value" && tab_meta_new[tab_meta_new$var_mod == names(x), "dim1"] == 1) {
    data_wide <- as.data.frame(x) 
    colnames(data_wide) <- "value"
    data_wide$area <- "Atlantic"
    data_wide$year <- NA}
  
  data_wide$var_mod <- names(x)
  if(data_wide$var_mod[1] %in% tab_meta_new$var_mod) {
    data_wide$age <- rep(tab_meta_new[tab_meta_new$var_mod == data_wide$var_mod[1], "ages"], nrow(data_wide))
    data_wide$type <- rep(tab_meta_new[tab_meta_new$var_mod == data_wide$var_mod[1], "type"], nrow(data_wide))
    data_wide$metric <- rep(tab_meta_new[tab_meta_new$var_mod == data_wide$var_mod[1], "metric"], nrow(data_wide))
    data_wide$location <- rep(tab_meta_new[tab_meta_new$var_mod == data_wide$var_mod[1], "locations"], nrow(data_wide))
  }
  
  data_long <- data_wide[,c("year", "type", "age", "area","location","metric", "value", "var_mod")]
  
  return(data_long)
}
###########################################
# Dealing with ARRAYS
###########################################
####################################
####################################
####################################

function_list_database <- function(x){
  #x corresponds to Data_nimble[i] or Const_nimble[i] i.e. an element of the lists
  type <- tab_meta_new[tab_meta_new$var_mod == names(x), "type_object"]
  
  df <- switch(as.character(type),
               matrix = from_mat_to_database(x),
               vector = from_vect_to_database(x),
               single_value = from_sv_to_database(x), 
               array = from_array_to_database(x),
               stop(cat('Type unknown for object ', names(x), '\n'))
  )
  return(df)
}

####################################
####################################
####################################
create_zone_age <- function(age) { #age corresponds to fresh_water_age (1FW, 2FW, 3FW, 4FW, 5FW, 6FW) or sea_winter_age (1SW, 2SW)
  ZONE_Age <- NULL
  k= 0
  for(i in 1:length(SU_ab)){
    for(j in 1:length(age)){
      k = k+1
      ZONE_Age[k] <- paste0(SU_ab[i], "/", age[j])
    }
  }
  return(ZONE_Age)
}


from_array_to_database <- function(x) { 
  
  #Case where the array is of dimension 47x6x25
  if(tab_meta_new[tab_meta_new$var_mod == names(x), "type_object"] == "array" && tab_meta_new[tab_meta_new$var_mod == names(x), "dim1"] == 47  && tab_meta_new[tab_meta_new$var_mod == names(x), "dim2"] == 6 && tab_meta_new[tab_meta_new$var_mod == names(x), "dim3"] == 25) {
    data_wide <- as.data.frame(x)
    ZONE_Age <- create_zone_age(fresh_water_age)
    colnames(data_wide) <- ZONE_Age}
  
  if(tab_meta_new[tab_meta_new$var_mod == names(x), "type_object"] == "array" && tab_meta_new[tab_meta_new$var_mod == names(x), "dim1"] == 7  && tab_meta_new[tab_meta_new$var_mod == names(x), "dim2"] == 6 && tab_meta_new[tab_meta_new$var_mod == names(x), "dim3"] == 25) {
    data_wide <- as.data.frame(x)
    ZONE_Age <- create_zone_age(fresh_water_age)
    colnames(data_wide) <- ZONE_Age}
  
  
  #Case where the array is of dimension 2x25x47
  if(tab_meta_new[tab_meta_new$var_mod == names(x), "type_object"] == "array" && tab_meta_new[tab_meta_new$var_mod == names(x), "dim1"] == 2 && tab_meta_new[tab_meta_new$var_mod == names(x), "dim2"] == 25 && tab_meta_new[tab_meta_new$var_mod == names(x), "dim3"] == 47) {
    data_wide <- data.frame(matrix(NA, ncol=length(SU_ab)*length(sea_winter_age), nrow=length(Year)))
    iterat <- seq(1, dim(as.data.frame(x))[2], by = length(SU_ab))
    m = 1
    for(l in 1:(length(SU_ab))){
      for(i in 1:dim(as.data.frame(x))[1]){
        k = 1
        for(j in iterat){
          data_wide[k, m] <- as.data.frame(x)[i,j]
          k = k+1
        }
        m = m+1
      }
      iterat = iterat + 1
    }
    ZONE_Age <- create_zone_age(sea_winter_age)
    colnames(data_wide) <- ZONE_Age
  }
  
  #If the array is of dimension 2x47x25 or 2x49x25 form (which we consider only the first 47 years)
  #The table is divided into sub-tables every 47 columns (per stock unit for 47 years)
  #We transpose the tables and then we merge them back together again
  if(tab_meta_new[tab_meta_new$var_mod == names(x), "type_object"] == "array" && tab_meta_new[tab_meta_new$var_mod == names(x), "dim1"] == 2 && (tab_meta_new[tab_meta_new$var_mod == names(x), "dim2"] == 47 | tab_meta_new[tab_meta_new$var_mod == names(x), "dim2"] == 49) && tab_meta_new[tab_meta_new$var_mod == names(x), "dim3"] == 25) {
    iterat <- seq(1, dim(t(as.data.frame(x)))[1]+dim(t(as.data.frame(x)))[1]/length(SU_ab), by = dim(t(as.data.frame(x)))[1]/length(SU_ab))
    data_wide <- data.frame(matrix(NA, ncol=length(SU_ab)*length(sea_winter_age), nrow=dim(t(as.data.frame(x)))[1]/length(SU_ab)))
    k=1
    for(i in 1:(length(iterat)-1)){
      data_wide[,k:(k+1)] <- t(as.data.frame(x))[iterat[i]:(iterat[i+1]-1),1:ncol(t(as.data.frame(x)))]
      k = k+2
    }
    
    data_wide <- data_wide[1:length(Year),]
    ZONE_Age <- create_zone_age(sea_winter_age)
    colnames(data_wide) <- ZONE_Age
  }
  
  if(tab_meta_new[tab_meta_new$var_mod == names(x), "type_object"] == "array" && tab_meta_new[tab_meta_new$var_mod == names(x), "dim1"] == 7){
    data_wide$year <- seq(1964,1970)
  }else{
    data_wide$year <- Year 
  }
  
  
  data_long <- gather(data = data_wide, area, value, colnames(data_wide[, colnames(data_wide) %in% ZONE_Age]), factor_key=TRUE)
  data_long$area <- as.character(data_long$area)
  data_long$value <- as.numeric(data_long$value)
  data_long$value <- as.numeric(data_long$value)
  data_long$var_mod <- rep(names(x), nrow(data_long))
  
  #Find in tab_final which line has the same name
  #So that we can retrieve the age, type, name associates 
  if(data_long$var_mod[1] %in% tab_meta_new$var_mod) {
    data_long$type <- rep(tab_meta_new[tab_meta_new$var_mod == data_long$var_mod[1], "type"], nrow(data_long))
    data_long$age <- rep(tab_meta_new[tab_meta_new$var_mod == data_long$var_mod[1], "ages"], nrow(data_long))
    data_long$metric <- rep(tab_meta_new[tab_meta_new$var_mod == data_long$var_mod[1], "metric"], nrow(data_long))
    data_long$location <- rep(tab_meta_new[tab_meta_new$var_mod == data_long$var_mod[1], "locations"], nrow(data_long))
  }
  
  data_long <- separate(data_long, col = area, into = c("area", "age"), sep = "/")
  data_long <- data_long[,c("year", "type", "age", "area","location", "metric", "value", "var_mod")]
  
  return(data_long)
}
