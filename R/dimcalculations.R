dimhelper <- function(i, wid) c(i %% wid, i %/% wid)
dim_calc <- function(wanted, diml){
  # zero indexed calculation
  res <- rep(NA, length(diml))
  cu <- c(0, wanted-1)
  for (i in seq_along(diml)){
    cu <- dimhelper(cu[[2]], diml[[i]])
    res[i] <- cu[[1]]
  }
  res + 1
}
