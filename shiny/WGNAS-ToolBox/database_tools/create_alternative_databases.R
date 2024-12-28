load("data/database.RData")

head(database)

database_initial<-database_archive<-database

date<-Sys.Date()
heure<-Sys.time()

database<-cbind.data.frame(database,date,heure)
database_archive<-cbind.data.frame(database_archive, "HERNVANN","Pierre-Yves","AGROCAMPUS OUEST","pierre.yves.hernvann@gmail.com",date,heure)

colnames(database)<-c(colnames(database_initial),"date","time")
colnames(database_archive)<-c(colnames(database_initial),"name","firstname","institute","email","date","time")

head(database_initial)
save(database_initial,file="data/database_initial.RData")
head(database)
save(database,file="data/database.RData")
head(database_archive)
save(database_archive,file="data/database_archive.RData")

database_archive[,1]<-as.numeric(database_archive[,1])
database_archive[,2]<-as.character(database_archive[,2])
database_archive[,3]<-as.character(database_archive[,3])
database_archive[,4]<-as.character(database_archive[,4])
database_archive[,5]<-as.character(database_archive[,5])
database_archive[,6]<-as.numeric(database_archive[,6])
database_archive[,7]<-as.character(database_archive[,7])
database_archive[,8]<-as.character(database_archive[,8])
database_archive[,9]<-as.character(database_archive[,9])
database_archive[,10]<-as.character(database_archive[,10])
database_archive[,11]<-as.character(database_archive[,11])
database_archive[,12]<-as.character(database_archive[,12])
database_archive[,13]<-as.character(database_archive[,13])
save(database_archive,file="data/database_archive.RData")

##### retrieve metadata
#load('~/salmon_proj/database.RData')
#save(tab_type_object, file="data/metadata.RData")

####
all_salmo_objects<-list(database, database_archive, database_initial, tab_type_object)
names(all_salmo_objects)<-c("database","database_archive","database_initial","metadata")
save(all_salmo_objects,file="data/salmo_database.RData")

####
#load('data/metadata.Rdata')
#load('data/database_initial.Rdata')
#load('data/database_archive.Rdata')
#load('data/database.Rdata')

save(database, database_archive,
     database_initial, tab_type_object,
     file="data/salmo_database.RData")
load("data/salmo_database.RData")

###
load("data/salmo_database.RData")
database<-cbind.data.frame(1,database)
database_archive<-cbind.data.frame(1,database_archive)
colnames(database)[1]<-colnames(database_archive)[1]<-"version"
save(database, database_archive,
     database_initial, tab_type_object,
     file="data/salmo_database.RData")


load("data/salmo_database.RData")
database$version<-as.character(database$version)
database_archive$version<-as.character(database_archive$version)
save(database, database_archive,
     database_initial, tab_type_object,
     file="data/salmo_database.RData")

#######
load("data/salmo_database.RData")
database_archive$date<-as.Date(database_archive$date)
database_archive$time<-as.POSIXct(database_archive$time)
save(database, database_archive,
     database_initial, tab_type_object,
     file="data/salmo_database.RData")


#######
load("data/salmo_database.RData")
x<-load("data/salmo_database.RData")
str(database)
str(database_archive)
str(database_initial)
str(tab_type_object)

database$ZONE<-as.character(database$ZONE)
database$Year<-as.numeric(database$Year)

resave(object=database,file="data/salmo_database.RData")

load("data/salmo_database.RData")
str(database)
str(database_archive)

###save(database,
   ###  file = file.path("/home/hernvann/WGNAS-ToolBox/data", "database.RData"))

###save(database_archive,
   ###  file = file.path("/home/hernvann/WGNAS-ToolBox/data", "database_archive.RData"))

##################################
##################################
##################################
load("data/database.RData")
load("data/database_archive.RData")
load("data/database_initial.RData")
load("data/metadata.RData")
all_salmo_objects<-list(database, database_archive, database_initial, tab_type_object)
names(all_salmo_objects)<-c("database","database_archive","database_initial","metadata")
save(all_salmo_objects,file="data/salmo_database.RData")



