
# read in table
aphia <- read.csv("data-raw/RECO_Export_14-59-2016.csv")

# keep only relavent columns and rename
aphia <- aphia[c("Code", "Description")]
names(aphia) <- c("aphia_code", "species")

# trim white space
aphia$species <- trimws(aphia$species)

# save to data folder
devtools::use_data(aphia, overwrite = TRUE)
