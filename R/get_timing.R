#' get exact time information of scans
#'
#' @export
#' @note at some point the date format changed. Currently need to try several
#' @import rhdf5
#' @param fid h5d file handle
#' @return vector of all measurment times
#' @examples
#' \dontrun{
#' get_timing("tof_file.h5")
#' }
get_timing <- function(fid){
  # note maybe use: h5readAttributes(fid, "TimingData")
  timing_mat <- h5read(fid, "TimingData/BufTimes",
                       read.attributes = T)
  times <- matrix(timing_mat, ncol = 1)
  atts <- h5readAttributes(fid, "/")
  start_time <- as.POSIXct(atts[["HDF5 File Creation Time"]],
                           format = "%d.%m.%Y %H:%M:%S")
  if (is.na(start_time))
        start_time <- as.POSIXct(atts[["HDF5 File Creation Time"]],
                           format = "%d/%m/%Y %H:%M:%S")

  start_time + c(times)
}
