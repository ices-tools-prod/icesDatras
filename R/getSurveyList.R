#' Query data availability
#'
#' 	Returns list of survey acronyms.
#'
#'
#' @return A numeric vector.
#'
#' @seealso
#' \code{\link{getSurveyYearList}} returns the years available for a given survey.
#'
#' \code{\link{getSurveyYearQuarterList}} returns the quarters available for a given survey and year.
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#' @author Colin Millar.
#'
#' @examples
#' getSurveyList()
#'
#'
#' @export

getSurveyList <- function() {
  # get a list of survey names

  # check websevices are running
  if (!checkDatrasWebserviceOK()) return (FALSE)

  # read and parse XML from api
  url <- "https://datras.ices.dk/WebServices/DATRASWebService.asmx/getSurveyList"
  out <- curlDatras(url = url)
  out <- parseDatras(out)

  # remove strange whitespace in EVHOE....
  out <- gsub("[[:space:]]*$", "", out $ Survey)

  # return
  out
}
