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

dimhelper <- function(i, wid) c(i %% wid +1, i %/% wid)

get_single_scan <- function(fid, id){
  tofblock <- H5Dopen(H5Gopen(fid, "FullSpectra"), 
                      "TofData")
  h5spaceFile <- H5Dget_space(tofblock)
  dims <- H5Sget_simple_extent_dims(h5spaceFile)
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

mass_range <- mh$to_index(c(40, 50))
selected <- seq(from = floor(mass_range[1]),
                to = ceiling(mass_range[2]))

plot(mass_scale[selected], ss[selected], type="l")

