#################################################
#################################################
### Updating the database regarding SEX SEX SEX & SEX
#################################################
#################################################


Const_Remi<-get(load("data/datapatin/Const_nimble.RData"))

Const_current<-get(load("exchange_plateform/Nimble_input/Const_nimble.RData"))

names(Const_Remi)
names(Const_current)

names(Const_Remi)[!names(Const_Remi)%in%names(Const_current)]
names(Const_current)[!names(Const_current)%in%names(Const_Remi)]

"prop_female"
"log_C6_sd"
"log_C9_sd"
"log_C6_sup_sd"
"log_C9_sup_sd"
"log_C6_delSp_sd"
"log_C9_delSp_sd"

Const_Remi[["prop_female"]]
Const_Remi[["log_C6_sd"]]
Const_Remi[["log_C9_sd"]]
Const_Remi[["log_C6_sup_sd"]]
Const_Remi[["log_C9_sup_sd"]]
Const_Remi[["log_C6_delSp_sd"]]
Const_Remi[["log_C9_delSp_sd"]]

######################################################"
#######################################################

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="sirs.agrocampus-ouest.fr", user="salmoglob_admin", password="salmo123!", dbname="salmoglob")
dbListObjects(con)

database<-dbReadTable(con,"database")
database_archive<-dbReadTable(con,"database_archive")
metadata<-dbReadTable(con,"metadata")
tablab<-dbReadTable(con,"area_labels")

# prop female
head(metadata)

dfblank<-metadata[1,]
dffemale<-dfC6_sd<-dfC9_sd<-dfC6_sup_sd<-dfC9_sup_sd<-dfC6_delSp_sd<-dfC9_delSp_sd<-dfblank


dffemale<-c("prop_female", "array", 2, 25, 47, "Age sea winter", "Stock unit","Year",
            "Const_nimble","Fit","Sex ratio","_",
            "_","Mean","parameter_constant","River","Spawners","Multiple","Multiple","Proportion of females for all years in all SUs")

dfC6_sd<-c("log_C6_sd", "matrix", 47, 25, NA, "Year", "Stock unit","",
           "Const_nimble","Fit","Homewater catches","_",
           "_","Standard deviation","parameter_constant","River","Spawners","Multiple","1SW","Standard deviation of homewater catches of 1SW returns")

dfC9_sd<-c("log_C9_sd", "matrix", 47, 25, NA, "Year", "Stock unit","",
           "Const_nimble","Fit","Homewater catches","_",
           "_","Standard deviation","parameter_constant","River","Spawners","Multiple","2SW","Standard deviation of homewater catches of 2SW returns")

dfC6_sup_sd<-c("log_C6_sup_sd", "matrix", 47, 25, NA, "Year", "Stock unit","",
               "Const_nimble","Fit","Homewater catches","_",
               "_","Standard deviation","parameter_constant","River","Spawners","Multiple","1SW","Standard deviation of supplementary homewater catches of 1SW returns")

dfC9_sup_sd<-c("log_C9_sup_sd", "matrix", 47, 25, NA, "Year", "Stock unit","",
               "Const_nimble","Fit","Homewater catches","_",
               "_","Standard deviation","parameter_constant","River","Spawners","Multiple","2SW","Standard deviation of supplementary homewater catches of 2SW returns")

dfC6_delSp_sd<-c("log_C6_delSp_sd", "matrix", 47, 25, NA, "Year", "Stock unit","",
                 "Const_nimble","Fit","Homewater catches","_",
                 "_","Standard deviation","parameter_constant","River","Spawners","Multiple","1SW","Standard deviation of homewaters catches of 1SW delayed spawners")

dfC9_delSp_sd<-c("log_C9_delSp_sd", "matrix", 47, 25, NA, "Year", "Stock unit","",
                 "Const_nimble","Fit","Homewater catches","_",
                 "_","Standard deviation","parameter_constant","River","Spawners","Multiple","2SW","Standard deviation of homewaters catches of 2SW delayed spawners")

meta_to_add<-rbind.data.frame(dffemale, dfC6_sd, dfC9_sd, dfC6_sup_sd, dfC9_sup_sd, dfC6_delSp_sd, dfC9_delSp_sd)
colnames(meta_to_add)<-colnames(metadata)

tab_meta_new<-rbind.data.frame(metadata,meta_to_add)

##############################################################################################################
##############################################################################################################

source("R/convert_from_wide_to_long.R")

n_const_nimble <- length(Const_Remi)

Year <- seq(1971, 2017)
SU_ab<-tablab$su_ab
sea_winter_age <- c("1SW","2SW")

Const_Remi_sub<-subset(Const_Remi,names(Const_Remi)%in%c("prop_female",
                                                         "log_C6_sd",
                                                         "log_C9_sd",
                                                         "log_C6_sup_sd",
                                                         "log_C9_sup_sd",
                                                         "log_C6_delSp_sd",
                                                         "log_C9_delSp_sd"))

n_const_nimble <- length(Const_Remi_sub)

base_const_list <- lapply(1:n_const_nimble, function(i_){
  cat(names(Const_Remi_sub[i_]))
  function_list_database(Const_Remi_sub[i_])}
)

add_to_database <- do.call('rbind', base_const_list)

###########################################################################

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="sirs.agrocampus-ouest.fr", user="salmoglob_admin", password="salmo123!", dbname="salmoglob")

dbListObjects(con)

database<-dbReadTable(con,"database")
database_archive<-dbReadTable(con,"database_archive")
metadata<-dbReadTable(con,"metadata")
tablab<-dbReadTable(con,"area_labels")

head(database)
head(add_to_database)
date_time<-Sys.time()

add_to_database_ready<-cbind.data.frame(version=1,add_to_database,date_time)
head(add_to_database_ready)

is(database$version)
is(add_to_database_ready$version)
is(database$year)
is(add_to_database_ready$year)
add_to_database_ready$year<-as.numeric(add_to_database_ready$year)
is(database$type)
is(add_to_database_ready$type)
is(database$age)
is(add_to_database_ready$age)
is(database$area)
is(add_to_database_ready$area)
is(database$location)
is(add_to_database_ready$location)
is(database$metric)
is(add_to_database_ready$metric)
is(database$value)
is(add_to_database_ready$value)
is(database$var_mod)
is(add_to_database_ready$var_mod)
is(database$date_time)
is(add_to_database_ready$date_time)


database_new <- rbind.data.frame(database, add_to_database_ready)

head(database_archive)

add_to_database_archive_ready <- add_to_database_ready

add_to_database_archive_ready <- cbind.data.frame(add_to_database_archive_ready, name="HERNVANN", firstname="Pierre-Yves", institute="AGROCAMPUS OUEST", email="pierre.yves.hernvann@gmail.com")

add_to_database_archive_ready <- add_to_database_archive_ready[,c("version", "year", "type", "age", "area", "location", "metric", "value", "var_mod", "name", "firstname", "institute", "email", "date_time")]


database_arch_new <- rbind.data.frame(database_archive, add_to_database_archive_ready)

head(database_arch_new)


lapply(seq(1,ncol(metadata)), function(x){is(metadata[,x])})
lapply(seq(1,ncol(tab_meta_new)), function(x){is(tab_meta_new[,x])})
tab_meta_new[,3] <- as.numeric(tab_meta_new[,3])
tab_meta_new[,4] <- as.numeric(tab_meta_new[,4])
tab_meta_new[,5] <- as.numeric(tab_meta_new[,5])


head(dbReadTable(con,"database"))
dbExecute(con, "drop table database")
dbWriteTable(con, "database", database_new, row.names=F)
head(dbReadTable(con,"database"))

head(dbReadTable(con,"database_archive"))
dbExecute(con, "drop table database_archive")
dbWriteTable(con, "database_archive", database_arch_new,row.names=F)
head(dbReadTable(con,"database_archive"))


head(dbReadTable(con,"metadata"))
dbExecute(con, "drop table metadata")
dbWriteTable(con, "metadata", tab_meta_new,row.names=F)
head(dbReadTable(con,"metadata"))


############################################
#############################################


drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="sirs.agrocampus-ouest.fr", user="salmoglob_admin", password="salmo123!", dbname="salmoglob")

dbListObjects(con)

database<-dbReadTable(con,"database")
database_archive<-dbReadTable(con,"database_archive")
metadata<-dbReadTable(con,"metadata")

database$type[database$var_mod=="max_log_N9"] <- "Initialization first year"
database_archive$type[database_archive$var_mod=="max_log_N9"] <- "Initialization first year"
metadata$type[metadata$var_mod=="max_log_N9"] <- "Initialization first year"

database$type[database$var_mod=="min_log_N9"] <- "Initialization first year"
database_archive$type[database_archive$var_mod=="min_log_N9"] <- "Initialization first year"
metadata$type[metadata$var_mod=="min_log_N9"] <- "Initialization first year"


head(dbReadTable(con,"database"))
dbExecute(con, "drop table database")
dbWriteTable(con, "database", database, row.names=F)
head(dbReadTable(con,"database"))

#dbCreateTable(con, "database_archive", database_archive)
head(dbReadTable(con,"database_archive"))
dbExecute(con, "drop table database_archive")
dbWriteTable(con, "database_archive", database_archive,row.names=F)
head(dbReadTable(con,"database_archive"))


head(dbReadTable(con,"metadata"))
dbExecute(con, "drop table metadata")
dbWriteTable(con, "metadata", metadata,row.names=F)
head(dbReadTable(con,"metadata"))

#####################################################################
####################################################################

# JUST IN CASE

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="sirs.agrocampus-ouest.fr", user="salmoglob_admin", password="salmo123!", dbname="salmoglob")

dbListObjects(con)

database<-dbReadTable(con,"database")
database_archive<-dbReadTable(con,"database_archive")
metadata<-dbReadTable(con,"metadata")

tosave<-list(database,database_archive,metadata)
names(tosave) <-c("database","database_archive","metadata")

save(tosave,file="data/database_version_16.03.21.RData")


###############################################################################

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="sirs.agrocampus-ouest.fr", user="salmoglob_admin", password="salmo123!", dbname="salmoglob")

dbListObjects(con)

check_database_tests<-dbReadTable(con,"database_test")
check_database_archive_tests<-dbReadTable(con,"database_archive_test")

View(check_database_tests)
View(check_database_archive_tests)
View(database_archive)

check_database_tests[1,2]<-"kikou"
DBI::dbWriteTable(con, "database_test", check_database_tests, overwrite = TRUE, row.names=F)
check_database_tests<-dbReadTable(con,"database_test")
head(check_database_tests)
nrow(check_database_archive_tests)
10115832-10160591
nrow(database_archive)


################################################################
################################################################

# Correcting the problems regarding order of SUs in min/max log_N9


source("R/convert_from_wide_to_long.R")

current_Nimble <- readRDS("exchange_plateform/Nimble_input/Const_nimble.rds")

n_const_nimble <- length(current_Nimble)

Year <- seq(1971, 2017)
SU_ab<-tablab$su_ab
sea_winter_age <- c("1SW","2SW")

current_Nimble_sub<-subset(current_Nimble,names(current_Nimble)%in%c("min_log_N9",
                                                         "max_log_N9"))

newmin <- readRDS("data/min_log_N9.rds")
newmax <- readRDS("data/max_log_N9.rds")
newmax-newmin

current_Nimble_sub[["min_log_N9"]] <- newmin
current_Nimble_sub[["max_log_N9"]] <- newmax

n_const_nimble <- length(current_Nimble_sub)

minmax_list <- lapply(1:n_const_nimble, function(i_){
  cat(names(current_Nimble_sub[i_]))
  function_list_database(current_Nimble_sub[i_])}
)

add_to_database <- do.call('rbind', minmax_list)

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="sirs.agrocampus-ouest.fr", user="salmoglob_admin", password="salmo123!", dbname="salmoglob")

dbListObjects(con)

database<-dbReadTable(con,"database")
database_archive<-dbReadTable(con,"database_archive")
metadata<-dbReadTable(con,"metadata")
#tablab<-dbReadTable(con,"area_labels")

database<-subset(database, !database$var_mod%in%c("min_log_N9","max_log_N9"))
database_archive<-subset(database_archive, !database_archive$var_mod%in%c("min_log_N9","max_log_N9"))

date_time<-Sys.time()

add_to_database_ready<-cbind.data.frame(version=1,add_to_database,date_time)
head(add_to_database_ready)

is(database$version)
is(add_to_database_ready$version)
is(database$year)
is(add_to_database_ready$year)
add_to_database_ready$year<-as.numeric(add_to_database_ready$year)
is(database$type)
is(add_to_database_ready$type)
is(database$age)
is(add_to_database_ready$age)
is(database$area)
is(add_to_database_ready$area)
is(database$location)
is(add_to_database_ready$location)
is(database$metric)
is(add_to_database_ready$metric)
is(database$value)
is(add_to_database_ready$value)
is(database$var_mod)
is(add_to_database_ready$var_mod)
is(database$date_time)
is(add_to_database_ready$date_time)


database_new <- rbind.data.frame(database, add_to_database_ready)
View(database_new)
View(database_archive)

add_to_database_archive_ready <- add_to_database_ready

add_to_database_archive_ready <- cbind.data.frame(add_to_database_archive_ready, name="HERNVANN", firstname="Pierre-Yves", institute="AGROCAMPUS OUEST", email="pierre.yves.hernvann@gmail.com")

add_to_database_archive_ready <- add_to_database_archive_ready[,c("version", "year", "type", "age", "area", "location", "metric", "value", "var_mod", "name", "firstname", "institute", "email", "date_time")]


database_arch_new <- rbind.data.frame(database_archive, add_to_database_archive_ready)

head(database_arch_new)


lapply(seq(1,ncol(metadata)), function(x){is(metadata[,x])})
#lapply(seq(1,ncol(tab_meta_new)), function(x){is(tab_meta_new[,x])})
#tab_meta_new[,3] <- as.numeric(tab_meta_new[,3])
#tab_meta_new[,4] <- as.numeric(tab_meta_new[,4])
#tab_meta_new[,5] <- as.numeric(tab_meta_new[,5])

head(dbReadTable(con,"database"))
dbExecute(con, "drop table database")
dbWriteTable(con, "database", database_new, row.names=F)
head(dbReadTable(con,"database"))

head(dbReadTable(con,"database_archive"))
dbExecute(con, "drop table database_archive")
dbWriteTable(con, "database_archive", database_arch_new,row.names=F)
head(dbReadTable(con,"database_archive"))

source('R/store_Nimble_objects.R') 


#####################################################################
####################################################################

# JUST IN CASE

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="sirs.agrocampus-ouest.fr", user="salmoglob_admin", password="salmo123!", dbname="salmoglob")

dbListObjects(con)

database<-dbReadTable(con,"database")
database_archive<-dbReadTable(con,"database_archive")
metadata<-dbReadTable(con,"metadata")

tosave<-list(database,database_archive,metadata)
names(tosave) <-c("database","database_archive","metadata")

save(tosave,file="data/database_version_23.03.21.RData")

labtab<-dbReadTable(con,"area_labels")


database$area[database$area=="NI_FO"]<-"NI.FO"
database$area[database$area=="NI_FB"]<-"NI.FB"
database$area[database$area=="SC_WE"]<-"SC.W"
database$area[database$area=="SC_EA"]<-"SC.E"
database$area[database$area=="IC_SW"]<-"IC.SW"
database$area[database$area=="IC_NE"]<-"IC.NE"
database$area[database$area=="NO_SE"]<-"NO.SE"
database$area[database$area=="NO_SW"]<-"NO.SW"
database$area[database$area=="NO_MI"]<-"NO.MI"
database$area[database$area=="NO_NO"]<-"NO.NO"
database$area[database$area=="RU_KB"]<-"RU.KB"
database$area[database$area=="RU_KW"]<-"RU.KW"
database$area[database$area=="RU_AK"]<-"RU.AK"
database$area[database$area=="RU_RP"]<-"RU.RP"

database_archive$area[database_archive$area=="NI_FO"]<-"NI.FO"
database_archive$area[database_archive$area=="NI_FB"]<-"NI.FB"
database_archive$area[database_archive$area=="SC_WE"]<-"SC.W"
database_archive$area[database_archive$area=="SC_EA"]<-"SC.E"
database_archive$area[database_archive$area=="IC_SW"]<-"IC.SW"
database_archive$area[database_archive$area=="IC_NE"]<-"IC.NE"
database_archive$area[database_archive$area=="NO_SE"]<-"NO.SE"
database_archive$area[database_archive$area=="NO_SW"]<-"NO.SW"
database_archive$area[database_archive$area=="NO_MI"]<-"NO.MI"
database_archive$area[database_archive$area=="NO_NO"]<-"NO.NO"
database_archive$area[database_archive$area=="RU_KB"]<-"RU.KB"
database_archive$area[database_archive$area=="RU_KW"]<-"RU.KW"
database_archive$area[database_archive$area=="RU_AK"]<-"RU.AK"
database_archive$area[database_archive$area=="RU_RP"]<-"RU.RP"


tablab$su_ab[tablab$su_ab=="NI_FO"]<-"NI.FO"
tablab$su_ab[tablab$su_ab=="NI_FB"]<-"NI.FB"
tablab$su_ab[tablab$su_ab=="SC_WE"]<-"SC.W"
tablab$su_ab[tablab$su_ab=="SC_EA"]<-"SC.E"
tablab$su_ab[tablab$su_ab=="IC_SW"]<-"IC.SW"
tablab$su_ab[tablab$su_ab=="IC_NE"]<-"IC.NE"
tablab$su_ab[tablab$su_ab=="NO_SE"]<-"NO.SE"
tablab$su_ab[tablab$su_ab=="NO_SW"]<-"NO.SW"
tablab$su_ab[tablab$su_ab=="NO_MI"]<-"NO.MI"
tablab$su_ab[tablab$su_ab=="NO_NO"]<-"NO.NO"
tablab$su_ab[tablab$su_ab=="RU_KB"]<-"RU.KB"
tablab$su_ab[tablab$su_ab=="RU_KW"]<-"RU.KW"
tablab$su_ab[tablab$su_ab=="RU_AK"]<-"RU.AK"
tablab$su_ab[tablab$su_ab=="RU_RP"]<-"RU.RP"

head(dbReadTable(con,"database"))
dbExecute(con, "drop table database")
dbWriteTable(con, "database", database, row.names=F)
head(dbReadTable(con,"database"))

head(dbReadTable(con,"database_archive"))
dbExecute(con, "drop table database_archive")
dbWriteTable(con, "database_archive", database_archive,row.names=F)
head(dbReadTable(con,"database_archive"))

head(dbReadTable(con,"area_labels"))
dbExecute(con, "drop table area_labels")
dbWriteTable(con, "area_labels", tablab,row.names=F)
head(dbReadTable(con,"area_labels"))
###############################""""
#########################################################

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="sirs.agrocampus-ouest.fr", user="salmoglob_admin", password="salmo123!", dbname="salmoglob")

dbListObjects(con)

database<-dbReadTable(con,"database")
database_archive<-dbReadTable(con,"database_archive")
metadata<-dbReadTable(con,"metadata")

View(metadata)

metadata$dim1[metadata$dim1==58] <- 50

View(metadata)


head(dbReadTable(con,"metadata"))
dbExecute(con, "drop table metadata")
dbWriteTable(con, "metadata", metadata, row.names=F)
head(dbReadTable(con,"metadata"))








































































