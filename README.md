<!-- badges: start -->
[![stability-experimental](https://img.shields.io/badge/stability-experimental-orange.svg)](https://github.com/joethorley/stability-badges#experimental)
[![Travis build status](https://travis-ci.org/bdcaf/rawTof.svg?branch=master)](https://travis-ci.org/bdcaf/rawTof)
<!-- badges: end -->
# rawTof
open h5 tof files in R.

I created this package to work with the [hdf5](https://en.wikipedia.org/wiki/Hierarchical_Data_Format) TOF data files created by Ionicon devices (this has nothing to do with hdf).

## Installation 

For building the vignettes and testing you need the
[tofExampleData](https://github.com/bdcaf/tofExampleData).

### package

Download the latest package from the [releases](https://github.com/bdcaf/rawTof/releases).  Then install using `R CMD install`.


### build 

You can build it using:

    library(devtools)
    install_github("bdcaf/rawTof")

### Notable issues
 
 - This version is slow.  I suppose this has to do with the way the data needs to be rearranged to be readable from R, and the sheer size of the data.  At the moment I suggest using a script to extract traces of ions to a R compatible format.

 - When the measurement is prematurely stopped the last data block contains invalid data.  At the moment I check the measurement time - it contains decreasing values. However this is not perfect.

 - Mass calibration - when I started working on this software we had an issue that the mass calibration might change over the duration of the measurement.  The recent instrument is more robust so at the moment there is only the global calibration available.  Calibration in software might return later.
