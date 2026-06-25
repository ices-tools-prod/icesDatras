#' Get Datras field list with column classes and mapping to old naming schema
#'
#' @return A dataframe
#' @export
#' @importFrom XML xmlToDataFrame
getDatrasFieldList <- function() {

  url <- "https://datras.ices.dk/WebServices/DATRASWebService.asmx/getDatrasFieldList"
  # read XML string and parse to data frame
  response <- readDatras(url)
  response2 <- gsub(
    'xmlns="ices.dk.local/DATRAS"',
    'xmlns="https://ices.dk.local/DATRAS"',
    response,
    fixed = TRUE
  )
  out <- xmlToDataFrame(response2)
  out <- lapply(out, trimws)
  out <- as.data.frame(out)
  out
}



