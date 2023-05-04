#' Summarize Data Availability
#'
#' Evaluate a presence-absence table for each survey with '1' where there is data and '0' (printed as '.') otherwise.
#'
#' @param surveys a vector of survey names, or \code{NULL} to process all surveys.
#' @param long whether tables should have year as row names (default) or column names.
#'
#' @return A list of tables.
#'
#' @seealso
#' \code{\link{getSurveyList}}, \code{\link{getSurveyYearList}}, and
#' \code{\link{getSurveyYearQuarterList}} also list available data.
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#'
#' @examples
#' \dontrun{
#' getDatrasDataOverview(surveys = "ROCKALL", long = FALSE)
#' }
#' @export

getDatrasDataOverview <- function(surveys = NULL, long = TRUE) {
  # check web services are running
  if (!checkDatrasWebserviceOK()) return (FALSE)

  # include all surveys if user did not specify any
  if (is.null(surveys)) surveys <- getSurveyList()

  available_data <-
    sapply(surveys,
           function(s) {
             out <- sapply(as.character(getSurveyYearList(s)),
                           function(y) getSurveyYearQuarterList(s, as.integer(y)),
                           simplify = FALSE)
             out <- sapply(out, function(x) as.integer(1:4 %in% x)) # hard wire 4 quarters
             rownames(out) <- paste0("Q", 1:4)
             class(out) <- c("datrasoverview", class(out))
             if (long)
               t(out)
             else
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
