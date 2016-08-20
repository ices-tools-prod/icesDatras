#' Summarize Data Availability
#'
#' Evaluate a presence-absence table for each survey with '1' where there is data and '0' (printed as '.') otherwise.
#'
#' @return A list of tables.
#'
#' @seealso
#' \code{\link{getSurveyList}}, \code{\link{getSurveyYearList}}, and
#' \code{\link{getSurveyYearQuarterList}} also list available data.
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

getDatrasDataOverview <- function() {
  # check web services are running
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

# print method for datrasoverview class produced in 'getDatrasDataOverview()'
#' @export
print.datrasoverview <- function(x, ...) {
  x <- as.table(x)
  print.table(x, zero.print = ".")
}
