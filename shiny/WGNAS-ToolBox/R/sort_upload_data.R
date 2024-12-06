sort_upload_data<-function(up, ref_tab_label){
  
  up <- up[order(up$year),]
  up <- up[order(up$age),]
  
  #if(unique(unique(up$location) %in% ref_tab_label$su_ab)){
  # actually, even if the elements are not part of tref_tab_label$su_ab, it will work.
  #The element present in the vector will be sorted first, the other will be put behind while conserving the previous hierarchy.
    up <- up[order(match(up$location, ref_tab_label$su_ab)),]
  #}else{
  #  up <- up[order(up$location),]
  #}
  #if(unique(unique(up$area)  %in% ref_tab_label$su_ab)){
    up <- up[order(match(up$area, ref_tab_label$su_ab)),]
  #}else{
  #  up <- up[order(up$area),]
  #}
  
  up <- up[order(up$var_mod),]

  return(up)
  
}
