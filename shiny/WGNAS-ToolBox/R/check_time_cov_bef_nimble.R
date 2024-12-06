#### Check the database prior to nimble formatting

# Here we define the variable generate_nimble that will control whether the generation of the Nimble objects can be launched.
# If generate_nimble is 0, the generation is blocked. If it set to 1, the generation will be enabled.
generate_nimble <- 0

# Let's identify all the variables for which a time-series exists
tab_type_object %>%
  dplyr::filter(name_dim1=="Year" | name_dim2== "Year" | name_dim3=="Year") %>%
  dplyr::filter(nimble %in% c("Const_nimble","Data_nimble")) %>%
  dplyr::select(var_mod) -> with_TS
with_TS <- as.vector(unlist(as.vector(c(with_TS))))
# We remove the initialization values with the "_pr" suffix
with_TS <- with_TS[-which(grepl("_pr",with_TS))]

## We retrieve the maximum Year for each variable.
databasenewval %>%
  dplyr::filter(var_mod %in% with_TS) %>%
  # Now that the variables can be updated for specific areas, the updating procedure can be at be complete
  #for some but not all areas. So I replace the following lines by new ones.
  #dplyr::group_by(var_mod) %>%
  #dplyr::summarise(maxy=max(year)) %>%
  dplyr::group_by(var_mod, area) %>%
  dplyr::summarise(maxy_area=max(year)) %>%
  dplyr::group_by(var_mod) %>%
  dplyr::summarise(maxy=min(maxy_area)) %>%
  as.data.frame() -> all_y

## If all the variables have the same temporal coverage, we consider that the Nimble object can be generated.
if(length(unique(all_y$maxy))==1){
  generate_nimble <- 1
}else{generate_nimble <- 0}