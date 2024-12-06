#----------------------------------------------------------------------------------------
# Function to extract the data at for each juridiction and formate if for the data call--
#----------------------------------------------------------------------------------------

source("R/functions_building_templates.R")

#####
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="sirs.agrocampus-ouest.fr", user="salmoglob_admin", password="salmo123!", dbname="salmoglob")
database<-dbReadTable(con,"database")
tab_type_object<-dbReadTable(con,"metadata")
dbDisconnect(con)
#####
constnimb<-get(load("exchange_plateform/Nimble_input/Const_nimble.RData"))
datanimb<-get(load("exchange_plateform/Nimble_input/Data_nimble.RData"))

str(constnimb)

str(datanimb)

#----------------------------
#---- Region specific -------
#----------------------------

#i<-1

# SU<-"Ireland"

SU_id<-tab_labels[which(tab_labels$su_name==SU),"su_nb"]

SU_template<-createWorkbook()

for (i in 1:length(datanimb)){
  produce_template_SU_it(datanimb, metadata, SU_template, i)
}

for (i in 1:length(constnimb)){
  produce_template_SU_it(constnimb, metadata, SU_template, i)
}

worksheetOrder(SU_template)<-order(sheets(SU_template))
worksheetOrder(SU_template)<-order(sapply(sheets(SU_template), function (x) metadata$type[which(metadata$var_mod==x)]))

#produce_template_SU_it<-function(sub, metadata, tab_labels, SU_id, template, i)
addWorksheet(wb=template, sheetName = names(sub[i]))
writeData(template, sheet = j, retrieve, startRow = 1, startCol = 1, colNames = TRUE, rowNames = TRUE)

saveWorkbook(SU_template, "test_template_kiki.xlsx", overwrite = TRUE)



#----------------------------
#---- Fisheries -------
#----------------------------


Fishery<-"GLD fishery"

var_fish_data<-which(names(datanimb)%in%metadata$var_mod[which(metadata$fishery==Fishery & metadata$var_mod%in%unique(names(datanimb)))])
var_fish_const<-which(names(constnimb)%in%metadata$var_mod[which(metadata$fishery==Fishery & metadata$var_mod%in%unique(names(constnimb)))])

fish_template<-createWorkbook()

for(i in var_fish_data){
  
  #addWorksheet(wb=template, sheetName = names(sub[i]))
  produce_template_fishery_it(datanimb, metadata, tab_labels, fish_template, i)
}

for(i in var_fish_const){
  produce_template_fishery_it(constnimb, metadata, tab_labels, fish_template, i)
}







