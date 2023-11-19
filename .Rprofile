rm(list = ls())
gc()


# System options ----------------------------------------------------------

options( keep.source = TRUE )
options( show.error.locations = TRUE )
options( mc.cores = 4L)
options(scipen=10)

utils::Rprof(line.profiling=TRUE)
utils::rc.settings(ipck=TRUE)



# Packages ----------------------------------------------------------------
myPackages <- c("dplyr", "magrittr", "parallel", "dbplyr", "RSQLite",
                "openxlsx", "DBI", "glue", "readr", "testthat", "utils",
                "getPass", "RPostgreSQL")
suppressMessages({
     lapply(myPackages, require, character.only = TRUE, quietly = TRUE)
})


# Set file paths ----------------------------------------------------------
main_path <- getwd() %>% normalizePath()
output_path <-  main_path %>% glue("/output")
input_path <- main_path %>% glue("/data")
test_path <- main_path %>% glue("/tests")



# Connect to my PostgreSQL database ---------------------------------------
#

# username and password defined as a system variable
username <- Sys.getenv("username")
password <- Sys.getenv("password")



connectPostgres <- function(username = username, password = password) {
        tryCatch({

              if (length(username) != 0 & length(password) != 0) {
                dbConnect(dbDriver("PostgreSQL"),
                          dbname = "briancarter",
                          host = "192.168.0.25",
                          port = 5432,
                          user = username,
                          password = password)
              } else {
                   dbConnect(dbDriver("PostgreSQL"),
                             dbname = "briancarter",
                             host = "192.168.0.25",
                             port = 5432,
                             user = getPass::getPass("Username"),
                             password = getPass::getPass("Password"))
              }
        },
        error = function(cond) {
                message("Can't connect to Orange PI")
                message(cond)
                return(NA)
        }
        )
}

myDB <<- connectPostgres(username, password)
rm(username, password)
# Functions ---------------------------------------------------------------

# Scott's CSV plus - reads/writes a CSV file with associated metadata
glue("{main_path}/R/csv_plus.r") %>% source()


# TODO:  add a flag that will alert me to updated versions
.packageVersions <- function() {
     foo <- loadedNamespaces()
     lapply(foo, function(package) {
          data.frame(Package = package,
                     Version = packageVersion(package))
     }) %>%
          do.call("rbind", .)
}



cat("Packages loaded on startup\n")
.packageVersions() %>%
     dplyr::filter(Package %in% myPackages) %>%
     print()




# error handling ----------------------------------------------------------

# TODO: This is broken



# Cleanup -----------------------------------------------------------------


