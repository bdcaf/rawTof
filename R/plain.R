get_peak_matrix <- function(fid){
  peak.data <- H5Dread(H5Dopen(fid, "PeakData/PeakTable"))
  peak.value <- H5Dread(H5Dopen(fid, "PeakData/PeakData"))
  peak.matrix <- matrix(peak.value, nrow=dim(peak.value)[1])
  rownames(peak.matrix) <- paste("mz", peak.data$mass)
  peak.matrix
}

get_sum_spec <- function(fid) H5Dread(H5Dopen(fid, "FullSpectra/SumSpectrum"))

masscal_helper <- function(fid){
  gr <- h5readAttributes(fid, "FullSpectra")
  with(gr,
       list( to_mass = Vectorize(function(i) ( (i-`MassCalibration p2`)/`MassCalibration p1`)^2),
             to_index = Vectorize(function(m) `MassCalibration p2` + `MassCalibration p1`*sqrt(m))
             ))
}

library(rhdf5)

tof.h5 <- "data/PTRTOF_test_spectrum.h5"
fid <- H5Fopen(tof.h5)

peaktable <- get_peak_matrix(fid)
plot(peaktable[69, ], type="l")
plot(peaktable[45, ], type="l")

mh <- masscal_helper(fid)
ss <- get_sum_spec(fid)
mass_scale <- mh$to_mass(seq_along(ss))
plot(mass_scale, ss, type="l")
