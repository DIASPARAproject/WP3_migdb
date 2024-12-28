#' check_input_data_set function checks the imported data format
#' NOTE CEDRIC: currently corresponds to previous code for
# check_uploaded_data_format.R, check_uploaded_data_format_emergency_procedure.R,
# and check_uploaded_data_format_varyingSU.R
# the same function was called depending on the state of the the app
# it is unclear where the "normal" was done, currently this will never be called within app
# Anyways I think this needs reprogramming, several errors cannot be reported with this function
#' @param upload_db The uploaded dataset
#' @param current_db The current dataset
#' @param typecheck c("normal", "emergency_procedure", "varying_SU")
#' @return A text message for the app indicating different errors
check_input_data_set <- function(upload_db, current_db, typecheck = "normal") {
  message <- "data is valid"
  if (type == "normal") {
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
  } else if (type == "emergency_procedure") {
    if (is.null(upload_db)) {
      message <- ""
    } else {
      message <- "data is valid"

      if (!all.equal(colnames(upload_db), colnames(current_db)) ||
        ncol(upload_db) != ncol(current_db)) {
        if (ncol(upload_db) <= 1) {
          message <- "!!! Uncorrect format - Check your .csv separator!"
        } else {
          message <- '!!! The number of columns / their name do not match the required format. Please check your data or modify the "Quote" or "Header" for .csv format'
        }
      } else {
        ### temporary removal before changes in the ckecking procedure
        # if(nrow(unique(cbind(upload_db$Data_Name,upload_db$ZONE,upload_db$Age)))>1){
        if (length(unique(upload_db$var_mod)) > 1) {
          message <- "!!! Your are providing data for more than one variable. Please check your file!"
        } else {
          if (TRUE %in% duplicated.data.frame(upload_db)) {
            message <- "!!! We identify duplicated lines. Please check your file!"
          }
        }
      }
    }
  } else if (type == "varying_SU") {
    if (is.null(upload_db)) {
      message <- ""
    } else {
      message <- "data is valid"
      if (all.equal(colnames(upload_db), colnames(current_db)) != TRUE || ncol(upload_db) != ncol(current_db)) {
        if (ncol(upload_db) <= 1) {
          message <- "!!! Uncorrect format - Check your .csv separator!"
        } else {
          message <- '!!! The number of columns / their name do not match the required format. Please check your data or modify the "Quote" or "Header" for .csv format'
        }
      } else {
        ### temporary removal before changes in the ckecking procedure
        # if(nrow(unique(cbind(upload_db$Data_Name,upload_db$ZONE,upload_db$Age)))>1){
        if (length(unique(upload_db$var_mod)) > 1) {
          message <- "!!! Your are providing data for more than one variable. Please check your file!"
        } else {
          if (TRUE %in% duplicated.data.frame(upload_db)) {
            message <- "!!! We identify duplicated lines. Please check your file!"
          } else {
            current_info <- subset(current_db, as.character(current_db$var_mod) == upload_db$var_mod[1] &
              as.character(current_db$area) %in% unique(upload_db$area))

            if (unique(upload_db$type) != unique(current_info$type) | unique(upload_db$var_mod) != unique(current_info$var_mod) | unique(upload_db$metric) != unique(current_info$metric)) {
              message <- "!!! datatype, var_mod or metric do not match the data to update. Please check your file!"
            } else {
              if (unique(unique(current_info$area) %in% unique(upload_db$area)) != T) {
                message <- "!!! You forgot data for one or several areas. Please check your file!"
              } else {
                if (unique(unique(current_info$age) %in% unique(upload_db$age)) != T) {
                  message <- "!!! You forgot data for one or several ages. Please check your file!"
                } else {
                  combupload <- upload_db %>%
                    dplyr::group_by(location, area, age) %>%
                    dplyr::summarise(n = n())
                  combcurrent <- current_info %>%
                    dplyr::group_by(location, area, age) %>%
                    dplyr::summarise(n = n())

                  if (nrow(combupload) != nrow(combcurrent)) {
                    message <- "!!! Some combinations of area/age/location are missing. Please check your file!"
                  } else {
                    if (NA %in% match(combcurrent$area, combupload$area)) {
                      message <- "!!! The name of areas does not seem correct. Please check your file!"
                    } else {
                      if (TRUE %in% (combupload$n < combcurrent$n)) {
                        message <- "!!! Some years missing for particular area/age/location combination. Please check your file!"
                      } else {
                        ####### Blocking when not uploading the data for the variable
                        if (length(unique(combupload$n)) > 1) {
                          message <- "!!! You are not providing the same temporal coverage for all variables. Please check your file!"
                        } else {
                          if (nrow(current_info) == 0) {
                            message <- "!!! No record yet for this variable in the database. Check your data or contact SalmoGlob team."
                          }
                          # IdentifiÃ© comme PB ? Jerome 03/01/2022 min(upload_db$year)>min(current_info$year) | max(upload_db$year)<max(current_info$year)
                          if (is.numeric(current_info$year) & is.numeric(upload_db$year)) {
                            if ((min(upload_db$year) > min(current_info$year)) == TRUE | (max(upload_db$year) < max(current_info$year)) == TRUE) {
                              message <- "!!! The new data should cover at least the same period as the current data. If no data is available for some years, please fill data with NA"
                            }
                          } else {
                            print("on est dans esls")
                            if (is.numeric(upload_db$value) == FALSE) {
                              message <- '!!! Check the format of your data: "value" should be numeric - check your data/the decimal character'
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  } else {
    stop("internal error, check_input_data_set,
    type should be one of normal or emergency_procedure or varying_SU")
  }

  return(message)
}
