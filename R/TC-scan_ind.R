#' @include TofClass.R
NULL


#' read the spectrum of scan i
#' @import rhdf5
#' @export
#' @rdname TofClass-class
setGeneric(name = "scan_ind", def = function(.Object, ind) {
             standardGeneric("scan_ind")
                     })


setMethod("scan_ind", "TofClass",
          function(.Object, ind){
            pos <- dim_calc(ind, .Object@.dims[-1])
            H5Sselect_hyperslab(.Object@.scanspace,
                                start = c(1, pos[[1]], pos[[2]], pos[[3]]),
                                count = c(.Object@points, 1, 1, 1) )
            h5spacemem <- H5Screate_simple(.Object@points)
            out <- H5Dread(h5dataset = .Object@.scandata,
                           h5spaceFile = .Object@.scanspace,
                           h5spaceMem = h5spacemem)
            H5Sclose(h5spacemem)
            out / .Object@single_ion_signal
          })
