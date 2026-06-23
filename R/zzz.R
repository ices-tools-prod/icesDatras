#' @importFrom memoise memoise
#' @importFrom cachem cache_mem
#' @importFrom rlang hash

# Expire items in cache after 24 hours
getcache <- cachem::cache_mem(max_age = 60*24 * 60)


.onLoad <- function(libname, pkgname) {
  
  getDATRASCatched <<- memoise::memoise(getDATRASCatched,
                                        cache = getcache,
                                        hash = function(x) hash(paste0(x$url))
  )
  
  getDatrasFieldList <<- memoise::memoise(getDatrasFieldList,
                                        cache = getcache,
                                        hash = function(x) hash(paste0(x$url))
  )
  
  opts <-
    c(
      icesDatras.new_names = FALSE,
      icesDatras.fix_types = TRUE
    )
  
  for (i in setdiff(names(opts), names(options()))) {
    eval(parse(text = paste0("options(", i, "=", opts[i], ")")))
  }
}



.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Welcome to icesDatras\n",
    "Please read the full disclaimer here:\n",
    "  https://github.com/ices-tools-prod/disclaimers/blob/master/Disclaimer_DATRAS_ExchangeData.txt\n",
    "Please be aware that there are known issues with the way CatCatchWgt has been reported until 2023.\n",
    "You can check known data issues here:\n",
    "  https://www.ices.dk/data/data-portals/Pages/Datras_news_and_updates.aspx\n\n",
    "icesDatras now enables users to set defaults options for column names and types.\n",
    " Please use`icesDatras::SetDatrasDefaults()` to change the defaults.\n",
    "Set new_names=TRUE to adopt the new DATRAS naming convention.\n",
    "Set fix_types=FALSE to revert to the prior icesDATRAS behaviour (It is recommended to update your workflow rather than choosing this option)."
  )
}

SetDatrasDefaults <- function(fix_types = getOption("icesDatras.fix_types"), 
                              new_names = getOption("icesDatras.new_names")){
  stopifnot(new_names %in% c(TRUE, FALSE))
  stopifnot(fix_types %in% c(TRUE, FALSE))
  options(icesDatras.fix_types = fix_types)
  message(paste0("icesDatras.fix_types set to ", fix_types))
  options(icesDatras.new_names = new_names)
  message(paste0("icesDatras.new_names set to ", new_names))
}