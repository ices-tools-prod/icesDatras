#' getDATRAS.R
#'
#' Downloads and parses data from ICES DATRAS database using web services
#'
#' @param record the data type required: "HH" haul meta data, "HL" length-based data, "CA" age-based data
#' @param survey the survey accronym e.g. NS-IBTS, BITS.
#' @param years a vector of numeric years of the survey, e.g. c(2010, 2012), or 2005:2010.
#' @param quarters a vector of quarters of the year the survey took place, i.e. c(1, 4) or 1:4.
#'
#' @return a data.frame
#'
#' @author Scott Large
#' @author Colin Millar
#'
#' @examples \dontrun{
#'  hhdata <- getDATRAS(record = "HH", survey = "NS-IBTS", years = 1966:1967, quarters = c(1,4))
#' }
#'
#' @export
getDATRAS <- function(record = "HH", survey, years, quarters) {

  # check record type
  if(!record %in% c("HL", "HH", "CA")) {
    message("Please specify record type:",
            "\n\t\tHH (haul meta-data)",
            "\n\t\tHL (Species length-based data)",
            "\n\t\tCA (species age-based data)")
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
                function(y) getSurveyYearQuarterList(survey, as.numeric(y)),
                simplify = FALSE)
  mat <- sapply(mat, function(x) as.numeric(1:4 %in% x)) # hard wire 4 quarters
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

  # report to user which years and wuarters are being extracted?
  message("Data being extracted for:\n",
          paste(capture.output(print(cbind.data.frame(survey = survey, year = yvec, quarter = qvec))), collapse = "\n"))

  # Create list of web service URLs
  url <-
    sprintf(
      "https://datras.ices.dk/WebServices/DATRASWebService.asmx/get%sdata?survey=%s&year=%i&quarter=%i",
      record, survey, yvec, qvec)

  # read and parse XML from api
  out <- lapply(url,
                function(x) {
                  out <- curlDatras(url = x)
                  parseDatras(out)
                })
  out <- do.call(rbind, out)

  # clean white space from text columns
  charcol <- which(sapply(out, is.character))
  out[charcol] <- lapply(out[charcol], function(x) gsub("[[:space:]]*$", "", x))

  # return
  out
}

