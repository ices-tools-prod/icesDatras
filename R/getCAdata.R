#' Get Age-Based Data
#'
#' Get age-based data such as sex, maturity, and age counts per length of sampled species.
#'
#' @param survey the survey acronym, e.g. NS-IBTS.
#' @param year the year of the survey, e.g. 2010.
#' @param quarter the quarter of the year the survey took place, i.e. 1, 2, 3 or 4.
#' @param species the valid aphia code of the species to download, if
#'                NULL all species are included
#' @param fix_types logical, apply the DATRAS type to columns. Takes package default 
#'                  unless specified. Use \code{SetDatrasDefaults() to change 
#'                  default across all functions 
#' @param new_names logical, apply the new DATRAS naming convention to output. 
#'                  Takes package default unless specified. Use 
#'                  \code{SetDatrasDefaults() to change default across all functions
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getDATRAS}} supports querying many years and quarters in one function call.
#'
#' \code{\link{getHHdata}} and \code{\link{getHLdata}} get haul data and
#' length-based data.
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#' @author Colin Millar.
#'
#' @examples
#' \dontrun{
#' cadata <- getCAdata(survey = "ROCKALL", year = 2002, quarter = 3)
#' str(cadata)
#'
#' cadata <- getCAdata(survey = "ROCKALL", year = 2002, quarter = 3, species = 126437)
#' str(cadata)
#' }
#' @export

getCAdata <- function(survey, year, quarter, species = NULL, fix_types = getOption("icesDatras.fix_types"), new_names = getOption("icesDatras.new_names")) {
  # check survey name
  if (!checkSurveyOK(survey)) return(FALSE)

  # check year
  if (!checkSurveyYearOK(survey, year, checksurvey = FALSE)) return(FALSE)

  # check quarter
  if (!checkSurveyYearQuarterOK(survey, year, quarter, checksurvey = FALSE, checkyear = FALSE)) return(FALSE)

  # read url and parse to data frame
  if (!is.null(species)) {
    url <-
      sprintf(
        "https://datras.ices.dk/WebServices/DATRASWebService.asmx/getCAdataSp?survey=%s&year=%i&quarter=%i&species=%i",
        survey, year, quarter, species
      )
  } else {
    url <-
      sprintf(
        "https://datras.ices.dk/WebServices/DATRASWebService.asmx/getCAdata?survey=%s&year=%i&quarter=%i",
        survey, year, quarter
      )
  }

  out <- readDatras(url)
  out <- parseDatras(out)
  out <- formatDatras(out, 
                      record = "CA",
                      fix_types = fix_types,
                      new_names = new_names)

  out
}
