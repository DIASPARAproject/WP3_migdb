runs <- list(
  DK = c("VidaG", "RibS"),
  ES = c("EbroG", "OriaG", "NalS"),
  FI = c("VaakS", "KotkS", "VesiY"),
  GB = c("BannGY", "GiBS", "LeeY", "BeeG"),
  GR = c("NorwS", "ArgY", "WepeS"),
  IE = c("ErneGY", "BurS", "ShaAGY"),
  IT = c("PogoS", "TibeG", "PobeY"),
  LT = c("CurlS", "AlauS", "CurlY"),
  LV = c("DaugY", "LilS", "DaugS"),
  NL = c("RhDOG", "IjsY", "RhIjG"),
  NO = c("SkaY", "ImsaGY", "ImsaS"),
  PL = c("VisY"),
  PT = c("MiPoG", "MonY", "MonS"),
  SE = c("GotaY", "YFS2G", "KavlS"),
  FR = c("GiTCG", "VacG","BresGY", "BreS"),
  DE = c("EmsG", "DoElY", "WarS"),
  BE = c("YserG", "MeusY", "VeAmG")
)
library(quarto)

for(i in seq_len(length(runs))) {
  cat(sprintf("Country = %s", names(runs)[i]))
  quarto_render(
    "export_format_datsu.qmd",
    execute_params = list(country=names(runs)[i],
                          samplingscheme = runs[[i]])
  )
  
}
