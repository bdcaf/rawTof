#' @include TofClass.R
NULL

#' read the sum spectrum
#' @export
#' @import rhdf5
setGeneric(name = "sumspec", def = function(.Object) {
             standardGeneric("sumspec")
                     })


setMethod("sumspec", "TofClass", function(.Object){
         ds <- H5Dopen(.Object@.datafile, "FullSpectra/SumSpectrum")
         out <- H5Dread(ds)
         H5Dclose(ds)
         out / .Object@single_ion_signal
                     })
