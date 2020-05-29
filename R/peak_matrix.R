#' retrieve matrix of precalculated peaks
#'
#' @export
#' @import rhdf5
#' @param fid h5d file handle
#' @return matrix of all peaks captured in Ionicion sofrtware
#' @examples
#' \dontrun{
#' get_peak_matrix(fid)
#' }
get_peak_matrix <- function(fid) {
    peak_table <- h5read(fid, "PeakData/PeakTable", read.attributes = T)
    peak_data <- h5read(fid, "PeakData/PeakData")
    peak_matrix <- matrix(peak_data, nrow = dim(peak_data)[1])
    rownames(peak_matrix) <- with(peak_table, paste(label, mass))
    peak_matrix
}
