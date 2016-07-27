#' Query data availability
#'
#' 	Returns list of years based on survey.
#'
#' @param survey the survey accronym e.g. NS-IBTS, BITS.
#'
#'
#' @return A numeric vector.
#'
#' @seealso
#' \code{\link{getSurveyList}} returns the acronyms for available surveys.
#'
#' \code{\link{getSurveyYearQuarterList}} returns the quarters available for a given survey and year.
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#' @author Colin Millar.
#'
#' @examples
#' getSurveyYearList(survey = "NS-IBTS")
#'
#'
#' @export

getSurveyYearList <- function(survey) {
  # get a list of available years

  # check websevices are running
  if (!checkDatrasWebserviceOK()) return (FALSE)

  # read and parse XML from api
  url <-
    sprintf(
      "https://datras.ices.dk/WebServices/DATRASWebService.asmx/getSurveyYearList?survey=%s",
      survey)
  out <- curlDatras(url = url)
  out <- parseDatras(out)

  # return
  as.integer(out $ Year)
}
