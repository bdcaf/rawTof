#' @include TofClass.R
NULL

#' read the sum spectrum
#' @param .Object an object
#' @return sum spectrum as array of counts
#' @export
setGeneric(name = "sumspec", def = function(.Object) {
             standardGeneric("sumspec")
                     })


#' read the sum spectrum
#' @export
#' @import rhdf5
#' @rdname TofClass-class
setMethod("sumspec", "TofClass", function(.Object){
         ds <- H5Dopen(.Object@.datafile, "FullSpectra/SumSpectrum")
         out <- H5Dread(ds)
         H5Dclose(ds)
         out / .Object@single_ion_signal
                     })

#' read the sum spectrum direct from file
#' @param filename name of h5 file
#' @return sum spectrum
#' @import methods
#' @export
directSumSpec <- function(filename){
    tof_ob <- new("TofClass", filename = filename)
    on.exit( finalize(tof_ob) )
    sumspec(tof_ob)
}
