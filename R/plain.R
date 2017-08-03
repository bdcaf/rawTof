library(rhdf5)

tof.h5 <- "data/PTRTOF_test_spectrum.h5"
fid <- H5Fopen(tof.h5)

get_peak_matrix <- function(fid){
  peak.data <- H5Dread(H5Dopen(fid, "PeakData/PeakTable"))
  peak.value <- H5Dread(H5Dopen(fid, "PeakData/PeakData"))
  peak.matrix <- matrix(peak.value, nrow=dim(peak.value)[1])
  rownames(peak.matrix) <- paste("mz", peak.data$mass)
  peak.matrix
}

peaktable <- get_peak_matrix(fid)
plot(peaktable[69, ])
plot(peaktable[45, ])
