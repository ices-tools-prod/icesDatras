#' Get Flex File
#'
#' Get all information in HH plus estimates of Door Spread, Wing Spread and
#' Swept Area per square km. Only available for NS-IBTS survey.
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
#' \code{\link{getHHdata}} get haul data
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#' @author Adriana Villamor.
#'
#' @examples
#' \dontrun{
#' flex <- getFlexFile(survey = "ROCKALL", year = 2002, quarter = 3)
#' str(flex)
#'
#' # error checking examples:
#' flex <- getFlexFile(survey = "NS_IBTS", year = 2016, quarter = 1)
#' flex <- getFlexFile(survey = "NS-IBTS", year = 2030, quarter = 1)
#' flex <- getFlexFile(survey = "NS-IBTS", year = 2016, quarter = 6)
#' }
#' @export

getFlexFile <- function(survey, year, quarter) {

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
