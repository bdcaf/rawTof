#' An S4 class to hold reused values for reading the spectrum
#'
#' @slot filename location of original h5 file
#' @slot points per scan
#' @slot nscans number of scans
#' @slot .dims internal dimensions
#' @export
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


setMethod("initialize", "TofClass", function(.Object, filename){
            .Object@filename <- filename
            .Object@.datafile <- H5Fopen(.Object@filename)
            .Object@.scandata <- H5Dopen(.Object@.datafile, "FullSpectra/TofData")
            .Object@.scanspace <- H5Dget_space(.Object@.scandata)

            .Object@.dims  <- H5Sget_simple_extent_dims(.Object@.scanspace)$size
            .Object@points <- .Object@.dims[[1]]
            .Object@nscans <- prod(.Object@.dims[-1])

            .Object@single_ion_signal <- .read_attrib(.Object@.datafile, "Single Ion Signal")[[1]]

            .Object
                     })

#' do cleanup, call this before leaving
#' @export
setGeneric(name="finalize", def=function(.Object) {
             standardGeneric("finalize")
                     })


setMethod("finalize", "TofClass", function(.Object){
            H5Sclose(.Object@.scanspace)
            H5Dclose(.Object@.scandata)
            H5Fclose(.Object@.datafile)
                     })

#' read the sum spectrum
#' @export
setGeneric(name="sumspec", def=function(.Object) {
             standardGeneric("sumspec")
                     })


setMethod("sumspec", "TofClass", function(.Object){
         ds <- H5Dopen(.Object@.datafile, "FullSpectra/SumSpectrum")
         out <- H5Dread(ds)
         H5Dclose(ds)
         out/.Object@single_ion_signal
                     })

#' read the spectrum of scan i
#' @export
setGeneric(name="scan_ind", def=function(.Object, ind) {
             standardGeneric("scan_ind")
                     })


setMethod("scan_ind", "TofClass", function(.Object, ind){
            pos <- dim_calc(ind, .Object@.dims[-1])
            H5Sselect_hyperslab(.Object@.scanspace,
                                start = c(1, pos[[1]], pos[[2]], pos[[3]]),
                                count = c(.Object@points, 1, 1, 1) )
            h5spacemem <- H5Screate_simple(.Object@points)
            out <- H5Dread(h5dataset=.Object@.scandata, h5spaceFile=.Object@.scanspace,
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
