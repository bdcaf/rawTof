#' retrieve matrix of precalculated peaks
#'
#' @export
#' @param fid h5d file handle
#' @return matrix of all peaks captured in Ionicion sofrtware
#' @examples
#' \dontrun{
#' fid <- h5open('toffile.h5')
#' get_peak_matrix(fid)
#' }
get_peak_matrix <- function(fid){
  peak.data <- H5Dread(H5Dopen(fid, "PeakData/PeakTable"))
  peak.value <- H5Dread(H5Dopen(fid, "PeakData/PeakData"))
  peak.matrix <- matrix(peak.value, nrow=dim(peak.value)[1])
  rownames(peak.matrix) <- paste("mz", peak.data$mass)
  peak.matrix
}
