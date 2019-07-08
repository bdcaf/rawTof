#' An S4 class to hold reused values for reading the spectrum
#'
#' @slot filename location of original h5 file
#' @slot points per scan
#' @slot nscans number of scans
#' @slot .dims internal dimensions
#' @slot .datafile h5 handle of tof data file
#' @slot .scandata h5 handle of scan data block
#' @slot .scanspace h5 handle of scan data array
#' @slot single_ion_signal cps value of single count
#' @export
#' @exportClass TofClass
#' @name TofClass
#' @aliases TofClass-class
#' @import rhdf5
#' @rdname TofClass-class
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




.read_attrib <- function(df, att){
  gg <- H5Gopen(df, "FullSpectra")
  ao <- H5Aopen(gg, att)
  out <- H5Aread(ao)
  H5Gclose(gg)
  H5Aclose(ao)
  return(out)
}

setMethod("initialize", "TofClass",
          function(.Object, filename,...){
            .Object@filename <- filename

            tmpOpen <- H5Fopen(.Object@filename)
            if (is.logical(tmpOpen) && !tmpOpen){
              stop("H5 file is not present or invalid!")
            }

            .Object@.datafile <- tmpOpen
            .Object@.scandata <- H5Dopen(.Object@.datafile,
                                         "FullSpectra/TofData")
            .Object@.scanspace <- H5Dget_space(.Object@.scandata)

            .Object@.dims  <- H5Sget_simple_extent_dims(.Object@.scanspace)$size
            .Object@points <- .Object@.dims[[1]]
            .Object@nscans <- prod(.Object@.dims[-1])

            .Object@single_ion_signal <-
              .read_attrib(.Object@.datafile,
                           "Single Ion Signal")[[1]]
            .Object
          })

# use finalizer
setGeneric(name = "finalize", def = function(.Object) {
             standardGeneric("finalize")
                     })


setMethod("finalize", "TofClass", function(.Object){
            H5Sclose(.Object@.scanspace)
            H5Dclose(.Object@.scandata)
            H5Fclose(.Object@.datafile)
                     })
