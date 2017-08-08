#' Calculates multidimentsional index from linear
#'
#' @param wanted linear index
#' @param diml vector of usually 3 dimensions describing dimension size
#' @return vector of multidimensional index
#' @note can work with arbritary dimensions, but typically uses three
#' @note this function does not check whether the final index is in
#' range of the final dimension, it simply wraps around.
#' @note internally uses zero based index for calculation
#' @examples
#' \dontrun{
#' dim_calc(1, c(4, 3))
#' dim_calc(4, c(4, 3))
#' dim_calc(5, c(4, 3))
#' dim_calc(12, c(4, 3))
#' dim_calc(13, c(4, 3))
#' }
dim_calc <- function(wanted, diml){
  dimhelper <- function(i, wid) c(i %% wid, i %/% wid)
  # zero indexed calculation
  res <- rep(NA, length(diml))
  cu <- c(0, wanted-1)
  for (i in seq_along(diml)){
    cu <- dimhelper(cu[[2]], diml[[i]])
    res[i] <- cu[[1]]
  }
  res + 1
}
