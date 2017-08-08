#' extract a single scan from tof spectrum
#'
#' @note the data block is opened with each individual call in scripts
#' it may prove usefull to open it once and make smaller interactions
#' with it.
#' @note this function does not check whether the scan is in the range
#' of measurement.  Checks will need to be done manually!
#' @note Theoretically the full matrix of scans could be loaded similar
#' to get_peak_matrix - but this will take loads of memory and usually
#' is not desirable.
#' @export
#' @param fid h5d file handle
#' @param id index of scan
#' @return vector of single scan
#' @seealso \code{get_sum_spec} which return the precalculated sum of
#' all individual scans
#' @examples
#' \dontrun{
#' fid <- h5open('toffile.h5')
#' get_single_scan(fid,1)
#' }
get_single_scan <- function(fid, id){
  tofblock <- H5Dopen(H5Gopen(fid, "FullSpectra"), "TofData")
  h5space <- H5Dget_space(tofblock)
  dims <- H5Sget_simple_extent_dims(h5space)
  h5spacemem <- H5Screate_simple(dims$size[[1]])

  pos <- dim_calc(id, dims$size[-1])
  slab <- H5Sselect_hyperslab(h5space,
                              start = c(1, pos),
                              count = c(dims$size[[1]], rep(1, 3)) )
  H5Dread(h5dataset = tofblock,
          h5spaceFile = h5space,
          h5spaceMem = h5spacemem )
}
