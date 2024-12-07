###############################################
######## Check the uploaded data format
###############################################

check_input_data_set<-function(upload_db, current_db){
  
  messg<-'data is valid'
  
  if(all.equal(as.character(colnames(upload_db)),as.character(colnames(current_db)))!=TRUE || ncol(upload_db)!=ncol(current_db)){
    messg<-"! The number of columns or their name do not match the required format. Please check your data or the .csv import parameters"
  } else{
    
    # TEST FOR NUMBER OF VARIABLES
    #if(nrow(unique(cbind(upload_db$Data_Name,upload_db$ZONE,upload_db$age)))>1){
    #  messg<-"/!\ Your are providing data for more than one variable. Please check your data" 
    #} else {
    
    if(nrow(unique(cbind(upload_db$var_mod)))>1){
      messg<-"! Your are providing data for more than one variable. Please check your data" 
    } else {
      
      # current_info<-subset(current_db, as.character(current_db$Data_Name)==upload_db$Data_Name[1] &
      #                       as.character(current_db$ZONE)==upload_db$ZONE[1] &
      #                        as.character(current_db$Age)==upload_db$Age[1])
      
      if(unique(upload_db$type)%in%c("Returns","Sea catches","Survival rate","Homewater catches","Demographic transitions","Natural mortality rate","Abundance")){
        current_db %>%
          filter(type == unique(upload_db$type)) %>%
          filter(metric %in% upload_db$metric)%>%
          filter(age %in% upload_db$age) %>%
          filter(area %in% upload_db$area) %>%
          filter(location %in% upload_db$loca)->current_info
      }else{
        current_db %>%
          filter(type == unique(upload_db$type)) %>%
          filter(age %in% upload_db$age) %>%
          filter(area %in% upload_db$area) %>%
          filter(location %in% upload_db$loca)->current_info
      }  
      
      
      if(nrow(current_info)==0){messg<-"/!\ It seems that this data has not been observed yet in the database. Make sure your provide a variable absent from the database."}
      
      if(min(upload_db$year)>min(current_info$year) | max(upload_db$year)<max(current_info$year)){
        messg<-"! The new data should cover at least the same period as the current data. If no data is available for some years, please fill data with NA"
      } else {
        
        if(
          # is.numeric(upload_db$Year)==FALSE |
          # is.numeric(upload_db$Data_type)== FALSE |
          # is.numeric(upload_db$Data_name)== FALSE |
          # is.numeric(upload_db$Age)== FALSE |
          # is.numeric(upload_db$ZONE)== FALSE |
          is.numeric(upload_db$value)== FALSE #|
          # is.numeric(upload_db$Var_mod)== FALSE 
        ){
          messg<-"! Check the format of your data: 'Value' should be numeric"
        }
      }
    }
  }
  
  return(messg)
}
