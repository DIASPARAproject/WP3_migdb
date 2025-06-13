# libraries
library(dplyr)
library(stringr)
library(stringi)
library(readxl)

#file WGBAST_streams_names.xlsx
#WGBAST_streams_names <- read_excel("/WGBAST_streams_names.xlsx")

# function to transform the names
transform_name <- function(name) {
  name %>%
    stri_trans_general("Latin-ASCII") %>%
    str_to_lower() %>%
    str_replace_all(" ", "") %>%
    str_to_sentence()
}

# Applying function
WGBAST_streams_names <- WGBAST_streams_names %>%
  mutate(freshwater_id = sapply(originalname, transform_name))


#Writing to csv for Qgis
write.csv(WGBAST_streams_names, "transformed_names.csv", row.names = FALSE, fileEncoding = "UTF-8")
