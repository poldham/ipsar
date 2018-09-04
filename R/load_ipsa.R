#' @title Load the IPSA MPs Expenses Table
#' @description Load the expenses table for Individual Members of the UK Parliament.
#' @return data.frame
#' @export
#' @examples \dontrun{load_ipsa()}
load_ipsa <- function(){
  ipsa <- load("data/ipsa.rda", .GlobalEnv)
}
