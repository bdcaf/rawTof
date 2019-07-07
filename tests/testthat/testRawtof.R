#! /usr/local/bin/R
#
# test rawtof.R
# Copyright (C) 2018 Clemens Ager <clemens.ager@uibk.ac.at>
#
# Distributed under terms of the MIT license.
#

# assure all is closed
rhdf5::h5closeAll()
rhdf5::H5close()

context("object creation")

tof.h5 <- system.file("testdata","samplefile.h5",
                      package = "rawTof", mustWork = TRUE)


test_that("object can be created",{
            expect_true( file.exists(tof.h5),
                        info = "test data presence")
            tof_ob <- new("TofClass", filename = tof.h5)
            expect_true( c("filename", "nscans", ".datafile") %in% slotNames(tof_ob) %>% all,
                        info = "test data presence")
})
