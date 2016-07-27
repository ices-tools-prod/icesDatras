#' Query data availability
#'
#' 	Returns list of quarter based on survey and year.
#'
#' @param survey the survey accronym e.g. NS-IBTS, BITS.
#' @param year the numeric year of the survey, e.g. 2010.
#'
#'
#' @return A numeric vector.
#'
#' @seealso
#' \code{\link{getSurveyList}} returns the acronyms for available surveys.
#'
#' \code{\link{getSurveyYearList}} returns the years available for a given survey.
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#' @author Colin Millar.
#'
#' @examples
#' getSurveyYearQuarterList(survey = "NS-IBTS", year = 2010)
#'
#'
#' @export

getSurveyYearQuarterList <- function(survey, year) {
  # get a list of available quarters

  # check websevices are running
  if (!checkDatrasWebserviceOK()) return (FALSE)

  # read and parse XML from api
  url <-
    sprintf(
      "https://datras.ices.dk/WebServices/DATRASWebService.asmx/getSurveyYearQuarterList?survey=%s&year=%i",
      survey, year)
  out <- curlDatras(url = url)
  out <- parseDatras(out)

  # return
  as.integer(out $ Quarter)
}


