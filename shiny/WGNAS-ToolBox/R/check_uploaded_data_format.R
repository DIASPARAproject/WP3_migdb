###############################################
######## Check the uploaded data format
###############################################

check_input_data_set<-function(upload_db, current_db){
  
  if(is.null(upload_db)){
    messg<-''
  }else{
    
    
    messg<-'data is valid'
    
    if(all.equal(colnames(upload_db),colnames(current_db))!=TRUE || ncol(upload_db)!=ncol(current_db)){
      
      if(ncol(upload_db)<=1){
        messg<-'!!! Uncorrect format - Check your .csv separator!'
      }else{
        messg<-'!!! The number of columns / their name do not match the required format. Please check your data or modify the "Quote" or "Header" for .csv format'  
      }

    } else{
    
    ### temporary removal before changes in the ckecking procedure       
        #if(nrow(unique(cbind(upload_db$Data_Name,upload_db$ZONE,upload_db$Age)))>1){
      if(length(unique(upload_db$var_mod))>1){
        messg<-'!!! Your are providing data for more than one variable. Please check your file!' 
      } else {
        
        if(TRUE%in%duplicated.data.frame(upload_db)){
          messg<-'!!! We identify duplicated lines. Please check your file!' 
        } else {
          
          current_info<-subset(current_db, as.character(current_db$var_mod)==upload_db$var_mod[1])
        
          if(unique(upload_db$type)!=unique(current_info$type) | unique(upload_db$var_mod)!=unique(current_info$var_mod) | unique(upload_db$metric)!=unique(current_info$metric) ){
           messg<-'!!! datatype, var_mod or metric do not match the data to update. Please check your file!' 
          } else {
        
            if(unique(unique(current_info$area)%in%unique(upload_db$area))!=T){
              messg<-'!!! You forgot data for one or several areas. Please check your file!'
            } else {
          
              if(unique(unique(current_info$age)%in%unique(upload_db$age))!=T){
                messg<-'!!! You forgot data for one or several ages. Please check your file!'
              } else {
            
                combupload<-upload_db%>%
                  group_by(location,area,age)%>%
                  summarise(n=n())
                combcurrent<-current_info%>%
                  group_by(location,area,age)%>%
                  summarise(n=n())
            
                  if(nrow(combupload)!=nrow(combcurrent)){
                    messg<-'!!! Some combinations of area/age/location are missing. Please check your file!'
                  } else { 
                    
                    if(NA%in%match(combcurrent$area, combupload$area)){
                      messg<-'!!! The name of areas does not seem correct. Please check your file!'
                    } else { 
            
                      if(TRUE%in%(combupload$n<combcurrent$n)){
                       messg<-'!!! Some years missing for particular area/age/location combination. Please check your file!'
                      } else { 
                        ####### Blocking when not uploading the data for the variable
                        if(length(unique(combupload$n))>1){
                          messg<-'!!! You are not providing the same temporal coverage for all variables. Please check your file!'
                        } else { 
                
                        if(nrow(current_info)==0){messg<-'!!! No record yet for this variable in the database. Check your data or contact SalmoGlob team.'}
      
                          if(min(upload_db$year)>min(current_info$year) | max(upload_db$year)<max(current_info$year)){
                            messg<-'!!! The new data should cover at least the same period as the current data. If no data is available for some years, please fill data with NA'
                          } else {
    
                            if(is.numeric(upload_db$value)== FALSE){
                              messg<-'!!! Check the format of your data: "value" should be numeric - check your data/the decimal character'
                            }
                          }
                        }
                      }
                  }
                  }
              }
            }
          }
        }
      }
    }
    }
  return(messg)
}
