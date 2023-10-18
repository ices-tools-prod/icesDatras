#' @export
 .onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Welcome to icesDatras\n",
    "Please read the full disclaimer here:\n",
    "  https://github.com/ices-tools-prod/disclaimers/blob/master/Disclaimer_DATRAS_ExchangeData.txt\n",
    "Please be aware that there are known issues with the way CatCatchWgt has been reported until 2023.\n",
    "You can check known data issues here:\n",
    "  https://www.ices.dk/data/data-portals/Pages/Datras_news_and_updates.aspx\n"
  )
}
