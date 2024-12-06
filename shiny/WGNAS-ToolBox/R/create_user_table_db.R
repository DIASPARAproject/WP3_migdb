#######################################
##### Create a table for users
#######################################

library(RPostgreSQL)
library(DBI)
library(tidyverse)
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="sirs.agrocampus-ouest.fr", user="salmoglob_admin", password="salmo123!", dbname="salmoglob")
dbListTables(con)

users_table <-cbind.data.frame(1,
                 "HERNVANN","Pierre-Yves",
                 "Agrocampus Ouest","pierre.yves.hernvann@gmail.com",
                 "pyhernvann","S0m0nK8S0m0nCru","admin")

colnames(users_table)<-c("user_id","lastname","firstname","affiliation","contact","username","password","status")

lapply(users_table[,seq(2,8)], FUN=as.character)
users_table$user_id <- as.numeric(users_table$user_id)

dbWriteTable(con, "users", users_table,row.names=F)
dbListTables(con)
dbReadTable(con, "users")


#### ADD USERS

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="sirs.agrocampus-ouest.fr", user="salmoglob_admin", password="salmo123!", dbname="salmoglob")
dbListTables(con)
dbReadTable(con, "users")

etienne<-cbind.data.frame(2,"RIVOT","Etienne","Agrocampus Ouest","etienne.rivot@agrocampus-ouest.fr","erivot","B0lin0_Maggi","admin")
colnames(etienne)<-c("user_id","lastname","firstname","affiliation","contact","username","password","status")
DBI::dbWriteTable(con, "users", etienne, append = TRUE, overwrite = FALSE, row.names=F)


remi<-cbind.data.frame(3,"PATIN", "Rémi", "Agrocampus Ouest", "remi.patin@agrocampus-ouest.fr","rpatin","AR0ulettes!","admin")
colnames(remi)<-c("user_id","lastname","firstname","affiliation","contact","username","password","status")
DBI::dbWriteTable(con, "users", remi, append = TRUE, overwrite = FALSE, row.names=F)

dbReadTable(con, "users")
dbDisconnect(con)






