#' Get Catch Weights
#'
#' Calculate the total reported catch weight by species and haul.
#'
#' @param survey the survey acronym e.g. NS-IBTS.
#' @param years a vector of years of the survey, e.g. c(2010, 2012) or 2005:2010.
#' @param quarters a vector of quarters of the year the survey took place, e.g. c(1, 4) or 1:4.
#' @param aphia a vector of Aphia species codes defined in the WoRMS database, e.g. c(126436, 1264374).
#'
#' @return A data frame.
#'
#' @note
#' The \pkg{icesVocab} package provides \code{findAphia}, a function to look up Aphia species codes.
#'
#' @seealso
#' \code{\link{getSurveyYearList}}, \code{\link{getSurveyYearQuarterList}}, and
#' \code{\link{getDatrasDataOverview}} also list available data.
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' getCatchWgt(survey = "ROCKALL", years = 2002, quarters = 3, aphia = 126437)
#'
#' # look up specific species
#' aphia <- icesVocab::findAphia(c("cod", "haddock"))
#' cwt <- getCatchWgt(survey = "ROCKALL", years = 2002, quarters = 3, aphia = aphia)
#' }
#' @export

getCatchWgt <- function(survey, years, quarters, aphia) {

  # get data
  hh <- getDATRAS("HH", survey, years, quarters)
  hl <- getDATRAS("HL", survey, years, quarters)

  # process HL record
  ## add HaulID for later merging
  hh$HaulID <-
    with(
      hh,
      factor(
        paste(
          Year, Quarter, Country, Ship, Gear, StNo, HaulNo,
          sep = ":"
        )
      )
    )

  hl$HaulID <-
    with(
      hl,
      factor(
        paste(
          Year, Quarter, Country, Ship, Gear, StNo, HaulNo,
          sep = ":"
        )
      )
    )
  key <-
    c(
      "Year", "Quarter", "Country", "Ship", "Gear", "StNo",
      "HaulNo", "HaulID"
    )


  ## loop over available species unless a restricted set is asked for
  sp_codes <- unique(hl$Valid_Aphia)
  sp_codes <- intersect(sp_codes, aphia)
  message(
    "Extracting total catch weight by species and haul for ",
    length(sp_codes), " species"
  )

  # drop unused data
  hl <- hl[hl$Valid_Aphia %in% sp_codes,]

  # create a table to hold total catch weights (could just copy HH in full)
  catchwgt <- hh # could restrict what we return[key]
  # set to zero, because no data ascribed to a haul means no fish caught
  catchwgt$CatchWgt <- 0
  row.names(catchwgt) <- catchwgt$HaulID
  catchwgt <- catchwgt[names(catchwgt) != "HaulID"]

  # run the loop
  out <-
    do.call(
      rbind,
      lapply(
        sp_codes,
        function(x) {
          # get unique catch weights for single species
          wk <-
            unique(
              hl[
                hl$Valid_Aphia == x,
                c(key, "CatIdentifier", "CatCatchWgt")
              ]
            )
          # these will include multiples if there was subsampling
          # applied to different parts of the catch sum these up over
          # HaulID
          tbl <- tapply(wk$CatCatchWgt, wk$HaulID, sum)
          # add into catchwgt data using row names to insert into
          # correct location
          out <- catchwgt
          out[names(tbl), "CatchWgt"] <- c(tbl)
          out$Valid_Aphia <- x
          out
        }
      )
    )

  rownames(out) <- NULL
  out
}
