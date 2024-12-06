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
        } 
      }
    }
  }
  return(messg)
}
