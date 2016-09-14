#' Get Reported Catch Weights
#'
#' Get the reported catch weight by species and haul.
#'
#' @param survey the survey acronym e.g. NS-IBTS.
#' @param years a vector of numeric years of the survey, e.g. c(2010, 2012), or 2005:2010.
#' @param quarters a vector of quarters of the year the survey took place, i.e. c(1, 4) or 1:4.
#' @param aphia_codes a vector of numeric 'aphia' codes defined in the WoRMS database, i.e. c(1, 4) or 1:4.
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{aphia}} a data.frame of aphia codes and latin species names
#'
#' \code{\link{getSurveyYearList}}, \code{\link{getSurveyYearQuarterList}}, and
#' \code{\link{getDatrasDataOverview}} also list available data.
#'
#'
#' \code{\link{icesDatras-package}} gives an overview of the package.
#'
#' @author Colin Millar.
#'
#' @examples
#' getCatchWgt(survey = "ROCKALL", years = 2002, quarters = 3, aphia_codes = "126437")
#'
#' # look up specific species
#' data(aphia)
#' aphia[pmatch("Gadus", aphia$species, duplicates.ok = TRUE),]
#' aphia[pmatch("Melano", aphia$species, duplicates.ok = TRUE),]
#'  species <- c("Gadus morhua", "Melanogrammus aeglefinus")
#' codes <- aphia[aphia$species %in% species,]
#' cwt <- getCatchWgt(survey = "ROCKALL", years = 2002, quarters = 3, aphia_codes = codes$aphia_code)
#'
#' @export
getCatchWgt <- function(survey, years, quarters, aphia_codes) {

  # get data
  hh <- getDATRAS("HH", survey, years, quarters)
  hl <- getDATRAS("HL", survey, years, quarters)

  # process HL record
  ## add HaulID for later merging
  hh$HaulID <- with(hh, paste(Year, Quarter, Ship, StNo, HaulNo, sep="."))
  hl$HaulID <- with(hl, paste(Year, Quarter, Ship, StNo, HaulNo, sep="."))
  key <- c("Year", "Quarter", "Ship", "StNo", "HaulNo", "HaulID")

  ## loop over available species unless a restricted set is asked for
  sp_codes <- unique(hl$Valid_Aphia)
  sp_codes <- intersect(sp_codes, aphia_codes)
  message("Extracting total catch weight by species and haul for ", length(sp_codes), " species")

  # drop unused data
  hl <- hl[hl$Valid_Aphia %in% sp_codes,]

  # Create a table to hold total catch weights (could just copy HH in full)
  catchwgt <- hh # could restrict what we return[key]
  # set to zero, because no data ascribed to a haul means no fish caught
  catchwgt$CatchWgt <- 0
  row.names(catchwgt) <- catchwgt$HaulID
  catchwgt <- catchwgt[names(catchwgt) != "HaulID"]

  # run the loop
  out <-
    do.call(rbind,
            lapply(sp_codes,
                   function(x) {
                     # get unique catch weights for single species
                     wk <- unique(hl[hl$Valid_Aphia == x, c(key, "CatIdentifier", "CatCatchWgt")])
                     # these will include multiples if there was subsampling applied to different parts of the catch
                     # sum these up over HaulID
                     tbl <- tapply(wk$CatCatchWgt, wk$HaulID, sum)
                     # add into catchwgt data using row names to insert into correct location
                     out <- catchwgt
                     out[names(tbl),"CatchWgt"] <- c(tbl)
                     out$Valid_Aphia <- x
                     out
                   })
    )

  rownames(out) <- NULL
  out
}

