#' @title Load the IPSA data.parliament Concordance Table
#' @description Convenience function to load the Concordance Table between IPSA and data.parliament into the global environment.
#' @return data.frame
#' @export
#' @examples \dontrun{load_ipsa_commons()}
load_ipsa_commons <- function(){
  ipsa_commons <- load("data/ipsa_commons.rda", .GlobalEnv)
}
