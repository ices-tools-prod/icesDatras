#' Summarise data availability
#'
#' Returns a table for each survey with '1' where there is data and '0' (printed as '.') otherwise.
#'
#'
#' @return A list of tables.
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
#' @examples
#' \dontrun{
#' getDatrasDataOverview()
#' }
#'
#' @export

# table data available
getDatrasDataOverview <- function() {
  # get a list of available quarters

  # check websevices are running
  if (!checkDatrasWebserviceOK()) return (FALSE)

  available_data <-
    sapply(getSurveyList(),
           function(s) {
             out <- sapply(as.character(getSurveyYearList(s)),
                           function(y) getSurveyYearQuarterList(s, as.numeric(y)),
                           simplify = FALSE)
             out <- sapply(out, function(x) as.numeric(1:4 %in% x)) # hard wire 4 quarters
             row.names(out) <- 1:4
             class(out) <- "datrasoverview"
             out
           },
           simplify = FALSE)

  available_data
}

# print method for datrasoverview class produces in 'getDatrasDataOverview()'
print.datrasoverview <- function(x) {
  x <- as.table(x)
  print.table(x, zero.print = ".")
}

