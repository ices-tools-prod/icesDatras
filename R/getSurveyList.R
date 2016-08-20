#' Get a List of All Surveys
#'
#' Get a list of all survey acronyms.
#'
#' @return A character vector.
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
#' getSurveyList()
#'
#' @export

getSurveyList <- function() {
  # check web services are running
  if (!checkDatrasWebserviceOK()) return (FALSE)

  # read and parse XML from API
  url <- "https://datras.ices.dk/WebServices/DATRASWebService.asmx/getSurveyList"
  out <- curlDatras(url = url)
  out <- parseDatras(out)

  # return
  out
}
