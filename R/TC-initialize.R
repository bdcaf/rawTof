#' @include TofClass.R
NULL


#' initializes TofClass based on filename
#' @name TofClass
#' @rdname TofClass-class
#' @export
initialize <- function(.Object, filename){
            .Object@filename <- filename
            .Object@.datafile <- H5Fopen(.Object@filename)
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
          }

#' @export
#' @name TofClass
#' @rdname TofClass-class
setMethod("initialize", "TofClass", initialize)
