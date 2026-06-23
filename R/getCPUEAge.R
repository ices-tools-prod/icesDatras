#' Get CPUE per Age per Haul per Hour for a given Survey, year and Quarter
#'
#'
#' @param survey the survey acronym, e.g. NS-IBTS.
#' @param year the year of the survey, e.g. 2010.
#' @param quarter the quarter of interest, e.g. 1
#' @param fix_types logical, apply the DATRAS type to columns. Takes package default 
#'                  unless specified. Use \code{SetDatrasDefaults()} to change 
#'                  default across all functions 
#' @param new_names logical, apply the new DATRAS naming convention to output. 
#'                  Takes package default unless specified. Use 
#'                  \code{SetDatrasDefaults()} to change default across all functions
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
#' getCPUEAge(survey = "NS-IBTS", year = 2018, quarter = 1)
#' }
#' @export

getCPUEAge <- function(survey, year, quarter, fix_types = getOption("icesDatras.fix_types"), new_names = getOption("icesDatras.new_names")) {
  # check web services are running
  if (!checkDatrasWebserviceOK()) return (FALSE)

  # read url and parse to data frame
  url <-
    sprintf(
      "https://datras.ices.dk/WebServices/DATRASWebService.asmx/getCPUEAge?survey=%s&year=%i&quarter=%i",
      survey, year, quarter)
  out <- readDatras(url)
  out <- parseDatras(out)
  out <- formatDatras(out, 
                      fix_types = fix_types,
                      new_names = new_names)

  out
}

