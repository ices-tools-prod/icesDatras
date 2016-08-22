#' Get Age-Based Data
#'
#' Get age-based data such as sex, maturity, and age counts per length of sampled species.
#'
#' @param survey the survey acronym e.g. NS-IBTS.
#' @param year the numeric year of the survey, e.g. 2010.
#' @param quarter the quarter of the year the survey took place, i.e. 1, 2, 3 or 4.
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getHHdata}} and \code{\link{getHLdata}} get haul data and
#' length-based data.
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#' @author Colin Millar.
#'
#' @examples
#' cadata <- getCAdata(survey = "BTS", year = 2015, quarter = 3)
#' str(cadata)
#'
#' @export

getCAdata <- function(survey, year, quarter) {
  # check survey name
  if (!checkSurveyOK(survey)) return(FALSE)

  # check year
  if (!checkSurveyYearOK(survey, year, checksurvey = FALSE)) return(FALSE)

  # check quarter
  if (!checkSurveyYearQuarterOK(survey, year, quarter, checksurvey = FALSE, checkyear = FALSE)) return(FALSE)

  # read and parse XML from API
  url <-
    sprintf(
      "https://datras.ices.dk/WebServices/DATRASWebService.asmx/getCAdata?survey=%s&year=%i&quarter=%i",
      survey, year, quarter)
  out <- curlDatras(url = url)
  out <- parseDatras(out)

  # return
  out
}
