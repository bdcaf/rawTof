#' retrieve sum spectrum
#' @export
#' @param fid h5d file handle
get_sum_spec <- function(fid) H5Dread(H5Dopen(fid, "FullSpectra/SumSpectrum"))
