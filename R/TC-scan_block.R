#' @include TofClass.R
NULL


#' read a block with specified indices
#' @import rhdf5
#' @import magrittr
#' @export
#' @rdname TofClass-class
setGeneric(name = "scan_block", def = function(.Object, indrange) {
             standardGeneric("scan_block")
                     })


setMethod("scan_block", "TofClass",
          function(.Object, indrange){
            dd <- tof_ob@.dims
            block_size = c(indrange[[2]], dd[[2]], dd[[3]], dd[[4]])
            H5Sselect_hyperslab(.Object@.scanspace,
                                start = c(indrange[[1]], 1, 1, 1),
                                count = c(block_size) )
            h5spacemem <- H5Screate_simple(block_size)
            block <- H5Dread(h5dataset = .Object@.scandata,
                             h5spaceFile = .Object@.scanspace,
                             h5spaceMem = h5spacemem) %>%
            matrix(., nrow = indrange[[2]])
          H5Sclose(h5spacemem)
          block / .Object@single_ion_signal
          })
