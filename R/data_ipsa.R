#' @name ipsa
#' @docType data
#' @title MPs expenses from the Independent Standards Authority
#' @description
#' The combined individual UK MP expenses data from May 2010 to 2018-03-31
#'
#' @usage data("ipsa")
#' @format{
#'  A data frame with 1,446,219 observations of 27 variables.
#'  \describe{
#'     \item{\code{year}}{a character vector}
#'     \item{\code{date}}{a Date}
#'     \item{\code{claim_no}}{a character vector}
#'     \item{\code{mps_name}}{a character vector}
#'     \item{\code{mps_constituency}}{a character vector}
#'     \item{\code{category}}{a character vector}
#'     \item{\code{expense_type}}{a character vector}
#'     \item{\code{short_description}}{a character vector}
#'     \item{\code{details}}{a character vector}
#'    \item{\code{journey_type}}{a character vector}
#'    \item{\code{from}}{a character vector}
#'    \item{\code{to}}{a character vector}
#'    \item{\code{travel}}{a character vector}
#'    \item{\code{nights}}{a numeric vector}
#'    \item{\code{mileage}}{a numeric vector}
#'    \item{\code{amount_claimed}}{a numeric vector}
#'    \item{\code{amount_paid}}{a numeric vector}
#'    \item{\code{amount_not_paid}}{a numeric vector}
#'    \item{\code{amount_repaid}}{a numeric vector}
#'    \item{\code{status}}{a character vector}
#'    \item{\code{reason_if_not_paid}}{a character vector}
#'    \item{\code{member_id}}{data.parliament id, a character vector}
#'    \item{\code{current_role}}{derived field from name matching, see vignette, a character vector}
#'    \item{\code{ipsa_name}}{the IPSA name, duplicates mps_name, character}
#'    \item{\code{dp_name}}{data.parliament name, duplicates display_as, character}
#'  }
#' }
#' @examples
#' data(ipsa)
## maybe str(ipsa) ; plot(ipsa) ...
#'
#' @keywords {datasets}
"ipsa"
