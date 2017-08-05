#' retrieve matrix of precalculated peaks
#' @export
#' @param fid h5d file handle
get_peak_matrix <- function(fid){
  peak.data <- H5Dread(H5Dopen(fid, "PeakData/PeakTable"))
  peak.value <- H5Dread(H5Dopen(fid, "PeakData/PeakData"))
  peak.matrix <- matrix(peak.value, nrow=dim(peak.value)[1])
  rownames(peak.matrix) <- paste("mz", peak.data$mass)
  peak.matrix
}

#' retrieve sum spectrum
#' @export
#' @param fid h5d file handle
get_sum_spec <- function(fid) H5Dread(H5Dopen(fid, "FullSpectra/SumSpectrum"))

#' create functions to work with existing mass calibration
#' @export
#' @param fid h5d file handle
masscal_helper <- function(fid){
  gr <- h5readAttributes(fid, "FullSpectra")
  with(gr,
       list( to_mass = Vectorize(function(i) ( (i-`MassCalibration p2`)/`MassCalibration p1`)^2),
             to_index = Vectorize(function(m) `MassCalibration p2` + `MassCalibration p1`*sqrt(m))
             ))
}

dimhelper <- function(i, wid) c(i %% wid, i %/% wid)
dim_calc <- function(wanted, diml){
  # zero indexed calculation
  res <- rep(NA, length(diml))
  cu <- c(0, wanted-1)
  for (i in seq_along(diml)){
    cu <- dimhelper(cu[[2]], diml[[i]])
    res[i] <- cu[[1]]
  }
  res + 1
}

#' extract a single scan from tof spectrum
#'
#' @description Note: this function does not check whether the scan is in the range
#' of measurement.  Checks will need to be done manually!
#' Note2: Theoretically the full matrix of scans could be loaded similar
#' to get_peak_matrix - but this will take loads of memory and usually
#' is not desirable.
#' @export
#' @param fid h5d file handle
#' @param id index of scan
#' @return vector of single scan
get_single_scan <- function(fid, id){
  tofblock <- H5Dopen(H5Gopen(fid, "FullSpectra"), "TofData")
  h5space <- H5Dget_space(tofblock)
  dims <- H5Sget_simple_extent_dims(h5space)
  h5spacemem <- H5Screate_simple(dims$size[[1]])

  pos <- dim_calc(id, dims$size[-1])
  slab <- H5Sselect_hyperslab(h5space,
                              start = c(1, pos),
                              count = c(dims$size[[1]], rep(1, 3)) )
  H5Dread(h5dataset = tofblock,
          h5spaceFile = h5space,
          h5spaceMem = h5spacemem )
}

library(rhdf5)

tof.h5 <- "data/PTRTOF_test_spectrum.h5"
fid <- H5Fopen(tof.h5)

peaktable <- get_peak_matrix(fid)
plot(peaktable[69, ], type="l")
plot(peaktable[45, ], type="l")

mh <- masscal_helper(fid)
ss <- get_sum_spec(fid)/180
s2 <- get_single_scan(fid, 31)
mass_scale <- mh$to_mass(seq_along(ss))
plot(mass_scale, s2, type="l")
lines(mass_scale, ss, col="red")

mass_range <- mh$to_index(c(40, 50))
selected <- seq(from = floor(mass_range[1]),
                to = ceiling(mass_range[2]))

plot(mass_scale[selected], s2[selected], type="l")
lines(mass_scale[selected], ss[selected], col="red")
