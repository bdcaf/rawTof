#! /usr/local/bin/R
#
# test rawtof.R
# Copyright (C) 2018 Clemens Ager <clemens.ager@uibk.ac.at>
#
# Distributed under terms of the MIT license.
#
rhdf5::h5closeAll()
rhdf5::H5close()

context("object creation")

tof.h5 <- "../../../toftools/testdata/2015.07.17-10h40m34 Ethanol deurated Karl .h5"

test_that("object can be created",{
            expect_true( file.exists(tof.h5),
                        info = "test data presence")
                             tof_ob <- new("TofClass", filename = tof.h5)
            expect_true( c("filename", "nscans", ".datafile") %in% slotNames(tof_ob) %>% all,
                        info = "test data presence")
})
