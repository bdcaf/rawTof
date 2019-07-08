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

# note the current test file does not contain any interesting data
tof.h5 <- system.file("testdata","samplefile.h5",
                      package = "rawTof", mustWork = TRUE)

tof_ob <- NULL
test_that("invalid input causes error",
            expect_error( new("TofClass", filename = "badname.h5"))
)

test_that("object can be created",{
            tof_ob <<- new("TofClass", filename = tof.h5)
            expect_s4_class(tof_ob, "TofClass")
                      })

test_that("fields are valid",{
            expect_true( c("filename", "nscans", ".datafile") %in% slotNames(tof_ob) %>%
                        all,
                        info = "test data presence")
            expect_equal(tof_ob@filename, tof.h5)

            expect_gt(tof_ob@nscans, 0)
            expect_equal(tof_ob@nscans, 127)

            expect_gt(tof_ob@points, 0)
            expect_gt(tof_ob@points, 1e5)

            expect_gt(tof_ob@single_ion_signal, 0)
            expect_lt(tof_ob@single_ion_signal, 1)

            expect_true(all(tof_ob@.dims > 0))
                      })

context("reading functions")
test_that("scan_block", {
  sb <- scan_block(tof_ob, c(1,5))
  expect_true(is.matrix(sb))
  expect_type(sb, "double")
  expect_equal(dim(sb), c(5, tof_ob@nscans))
                      })

test_that("scan_ind",{
  expect_error(scan_ind(tof_ob,999))
  sb <- scan_ind(tof_ob, 60)
  expect_true(is.array(sb))
  expect_type(sb, "double")
  expect_equal(dim(sb), tof_ob@points)
                      })

test_that("sumspec",{
  sb <- sumspec(tof_ob)
  expect_true(is.array(sb))
  expect_type(sb, "double")
  expect_equal(dim(sb), tof_ob@points)
})
