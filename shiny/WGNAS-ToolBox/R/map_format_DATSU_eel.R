if (Sys.info()[["user"]] == "joliviero") {
    setwd("D:/workspace/DIASPARA_WP3_migdb/R")
    datawd <- "D:/DIASPARA/wgbast"
} else if (Sys.info()[["user"]] == "cedric.briand") {
    setwd("C:/workspace/DIASPARA_WP3_migdb/R")
    datawd <- "C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/DIASPARA/wgbast"
}
source("utilities/load_library.R")
load_library("tidyverse")
load_library("knitr")
load_library("kableExtra")
load_library("icesVocab")
load_library("readxl")
load_library("janitor")
load_library("skimr")
load_library("RPostgres")
load_library("yaml")
load_library("DBI")
load_library("ggplot2")
load_library("sf")
load_library("janitor") # clean_names
load_library("uuid")
cred <- read_yaml("../credentials.yml")
con_diaspara <- dbConnect(Postgres(),
    dbname = cred$dbnamediaspara,
    host = cred$hostdistant,
    port = cred$port,
    user = cred$userdiaspara,
    password = cred$passworddiaspara
)
con_diaspara_admin <- dbConnect(Postgres(),
    dbname = cred$dbnamediaspara,
    host = cred$hostdistant,
    port = cred$port,
    user = cred$userdistant,
    password = cred$passworddistant
)
con_salmoglob <- dbConnect(Postgres(),
    dbname = cred$dbnamesalmo,
    host = cred$hostdistant,
    port = cred$port,
    user = cred$usersalmo,
    password = cred$passwordsalmo
)
con_wgeel_distant <- dbConnect(Postgres(),
    dbname = cred$dbnamedistant,
    host = cred$hostdistant,
    port = cred$port,
    user = cred$userdistant,
    password = cred$passworddistant
)
# con_wgeel_local <- dbConnect(Postgres(),
#                            dbname = "wgeel",
#                            host = "127.0.0.1",
#                            port = cred$port,
#                            user = cred$userdistant,
#                            password = cred$passwordsalmo)

map_col <-dbGetQuery(con_diaspara_admin,"SELECT table_schema, table_name, column_name
  FROM information_schema.columns
 WHERE table_schema  ='dateel'
   AND table_name   in ('t_fish_fi' ,'t_group_gr' ,'t_grouptrait_grt' ,'t_indivtrait_int' ,'t_serannual_san' ,'t_series_ser'
)   ORDER BY table_name, ordinal_position;")

map_col1 <- edit(map_col)
save(map_col1, file = "data/map_col1.Rdata")
clipr::write_clip(map_col1)
# save  in excel

library(readxl)
file_path <- "data/metric_db_format.xlsx"
mdc <- read_excel(file_path, sheet = 1)[,1:4] # Mapping db col
mdgn <- read_excel(file_path, sheet = 2)[,1:2] # Mapping db group names
mdgn <- read_excel(file_path, sheet = 3)[,1:2] # Mapping db indiv names

tt <- "t_series_ser"

mdc |> 
filter(table_name == "t_series_ser") 


rename_ICES <- function(x, table_name., table_format = mdc){
  table_format <- table_format |> filter(table_name==table_name.)
  y <- table_format[table_format$column_name == x, "ICES_field"] |> pull()
  if (is.na(y)) {
    warning(sprintf("Correspondance for %s not found using %s instead", x, x))
    y <- x
  }
  return(y)
}
mdc$ICES field

rename_ICES("ser_id", tt)

query <- paste("SELECT",
"ser_id AS", rename_ICES("ser_id", tt),
",ser_name AS", rename_ICES("ser_name", tt),
",NULL AS Station",
",ser_spe_code AS", rename_ICES("ser_spe_code", tt),
",ser_lfs_code AS", rename_ICES("ser_lfs_code", tt),
",ser_hab_code AS", rename_ICES("ser_hab_code", tt), 
",ser_are_code AS", rename_ICES("ser_are_code", tt),
",ser_gea_code AS", rename_ICES("ser_gea_code", tt),
",ser_fiw_code AS Fishway",
",ser_mon_code as MonitoringDevice",
",ser_stocking as RestockingFlag",
",ser_stockingcomment as StockingComment",
",ser_effort_uni_code AS UnitEffort",
",ser_uni_code AS Unit",
",ser_description",
",ser_locationdescription",
",ser_protocol",
",ser_samplingstrategy",
",ser_wltyp_code",
"FROM dateel.t_series_ser limit 100"
)

sampling_info <-dbGetQuery(con_diaspara_admin, query)


library(writexl)
write_xlsx(sampling_info, "data/sample_eel_format.xlsx")



# Annual series


query <- paste("SELECT 
ser_code AS SeriesID,
san_ser_id AS	SamplingSchemeID,
san_value AS	Value,
ser_uni_code AS Unit,
san_year as	Year,
san_effort AS Effort,
ser_effort_uni_code as UnitEffort,
san_qal_id as 	QualityCode,
san_comment AS Comment,
san_qal_comment AS QualityCommentNOTINFORMAT,
san_wkg_code AS	WorkingGroup,
san_ver_code AS	Version
FROM dateel.t_serannual_san
JOIN dateel.t_series_ser ON ser_id = san_ser_id limit 200;")

AnnualSeries <-dbGetQuery(con_diaspara_admin, query)
write_xlsx(AnnualSeries, "data/sample_eel_format_2.xlsx")


query <- "SELECT ser_code, gr.*, grt.* FROM  dateel.t_series_ser 
JOIN dateel.t_group_gr gr ON gr_ser_id = ser_id
JOIN dateel.t_grouptrait_grt grt ON grt_gr_id = gr_id
limit 10000
"

gr <- dbGetQuery(con_diaspara_admin, query)
write_xlsx(gr, "data/sample_eel_format_3.xlsx")

query <- "SELECT ser_code, fi.*, int.* FROM  dateel.t_series_ser 
JOIN dateel.t_fish_fi fi ON fi_ser_id = ser_id
JOIN dateel.t_indivtrait_int int ON int_fi_id = fi_id
limit 10000
"
fi <- dbGetQuery(con_diaspara_admin, query)
write_xlsx(fi, "data/sample_eel_format_4.xlsx")

query <- paste('SELECT
gr_ser_id AS "SamplingSchemeID",
ser_code AS "SeriesID",
LifeStageProportion
NumberofIndividuals
MeanAge (or AgeClass)
MeanLength (or lengthClass)
MeanWeight
FemaleProportion
SexMeasurement_method
DifferentiatedProportion
AnguillicolaProportion
AnguillicolaIntensity
AnguillicolaMethod
MuscleLipidPercentage
MuscleLipidMeasuringMethod
6PCB
TEQ
EVEXProportion
HVAProportion
Pb
Hg
Cd
Comments
")

t_group_gr	gr_id
t_group_gr	gr_ser_id
t_group_gr	gr_gr_id
t_group_gr	gr_wkg_code
t_group_gr	gr_spe_code
t_group_gr	gr_lfs_code
t_group_gr	gr_sex_code
t_group_gr	gr_year
t_group_gr	gr_number
t_group_gr	gr_comment
t_group_gr	gr_lastupdate
t_group_gr	gr_ver_code
t_grouptrait_grt	grt_ser_id
t_grouptrait_grt	grt_wkg_code
t_grouptrait_grt	grt_spe_code
t_grouptrait_grt	grt_id
t_grouptrait_grt	grt_gr_id
t_grouptrait_grt	grt_tra_code
t_grouptrait_grt	grt_value
t_grouptrait_grt	grt_trv_code
t_grouptrait_grt	grt_trm_code
t_grouptrait_grt	grt_last_update
t_grouptrait_grt	grt_qal_code
t_grouptrait_grt	grt_ver_code
