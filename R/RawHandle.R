#' S3 class constructor for TOF object
#'
#' stores repeatedly used object information
#' @param filename name of the h5 file
#' @return S3 object
#' @export
#' @examples
#' \dontrun{
#' rh <- raw_handle("mytof.h5")
#' }
raw_handle <- function(filename){
  fid <- H5Fopen(filename)
  tofblock <- H5Dopen(H5Gopen(fid, "FullSpectra"), "TofData")
  h5space <- H5Dget_space(tofblock)
  dims <- H5Sget_simple_extent_dims(h5space)

  out <- list(file = filename,
              fid = fid,
              full_dims = dims,
              full_space = h5space,
              pos_calc = function(id) dim_calc(i, dims$size[-1])
              )

  class(out) <- append(class(out), "raw_handle")
  return(out)
}
