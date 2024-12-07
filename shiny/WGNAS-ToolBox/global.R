#------------------------------------------------------------------------------------#
# ------------------ Preliminary #1 Loading the required packages --------------------
#------------------------------------------------------------------------------------#
# stop()

source("../../R/utilities/load_library.R") # TODO move this
load_library("shiny")
load_library("shinydashboard")
load_library("leaflet")
load_library("plotly")
load_library("dplyr")
load_library("ggplot2")
load_library("grid")
load_library("gridExtra")
load_library("png")
load_library("shinyjs")
load_library("DT")
load_library("DBI")
load_library("tibble")
load_library("tidyr")
load_library("stringr")
load_library("tidyverse")
load_library("lubridate")
load_library("cgwtools")
load_library("RPostgres")
load_library("RColorBrewer")
load_library("reshape") # TODO CB virer
load_library("reshape2")
load_library("openxlsx")
load_library("yaml")
cred <- read_yaml("../../credentials.yml") # TODO MOVE THIS

#------------------------------------------------------------------------------------#
# -------------- Preliminary #2 Loading Salmon data from the SIRS Server ------------
#------------------------------------------------------------------------------------#

# We open a connection to the online database to load the first version of each table
# that should be displayed when opening the application
con <- dbConnect(
  RPostgres::Postgres(),
  host = cred$host,
  port = cred$port,
  user = cred$usersalmo,
  password = cred$passwordsalmo,
  dbname = cred$dbnamesalmo
)

onStop(function() {
  dbDisconnect(con)
})

# Load the tables from the database
database_mother <- dbReadTable(con, "database")
database_archive <- dbReadTable(con, "database_archive")
tab_type_object <- dbReadTable(con, "metadata")
tab_labels <- dbReadTable(con, "area_labels")
tab_users <- dbReadTable(con, "users")
# Load the tables from the database
# dbDisconnect(con) # CB I'm leavin the connexion open

#------------------------------------------------------------------------------------#
# ------------ Preliminary #3 Loading the functions called by the application---------
#------------------------------------------------------------------------------------#

# These functions qre used by the SERVER part of the application to plot outputs, updated data etc.
source("R/check_uploaded_data_format_varyingSU.R")
source("R/graph_functions.R")
source("R/manage_database.R")
source("R/formate_upload_data.R")
source("R/sort_upload_data.R")
source("R/function_exploration_data.R")
source("R/fun_perc_updated.R")
source("R/functions_building_templates.R")
source("R/time_line_plot_by_type.R")

# Here we just specify a directory that will be used by the SERVER part of the application
outputDir <- "data"
