#' An S4 class to hold reused values for reading the spectrum
#'
#' @slot filename location of original h5 file
#' @slot points per scan
#' @slot nscans number of scans
#' @slot .dims internal dimensions
#' @export
#' @exportClass TofClass
#' @name TofClass
#' @aliases TofClass-class
#' @import rhdf5
TofClass <- setClass("TofClass",
                     slots = c(
                               filename = "character",
                               points = "numeric",
                               nscans = "numeric",
                               single_ion_signal = "numeric",
                               .dims = "numeric",
                               .datafile = "H5IdComponent",
                               .scandata = "H5IdComponent",
                               .scanspace = "H5IdComponent"
                               ) )



#' read the spectrum of scan i
#' @export
setGeneric(name = "scan_ind", def = function(.Object, ind) {
             standardGeneric("scan_ind")
                     })


setMethod("scan_ind", "TofClass", function(.Object, ind){
            pos <- dim_calc(ind, .Object@.dims[-1])
            H5Sselect_hyperslab(.Object@.scanspace,
                                start = c(1, pos[[1]], pos[[2]], pos[[3]]),
                                count = c(.Object@points, 1, 1, 1) )
            h5spacemem <- H5Screate_simple(.Object@points)
            out <- H5Dread(h5dataset = .Object@.scandata,
                           h5spaceFile=.Object@.scanspace,
                           h5spaceMem=h5spacemem)
            H5Sclose(h5spacemem)
            out/.Object@single_ion_signal
                     })

.read_attrib <- function(df, att){
  gg <- H5Gopen(df, "FullSpectra")
  ao <- H5Aopen(gg, att)
  out <- H5Aread(ao)
  H5Gclose(gg)
  H5Aclose(ao)
  out
}
