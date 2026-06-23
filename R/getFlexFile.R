#' Get Flex File
#'
#' Get all information in HH plus estimates of Door Spread, Wing Spread and
#' Swept Area per square km. Only available for NS-IBTS survey.
#'
#' @param survey the survey acronym, e.g. NS-IBTS.
#' @param year the year of the survey, e.g. 2010.
#' @param quarter the quarter of the year the survey took place, i.e. 1, 2, 3 or 4.
#' @param fix_types logical, apply the DATRAS type to columns. Takes package default 
#'                  unless specified. Use \code{SetDatrasDefaults()} to change 
#'                  default across all functions. 
#' @param new_names logical, apply the new DATRAS naming convention to output. 
#'                  Takes package default unless specified. Use 
#'                  \code{SetDatrasDefaults()} to change default across all functions.
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
#' flex <- getFlexFile(survey = "NS-IBTS", year = 2020, quarter = 1)
#' str(flex)
#'
#' # error checking examples:
#' flex <- getFlexFile(survey = "NS-IBTS", year = 2016, quarter = 1)
#' flex <- getFlexFile(survey = "NS-IBTS", year = 2030, quarter = 1)
#' flex <- getFlexFile(survey = "NS-IBTS", year = 2016, quarter = 6)
#' }
#' @export

getFlexFile <- function(survey, year, quarter, fix_types = getOption("icesDatras.fix_types"), new_names = getOption("icesDatras.new_names")) {

  # check survey name
  if (!checkSurveyOK(survey)) return(FALSE)

  # check year
  if (!checkSurveyYearOK(survey, year, checksurvey = FALSE)) return(FALSE)

  # check quarter
  if (!checkSurveyYearQuarterOK(survey, year, quarter, checksurvey = FALSE, checkyear = FALSE)) return(FALSE)

  # read url and parse to data frame
  url <-
    sprintf(
      "https://datras.ices.dk/WebServices/DATRASWebService.asmx/getFlexFile?survey=%s&year=%i&quarter=%i",
      survey, year, quarter)
  out <- readDatras(url)
  out <- parseDatras(out)
  out <- formatDatras(out, 
                      record = "HH",
                      fix_types = fix_types,
                      new_names = new_names)

  out
}
