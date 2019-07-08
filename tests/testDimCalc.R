#! /usr/local/bin/R
#
# testDimCalc.R
# Copyright (C) 2019 Clemens Ager <clemens.ager@uibk.ac.at>
#
# Distributed under terms of the MIT license.
#

context("helper dim_calc")

test_that("simple cases",{
            expect_equal(dim_calc(1, c(4, 3)), c(1,1))
            expect_equal(dim_calc(4, c(4, 3)), c(4,1))
            expect_equal(dim_calc(5, c(4, 3)), c(1,2))
            expect_equal(dim_calc(12, c(4, 3)), c(4,3))
            expect_error(dim_calc(13, c(4, 3)))
})
