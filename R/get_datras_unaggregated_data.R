#' Download unaggregated DATRAS survey data
#'
#' Downloads unaggregated haul- and biological-level data from the
#' ICES DATRAS Download API.

#'#' @author Vaishav Soni, International Council for the Exploration of the Sea (ICES)

#' @param recordtype Character. One of `"HH"`, `"HL"`, or `"CA"`.
#' @param survey Character. Survey acronym (e.g. `"NS-IBTS"`).
#' @param year Character. Year or range (e.g. `"2020"` or `"1965:2025"`).
#' @param quarter Character. Quarter or range (e.g. `"1"` or `"1:4"`).
#'
#' @return A `data.table` containing the requested DATRAS data.
#'
#' @details
#' The function downloads a zipped CSV file from the official ICES DATRAS API,
#' extracts it locally, and reads it using fixed column classes to avoid
#' costly type guessing.
#'
#' @examples
#' \dontrun{
#' df <- get_datras_unaggregated_data(
#'   recordtype = "HH",
#'   survey = "NS-IBTS",
#'   year = "1965:2025",
#'   quarter = "1:4"
#' )
#' }
#'
#' @export
#' @importFrom data.table setDTthreads fread
get_datras_unaggregated_data <- function(recordtype, survey, year, quarter) {

  if (!recordtype %in% c("HH", "HL", "CA")) {
    stop("recordtype must be one of 'HH', 'HL', or 'CA'")
  }

  base_url <- "https://datras.ices.dk/Data_products/Download/DATRASDownloadAPI.aspx"

  full_url <- paste0(
    base_url,
    "?recordtype=", recordtype,
    "&survey=", survey,
    "&year=", year,
    "&quarter=", quarter
  )

  col_classes <- .datras_column_classes(recordtype)

  tmp_zip <- tempfile(fileext = ".zip")
  tmp_dir <- tempfile()
  dir.create(tmp_dir)

  message("Downloading DATRAS data...")
  utils::download.file(full_url, tmp_zip, mode = "wb", quiet = TRUE)

  message("Extracting files...")
  utils::unzip(tmp_zip, exdir = tmp_dir)

  csv_file <- list.files(
    tmp_dir,
    pattern = "DATRASDataTable\\.csv$",
    full.names = TRUE
  )

  if (length(csv_file) == 0) {
    stop("No CSV file found in downloaded archive")
  }

  message("Reading data...")
  data.table::setDTthreads(0)

  df <- data.table::fread(
    csv_file,
    colClasses = col_classes,
    fill = TRUE,
    showProgress = FALSE
  )

  unlink(c(tmp_zip, tmp_dir), recursive = TRUE)
  df
}


# -------------------------------------------------------------------------
# Internal helper functions (not exported)
# -------------------------------------------------------------------------

.datras_column_classes <- function(recordtype) {

  classes <- list(

    HH = list(
      character = c(
        "RecordHeader","Country","Platform","Gear","GearExceptions",
        "DoorType","StationName","Year","StartTime","DepthStratum",
        "StatisticalRectangle","HydrographicStationID",
        "StandardSpeciesCode","BycatchSpeciesCode","Rigging",
        "DayNight","ThermoCline","PelagicSamplingType",
        "Survey","DateofCalculation"
      ),
      integer = c(
        "Quarter","SweepLength","HaulNumber","Month","Day",
        "HaulDuration","WarpLength","WarpDiameter","WarpDensity",
        "DoorWeight","Buoyancy","TowDirection",
        "SurfaceCurrentDirection","BottomCurrentDirection",
        "WindDirection","WindSpeed","SwellDirection",
        "ThermoClineDepth","TidePhase","MinTrawlDepth",
        "MaxTrawlDepth"
      ),
      numeric = c(
        "ShootLatitude","ShootLongitude","HaulLatitude",
        "HaulLongitude","NetOpening","Distance","DoorSurface",
        "DoorSpread","WingSpread","KiteArea","GroundRopeWeight",
        "SpeedGround","SpeedWater","SurfaceCurrentSpeed",
        "BottomCurrentSpeed","SwellHeight","SurfaceTemperature",
        "BottomTemperature","SurfaceSalinity","BottomSalinity",
        "SecchiDepth","Turbidity","TideSpeed","SurveyIndexArea"
      )
    ),

    HL = list(
      character = c(
        "RecordHeader","Country","Platform","Gear","GearExceptions",
        "DoorType","StationName","Year","SpeciesCodeType",
        "SpeciesCode","SpeciesValidity","SpeciesSex",
        "LengthCode","DevelopmentStage","LengthType",
        "Survey","ScientificName_WoRMS","DateofCalculation"
      ),
      integer = c(
        "Quarter","SweepLength","HaulNumber","SpeciesCategory",
        "SubsampledNumber","SubsampleWeight",
        "SpeciesCategoryWeight","LengthClass","ValidAphiaID"
      ),
      numeric = c(
        "TotalNumber","SubsamplingFactor","NumberAtLength"
      )
    ),

    CA = list(
      character = c(
        "RecordHeader","Country","Platform","Gear","GearExceptions",
        "DoorType","StationName","Year","SpeciesCodeType",
        "SpeciesCode","AreaType","AreaCode","LengthCode",
        "IndividualSex","IndividualMaturity","AgePlusGroup",
        "MaturityScale","FishID","GeneticSamplingFlag",
        "StomachSamplingFlag","AgeSource",
        "AgePreparationMethod","OtolithGrading",
        "ParasiteSamplingFlag","Survey",
        "ScientificName_WoRMS","DateofCalculation"
      ),
      integer = c(
        "Quarter","SweepLength","HaulNumber","LengthClass",
        "IndividualAge","NumberAtLength","ValidAphiaID"
      ),
      numeric = c(
        "IndividualWeight","LiverWeight"
      )
    )
  )

  classes[[recordtype]]
}
