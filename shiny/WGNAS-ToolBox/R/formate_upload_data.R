formate_upload_data<-function(up){

  up$year<-as.numeric(up$year)
  up$type<-as.character(up$type)
  up$age<-as.character(up$age)
  up$area<-as.character(up$area)
  up$location<-as.character(up$location)
  up$metric<-as.character(up$metric)
  up$value<-as.numeric(up$value)
  up$var_mod<-as.character(up$var_mod)

  return(up)
  
}
