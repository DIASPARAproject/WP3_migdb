#' Get all parents from a vocab object returned by icesVocab::getCodeDetail
#' compatibility version 1.2.0
#' @param st. an object returned by getCodeDetail
#' @return A vector with unique key of parents
#' @examples
#' \dontrun{
#' tt <- icesVocab::getCodeDetail("Station", 1000)
#' getlistparent(st. = tt, key. = "ISO_3166")
#' # [1] "Station_DTYPE" "PURPM"         "Datasets"      "ISO_3166"
#' # [5] "WLTYP"         "PRGOV"         "EDMO"
#' }
#' @export
getparent <- function(st.) {
  unique(st.$parents$code_types$Key)
}

#' Get a vector of values for each parent
#' compatibility version 1.2.0
#' @param st. an object returned by getCodeDetail
#' @param parent_key the parent key returned by getparents()
#' @return A vector of parent values
#' @examples
#' \dontrun{
#' tt <- icesVocab::getCodeDetail("Station", 1000)
#' parent_key <- getparent(tt)
#' getlistparent(st. = tt, parent_key. = "ISO_3166") # FI
#' getlistparent(st. = tt, parent_key. = "Station_DTYPE") # EW~EU~NU~CW
#' }
#' @export
getlistparent <- function(st., parent_key.) {
  pos <- which(st.$parents$code_types$Key == parent_key.)
  values <- st.$parents$codes[pos, "Key"]
  if (length(values) > 1) values <- paste0(values, collapse = "~")
  return(values)
}

#' Get a dataset of the stations in a form suitable for import
#' note currently I cannot return fields AciveFromDate, ActiveUntilldate,
#' latitude ... notes.
#' @param .code The code of the station
#' @return A table with station values partly filled in
#' @examples
#' \dontrun{
#' tt <- icesVocab::getCodeDetail("Station", 1000)
#' parent_key <- getparent(tt)
#' getlistparent(st. = tt, parent_key. = "ISO_3166") # FI
#' getlistparent(st. = tt, parent_key. = "Station_DTYPE") # EW~EU~NU~CW
#' }
get_station_detail <- function(.code) {
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
