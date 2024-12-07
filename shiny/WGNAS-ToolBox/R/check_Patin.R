########## Check the dimensions of
########## Nimble object created
########## from the up-to-date DB

#-------------------------------------------------
# Check the format in operational nimble object-
#-------------------------------------------------

tik<-cbind.data.frame(names(get(load("data/Patin/Const_nimble_2020_10_23.RData"))),
                 unlist(lapply(get(load("data/Patin/Const_nimble_2020_10_23.RData")), FUN=function(x)ifelse(!is.null(dim(x)[1]),dim(x)[1],NA))),
                 unlist(lapply(get(load("data/Patin/Const_nimble_2020_10_23.RData")), FUN=function(x)ifelse(!is.null(dim(x)[2]),dim(x)[2],NA))),
                 unlist(lapply(get(load("data/Patin/Const_nimble_2020_10_23.RData")), FUN=function(x)ifelse(!is.null(dim(x)[3]),dim(x)[3],NA))),"Const")

tak<-cbind.data.frame(names(get(load("data/Patin/Data_nimble_2020_10_15.RData"))),
                 unlist(lapply(get(load("data/Patin/Data_nimble_2020_10_15.RData")), FUN=function(x)ifelse(!is.null(dim(x)[1]),dim(x)[1],NA))),
                 unlist(lapply(get(load("data/Patin/Data_nimble_2020_10_15.RData")), FUN=function(x)ifelse(!is.null(dim(x)[2]),dim(x)[2],NA))),
                 unlist(lapply(get(load("data/Patin/Data_nimble_2020_10_15.RData")), FUN=function(x)ifelse(!is.null(dim(x)[3]),dim(x)[3],NA))),"Data")

colnames(tik)<-colnames(tak)<-c("var","dim1","dim2","dim3", "type")

all_tiktak<-rbind.data.frame(tik, tak)

#-------------------------------------------------
# Load up-to-date database -
#-------------------------------------------------

#drv <- dbDriver("PostgreSQL")
#con <- dbConnect(drv, host="sirs.agrocampus-ouest.fr", user="salmoglob_admin", password="salmo123!", dbname="salmoglob")
con <- dbConnect(RPostgres::Postgres(), host="sirs.agrocampus-ouest.fr", user="salmoglob_admin", password="salmo123!", dbname="salmoglob")
database<-dbReadTable(con,"database")
database_archive<-dbReadTable(con,"database_archive")
tab_type_object<-dbReadTable(con,"metadata")
tab_labels<-dbReadTable(con,"area_labels")

#-------------------------------------------------
# Create nimble obkect from the up-to-date object-
#-------------------------------------------------

source("R/store_Nimble_objects.R")

tik_app<-cbind.data.frame(names(get(load("exchange_plateform/Nimble_input/Const_nimble.RData"))),
                      unlist(lapply(get(load("exchange_plateform/Nimble_input/Const_nimble.RData")), FUN=function(x)ifelse(!is.null(dim(x)[1]),dim(x)[1],NA))),
                      unlist(lapply(get(load("exchange_plateform/Nimble_input/Const_nimble.RData")), FUN=function(x)ifelse(!is.null(dim(x)[2]),dim(x)[2],NA))),
                      unlist(lapply(get(load("exchange_plateform/Nimble_input/Const_nimble.RData")), FUN=function(x)ifelse(!is.null(dim(x)[3]),dim(x)[3],NA))),"Const")

tak_app<-cbind.data.frame(names(get(load("exchange_plateform/Nimble_input/Data_nimble.RData"))),
                      unlist(lapply(get(load("exchange_plateform/Nimble_input/Data_nimble.RData")), FUN=function(x)ifelse(!is.null(dim(x)[1]),dim(x)[1],NA))),
                      unlist(lapply(get(load("exchange_plateform/Nimble_input/Data_nimble.RData")), FUN=function(x)ifelse(!is.null(dim(x)[2]),dim(x)[2],NA))),
                      unlist(lapply(get(load("exchange_plateform/Nimble_input/Data_nimble.RData")), FUN=function(x)ifelse(!is.null(dim(x)[3]),dim(x)[3],NA))),"Data")

colnames(tik_app)<-colnames(tak_app)<-c("var","dim1","dim2","dim3", "type")

all_tiktak_app<-rbind.data.frame(tik_app, tak_app)

#-------------------------------------------------
# Comparison -
#-------------------------------------------------


all_tiktak_app[all_tiktak_app$type=="Data",]
nrow(all_tiktak_app[all_tiktak_app$type=="Data",])
all_tiktak[all_tiktak$type=="Data",]
nrow(all_tiktak[all_tiktak$type=="Data",])

all_tiktak_app[all_tiktak_app$type=="Const",]
nrow(all_tiktak_app[all_tiktak_app$type=="Const",])
all_tiktak[all_tiktak$type=="Const",]
View(all_tiktak[all_tiktak$type=="Const",])
nrow(all_tiktak[all_tiktak$type=="Const",])


all_tiktak[all_tiktak$type=="Const","var"][which(!all_tiktak[all_tiktak$type=="Const","var"]%in%all_tiktak_app[all_tiktak_app$type=="Const","var"])]

all_tiktak_app[all_tiktak_app$type=="Const","var"][which(!all_tiktak_app[all_tiktak_app$type=="Const","var"]%in%all_tiktak[all_tiktak$type=="Const","var"])]


updateConst<-get(load("exchange_plateform/Nimble_input/Const_nimble.RData"))

updateConst<-updateConst[names(updateConst)!="omega"]
nam<-names(updateConst)
updateConst<-c(updateConst,list(diag(25)))
names(updateConst)[length(updateConst)]<-"omega"

egg<-updateConst["eggs"]
egg<-as.array(unlist(egg), dim = c(47,2,25))
dim(egg)
str(egg)
egg[1,1,1]

save(updateConst,file="exchange_plateform/Nimble_input/Const_nimble.RData")






newegg<-array(NA,dim = c(2,25,47))

dim(egg)
egg[1,1:2,1:47]


array(NA,dim = c(2,25,47))













