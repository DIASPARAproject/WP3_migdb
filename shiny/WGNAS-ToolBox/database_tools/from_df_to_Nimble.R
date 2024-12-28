# This script defines the functions that will be helpful to  convert the data in the database, which has a data.frame format, into Nimble objects

list_nimb <- NULL

# Depending on the dimensions of the variables (multiple years, areas, age etc.), the objects in Const_ and Data_Nimble
#will be of different type, from single value to arrays. Thus, different functions are used for converting the database content into the 
#formats required by Nimble.

# to create matrices
long_to_wide_mat<-function(x){
  ifelse(unique(x[,c("var_mod")])!="omega",
         out<-as.matrix(cast(x[,c("year","area","value")], year ~ area)[,-1]),
         out<-as.matrix(cast(x[,c("area","location","value")], area ~ location)[,-1])
         )
return(out)}

# to create vectors
long_to_wide_vect<-function(x){out<-as.vector(x[,c("value")])
return(out)}

# to create single values
long_to_wide_sv<-function(x){out<-as.numeric(x[,c("value")])
return(out)}

# to create arrays
long_to_wide_arr<-function(x){
  ifelse(!unique(x[,c("var_mod")])%in%c("eggs", "prop_female"),
         out<-as.array(acast(x[,c("year","age","area","value")], year ~ age  ~ area )),
         out<-as.array(acast(x[,c("year","age","area","value")], age ~ area  ~ year ))
         )
  return(out)
  }

# there is a specific format for the eggs variable (age as dimension 1, year as dimension 2). Could be modified in the future, it is just an old remain from 
#previous work.
long_to_wide_arr_eggs<-function(x){out<-as.array(acast(x[,c("age","year","area","value")], year ~ age  ~ area ))
return(out)}

# create_nimble_objects is the function that will be used to format the data.frames into Nimble format
create_nimble_objects <- function(y, tab_type_object, tab_label){ #x corresponds to the database
  
  # We convert the character variables into factors so that the variable modalities are always assigned to rank in the vectors/matrices/arrays.
  #The rank is based on the information found in the database table containing the so-called "labels", tab_label
  x<-y
  x$area<-as.factor(x$area)
  x$area<-factor(x$area,levels=c(unique(tab_label$su_ab),unique(tab_label$complex2),unique(tab_label$complex3)))
  x$location<-as.factor(x$location)
  levloc<-c(unique(tab_label$su_ab), unique(y$location)[!unique(y$location)%in%unique(tab_label$su_ab)])
  x$location<-factor(x$location,levels=levloc)
  
  # The destination of the create objects will be different, i.e. Constant/Data, depending on the information present in the metadata table of the database.
  tab_type_object %>%  filter(nimble == 'Data_nimble')  %>% select(var_mod) -> var_names_Data
  tab_type_object %>%  filter(nimble == 'Const_nimble') %>% select(var_mod)-> var_names_Const
  
  x %>%  distinct(var_mod) %>%  inner_join(var_names_Data, by = 'var_mod') -> var_names_Data
  x %>%  distinct(var_mod) %>%  inner_join(var_names_Const, by = 'var_mod') -> var_names_Const
  
  n_var_Data  <- nrow(var_names_Data)
  n_var_Const <- nrow(var_names_Const)
  
  list_data_nimble <- lapply(1:n_var_Data, function(i_){
    
    type <- tab_type_object[tab_type_object$var_mod == var_names_Data$var_mod[i_], "type_object"]
    database_var <- x %>% filter(var_mod == var_names_Data$var_mod[i_])
    
    database_var <- database_var[order(database_var$year),]
    
    if(var_names_Data$var_mod[i_]=="p_C8_2_NECNAC_gld_mu"){
      database_var$area <- factor(database_var$area,levels=rev(c(unique(tab_label$su_ab),unique(tab_label$complex2),unique(tab_label$complex3))))
    }
    
    if(var_names_Data$var_mod[i_]=="cons_lim"){
      database_var$area <- factor(database_var$area,levels=c("coun_Labrador","coun_Newfoundland","coun_Quebec","coun_Gulf","coun_Scotia Fundy","coun_US","coun_Iceland",
                                                             "coun_Scotland","coun_Northern Ireland","coun_Ireland","coun_England_Wales","coun_France","coun_Iceland","coun_Sweden",
                                                             "coun_Norway","coun_Finland","coun_Russia"))
    }
    
    switch(type,
           matrix =long_to_wide_mat(database_var),
           vector = long_to_wide_vect(database_var),
           single_value = long_to_wide_sv(database_var),
           array = long_to_wide_arr(database_var),
           stop(cat('Type unknown for object ', database_var$var_mod, '\n'))
    )
  })
  
  list_data_nimble<-setNames(list_data_nimble, as.list(var_names_Data$var_mod))
  
  
  list_const_nimble <- lapply(1:n_var_Const, function(i_){
    type <- tab_type_object[tab_type_object$var_mod == var_names_Const$var_mod[i_], "type_object"]
    database_var <- x %>% filter(var_mod == var_names_Const$var_mod[i_])
    
    switch(type,
           matrix =long_to_wide_mat(database_var),
           vector = long_to_wide_vect(database_var),
           single_value = long_to_wide_sv(database_var),
           array = long_to_wide_arr(database_var),
           stop(cat('Type unknown for object ', database_var$var_mod, '\n'))
    )
  })
  
  list_const_nimble<-setNames(list_const_nimble, as.list(var_names_Const$var_mod))
  
  
  #Data_nimble = do.call('c', list_data_nimble)
  #Const_nimble = do.call('c', list_const_nimble)
  return(list(Data_nimble= list_data_nimble,
              Const_nimble= list_const_nimble
  ))
  
}

