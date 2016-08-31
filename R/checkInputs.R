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
