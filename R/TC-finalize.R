#' @include TofClass.R
NULL

#' do cleanup, call this before leaving
#' @rdname TofClass-class
setGeneric(name = "finalize", def = function(.Object) {
             standardGeneric("finalize")
                     })


setMethod("finalize", "TofClass", function(.Object){
            H5Sclose(.Object@.scanspace)
            H5Dclose(.Object@.scandata)
            H5Fclose(.Object@.datafile)
                     })
