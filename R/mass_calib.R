#' create functions to work with existing mass calibration
#'
#' @export
#' @param fid h5d file handle
#' @examples
#' \dontrun{
#' fid <- h5open('toffile.h5')
#' mc <- masscal_helper(fid)
#' with(mc, to_index(c(45,47)))
#' with(mc, to_mass(c(2000:3000)))
#' }
masscal_helper <- function(fid){
  gr <- h5readAttributes(fid, "FullSpectra")
  with(gr,
       list( to_mass = Vectorize(function(i) ( (i-`MassCalibration p2`)/`MassCalibration p1`)^2),
             to_index = Vectorize(function(m) `MassCalibration p2` + `MassCalibration p1`*sqrt(m))
             ))
}
