#' @include TofClass.R
NULL

#' read stored mass cal
#' @param .Object an object
#' @return list with mass cal functions
#' @export
setGeneric(name = "storedMassCal", def = function(.Object) {
    standardGeneric("storedMassCal")
})

#' read the sum spectrum
#' @export
#' @import rhdf5
#' @rdname TofClass-class
setMethod("storedMassCal", "TofClass", function(.Object) {
    ds <- H5Dopen(.Object@.datafile, "FullSpectra/SumSpectrum")
    out <- H5Dread(ds)
    H5Dclose(ds)
    out/.Object@single_ion_signal
})
