#' Get Haul Data
#'
#' Get haul data such as position, depth, sampling method, etc.
#'
#' @param survey the survey acronym, e.g. NS-IBTS.
#' @param year the year of the survey, e.g. 2010.
#' @param quarter the quarter of the year the survey took place, i.e. 1, 2, 3 or 4.
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getDATRAS}} supports querying many years and quarters in one function call.
#'
#' \code{\link{getHLdata}} and \code{\link{getCAdata}} get length-based data and
#' age-based data.
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#' @author Colin Millar.
#'
#' @examples
#' \dontrun{
#' hhdata <- getHHdata(survey = "ROCKALL", year = 2002, quarter = 3)
#' str(hhdata)
#'
#' # error checking examples:
#' hhdata <- getHHdata(survey = "NS_IBTS", year = 2016, quarter = 1)
#' hhdata <- getHHdata(survey = "NS-IBTS", year = 2030, quarter = 1)
#' hhdata <- getHHdata(survey = "NS-IBTS", year = 2016, quarter = 6)
#' }
#' @export

getHHdata <- function(survey, year, quarter) {
  # check survey name
  if (!checkSurveyOK(survey)) return(FALSE)

  # check year
  if (!checkSurveyYearOK(survey, year, checksurvey = FALSE)) return(FALSE)

  # check quarter
  if (!checkSurveyYearQuarterOK(survey, year, quarter, checksurvey = FALSE, checkyear = FALSE)) return(FALSE)

  # read url and parse to data frame
  url <-
    sprintf(
      "https://datras.ices.dk/WebServices/DATRASWebService.asmx/getHHdata?survey=%s&year=%i&quarter=%i",
      survey, year, quarter)
  out <- readDatras(url)
  out <- parseDatras(out)

  out
}
