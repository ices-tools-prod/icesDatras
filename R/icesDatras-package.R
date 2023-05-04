#' @docType package
#'
#' @name icesDatras-package
#'
#' @aliases icesDatras
#'
#' @title DATRAS Trawl Survey Database Web Services
#'
#' @description
#' R interface to access the web services of the ICES DATRAS trawl survey
#' database.
#'
#' @details
#' \emph{Exchange data:}
#' \tabular{ll}{
#'   \code{\link{getHHdata}} \tab haul data\cr
#'   \code{\link{getHLdata}} \tab length-based data\cr
#'   \code{\link{getCAdata}} \tab age-based data\cr
#'   \code{\link{getDATRAS}} \tab exchange data
#' }
#' \emph{Catch weights:}
#' \tabular{ll}{
#'   \code{\link{getCatchWgt}} \tab catch weights
#' }
#' \emph{Survey indices:}
#' \tabular{ll}{
#'   \code{\link{getIndices}} \tab survey indices
#' }
#' \emph{Overview of available data:}
#' \tabular{ll}{
#'   \code{\link{getSurveyList}}            \tab surveys\cr
#'   \code{\link{getSurveyYearList}}        \tab years\cr
#'   \code{\link{getSurveyYearQuarterList}} \tab quarters\cr
#'   \code{\link{getDatrasDataOverview}}    \tab surveys, years, and quarters
#' }
#' \emph{Basic queries (thin web service wrappers):}\cr
#' \code{getCAdata},
#' \code{getHHdata},
#' \code{getHLdata},
#' \code{getIndices},
#' \code{getSurveyList},
#' \code{getSurveyYearList},
#' \code{getSurveyYearQuarterList}
#'
#' \emph{Derived queries (combining web services with R computations):}\cr
#' \code{getCatchWgt},
#' \code{getDatrasDataOverview},
#' \code{getDATRAS}
#'
#' @author Colin Millar, Scott Large, and Arni Magnusson.
#'
#' @references
#' ICES DATRAS database: \url{http://datras.ices.dk}.
#'
#' ICES DATRAS web services:
#' \url{https://datras.ices.dk/WebServices/Webservices.aspx}.

NA
