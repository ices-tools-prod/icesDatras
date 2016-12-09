context("check inputs")

test_that("checkSurveyOK", {

  # return values
  expect_true(checkSurveyOK("NS-IBTS"))
  expect_false(checkSurveyOK("never"))
  expect_false(checkSurveyOK(raw(1)))

  # messages
  expect_message(checkSurveyOK("never"))

  # warnings
  expect_warning(checkSurveyOK(c("NS-IBTS", "never")))

  # errors
  expect_error(checkSurveyOK(numeric()))
  expect_error(checkSurveyOK())
})


test_that("checkSurveyYearOK", {

  # return values
  expect_true(checkSurveyYearOK("NS-IBTS", 2010))
  expect_false(checkSurveyYearOK("never"))
  expect_false(checkSurveyYearOK(raw(1)))

  # messages
  expect_message(checkSurveyYearOK("never"))

  # warnings


  # errors
  expect_error(checkSurveyYearOK(c("NS-IBTS", "never"), 1))
  expect_error(checkSurveyYearOK(numeric()))
  expect_error(checkSurveyYearOK())
})


test_that("checkSurveyYearQuarterOK", {

  # return values
  expect_true(checkSurveyYearQuarterOK("NS-IBTS", 2010, 1))
  expect_false(checkSurveyYearQuarterOK("never"))
  expect_false(checkSurveyYearQuarterOK(raw(1)))
  expect_false(checkSurveyYearQuarterOK("NS-IBTS", 9))
  expect_false(checkSurveyYearQuarterOK("NS-IBTS", 2010, 5))

  # messages
  expect_message(checkSurveyYearQuarterOK("never"))
  expect_message(checkSurveyYearQuarterOK("NS-IBTS", 9))
  expect_message(checkSurveyYearQuarterOK("NS-IBTS", 2010, 5))

  # warnings
  expect_error(checkSurveyYearQuarterOK(c("NS-IBTS", "never"), 2010, 1))
  expect_error(checkSurveyYearQuarterOK("NS-IBTS", 2010:2011, 1))
  expect_warning(checkSurveyYearQuarterOK("NS-IBTS", 2010, 1:2))

  # errors
  expect_error(checkSurveyYearQuarterOK("NS-IBTS"))
  expect_error(checkSurveyYearQuarterOK("NS-IBTS", 2010))
  expect_error(checkSurveyYearQuarterOK(numeric()))
  expect_error(checkSurveyYearQuarterOK())
})




