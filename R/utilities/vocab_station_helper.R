#' Get a dataset of the stations in a form suitable for import
#' @param .code The code of the station
#' @return A table with station values partly filled in
#' @examples
#' \dontrun{
#' tt <- icesVocab::getCodeDetail("Station", 1000)
#' getListParents(st. = tt, parent_key. = "ISO_3166") # FI
#' getListParents(st. = tt, parent_key. = "Station_DTYPE") # EW~EU~NU~CW
#' }
getStationDetail <- function(.code) {
  st <- icesVocab::getCodeDetail(code_type = "Station", code = .code)
  # getlistparent(st, "Station_DTYPE") # "CS~ES~PB~ZB"
  pa <- c("PURPM", "WLTYP", "ISO_3166", "EDMO", "Station_DTYPE", "PRGOV")
  parents <- mapply(FUN = getlistparent, pa, MoreArgs = list(st. = st))
  parents <- unlist(parents)
  Station <- data.frame(
    "Definition" = "Station",
    "HeaderRecord" = "record",
    "Station_Code" = st$detail$Key,
    "Station_Country" = parents["ISO_3166"],
    "Station_Name" = st$detail$Description,
    "Station_LongName" = st$detail$LongDescription,
    "Station_ActiveFromDate" = NA,
    "Station_ActiveUntilDate" = NA,
    "Station_ProgramGovernance" = parents["PRGOV"],
    "Station_StationGovernance" = parents["EDMO"],
    "Station_PURPM" = parents["PURPM"],
    "Station_Latitude" = NA,
    "Station_LatitudeRange" = NA,
    "Station_Longitude" = NA,
    "Station_LongitudeRange" = NA,
    "Station_Geometry" = NA,
    "Station_DataType" = parents["Station_DTYPE"],
    "Station_WLTYP" = parents["WLTYP"],
    "Station_MSTAT" = parents["MSTAT"],
    "Station_Notes" = NA,
    "Station_Deprecated" = NA
  )
  return(Station)
}
