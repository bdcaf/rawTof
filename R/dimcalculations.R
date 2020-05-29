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
dim_calc <- function(wanted, diml) {
    w1 <- wanted - 1
    res <- dim_private(w1, diml)
    return(res + 1)
}

dim_private <- function(wanted, diml) {
    if (length(diml) == 0)
        stop("Too small data block.")
    size_here <- diml[[1]]
    size_next <- diml[-1]
    here <- divmod(wanted, size_here)
    if (here[["div"]] == 0)
        return(c(here[["mod"]], rep(0, length(size_next))))
    return(c(here[["mod"]], dim_private(here[["div"]], size_next)))
}

divmod <- function(i, wid) c(mod = i%%wid, div = i%/%wid)
