#------------------------------------
# Defining the function for SU -----
#------------------------------------
produce_template_db_SU_it<-function(sub, SU_id, template, i, blank_y){
  
  var_data_area<-subset(sub, sub$var_mod==i)[,c("year","type","age","area",
                                                "location","metric","value",
                                                "var_mod")]
  
  if(i!="omega" &
     grepl("_pr", i)==F &
     grepl("p_C", i)==F &
     grepl("deltat", i)==F &
     grepl("min", i)==F &
     grepl("max", i)==F &
     grepl("CV_theta1", i)==F){
    
    n_insert<-length(which(var_data_area$year==blank_y))
    
    for (loc in 1:n_insert){
      
      loc_insert<-which(var_data_area$year==blank_y)[loc]
      pattern_insert<-var_data_area[loc_insert,]
      
      var_data_area<-dplyr::add_row(
        var_data_area,
        year = pattern_insert$year+1,
        type = pattern_insert$type,
        age=pattern_insert$age,
        location=pattern_insert$location,
        metric=pattern_insert$metric,
        value=NA,
        var_mod=pattern_insert$var_mod,
        .after = loc_insert
      )
    }
    
    j<-length(sheets(template))+1
    
    addWorksheet(wb=template, sheetName = i)
    writeData(template, sheet = j, var_data_area, startRow = 1, startCol = 1, colNames = TRUE, rowNames = F)
    fillStyle <- createStyle(fontSize = 12, fontColour = "black",
                                   halign = "center", valign = "center", fgFill = "mistyrose", 
                                   border = "TopBottomLeftRight", borderColour = "black",
                                   textDecoration = "bold", wrapText = TRUE)
    BlankStyle <- createStyle(fontColour = "red",
                             valign = "center", fgFill = "mistyrose", borderColour = "red",
                             textDecoration = "bold")
    headerStyle <- createStyle(fontSize = 12, fontColour = "black",
                                halign = "center", valign = "center", fgFill = "grey", 
                                border = "TopBottomLeftRight", borderColour = "black",
                                textDecoration = "bold", wrapText = TRUE)
    addStyle(template, sheet = j, fillStyle, rows = 1:nrow(var_data_area), cols=7, 
             gridExpand = TRUE)
    addStyle(template, sheet = j, headerStyle, rows = 1, cols=1:8, 
             gridExpand = TRUE)
    addStyle(template, sheet = j, BlankStyle, rows = which(is.na(var_data_area$value))+1, cols=1:8, 
             gridExpand = TRUE)
    
  }
    
}


#-------------------------------------
# Defining the function for fisheries-
#-------------------------------------


produce_template_db_fishery_it<-function(sub, template, i, blank_y){
  
  ###datanimb<-get(load("exchange_plateform/Nimble_input/Data_nimble.RData"))
  ###constnimb<-get(load("exchange_plateform/Nimble_input/Const_nimble.RData"))
  
  var_data_area<-subset(sub, sub$var_mod==i)[,c("year","type","age","area",
                                                "location","metric","value",
                                                "var_mod")]
  
  n_insert<-length(which(var_data_area$year==blank_y))
  
  for (loc in 1:n_insert){
    
    loc_insert<-which(var_data_area$year==blank_y)[loc]
    pattern_insert<-var_data_area[loc_insert,]
    
    var_data_area<-dplyr::add_row(
      var_data_area,
      year = pattern_insert$year+1,
      type = pattern_insert$type,
      age=pattern_insert$age,
      location=pattern_insert$location,
      metric=pattern_insert$metric,
      value=NA,
      var_mod=pattern_insert$var_mod,
      .after = loc_insert
    )
  }
  
  ###var_in_meta<-which(metadata$var_mod==names(sub[i]))
  ###
  ###nd1<-metadata$name_dim1[var_in_meta]
  ###nd2<-metadata$name_dim2[var_in_meta]
  ###nd3<-metadata$name_dim3[var_in_meta]
  ###
  ###dim_obj<-ncol(as.data.frame(as.matrix(sub[[i]])))
  ###
  ###if(dim_obj==1){
  ###  
  ###  retrieve<-as.data.frame(c(sub[[i]],NA))
  ###  rownames(retrieve)<-as.character(seq(1970+as.numeric(constnimb["date_begin"]),1971+as.numeric(constnimb["date_end"])))
  ###  colnames(retrieve)<-"value"
  ###}
  ###
  ###if(dim_obj>1){
  ###  
  ###  
  ###  if(grepl("NECNAC",names(sub[i]))){
  ###    NECNAC_names <-c("NEC","NAC")
  ###  }else{
  ###    if(grepl("NEC",names(sub[i]))){
  ###      NECNAC_names <- tab_labels$su_ab[seq((as.numeric(constnimb["N_NAC"])+1),as.numeric(constnimb["N"]))]
  ###    }else{
  ###      NECNAC_names <-tab_labels$su_ab[seq(1,as.numeric(constnimb["N_NAC"]))]
  ###    }
  ###  }
  ###  
  ###  retrieve<-as.data.frame(rbind(as.matrix(sub[[i]]),NA))
  ###  rownames(retrieve)<-as.character(seq(1970+as.numeric(constnimb["date_begin"]),1971+as.numeric(constnimb["date_end"])))
  ###  colnames(retrieve)<-NECNAC_names
  ###  
  ###}
  
  j<-length(sheets(template))+1
  
  #addWorksheet(wb=template, sheetName = names(sub[i]))
  #writeData(template, sheet = j, retrieve, startRow = 1, startCol = 1, colNames = TRUE, rowNames = TRUE)
  
  addWorksheet(wb=template, sheetName = i)
  writeData(template, sheet = j, var_data_area, startRow = 1, startCol = 1, colNames = TRUE, rowNames = F)
  fillStyle <- createStyle(fontSize = 12, fontColour = "black",
                           halign = "center", valign = "center", fgFill = "mistyrose", 
                           border = "TopBottomLeftRight", borderColour = "black",
                           textDecoration = "bold", wrapText = TRUE)
  BlankStyle <- createStyle(fontColour = "red",
                            valign = "center", fgFill = "mistyrose", borderColour = "red",
                            textDecoration = "bold")
  headerStyle <- createStyle(fontSize = 12, fontColour = "black",
                             halign = "center", valign = "center", fgFill = "grey", 
                             border = "TopBottomLeftRight", borderColour = "black",
                             textDecoration = "bold", wrapText = TRUE)
  addStyle(template, sheet = j, fillStyle, rows = 1:nrow(var_data_area), cols=7, 
           gridExpand = TRUE)
  addStyle(template, sheet = j, headerStyle, rows = 1, cols=1:8, 
           gridExpand = TRUE)
  addStyle(template, sheet = j, BlankStyle, rows = which(is.na(var_data_area$value))+1, cols=1:8, 
           gridExpand = TRUE)
  
  
  
  
}#

