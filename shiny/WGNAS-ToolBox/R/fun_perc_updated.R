#' fun_perc_updated function, calculates the % of updated series
#' checks wich type of data have a Year in one of the three nimble dimensions
#' and calculates which value corresponds to tha maximum of year
#' encountered in groups of var_mod and metric
#' @param database The database
#' @param tab_type_object A table of object types
#' @return A table with column pc_update the perecentage of data
fun_perc_updated <- function(database, tab_type_object) {
  with_TS <- tab_type_object %>%
    filter(name_dim1 == "Year" | name_dim2 == "Year" | name_dim3 == "Year") %>%
    filter(nimble %in% c("Const_nimble", "Data_nimble")) %>%
    select(var_mod)

  with_TS <- as.vector(unlist(as.vector(c(with_TS))))
  with_TS <- with_TS[-which(grepl("_pr", with_TS))]

  minmax_type_sel <- database %>%
    filter(var_mod %in% with_TS) %>%
    group_by(var_mod, metric) %>%
    summarise(maxy = max(year), miny = min(year))

  pc_update <- length(which(minmax_type_sel$maxy == max(minmax_type_sel$maxy, na.rm = T))) /
    nrow(minmax_type_sel) * 100

  year_ready <- min(minmax_type_sel$maxy)

  status_DB <- c(pc_update, year_ready)

  return(status_DB)
}
