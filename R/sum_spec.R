#' retrieve sum spectrum
#'
#' @export
#' @param fid h5d file handle
#' @seealso \code{get_single_scan} which returns individual scans
#' @examples
#' \dontrun{
#' fid <- h5open('toffile.h5')
#' get_sum_spec(fid)
#' }
get_sum_spec <- function(fid) H5Dread(H5Dopen(fid, "FullSpectra/SumSpectrum"))
