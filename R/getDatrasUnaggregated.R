#' Download unaggregated DATRAS survey data
#'
#' Downloads unaggregated haul- and biological-level data from the
#' ICES DATRAS Download API.

#' @author Vaishav Soni, International Council for the Exploration of the Sea (ICES)
#' @param recordtype Character. One of `"HH"`, `"HL"`, or `"CA"`.
#' @param survey Character. Survey acronym (e.g. `"NS-IBTS"`).
#' @param year Character. Year or range (e.g. `"2020"` or `"1965:2025"`).
#' @param quarter Character. Quarter or range (e.g. `"1"` or `"1:4"`).
#' @param data.table.output Logical, return output as data.table if TRUE, otherwise as data.frame.
#' @param fix_types logical, apply the DATRAS type to columns. Takes package default 
#'                  unless specified. Use \code{SetDatrasDefaults()} to change 
#'                  default across all functions 
#' @param new_names logical, apply the new DATRAS naming convention to output. 
#'                  Takes package default unless specified. Use 
#'                  \code{SetDatrasDefaults()} to change default across all functions
#'
#' @return A `data.table`, optionally a `data.frame`, containing the requested DATRAS data.
#'
#' @details
#' The function downloads a zipped CSV file from the official ICES DATRAS API,
#' extracts it locally, applies the requested naming and type convention and provides
#' outputs as a data.table or data.frame.
#'
#' @examples
#' \dontrun{
#' #Download HH records for all quarters in 2024
#' df_datrasHH <- get_datras_unaggregated_data(
#'   recordtype = "HH",
#'   survey = "NS-IBTS",
#'   year = "2024:2025",
#'   quarter = "1:4"
#' )
#'
#' # Download HL records for Quarter 1 of the 2020 NS-IBTS survey
#' df_datrasHL <- get_datras_unaggregated_data(
#'   recordtype = "HL",
#'   survey = "NS-IBTS",
#'   year = "2020:2020",
#'   quarter = "1"
#' )
#'
#' head(df_datrasHL)
#'
#' # Download CA records for multiple years
#' df_datrasCA <- get_datras_unaggregated_data(
#'   recordtype = "CA",
#'   survey = "NS-IBTS",
#'   year = "2020:2024",
#'   quarter = "1"
#' )
#'
#' }
#'
#' @export
#' @importFrom data.table setDTthreads fread as.data.table
getDatrasUnaggregated <- function(recordtype, survey, year, quarter, data.table.output = TRUE, fix_types = getOption("icesDatras.fix_types"), new_names = getOption("icesDatras.new_names")) {
  
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
  setDTthreads(0)
  
  df <- readDatrasUnaggregated(csv_file, recordtype)
  
  unlink(c(tmp_zip, tmp_dir), recursive = TRUE)
  df <- formatDatras(df, 
                     fix_types = fix_types,
                     new_names = new_names)
  if (data.table.output) {
    as.data.table(df)
  } else {
    df
  }
}

#' Download unaggregated DATRAS survey data (Deprecated)
#'
#' Downloads unaggregated haul- and biological-level data from the
#' ICES DATRAS Download API.
#' Now deprecated, use getDatrasUnaggregated
#' @author Vaishav Soni, International Council for the Exploration of the Sea (ICES)
#' @param recordtype Character. One of `"HH"`, `"HL"`, or `"CA"`.
#' @param survey Character. Survey acronym (e.g. `"NS-IBTS"`).
#' @param year Character. Year or range (e.g. `"2020"` or `"1965:2025"`).
#' @param quarter Character. Quarter or range (e.g. `"1"` or `"1:4"`).
#' @param data.table.output Logical, return output as data.table if TRUE, otherwise as data.frame.
#' @param fix_types logical, apply the DATRAS type to columns. Takes package default 
#'                  unless specified. Use \code{SetDatrasDefaults()} to change 
#'                  default across all functions 
#' @param new_names logical, apply the new DATRAS naming convention to output. 
#'                  Takes package default unless specified. Use 
#'                  \code{SetDatrasDefaults()} to change default across all functions
#'
#' @return A `data.table`, optionally a `data.frame`, containing the requested DATRAS data.
#'
#' @details
#' The function downloads a zipped CSV file from the official ICES DATRAS API,
#' extracts it locally, applies the requested naming and type convention and provides
#' outputs as a data.table or data.frame.
#'
#' @examples
#' \dontrun{
#' # Download HH records for all quarters in 2024
#' df_datrasHH <- get_datras_unaggregated_data(
#'   recordtype = "HH",
#'   survey = "NS-IBTS",
#'   year = "2024:2025",
#'   quarter = "1:4"
#' )
#'
#' # Download HL records for Quarter 1 of the 2020 NS-IBTS survey
#' df_datrasHL <- get_datras_unaggregated_data(
#'   recordtype = "HL",
#'   survey = "NS-IBTS",
#'   year = "2020:2020",
#'   quarter = "1"
#' )
#'
#' head(df_datrasHL)
#'
#' # Download CA records for multiple years
#' df_datrasCA <- get_datras_unaggregated_data(
#'   recordtype = "CA",
#'   survey = "NS-IBTS",
#'   year = "2020:2024",
#'   quarter = "1"
#' )
#'
#' }
#'
#' @export
get_datras_unaggregated_data <- function(recordtype, survey, year, quarter, data.table.output = TRUE, fix_types = getOption("icesDatras.fix_types"), new_names = getOption("icesDatras.new_names")) {
  .Deprecated(new = "getDatrasUnaggregated")
  getDatrasUnaggregated(recordtype, survey, year, quarter, data.table.output = data.table.output, fix_types = fix_types, new_names = new_names)
}

# fields the download API lists in the csv header but supplies no values for,
# see https://github.com/ices-tools-prod/icesDatras/issues/63
datras_header_only_fields <- list(
  HH = c("EDOM", "ReasonHaulDisruption")
)

# reads the csv file from the download API, checking that the header matches
# the data rows rather than letting fread pad short rows and shift values into
# the wrong columns
readDatrasUnaggregated <- function(csv_file, recordtype) {
  
  con <- file(csv_file, encoding = "UTF-8-BOM")
  on.exit(close(con))
  header <- scan(con, what = "", sep = ",", nlines = 1, quiet = TRUE)
  
  # no data rows, only a header
  if (length(readLines(csv_file, n = 2)) < 2) {
    return(fread(csv_file, showProgress = FALSE, data.table = FALSE))
  }
  
  df <- fread(
    csv_file,
    skip = 1,
    header = FALSE,
    showProgress = FALSE,
    blank.lines.skip = TRUE,
    data.table = FALSE
  )
  
  if (ncol(df) == length(header)) {
    names(df) <- header
    return(df)
  }
  
  absent <- datras_header_only_fields[[recordtype]]
  if (length(absent) == 0 || !all(absent %in% header) ||
      ncol(df) != length(header) - length(absent)) {
    stop(
      "DATRAS returned a ", recordtype, " file with ", length(header),
      " column names but ", ncol(df), " columns of data, ",
      "so columns cannot be reliably identified. Please report this at ",
      "https://github.com/ices-tools-prod/icesDatras/issues"
    )
  }
  
  warning(
    "DATRAS lists ", paste(absent, collapse = " and "), " in the ", recordtype,
    " header but supplies no values for them, these columns are returned as NA",
    call. = FALSE
  )
  names(df) <- setdiff(header, absent)
  df[absent] <- rep(NA_character_, nrow(df))
  df[header]
}
