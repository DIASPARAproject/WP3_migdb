# Load the required versions for converting the database into Nimble objects
source('R/from_df_to_Nimble.R')

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="sirs.agrocampus-ouest.fr", user="salmoglob_admin", password="salmo123!", dbname="salmoglob")

database_utd<-dbReadTable(con,"database")
tab_type_object_utd<-dbReadTable(con,"metadata")


#database_utd$value[database_utd$var_mod=="date_begin"]
database_utd$value[database_utd$var_mod=="date_end"] <- max(database_utd$year, na.rm=T)-1970
database_utd$value[database_utd$var_mod=="date_end_hindcast"] <- max(database_utd$year, na.rm=T)-1970

# Here we load the function check_function that may be usefull to automatically correct some values that may be present in the database
#but would lead to problems when running the model on it. This is notably where are set to 0.05 the values of log_N6/9_sd when they are lower
#than 0.05
source("R/check_database_for_Nimble.R")
database_checked <- check_function(database_utd)

tab_label <- dbReadTable(con,"area_labels")
nimble_objects <- create_nimble_objects(database_checked, tab_type_object_utd, tab_label)


Data_nimble <- nimble_objects$Data_nimble
Const_nimble <- nimble_objects$Const_nimble

#Once weget Const_nimble, we add to it information used by the model but not present in the final database 
#WGNAS_year, last_year, first_year, n, N, SU_ab, SU, N_NAC, N_NEAC
WGNAS_year <- format(Sys.Date(), "%Y")
first_year <- min(database_utd$year, na.rm = T)
last_year <- max(database_utd$year, na.rm = T)

n <- (last_year-first_year) + 1
N<- length(unique(tab_label$su_ab))

SU_ab <- tab_label$su_ab
SU <- tab_label$su_name
SU_NAC <- tab_label %>% filter(complex2 == "NAC") %>% 
  select(su_ab) %>% pull(su_ab)
N_NAC <- length(unique(SU_NAC))
SU_NEC <- tab_label %>% filter(complex2 == "NEC") %>%
  select(su_ab) %>% pull(su_ab)
N_NEC <- length(unique(SU_NEC))

Const_nimble_add <- list(WGNAS_year = WGNAS_year, 
                         #last_year = last_year, 
                         #first_year = first_year, 
                         #n = n, 
                         #N = N, 
                         SU_ab= SU_ab, 
                         SU = SU,
                         N_NAC = N_NAC,
                         N_NEC = N_NEC)
Const_nimble <- c(Const_nimble, Const_nimble_add)


#resave(Data_nimble, file="exchange_plateform/Nimble_input/Data_nimble.RData")
#######save(Const_nimble, file="exchange_plateform/Nimble_input/Const_nimble.RData")
unlink("exchange_plateform/Nimble_input/Data_nimble.rds")
unlink("exchange_plateform/Nimble_input/Const_nimble.rds")
saveRDS(Data_nimble, file="exchange_plateform/Nimble_input/Data_nimble.rds")
saveRDS(Const_nimble, file="exchange_plateform/Nimble_input/Const_nimble.rds")
#dbDisconnect(con)














