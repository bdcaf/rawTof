#' retrieve sum spectrum
#'
#' @export
#' @param fid h5d file handle
#' @seealso \code{get_single_scan} which returns individual scans
#' @import rhdf5
#' @examples
#' \dontrun{
#' get_sum_spec("toffile.h5")
#' }
get_sum_spec <- function(tof_file) h5read(tof_file, "FullSpectra/SumSpectrum")
