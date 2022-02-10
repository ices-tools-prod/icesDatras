#' Check that a survey name is in the database
#'
#' Checks a survey name against a list of all survey names in the DATRAS database.
#' If the name is not matched it puts up a message showing the available survey names.
#'
#' @param survey the survey acronym, e.g. NS-IBTS.
#'
#' @return logical.
#'
#' @seealso
#' \code{\link{checkSurveyYearOK}} and \code{\link{getSurveyYearQuarterList}}
#'  also perform checks against the DATRAS database.
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' checkSurveyOK(survey = "ROCKALL")
#' checkSurveyOK(survey = "NOTALL")
#' }
#' @export

#' @importFrom utils capture.output
checkSurveyOK <- function(survey) {
  # check survey name against available surveys
  available_surveys <- getSurveyList()

  if (!survey %in% available_surveys) {
    message("Supplied survey name (", survey, ") is not available.\n  Available options are:\n",
            paste(capture.output(print(available_surveys)), collapse = "\n"))
    FALSE
  } else {
    TRUE
  }
}


#' Check that a survey and year combination is in the database
#'
#' Checks a year and/or survey name against a list of all survey year combinations in the DATRAS database.
#' If the combination is not matched it puts up a message showing the available options.
#'
#' @param survey the survey acronym, e.g. NS-IBTS.
#' @param year the year of the survey, e.g. 2010.
#' @param checksurvey logical, should the survey name also be checked.
#'
#' @return logical.
#'
#' @seealso
#' \code{\link{checkSurveyOK}} and \code{\link{checkSurveyYearQuarterOK}}
#'  also perform checks against the DATRAS database.
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' checkSurveyYearOK(survey = "ROCKALL", 2015)
#' checkSurveyYearOK(survey = "ROCKALL", 2000)
#' checkSurveyYearOK(survey = "NOTALL", 2000)
#' }
#' @export

checkSurveyYearOK <- function(survey, year, checksurvey = TRUE) {
  # check year against available years for a given survey
  if (checksurvey) {
    # check survey name
    if (!checkSurveyOK(survey)) return(FALSE)
  }

  available_years <- getSurveyYearList(survey)
  if (!year %in% available_years) {
    message("Supplied year (", year, ") is not available.\n  Available options are:\n",
            paste(capture.output(print(available_years)), collapse = "\n"))
    FALSE
  } else {
    TRUE
  }
}


#' Check that a survey, year and quarter combination is in the database
#'
#' Checks a quarter and/or year and/or survey name against a list of all survey year quarter
#' combinations in the DATRAS database.
#' If the combination is not matched it puts up a message showing the available options.
#'
#' @param survey the survey acronym, e.g. NS-IBTS.
#' @param year the year of the survey, e.g. 2010.
#' @param quarter the quarter of the year the survey took place, i.e. 1, 2, 3 or 4.
#' @param checksurvey logical, should the survey name also be checked.
#' @param checkyear logical, should the year also be checked.
#'
#' @return logical.
#'
#' @seealso
#' \code{\link{checkSurveyOK}} and \code{\link{checkSurveyYearOK}}
#'  also perform checks against the DATRAS database.
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' checkSurveyYearQuarterOK(survey = "ROCKALL", 2015, 3)
#' checkSurveyYearQuarterOK(survey = "ROCKALL", 2015, 1)
#' checkSurveyYearQuarterOK(survey = "ROCKALL", 2000, 1)
#' checkSurveyYearQuarterOK(survey = "NOTALL", 2000, 1)
#'
#' # be careful of unexpected results with checksurvey and checkyear!
#' checkSurveyYearQuarterOK(survey = "NOTALL", 2000, 1, checksurvey=FALSE)
#' }
#' @export

checkSurveyYearQuarterOK <- function(survey, year, quarter, checksurvey = TRUE, checkyear = TRUE) {
  # check year against available years for a given survey
  if (checksurvey) {
    # check survey name
    if (!checkSurveyOK(survey)) return(FALSE)
  }

  if (checkyear) {
    # check survey year
    if (!checkSurveyYearOK(survey, year, checksurvey = FALSE)) return(FALSE)
  }

  available_quarters <- getSurveyYearQuarterList(survey, year)
  if (!quarter %in% available_quarters) {
    message("Supplied quarter (", quarter, ") is not available.\n  Available options are:\n",
            paste(capture.output(print(available_quarters)), collapse = "\n"))
    FALSE
  } else {
    TRUE
  }
}
