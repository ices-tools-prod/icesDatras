#' Get CPUE per Age per Haul per Hour for a given Survey, year and Quarter
#'
#'
#' @param survey the survey acronym, e.g. NS-IBTS.
#' @param year the year of the survey, e.g. 2010.
#' @param quarter the quarter of interest, e.g. 1
#'
#' @return A data frame.
#'
#' @seealso
#'
#' \code{\link{getHHdata}} and \code{\link{getCAdata}} get haul data and
#' age-based data., and
#' \code{\link{getIndices}}, and
#' \code{\link{getCPUELength}}.
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#' @author Adriana Villamor.
#'
#' @examples
#' \dontrun{
#' getCPUEperAge(survey = "NS-IBTS", year = 2018, quarter = 1)
#' }
#' @export

getCPUEAge <- function(survey, year, quarter) {
  # check web services are running
  if (!checkDatrasWebserviceOK()) return (FALSE)

  # read url and parse to data frame
  url <-
    sprintf(
      "https://datras.ices.dk/WebServices/DATRASWebService.asmx/getCPUEAge?survey=%s&year=%i&quarter=%i",
      survey, year, quarter)
  out <- readDatras(url)
  out <- parseDatras(out)

  out
}
