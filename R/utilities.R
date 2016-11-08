#' @importFrom RCurl basicTextGatherer
#' @importFrom RCurl curlPerform
curlDatras <- function(url) {
  # read only XML table and return as string
  reader <- basicTextGatherer()
  curlPerform(url = url,
              httpheader = c('Content-Type' = "text/xml; charset=utf-8", SOAPAction = ""),
              writefunction = reader$update,
              verbose = FALSE)
  # return
  reader$value()
}


#' @importFrom XML xmlParse
#' @importFrom XML xmlRoot
#' @importFrom XML xmlSize
#' @importFrom XML getChildrenStrings
#' @importFrom XML removeNodes
#' @importFrom utils capture.output
parseDatras <- function(x, use.strsplit = FALSE) {
  if (use.strsplit) {
    # simply parse using line and column separators
    x <- gsub("<Cls_Datras[a-zA-Z_]*>", "<rowstart>", x)
    x <- strsplit(x, "<rowstart>\r\n")[[1]][-1]

    # exit if no data is being returned
    if (length(x) == 0) return(NULL)

    # split rows into columns
    x <- strsplit(x, "\r\n")

    # get column names from XML format
    names_x <- gsub("[</>]", "", regmatches(x[[1]], gregexpr("</.*?>", x[[1]])))

    # get data from XML format
    x <- sapply(x, function(j) gsub("[<>]", "", regmatches(j, gregexpr(">.*?<", j))))
    # chop off junk at end of rows
    x <- x[1:(nrow(x)-2),,drop=FALSE]
    row.names(x) <- names_x[1:nrow(x)]
  } else {
    # parse XML string to data frame
    capture.output(x <- xmlParse(x))
    # capture.output is used to suppress the output message from xmlns:
    #   "xmlns: URI ices.dk.local/DATRAS is not absolute"

    # work with root node
    x <- xmlRoot(x)

    # exit if no data is being returned
    if (xmlSize(x) == 0) return(NULL)
    nc <- length(getChildrenStrings(x[[1]]))

    # read XML values into matrix, then convert to data frame
    x <- replicate(xmlSize(x), {
    # remove top record after reading to optimize speed and memory
                    out <- getChildrenStrings(x[[1]])  # peek
                    removeNodes(x[[1]])                # pop
                    out
                  })
    if (nc == 1) x <- matrix(x, 1, length(x), dimnames = list(names(x[1])))
  }
  x <- as.data.frame(t(x), stringsAsFactors = FALSE)

  fudged <- FALSE
  if ("StatRec" %in% names(x)) {
    # fudge
    x <- rbind(x, x[1,])
    x$StatRec[nrow(x)] <- "10A1"
    fudged <- TRUE
  }
  x <- simplify(x)

  # return data frame now if empty
  if (nrow(x) == 0) return(x)

  # clean trailing white space from text columns
  charcol <- which(sapply(x, is.character))
  x[charcol] <- lapply(x[charcol], trimws)

  # DATRAS uses -9 and "" to indicate NA
  x[x == -9] <- NA
  x[x == ""] <- NA
  x <- simplify(x)  # simplify again, as ""->NA may enable us to coerce char->num/int

  # unfudge
  if (fudged) x <- x[-nrow(x),]

  # return
  x
}


checkDatrasWebserviceOK <- function() {
  # return TRUE if web service is active, FALSE otherwise
  out <- curlDatras("https://datras.ices.dk/WebServices/DATRASWebService.asmx")

  # check server is not down by inspecting XML response for internal server error message
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
