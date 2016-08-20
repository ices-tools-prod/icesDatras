#' Get a List of Survey Years
#'
#' Get a list of all data years for a given survey.
#'
#' @param survey the survey acronym, e.g. NS-IBTS.
#'
#' @return A numeric vector.
#'
#' @seealso
#' \code{\link{getSurveyList}}, \code{\link{getSurveyYearQuarterList}}, and
#' \code{\link{getDatrasDataOverview}} also list available data.
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#' @author Colin Millar.
#'
#' @examples
#' getSurveyYearList(survey = "NS-IBTS")
#'
#' @export

getSurveyYearList <- function(survey) {
  # check web services are running
  if (!checkDatrasWebserviceOK()) return (FALSE)

  # read and parse XML from API
  url <-
    sprintf(
      "https://datras.ices.dk/WebServices/DATRASWebService.asmx/getSurveyYearList?survey=%s",
      survey)
  out <- curlDatras(url = url)
  out <- parseDatras(out)

  # return
  as.integer(out $ Year)
}
