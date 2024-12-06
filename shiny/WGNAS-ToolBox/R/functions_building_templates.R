#------------------------------------
# Defining the function for SU -----
#------------------------------------
produce_template_SU_it<-function(sub, metadata, tab_labels, SU_id, template, i){
  
  datanimb<-readRDS("exchange_plateform/Nimble_input/Data_nimble.rds")
  constnimb<-readRDS("exchange_plateform/Nimble_input/Const_nimble.rds")
  
  var_in_meta<-which(metadata$var_mod==names(sub[i]))
  
  typename<-metadata$type[var_in_meta]
  agename<-metadata$ages[var_in_meta]
  fisheryname<-ifelse(metadata$fishery[var_in_meta]=="","",metadata$fishery[var_in_meta])
  
  nd1<-metadata$name_dim1[var_in_meta]
  nd2<-metadata$name_dim2[var_in_meta]
  nd3<-metadata$name_dim3[var_in_meta]
  
  dim_stock<-ifelse(TRUE%in%grepl("Stock unit", c(nd1,nd2,nd3)),which(grepl("Stock unit", c(nd1,nd2,nd3))),0)
  
  NECNAC_id<-ifelse(grepl("NEC",metadata[var_in_meta,paste0("name_dim",dim_stock)]),
                    SU_id-as.numeric(constnimb["N_NAC"]), SU_id)
  
  if(length(unique(grepl("Stock unit", c(nd1,nd2,nd3))))>1 & dim_stock!=1){
    
    if(metadata$var_mod[var_in_meta]!="omega" &
       grepl("_pr",metadata$var_mod[var_in_meta])==F &
       grepl("p_C",metadata$var_mod[var_in_meta])==F){
      
      dim_obj <- length(dim(sub[[i]]))
      
      if(dim_obj==2){
        
        retrieve<-as.data.frame(c(sub[[i]][,NECNAC_id],NA))
        rownames(retrieve)<-as.character(seq(1970+as.numeric(constnimb["date_begin"]),1971+as.numeric(constnimb["date_end"])))
        colnames(retrieve)<-"value"
      }
      
     if(dim_obj==3){
        
        if(metadata$var_mod[var_in_meta]%in%c("eggs", "prop_female")){
          
          retrieve<-as.data.frame(cbind(sub[[i]][,NECNAC_id,],NA))
          colnames(retrieve)<-as.character(seq(1970+as.numeric(constnimb["date_begin"]),1971+as.numeric(constnimb["date_end"])))
          rownames(retrieve)<-c("1SW","2SW")
          
        }else{
          
          retrieve<-as.data.frame(rbind(sub[[i]][,,NECNAC_id],NA))
          rownames(retrieve)<-as.character(seq(1970+as.numeric(constnimb["date_begin"]),1971+as.numeric(constnimb["date_end"])))
          colnames(retrieve)<-c("1FW","2FW","3FW","4FW","5FW","6FW")
          
        }
        
        
      }
      
      j<-length(sheets(template))+1
      
      addWorksheet(wb=template, sheetName = names(sub[i]))
      writeData(template, sheet = j, retrieve, startRow = 1, startCol = 1, colNames = TRUE, rowNames = TRUE)
      
    }
    
  }

}


#-------------------------------------
# Defining the function for fisheries-
#-------------------------------------


produce_template_fishery_it<-function(sub, metadata, tab_labels, template, i){
  
    datanimb<-get(load("exchange_plateform/Nimble_input/Data_nimble.rds"))
  constnimb<-get(load("exchange_plateform/Nimble_input/Const_nimble.rds"))
  
  var_in_meta<-which(metadata$var_mod==names(sub[i]))
  
  nd1<-metadata$name_dim1[var_in_meta]
  nd2<-metadata$name_dim2[var_in_meta]
  nd3<-metadata$name_dim3[var_in_meta]
  
  dim_obj<-ncol(as.data.frame(as.matrix(sub[[i]])))
  
  if(dim_obj==1){
    
    retrieve<-as.data.frame(c(sub[[i]],NA))
    rownames(retrieve)<-as.character(seq(1970+as.numeric(constnimb["date_begin"]),1971+as.numeric(constnimb["date_end"])))
    colnames(retrieve)<-"value"
  }
  
  if(dim_obj>1){
    
    
    if(grepl("NECNAC",names(sub[i]))){
            NECNAC_names <-c("NEC","NAC")
    }else{
      if(grepl("NEC",names(sub[i]))){
        NECNAC_names <- tab_labels$su_ab[seq((as.numeric(constnimb["N_NAC"])+1),as.numeric(constnimb["N"]))]
      }else{
        NECNAC_names <-tab_labels$su_ab[seq(1,as.numeric(constnimb["N_NAC"]))]
      }
    }
    
    retrieve<-as.data.frame(rbind(as.matrix(sub[[i]]),NA))
    rownames(retrieve)<-as.character(seq(1970+as.numeric(constnimb["date_begin"]),1971+as.numeric(constnimb["date_end"])))
    colnames(retrieve)<-NECNAC_names
    
  }
  
  j<-length(sheets(template))+1
  
  addWorksheet(wb=template, sheetName = names(sub[i]))
  writeData(template, sheet = j, retrieve, startRow = 1, startCol = 1, colNames = TRUE, rowNames = TRUE)
  
  
}#
























