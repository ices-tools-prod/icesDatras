#' Get Survey Indices
#'
#' Get age based indices of abundance by species, survey and year.
#'
#' @param survey the survey acronym, e.g. NS-IBTS.
#' @param year the year of the survey, e.g. 2010.
#' @param quarter the quarter of the year the survey took place, i.e. 1, 2, 3 or 4.
#' @param species the aphia species code for the species of interest.
#'
#' @return A data frame.
#' @note
#' The \pkg{icesAdvice} package provides \code{findAphia}, a function to look up Aphia species codes.
#'
#' @seealso
#' \code{\link{getDATRAS}} supports querying many years and quarters in one function call.
#'
#' \code{\link{getHHdata}} and \code{\link{getCAdata}} get haul data and
#' age-based data.
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' haddock_aphia <- icesVocab::findAphia("haddock")
#' index <- getIndices(survey = "NS-IBTS", year = 2002, quarter = 3, species = haddock_aphia)
#' str(index)
#' }
#' @export

getIndices <- function(survey, year, quarter, species) {
  # check survey name
  if (!checkSurveyOK(survey)) return(FALSE)

  # check year
  if (!checkSurveyYearOK(survey, year, checksurvey = FALSE)) return(FALSE)

  # check quarter
  if (!checkSurveyYearQuarterOK(survey, year, quarter, checksurvey = FALSE, checkyear = FALSE)) return(FALSE)

  # check species?

  # read url and parse to data frame
  url <-
    sprintf(
      "https://datras.ices.dk/WebServices/DATRASWebService.asmx/getIndices?survey=%s&year=%i&quarter=%i&species=%s",
      survey, year, quarter, species)
  out <- readDatras(url)
  out <- parseDatras(out)

  # return
  out
}
