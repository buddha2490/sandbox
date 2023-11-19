


# Load any additional packages --------------------------------------------

# Already loaded by the Rprofile
# "dplyr", "magrittr", "parallel", "dbplyr", "RSQLite",
# "openxlsx", "DBI", "glue", "readr", "testthat"


# Source functions --------------------------------------------------------

source(glue::glue("{main_path}/R/template_function.r"),
     local = TRUE, echo = TRUE, keep.source = TRUE, max.deparse.length = Inf)


# Run my tests ------------------------------------------------------------
source(glue::glue("{main_path}/tests/tests/test_01_template.R"))


# Environmental specs -----------------------------------------------------

suppressMessages({
     env_specs <- "config/env_params.csv" %>%
          readr::read_csv()
})



# Data sources ------------------------------------------------------------

loadData <- TRUE
if (loadData == TRUE) {

# Database object
myDB <- dbConnect(SQLite(), glue("{input_path}/myDB.db"))

# Rdata files
# load(glue("{input_path}/dat.Rdata"))

# RDS files
# dat <- readRDS(glue("{input_path}/dat.RDS"))

# CSV files
# dat <- read_csv(glue("{input_path}/dat.csv))

# Excel files
# dat <- readxl::read_excel(glue("{input_path}/dat.xlsx"), sheet = "SheetName")

}

# Disconnect so R won't yell at me
dbDisconnect(myDB)
rm(myDB)



# Begin programming -------------------------------------------------------


