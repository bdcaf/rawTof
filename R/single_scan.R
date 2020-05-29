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
#' @param toffile file name
#' @param id index of scan
#' @import rhdf5
#' @return vector of single scan
#' @seealso \code{get_sum_spec} which return the precalculated sum of
#' all individual scans
#' @examples
#' \dontrun{
#' get_single_scan('toffile.h5',1)
#' }
get_single_scan <- function(toffile, id) {
    fid <- H5Fopen(toffile)
    
    tofblock <- H5Dopen(H5Gopen(fid, "FullSpectra"), "TofData")
    h5space <- H5Dget_space(tofblock)
    dims <- H5Sget_simple_extent_dims(h5space)
    h5spacemem <- H5Screate_simple(dims$size[[1]])
    
    pos <- dim_calc(id, dims$size[-1])
    slab <- H5Sselect_hyperslab(h5space, start = c(1, pos), count = c(dims$size[[1]], 
        rep(1, 3)))
    out <- H5Dread(h5dataset = tofblock, h5spaceFile = h5space, h5spaceMem = h5spacemem)
    H5Sclose(h5space)
    H5Sclose(h5spacemem)
    H5Dclose(tofblock)
    H5Fclose(fid)
    return(out)
}
