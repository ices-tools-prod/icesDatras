
#' @importFrom utils download.file
readDatras <- function(url) {
  # try downloading first:
  # create file name
  tmp <- tempfile()
  on.exit(unlink(tmp))

  # download file
  ret <-
    if (os.type("windows")) {
      download.file(url, destfile = tmp, quiet = TRUE)
    } else if (os.type("unix") & Sys.which("wget") != "") {
      download.file(url, destfile = tmp, quiet = TRUE, method = "wget")
    } else if (os.type("unix") & Sys.which("curl") != "") {
      download.file(url, destfile = tmp, quiet = TRUE, method = "curl")
    } else {
      127
    }

  # check return value
  if (ret == 0) {
    # scan lines
    scan(tmp, what = "", sep = "\n", quiet = TRUE)
  } else {
    message("Unable to download file so using slower method url().\n",
            "Try setting an appropriate value via\n\t",
            "options(download.file.method = ...)\n",
            "see ?download.file for more information.")
    # connect to url
    con <- url(url)
    on.exit(close(con))

    # scan lines
    scan(con, what = "", sep = "\n", quiet = TRUE)
  }
}



parseDatras <- function(x) {
  # parse using line and column separators
  type <- gsub(" *<ArrayOf(.*?) .*", "\\1", x[2])

  # convert any lazy teminated feilds to full feilds
  x <- gsub("^ *<(.*?) />$", "<\\1> NA </\\1>", x)
  starts <- grep(paste0("<", type, ">"), x)
  ends <- grep(paste0("</", type, ">"), x)
  ncol <- unique(ends[1] - starts[1]) - 1
  # drop everything we don't need
  x <- x[-c(1, 2, starts, ends, length(x))]

  # exit if no data is being returned
  if (length(x) == 0) return(NULL)

  # match content of first <tag>
  names_x <- gsub(" *<(.*?)>.*", "\\1", x[1:ncol])

  # delete all <tags>
  x <- gsub(" *<.*?>", "", x)
  # trim white space
  x <- trimws(x)

  # convert to data frame
  dim(x) <- c(ncol, length(x)/ncol)
  row.names(x) <- names_x
  x <- as.data.frame(t(x), stringsAsFactors = FALSE)

  # return data frame now if empty
  if (nrow(x) == 0) return(x)

  # DATRAS uses -9 and "" to indicate NA
  x[x == -9] <- NA
  x[x == ""] <- NA

  # simplify all columns except StatRec and AreaCode (so "45e6" does not become 45000000)
  x[!names(x) %in% c("StatRec", "AreaCode", "Ship")] <- simplify(x[!names(x) %in% c("StatRec", "AreaCode", "Ship")])

  x
}



# TODO - combine the check into readDatras - and do it at the download.file stage...
checkDatrasWebserviceOK <- function() {
  # return TRUE if web service is active, FALSE otherwise
  out <- readDatras("https://datras.ices.dk/WebServices/DATRASWebService.asmx/getSurveyList")

  # check server is not down by inspecting XML response for internal server error message
  if (grepl("Internal Server Error", out[1])) {
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
    for (i in seq_len(length(x)))
      x[[i]] <- simplify(x[[i]])
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

# function to apply type fixes and new naming convention. 
# Falls back to package default settings if arguments not provided
formatDatras <- function(df, record = NULL, new_names = getOption("icesDatras.new_names"), fix_types = getOption("icesDatras.fix_types")){
  stopifnot(new_names %in% c(TRUE, FALSE))
  stopifnot(fix_types %in% c(TRUE, FALSE))
  
  if (fix_types) {
    df <- applyDatrasTypeSchema(df, record = record)
  }
  
  if (new_names) {
    df <- applyDatrasNameSchema(df, record = record)
  }
  df
}

#Applies correct column types to DATRAS output
applyDatrasTypeSchema <- function(df, record = NULL) {
  
  datras_field_list <- getDatrasFieldList()
  
  if (!is.null(record)) {
    datras_field_list <- datras_field_list[datras_field_list["RecordHeader"] == record,]
  }
  
  char_cols <- c(datras_field_list[datras_field_list[["DataFormat"]] == "char", "FieldNameOld"],
                 datras_field_list[datras_field_list[["DataFormat"]] == "char", "FieldName"])
  
  int_cols <-  c(datras_field_list[datras_field_list[["DataFormat"]] == "int", "FieldNameOld"],
                 datras_field_list[datras_field_list[["DataFormat"]] == "int", "FieldName"])
  
  dbl_cols <-  c(datras_field_list[datras_field_list[["DataFormat"]] == "decimal", "FieldNameOld"],
                 datras_field_list[datras_field_list[["DataFormat"]] == "decimal", "FieldName"])
  
  char_cols <- intersect(char_cols, names(df))
  int_cols  <- intersect(int_cols, names(df))
  dbl_cols  <- intersect(dbl_cols, names(df))
  
  df[char_cols] <- lapply(df[char_cols], as.character)
  df[int_cols]  <- lapply(df[int_cols], as.integer)
  df[dbl_cols]  <- lapply(df[dbl_cols], as.numeric)
  
  df
}

# Applies new DATRAS column names to Datras output
applyDatrasNameSchema <- function(df, record = NULL) {
  
  datras_field_list <- getDatrasFieldList()
  
  if (!is.null(record)) {
    datras_field_list <- datras_field_list[datras_field_list[["RecordHeader"]] == record,]
  }
  
  cols <- intersect(datras_field_list$FieldNameOld, names(df))
  row_ids <- match(cols, datras_field_list$FieldNameOld)
  match_ids <- match(cols, names(df))
  names(df)[match_ids] <- datras_field_list$FieldName[row_ids]
  df
}



# returns TRUE if correct operating system is passed as an argument
os.type <- function (type = c("unix", "windows", "other"))
{
  type <- match.arg(type)
  if (type %in% c("windows", "unix")) {
    .Platform$OS.type == type
  } else {
    TRUE
  }
}
