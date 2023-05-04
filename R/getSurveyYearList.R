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
#' \dontrun{
#' getSurveyYearList(survey = "ROCKALL")
#' }
#' @export

getSurveyYearList <- function(survey) {
  # check web services are running
  if (!checkDatrasWebserviceOK()) return (FALSE)

  # read url and parse to data frame
  url <-
    sprintf(
      "https://datras.ices.dk/WebServices/DATRASWebService.asmx/getSurveyYearList?survey=%s",
      survey)
  out <- readDatras(url)
  out <- parseDatras(out)

  out$Year
}
