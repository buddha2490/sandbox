# Functions for transferring data using csv files and a yaml metadata header

#' @title Export csv file with accompanying yaml metadata file
#'
#' @description Save a csv file using `readr::write_csv` along with an accompanying
#' yaml metadata file which contains the variable types for each column
#'
#' @param x the reference to the dataframe or spark table to be exported
#' @param file path where the directory of csv files will be saved
#' @param yaml_file (optional) path where the yaml metadata will be saved,
#'                    defaults to the same base name as the csv file with extension .yaml
#' @param df_name (optional) name of the dataframe (to be saved in the yaml file)
#' @param ... additional options for `readr::write_csv`
#'
#' @examples
#' write_csv_plus( iris, file = "/dbfs/tmp/iris_1.csv" )
#' iris_1 <- read_csv_plus( file = "/dbfs/tmp/iris_1.csv" )
#'
write_csv_plus <- function(
    x,
    file,
    yaml_file = paste0(tools::file_path_sans_ext(file), ".yaml"),
    df_name = deparse(substitute(x)),
    ...
) {

  requireNamespace("csvy")
  requireNamespace("readr")

  dataframe <- as.data.frame(x)

  # In case this variable was loaded using csvy or read_csv_plus,
  #   remove previous attributes

  attr(dataframe, "profile") <- NULL
  attr(dataframe, "name") <- NULL

  # write the yaml metadata using csvy package
  csvy::write_csvy(dataframe, metadata = yaml_file, metadata_only = TRUE, name = df_name)

  # write the data
  readr::write_csv(x = x, file = file, ...)
}

#' @title Import csv file referencing accompanying yaml metadata file
#'
#' @description Save a csv file using `readr::write_csv` and include a yaml
#' metadata file which contains the variable types for each column
#'
#' @param file path where the directory of csv files will be saved
#' @param yaml_file path where the yaml metadata will be saved
#' @param datetime_format format to be used by `readr::parse_datetime` calls
#' @param ... additional options for `readr::read_csv`
#'
#' @return dataframe
#'
#' @examples
#' write_csv_plus( iris, file = "/dbfs/tmp/iris_1.csv" )
#' iris_1 <- read_csv_plus( file = "/dbfs/tmp/iris_1.csv" )
read_csv_plus <- function(
    file,
    yaml_file = paste0(tools::file_path_sans_ext(file), ".yaml"),
    datetime_format = "",
    col_names = TRUE,
    ...
) {

  requireNamespace("csvy")
  requireNamespace("readr")
  requireNamespace("purrr")

  # if the `file` is actually a directory, get the list of csv files
  if (dir.exists( file ) ) {
    file_list <- list.files(
      path =  file,
      pattern = "\\.csv$",
      recursive = TRUE,
      full.names =  TRUE
    )
    file <- file_list
  }

  this_metadata <- csvy::read_metadata( yaml_file )

  this_fields <- this_metadata$fields

  field_names <- purrr::map_chr(this_fields, purrr::pluck("name"), "name")
  field_types <- purrr::map_chr(this_fields, purrr::pluck("type"), "type")

  if (length(field_names) != length(field_types)) {
    stop("metadata file has different lengths for field names and field types")
  }


  col_spec_vector <- c()

  for (i in seq_along(field_types)) {
    col_spec_vector[[i]] <- switch(
      field_types[[i]],
      "datetime" = readr::col_datetime( format = as.character(datetime_format)),
      "date" = readr::col_date(),
      "boolean" = readr::col_logical(),
      "integer" = readr::col_integer(),
      "number" = readr::col_number(),
      readr::col_character()
    )
  }

  # first read in most types with correct type, rest as character
  this_df_char <- readr::read_csv(
    file = file,
    col_types = col_spec_vector,
    col_names = col_names,
    ...
  )

  # apply dataset level metadata from yaml
  this_df_char_2 <- csvy:::add_dataset_metadata(this_df_char, this_metadata)

  # apply variable level metadata from yaml
  this_df <- csvy:::add_variable_metadata(this_df_char_2, this_fields, "never")

  this_df
}



