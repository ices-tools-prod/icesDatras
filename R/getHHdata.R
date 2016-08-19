#' Haul meta data
#'
#' Returns detailed haul-based meta-data of the survey such as haul position, sampling method etc.
#'
#' @param survey the survey accronym e.g. NS-IBTS, BITS.
#' @param year the numeric year of the survey, e.g. 2010.
#' @param quarter the quarter of the year the survey took place, i.e. 1, 2, 3 or 4.
#'
#'
#' @return A data.frame.
#'
#' @seealso
#' \code{\link{getSurveyList}} returns the acronyms for available surveys.
#'
#' \code{\link{getSurveyYearList}} returns the years available for a given survey.
#'
#' \code{\link{getSurveyYearQuarterList}} returns the quarters available for a given survey and year.
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#' @author Colin Millar.
#'
#' @note All columns are returned as characters with any trailing white space removed
#'
#' @examples
#' # read meta data
#' hhdata <- getHHdata(survey = "NS-IBTS", year = 2016, quarter = 1)
#' str(hhdata)
#'
#' # error checking examples:
#' hhdata <- getHHdata(survey = "NS_IBTS", year = 2016, quarter = 1)
#' hhdata <- getHHdata(survey = "NS-IBTS", year = 2018, quarter = 1)
#' hhdata <- getHHdata(survey = "NS-IBTS", year = 2016, quarter = 6)
#'
#' # multiple year example
#' hhdata <- do.call(rbind,
#'                   lapply(2015:2016,
#'                          function(year)
#'                            getHHdata(survey = "NS-IBTS", year = year, quarter = 1)
#'                          )
#'                  )
#' str(hhdata)
#'
#'
#' @export

getHHdata <- function(survey, year, quarter) {
  # 	Returns detailed haul-based meta-data of the survey such as haul position, sampling method etc.

  # check survey name
  if (!checkSurveyOK(survey)) return(FALSE)

  # check year
  if (!checkSurveyYearOK(survey, year, checksurvey = FALSE)) return(FALSE)

  # check quarter
  if (!checkSurveyYearQuarterOK(survey, year, quarter, checksurvey = FALSE, checkyear = FALSE)) return(FALSE)

  # read and parse XML from api
  url <-
    sprintf(
      "https://datras.ices.dk/WebServices/DATRASWebService.asmx/getHHdata?survey=%s&year=%i&quarter=%i",
      survey, year, quarter)
  out <- curlDatras(url = url)
  out <- parseDatras(out)

  # return
  out
}

