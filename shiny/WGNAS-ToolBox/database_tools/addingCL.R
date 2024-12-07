#################################
#### Add conservation limits to the SalmoGlobDatabase
library(DBI)
library(RPostgreSQL)

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="sirs.agrocampus-ouest.fr", user="salmoglob_admin", password="salmo123!", dbname="salmoglob")

dbListObjects(con)

database<-dbReadTable(con,"database")
metadata<-dbReadTable(con,"metadata")
database_archive<-dbReadTable(con,"database_archive")

head(database)
head(database_archive)

CL_brut<-get(load("data/Data_CL.RData"))

add_CL_db<-cbind.data.frame(version=1,
                 year = "_",
                 age="_",
                 type = "Conservation limits",
                 area = paste("coun", c("Labrador","Newfoundland","Quebec","Gulf","Scotia Fundy","US","Iceland","Scotland","Northern Ireland",
                                 "Ireland","England_Wales","France","Iceland","Sweden","Norway","Finland","Russia"),sep="_"),
                 location = "_",
                 metric = "Mean",
                 value = get(load("data/Data_CL.RData")),
                 var_mod = "cons_lim",
                 date_time = Sys.time()
                 )
ncol(database)
ncol(add_CL_db)
rbind.data.frame(database, add_CL_db)

add_CL_meta<-cbind.data.frame(var_mod = "cons_lim",
                              type_object="vector",
                              dim1=17,
                              dim2=NA,
                              dim3=NA,
                              name_dim1="Countries",
                              name_dim2="",
                              name_dim3="",
                              nimble="other",
                              model_stage="other",
                              type="Conservation limits",
                              locations="_",
                              fishery="_",
                              metric="Mean",
                              status='other',
                              environment="River",
                              life_stage="Eggs",
                              complex="Multiple",
                              ages="Multiple",
                              definition="Conservation limits by country"
)
rbind.data.frame(metadata, add_CL_meta)

add_CL_dbarch<-cbind.data.frame(version=1,
                            year = "_",
                            type = "Conservation limits",
                            age = "_",
                            area = paste("coun", c("Labrador","Newfoundland","Quebec","Gulf","Scotia Fundy","US","Iceland","Scotland","Northern Ireland",
                                                   "Ireland","England_Wales","France","Iceland","Sweden","Norway","Finland","Russia"),sep="_"),
                            location = "_",
                            metric = "Mean",
                            value = get(load("data/Data_CL.RData")),
                            var_mod = "cons_lim",
                            name="HERNVANN",
                            firstname="Pierre-Yves",
                            institute="AGROCAMPUS OUEST",
                            email="pierre.yves.hernvann@gmail.com",
                            date_time = Sys.time()
)
head(database_archive)
head(add_CL_dbarch)
is(rbind.data.frame(database_archive, add_CL_dbarch)$type)


saveobj<-list(database,metadata,database_archive)
names(saveobj)<-c("database","metadata","database_archive")
save(saveobj, file="data/save_DB_21_11_03.RData")

database <- rbind.data.frame(database, add_CL_db)
metadata <- rbind.data.frame(metadata, add_CL_meta)
database_archive <- rbind.data.frame(database_archive, add_CL_dbarch)

head(dbReadTable(con,"metadata"))
dbExecute(con, "drop table metadata")
dbWriteTable(con, "metadata", metadata, row.names=F)
head(dbReadTable(con,"metadata"))

head(dbReadTable(con,"database"))
dbExecute(con, "drop table database")
dbWriteTable(con, "database", database, row.names=F)
head(dbReadTable(con,"database"))

head(dbReadTable(con,"database_archive"))
dbExecute(con, "drop table database_archive")
dbWriteTable(con, "database_archive", database_archive,row.names=F)
head(dbReadTable(con,"database_archive"))


#########################################################
#########################################################

database<-dbReadTable(con,"database")
database_archive<-dbReadTable(con,"database_archive")

database$year<-as.numeric(as.character(database$year))
database_archive$year<-as.numeric(as.character(database_archive$year))


head(dbReadTable(con,"database"))
dbExecute(con, "drop table database")
dbWriteTable(con, "database", database, row.names=F)
head(dbReadTable(con,"database"))

head(dbReadTable(con,"database_archive"))
dbExecute(con, "drop table database_archive")
dbWriteTable(con, "database_archive", database_archive,row.names=F)
head(dbReadTable(con,"database_archive"))

#########################################################
#########################################################
#########################################################
#########################################################


library(DBI)
library(RPostgreSQL)

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="sirs.agrocampus-ouest.fr", user="salmoglob_admin", password="salmo123!", dbname="salmoglob")

dbListObjects(con)

database<-dbReadTable(con,"database")
metadata<-dbReadTable(con,"metadata")
database_archive<-dbReadTable(con,"database_archive")

head(database)
head(database_archive)


stockgoodformat <- subset(database, database$var_mod=="cons_lim" & database$date_time=="2021-03-11 10:19:33 CET")
stockgoodformat_arch <- subset(database_archive, database_archive$var_mod=="cons_lim" & database_archive$date_time=="2021-03-11 10:23:40 CET")


database_corrected <- subset(database, database$var_mod!="cons_lim")
database_archive_corrected <- subset(database_archive, database_archive$var_mod!="cons_lim")

stockgoodformat$area[stockgoodformat$area=="coun_Iceland"][1] <- "coun_Iceland_SW"
stockgoodformat$area[stockgoodformat$area=="coun_Iceland"] <- "coun_Iceland_NE"

stockgoodformat$value[stockgoodformat$area=="coun_Labrador"] <- 243660000
stockgoodformat$value[stockgoodformat$area=="coun_Newfoundland"] <- 267780000
stockgoodformat$value[stockgoodformat$area=="coun_Quebec"] <- 50380000
stockgoodformat$value[stockgoodformat$area=="coun_Gulf"] <- 248680000
stockgoodformat$value[stockgoodformat$area=="coun_Scotia Fundy"] <- 224140000
stockgoodformat$value[stockgoodformat$area=="coun_US"] <- 435369000
stockgoodformat$value[stockgoodformat$area=="coun_Iceland_SW"] <- 51693269
stockgoodformat$value[stockgoodformat$area=="coun_Iceland_NE"] <- 23889096
stockgoodformat$value[stockgoodformat$area=="coun_Scotland"] <- 561073322
stockgoodformat$value[stockgoodformat$area=="coun_Northern Ireland"] <- 93800000
stockgoodformat$area[stockgoodformat$area=="coun_Northern Ireland"] <- "coun_Northern_Ireland"
stockgoodformat$value[stockgoodformat$area=="coun_Ireland"] <- 710711690
stockgoodformat$value[stockgoodformat$area=="coun_England_Wales"] <- 209010700
stockgoodformat$value[stockgoodformat$area=="coun_France"] <- 55156800
stockgoodformat$value[stockgoodformat$area=="coun_Sweden"] <- 13997100
stockgoodformat$value[stockgoodformat$area=="coun_Norway"] <- 444064979.75
stockgoodformat$value[stockgoodformat$area=="coun_Finland"] <- 104278220
stockgoodformat$value[stockgoodformat$area=="coun_Russia"] <- 357856550


stockgoodformat_arch$area[stockgoodformat_arch$area=="coun_Iceland"][1] <- "coun_Iceland_SW"
stockgoodformat_arch$area[stockgoodformat_arch$area=="coun_Iceland"] <- "coun_Iceland_NE"

stockgoodformat_arch$value[stockgoodformat_arch$area=="coun_Labrador"] <- 243660000
stockgoodformat_arch$value[stockgoodformat_arch$area=="coun_Newfoundland"] <- 267780000
stockgoodformat_arch$value[stockgoodformat_arch$area=="coun_Quebec"] <- 50380000
stockgoodformat_arch$value[stockgoodformat_arch$area=="coun_Gulf"] <- 248680000
stockgoodformat_arch$value[stockgoodformat_arch$area=="coun_Scotia Fundy"] <- 224140000
stockgoodformat_arch$value[stockgoodformat_arch$area=="coun_US"] <- 435369000
stockgoodformat_arch$value[stockgoodformat_arch$area=="coun_Iceland_SW"] <- 51693269
stockgoodformat_arch$value[stockgoodformat_arch$area=="coun_Iceland_NE"] <- 23889096
stockgoodformat_arch$value[stockgoodformat_arch$area=="coun_Scotland"] <- 561073322
stockgoodformat_arch$value[stockgoodformat_arch$area=="coun_Northern Ireland"] <- 93800000
stockgoodformat_arch$area[stockgoodformat_arch$area=="coun_Northern Ireland"] <- "coun_Northern_Ireland"
stockgoodformat_arch$value[stockgoodformat_arch$area=="coun_Ireland"] <- 710711690
stockgoodformat_arch$value[stockgoodformat_arch$area=="coun_England_Wales"] <- 209010700
stockgoodformat_arch$value[stockgoodformat_arch$area=="coun_France"] <- 55156800
stockgoodformat_arch$value[stockgoodformat_arch$area=="coun_Sweden"] <- 13997100
stockgoodformat_arch$value[stockgoodformat_arch$area=="coun_Norway"] <- 444064979.75
stockgoodformat_arch$value[stockgoodformat_arch$area=="coun_Finland"] <- 104278220
stockgoodformat_arch$value[stockgoodformat_arch$area=="coun_Russia"] <- 357856550



database_corrected  <- rbind.data.frame(database_corrected, stockgoodformat)
database_archive_corrected  <- rbind.data.frame(database_archive_corrected, stockgoodformat_arch)


#head(dbReadTable(con,"database"))
#dbExecute(con, "drop table database")
#dbWriteTable(con, "database", database_corrected, row.names=F)
#head(dbReadTable(con,"database"))
#
#head(dbReadTable(con,"database_archive"))
#dbExecute(con, "drop table database_archive")
#dbWriteTable(con, "database_archive", database_archive_corrected,row.names=F)
#head(dbReadTable(con,"database_archive"))













