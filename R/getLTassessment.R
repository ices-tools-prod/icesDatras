#' Get Litter assessment output
#'
#' Get Litter assessment output by survey, year and quarter. The raw data are also
#' included in this file.
#'
#' @param survey the survey acronym, e.g. NS-IBTS.
#' @param year the year of the survey, e.g. 2010.
#' @param quarter the quarter of the year the survey took place, i.e. 1, 2, 3 or 4.
#' 
#' @return A data frame.
#' @note
#' The \pkg{icesAdvice} package provides \code{findAphia}, a function to look up Aphia species codes.
#'
#' @seealso
#' \code{\link{getDATRAS}} supports querying many years and quarters in one function call.
#'
#' \code{\link{getHHdata}} and \code{\link{getCAdata}} get haul data and
#' age-based data.
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' index <- getLTassessment(survey = "NS-IBTS", year = 2002, quarter = 3)
#' str(index)
#' }
#' @export

getLTassessment <- function(survey, year, quarter) {
  # check survey name
  if (!checkSurveyOK(survey)) return(FALSE)

  # check year
  if (!checkSurveyYearOK(survey, year, checksurvey = FALSE)) return(FALSE)

  # check quarter
  if (!checkSurveyYearQuarterOK(survey, year, quarter, checksurvey = FALSE, checkyear = FALSE)) return(FALSE)

  # check species?

  # read url and parse to data frame
  url <-
    sprintf(
      "https://datras.ices.dk/WebServices/DATRASWebService.asmx/getLitterAssessmentOutput?survey=%s&year=%i&quarter=%i",
      survey, year, quarter)
  out <- readDatras(url)
  out <- parseDatras(out)

  # return
  out
}
