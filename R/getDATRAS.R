#' Get Any DATRAS Data
#'
#' This function combines the functionality of getHHdata, getHLdata, and getCAdata.
#' It supports querying many years and quarters in one function call.
#'
#' @param record the data type required: "HH" haul data, "HL" length-based data, "CA" age-based data.
#' @param survey the survey acronym e.g. NS-IBTS.
#' @param years a vector of years of the survey, e.g. c(2010, 2012) or 2005:2010.
#' @param quarters a vector of quarters of the year the survey took place, i.e. c(1, 4) or 1:4.
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getHHdata}}, \code{\link{getHLdata}}, and \code{\link{getCAdata}}
#' get haul data, length-based data, and age-based data.
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#' @author Scott Large and Colin Millar.
#'
#' @examples
#' \dontrun{
#' hhdata <- getDATRAS(record = "HH", survey = "ROCKALL", years = 2002, quarters = 3)
#' hldata <- getDATRAS(record = "HL", survey = "ROCKALL", years = 2002, quarters = 3)
#' cadata <- getDATRAS(record = "CA", survey = "ROCKALL", years = 2002, quarters = 3)
#' }
#' @export

getDATRAS <- function(record = "HH", survey, years, quarters) {
  # check record type
  if (!record %in% c("HH", "HL", "CA")) {
    message("Please specify record type:",
            "\n\t\tHH (haul data)",
            "\n\t\tHL (length-based data)",
            "\n\t\tCA (age-based data)")
    return(FALSE)
  }

  # check survey name
  if (!checkSurveyOK(survey)) return(FALSE)

  # cross check available years with those requested
  available_years <- getSurveyYearList(survey)
  available_years_req <- intersect(years, available_years)
  if (length(available_years_req) == 0) {
    # all years are unavailable
    message("Supplied years (", paste(years, collapse = ", "), ") are not available.\n  Available options are:\n",
            paste(capture.output(print(available_years)), collapse = "\n"))
    return(FALSE)
  } else if (length(available_years_req) < length(years)) {
    # some years are unavailable
    message("Some supplied years (", paste(setdiff(years, available_years), collapse = ", "),
            ") are not available.")
  }

  # get matrix of available data for years and quarters requested
  mat <- sapply(as.character(available_years_req),
                function(y) getSurveyYearQuarterList(survey, as.integer(y)),
                simplify = FALSE)
  mat <- sapply(mat, function(x) as.integer(1:4 %in% x)) # hard wire 4 quarters
  row.names(mat) <- 1:4

  if (sum(mat[quarters,]) == 0) {
    # all quarters are unavailable
    message("Supplied quarters (", paste(quarters, collapse = ", "), ") are not available.\n  Available options are:\n",
            paste(capture.output(print(mat)), collapse = "\n"))
    return(FALSE)
  } else if (sum(mat[quarters,] == 0) > 0) {
    # some quarters are unavailable
    message("Some supplied quarter and year combinations are not available.")
  }

  # work out year and quarter combinations to extract
  amat <- mat[quarters,,drop = FALSE]
  qvec <- quarters[row(amat)[amat == 1]]
  yvec <- available_years_req[col(amat)[amat == 1]]

  # report to user which years and quarters are being extracted?
  message("Data being extracted for:\n",
          paste(capture.output(print(cbind.data.frame(survey = survey, year = yvec, quarter = qvec))), collapse = "\n"))

  # create list of web service URLs
  url <-
    sprintf(
      "https://datras.ices.dk/WebServices/DATRASWebService.asmx/get%sdata?survey=%s&year=%i&quarter=%i",
      record, survey, yvec, qvec)

  # read XML string and parse to data frame
  out <- lapply(url,
                function(x) {
                  x <- readDatras(x)
                  parseDatras(x)
                })
  out <- do.call(rbind, out)

  out
}
