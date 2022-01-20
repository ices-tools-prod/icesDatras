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
#' \dontrun{
#' getSurveyYearQuarterList(survey = "ROCKALL", year = 2002)
#' }
#' @export

getSurveyYearQuarterList <- function(survey, year) {
  # check web services are running
  if (!checkDatrasWebserviceOK()) return (FALSE)

  # read url and parse to data frame
  url <-
    sprintf(
      "https://datras.ices.dk/WebServices/DATRASWebService.asmx/getSurveyYearQuarterList?survey=%s&year=%i",
      survey, year)
  out <- readDatras(url)
  out <- parseDatras(out)

  out$Quarter
}
