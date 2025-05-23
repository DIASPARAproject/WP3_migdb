#' Get all parents from a vocab object returned by icesVocab::getCodeDetail
#' compatibility version 1.2.0
#' @param st. an object returned by getCodeDetail 
#' @return A vector with unique key of parents
#' @examples
#' \dontrun{
#' tt <-  icesVocab::getCodeDetail("Station",1000)
#' getlistparent(st.= tt, key.="ISO_3166")
#' #[1] "Station_DTYPE" "PURPM"         "Datasets"      "ISO_3166"     
#' #[5] "WLTYP"         "PRGOV"         "EDMO"  
#' }
#' @export
getparent <- function(st.){
  unique(st.$parents$code_types$Key)
}

#' Get a vector of values for each parent 
#' compatibility version 1.2.0
#' @param st. an object returned by getCodeDetail 
#' @param parent_key the parent key returned by getparents()
#' @return A vector of parent values
#' @examples
#' \dontrun{
#' tt <-  icesVocab::getCodeDetail("Station",1000)
#' parent_key <- getparent(tt)
#' getlistparent(st.= tt, parent_key.="ISO_3166") # FI
#' getlistparent(st.= tt, parent_key.="Station_DTYPE") # EW~EU~NU~CW
#' }
#' @export
getlistparent <- function(st., parent_key.){
  pos <- which(st.$parents$code_types$Key==parent_key.) 
  values <- st.$parents$codes[pos,"Key"]
  if (length(values) >1) values <- paste0(values, collapse ="~") 
  return(values)
}

#' Get a dataset of the stations in a form suitable for import
#' note currently I cannot return fields AciveFromDate, ActiveUntilldate,
#' latitude ... notes.
#' @param .code The code of the station
#' @return A table with station values partly filled in
#' @examples
#' \dontrun{
#' tt <-  icesVocab::getCodeDetail("Station",1000)
#' parent_key <- getparent(tt)
#' getlistparent(st.= tt, parent_key.="ISO_3166") # FI
#' getlistparent(st.= tt, parent_key.="Station_DTYPE") # EW~EU~NU~CW
#' }
get_station_detail <- function(get_station_detail){
  st <-  icesVocab::getCodeDetail(code_type ="Station", code = .code)
  # getlistparent(st, "Station_DTYPE") # "CS~ES~PB~ZB"
  parents <- mapply(FUN= getlistparent, pa, MoreArgs = list(st.= st))
 
  Station <- data.frame("Definition" = "Station",
  "HeaderRecord" = "record",
  "Station_Code" = st$detail$Key,
  "Station_Country" = parents$ISO_3166,  
  "Station_Name" = st$detail$Description,
  "Station_LongName" =st$detail$LongDescription,
  "Station_ActiveFromDate" = NA,
  "Station_ActiveUntilDate" = NA,
  "Station_ProgramGovernance" = parents$PRGOV,
  "Station_StationGovernance" = parents$EDMO,
  "Station_PURPM" = parents$PURPM,
  "Station_Latitude" = NA,
  "Station_LatitudeRange" = NA,
  "Station_Longitude" = NA,
  "Station_LongitudeRange" = NA,  
  "Station_Geometry" = NA,
  "Station_DataType" = parents["Station_DTYPE"],
  "Station_WLTYP" = parents$WLTYP,
  "Station_MSTAT" = parents$MSTAT,
  "Station_Notes" = NA,
  "Station_Deprecated" = NA) 
return(Station)
}
st0 <- getCodeList(code_type ="Station")
ll <- mapply(get_station_detail, st0$Key)





tt <-  icesVocab::getCodeDetail("Station",1000)
str(tt)
 icesVocab::getCodeDetail("Station",1000)$detail
 #    Key           Description       LongDescription   Modified Deprecated
#   1 1000 Suomenl Pyöts Kyvy-13 Suomenl Pyöts Kyvy-13 2018-03-21      FALSE
 icesVocab::getCodeDetail("Station",1000)$parent$codes
# Key           Description       LongDescription   Modified Deprecated
# 1 1000 Suomenl Pyöts Kyvy-13 Suomenl Pyöts Kyvy-13 2018-03-21      FALSE
# >  icesVocab::getCodeDetail("Station",1000)$parent$codes
# The output from this function is developing.  please do not rely on the current output format
# GUID  Key
# 1  f313f04d-76ca-4bd0-b50a-b4b832c47ce8   FI
# 2  8655c1bd-330a-4f7a-812c-f6cc0bd8f5a2   CW
# 3  8a758bca-6647-4b47-94a6-7d85ea48a29b   EW
# 4  83052fb7-d4e1-482f-a947-801e2273f478    H
# 5  86d9897d-6adc-430e-a689-f321b75cadcc    C
# 6  3254f008-f7b4-4776-934a-890bae28f22c 1104
# 7  4886803a-5262-404a-a88c-f32eb2ed06e6 CUWN
# 8  ba545513-a5dc-4087-bd05-71c28da65f54   NU
# 9  6583e8b5-5d79-4ba2-94cb-099dd745e8eb   EU
# 10 49df3df6-f880-4330-9707-a276eb92b4f2    S
# Description        LongDescription
# 1                                         Finland                   <NA>
#     2      Contaminants/hazardous substances in water                   <NA>
#     3                     Biological effects in water                   <NA>
#     4                                          HELCOM                   <NA>
#     5                               WFD Coastal water                   <NA>
#     6            Finnish Environment Institute (SYKE) Suomen ymparistokeskus
# 7                     Continuous underwater noise                   <NA>
#     8                              Nutrients in water  nitrogen, phosphorous
# 9                          Eutrophication effects   Oxygen, Chlorophyl-a
# 10 Spatial (geographical) distribution monitoring                   <NA>
#     Modified Deprecated
# 1  2024-12-10      FALSE
# 2  2025-04-23      FALSE
# 3  2025-04-23      FALSE
# 4  2025-02-05      FALSE
# 5  2025-04-23      FALSE
# 6  2022-08-26      FALSE
# 7  2025-05-17      FALSE
# 8  2022-12-15      FALSE
# 9  2025-04-23      FALSE
# 10 2025-04-23      FALSE

