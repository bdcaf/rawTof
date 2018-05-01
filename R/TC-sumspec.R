#' @include TofClass.R
NULL

#' read the sum spectrum
#' @export
#' @import rhdf5
#' @rdname TofClass-class
setGeneric(name = "sumspec", def = function(.Object) {
             standardGeneric("sumspec")
                     })


setMethod("sumspec", "TofClass", function(.Object){
         ds <- H5Dopen(.Object@.datafile, "FullSpectra/SumSpectrum")
         out <- H5Dread(ds)
         H5Dclose(ds)
         out / .Object@single_ion_signal
                     })

#' read the sum spectrum direct from file
#' @param filename name of h5 file
#' @return sum spectrum
#' @export
directSumSpec <- function(filename){
    tof_ob <- new("TofClass", filename = in_file)
    on.exit( finalize(tof_ob) )

    sumspec(tof_ob)
}
