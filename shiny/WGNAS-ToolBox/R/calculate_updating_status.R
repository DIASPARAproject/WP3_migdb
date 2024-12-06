#############################################
#### Calculating the % of updated time-series


pc_updated <- function(database, tab_type_object){

  tab_type_object %>% filter(name_dim1=="Year" | name_dim2== "Year" | name_dim3=="Year") %>%
    filter(nimble %in% c("Const_nimble","Data_nimble")) %>% select(var_mod) -> with_TS
  
  with_TS <- as.vector(unlist(as.vector(c(with_TS))))
  with_TS <- with_TS[-which(grepl("_pr",with_TS))] 
  
  database %>% filter(var_mod %in% with_TS) %>%
    group_by(var_mod, metric) %>%
    summarise(maxy=max(year), miny=min(year)) -> minmax_type_sel
  
  pc_update <- length(which(minmax_type_sel$maxy==max(minmax_type_sel$maxy, na.rm=T)))/nrow(minmax_type_sel)*100

  year_ready <- min(minmax_type_sel$maxy)
  
  status_DB <- c(pc_update,year_ready)
  
  return(status_DB)
  
}