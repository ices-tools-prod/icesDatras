#' @importFrom RCurl basicTextGatherer
#' @importFrom RCurl curlPerform
curlDatras <- function(url) {
  # read only XML table and return as string
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
  # capture.output is used to suppress the output message from xmlns:
  #   "xmlns: URI ices.dk.local/DATRAS is not absolute"

  # convert xml to data frame, with appropriate column types
  x <- simplify(xmlToDataFrame(x, stringsAsFactors = FALSE))

  # return data frame now if empty
  if (nrow(x) == 0) return(x)

  # clean trailing white space from text columns
  charcol <- which(sapply(x, is.character))
  x[charcol] <- lapply(x[charcol], function(x) gsub("[[:space:]]*$", "", x))

  # DATRAS uses -9 and "" to indicate NA
  x[x == -9] <- NA
  x[x == ""] <- NA
  simplify(x)  # simplify again, as ""->NA may enable us to coerce char->num/int
}


checkDatrasWebserviceOK <- function() {
  # return TRUE if webservice server is good, FALSE otherwise
  out <- curlDatras(url = "https://datras.ices.dk/WebServices/DATRASWebService.asmx")

  # Check the server is not down by insepcting the XML response for internal server error message.
  if (grepl("Internal Server Error", out)) {
    warning("Web service failure: the server seems to be down, please try again later.")
    FALSE
  } else {
    TRUE
  }
}


simplify <- function(x) {
  # from Arni's toolbox
  # coerce object to simplest storage mode: factor > character > numeric > integer
  owarn <- options(warn = -1)
  on.exit(options(owarn))
  # list or data.frame
  if (is.list(x)) {
    if (is.data.frame(x)) {
      old.row.names <- attr(x, "row.names")
      x <- lapply(x, simplify)
      attributes(x) <- list(names = names(x), row.names = old.row.names, class = "data.frame")
    }
    else
      x <- lapply(x, simplify)
  }
  # matrix
  else if (is.matrix(x))
  {
    if (is.character(x) && sum(is.na(as.numeric(x))) == sum(is.na(x)))
      mode(x) <- "numeric"
    if (is.numeric(x))
    {
      y <- as.integer(x)
      if (sum(is.na(x)) == sum(is.na(y)) && all(x == y, na.rm = TRUE))
        mode(x) <- "integer"
    }
  }
  # vector
  else
  {
    if (is.factor(x))
      x <- as.character(x)
    if (is.character(x))
    {
      y <- as.numeric(x)
      if (sum(is.na(y)) == sum(is.na(x)))
        x <- y
    }
    if (is.numeric(x))
    {
      y <- as.integer(x)
      if (sum(is.na(x)) == sum(is.na(y)) && all(x == y, na.rm = TRUE))
        x <- y
    }
  }
  x
}
