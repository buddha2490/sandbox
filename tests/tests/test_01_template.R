
testthat::context("Unit tests for {function_name}")


# Load required packages --------------------------------------------------
library(survival)



# File paths --------------------------------------------------------------

test_inputs <- glue("{main_path}/tests/testdata/template_function/cached_inputs")
test_outputs <- glue("{main_path}/tests/testdata/template_function/cached_outputs")



# Source function to test -------------------------------------------------

glue("{main_path}/R/template_function.R") %>% source()


# Load inputs for the function ---------------------------------------------------------------

myDat <- glue("{main_path}/tests/testdata/template_function/cached_inputs") %>%
     read_csv_plus()


# Load any cached output data to compare ----------------------------------

# Load expected output if necessary
# Not all tests require comparison data

cached_output <- glue("{main_path}/tests/testdata/template_function/cached_outputs/function_output") %>%
     read_csv_plus()

# Run my function ---------------------------------------------------------

function_output <- template_function(arg1 = "arg1",
                                     arg2 = "arg2",
                                     arg3 = "arg3")





# Test to directly compare data -------------------------------------------
test_that("Expect identical data", {
     testthat::expect_equal(
          cached_output,
          function_output,
          tolerance = 0.001
     )
})


# Test a condition --------------------------------------------------------
test_that("Expect condition is true", {
     testthat::expect_true(
          class(function_output) == "data.frame"
     )
})








# Delete snapshots --------------------------------------------------------
testthat::teardown({
     unlink("_snaps", recursive=TRUE)
     unlink(glue::glue("{main_path}/_snaps"), recursive=TRUE)
})

