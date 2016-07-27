#' @importFrom RCurl basicTextGatherer
#' @importFrom RCurl curlPerform
curlDatras <- function(url) {
  # read only XML table and return as txt string
  reader <- basicTextGatherer()
  curlPerform(url = url,
              httpheader = c('Content-Type' = "text/xml; charset=utf-8", SOAPAction=""),
              writefunction = reader$update,
              verbose = FALSE)
  # return
  reader$value()
}


#' @importFrom XML xmlParse
#' @importFrom XML xmlToDataFrame
#' @importFrom utils capture.output
parseDatras <- function(x) {
  # parse the xml text string suppplied by the Datras webservice
  # returning a dataframe
  capture.output(x <- xmlParse(x))
  # capture.output is used to stiffle the output message from xmlns:
  #   "xmlns: URI ices.dk.local/DATRAS is not absolute"

  # return
  xmlToDataFrame(x)
}


checkDatrasWebserviceOK <- function() {
  # return TRUE if webservice server is good, FALSE otherwise
  out <- curlDatras(url = "https://datras.ices.dk/WebServices/DATRASWebService.asmx")

  # Check the server is not down by insepcting the XML response for internal server error message.
  if(grepl("Internal Server Error", out)) {
    warning("Web service failure: the server seems to be down, please try again later.")
    FALSE
  } else {
    TRUE
  }
}


