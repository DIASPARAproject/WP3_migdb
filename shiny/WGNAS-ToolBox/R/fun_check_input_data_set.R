#' fun_check_input_data_set function checks the imported data format
#' Cedric : check this function only returns one type of error
#' @param upload_db The uploaded dataset
#' @param current_db The current dataset
#' @return A text message for the app indicating different errors
check_input_data_set <- function(upload_db, current_db) {
  message <- "data is valid"

  if (all.equal(
    as.character(colnames(upload_db)),
    as.character(colnames(current_db))
  ) != TRUE ||
    ncol(upload_db) != ncol(current_db)) {
    message <- "! The number of columns or their name do not match the required format.
    Please check your data or the .csv import parameters"
  } else {
    # TEST FOR NUMBER OF VARIABLES
    # if(nrow(unique(cbind(upload_db$Data_Name,upload_db$ZONE,upload_db$age)))>1){
    #  message<-"/!\ Your are providing data for more than one variable. Please check your data"
    # } else {

    if (nrow(unique(cbind(upload_db$var_mod))) > 1) {
      message <- "! Your are providing data for more than one variable. Please check your data"
    } else {
      # current_info<-subset(current_db, as.character(current_db$Data_Name)==upload_db$Data_Name[1] &
      #                       as.character(current_db$ZONE)==upload_db$ZONE[1] &
      #                        as.character(current_db$Age)==upload_db$Age[1])

      if (unique(upload_db$type) %in% c("Returns", "Sea catches", "Survival rate", "Homewater catches", "Demographic transitions", "Natural mortality rate", "Abundance")) {
        current_info <- current_db %>%
          filter(type == unique(upload_db$type)) %>%
          filter(metric %in% upload_db$metric) %>%
          filter(age %in% upload_db$age) %>%
          filter(area %in% upload_db$area) %>%
          filter(location %in% upload_db$loca)
      } else {
        current_info <- current_db %>%
          filter(type == unique(upload_db$type)) %>%
          filter(age %in% upload_db$age) %>%
          filter(area %in% upload_db$area) %>%
          filter(location %in% upload_db$loca)
      }


      if (nrow(current_info) == 0) {
        message <- "! It seems that this data has not been observed yet in the database.
        Make sure your provide a variable absent from the database."
      }

      if (min(upload_db$year) > min(current_info$year) |
        max(upload_db$year) < max(current_info$year)) {
        message <- "! The new data should cover at least the same period as the current data.
         If no data is available for some years, please fill data with NA"
      } else {
        if (
          # is.numeric(upload_db$Year)==FALSE |
          # is.numeric(upload_db$Data_type)== FALSE |
          # is.numeric(upload_db$Data_name)== FALSE |
          # is.numeric(upload_db$Age)== FALSE |
          # is.numeric(upload_db$ZONE)== FALSE |
          is.numeric(upload_db$value) == FALSE #|
          # is.numeric(upload_db$Var_mod)== FALSE
        ) {
          message <- "! Check the format of your data: 'Value' should be numeric"
        }
      }
    }
  }

  return(message)
}
