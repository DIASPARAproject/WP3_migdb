check_function<-function(x){
  
  get_database_checked<-x
  
  get_database_checked$value[get_database_checked$var_mod=="log_N6_sd"]<-
    pmax(0.05, get_database_checked$value[get_database_checked$var_mod=="log_N6_sd"])
  get_database_checked$value[get_database_checked$var_mod=="log_N9_sd"]<-
    pmax(0.05, get_database_checked$value[get_database_checked$var_mod=="log_N9_sd"])
  
  return(get_database_checked)
}