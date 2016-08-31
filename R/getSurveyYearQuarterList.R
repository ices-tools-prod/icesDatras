#' Get a List of Quarters
#'
#' Get a list of quarters available for a given survey and year.
#'
#' @param survey the survey acronym, e.g. NS-IBTS.
#' @param year the year of the survey, e.g. 2010.
#'
#' @return A numeric vector.
#'
#' @seealso
#' \code{\link{getSurveyYearList}}, \code{\link{getSurveyYearQuarterList}}, and
#' \code{\link{getDatrasDataOverview}} also list available data.
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#' @author Colin Millar.
#'
#' @examples
#' getSurveyYearQuarterList(survey = "ROCKALL", year = 2015)
#'
#' @export

getSurveyYearQuarterList <- function(survey, year) {
  # check web services are running
  if (!checkDatrasWebserviceOK()) return (FALSE)

  # read and parse XML from API
  url <-
    sprintf(
      "https://datras.ices.dk/WebServices/DATRASWebService.asmx/getSurveyYearQuarterList?survey=%s&year=%i",
      survey, year)
  out <- curlDatras(url = url)
  out <- parseDatras(out)

  # return
  as.integer(out $ Quarter)
}
