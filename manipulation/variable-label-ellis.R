rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path

# Import only certain functions of a package into the search path.
# import::from("magrittr", "%>%")

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("readr"        )
requireNamespace("arrow"        )
requireNamespace("dplyr"        ) # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("OuhscMunge"   ) # remotes::install_github(repo="OuhscBbmc/OuhscMunge")

# ---- declare-globals ---------------------------------------------------------
# Constant values that won't change.
config                         <- config::get()

# Execute to specify the column types.  It might require some manual adjustment (eg doubles to integers).
#   OuhscMunge::readr_spec_aligned(config$path_variable_label_raw)

col_types <- readr::cols_only(
  `category`          = readr::col_character(),
  `value`             = readr::col_character(),
  `label`             = readr::col_character(),
  `display_order`     = readr::col_double()
  # `comment`     = readr::col_character()
)

# ---- load-data ---------------------------------------------------------------
# Read the CSVs
ds <- readr::read_csv(config$path_variable_label_raw  , col_types=col_types)

# readr::problems(ds)
rm(col_types)

# ---- tweak-data --------------------------------------------------------------
# OuhscMunge::column_rename_headstart(ds) # Help write `dplyr::select()` call.
ds <-
  ds |>
  dplyr::select(
    category,
    value,
    label,
    display_order,
  )

# ---- verify-values -----------------------------------------------------------
# OuhscMunge::verify_value_headstart(ds)
checkmate::assert_character(ds$category       , any.missing=F , pattern="^.{2,50}$" )
checkmate::assert_character(ds$value          , any.missing=F , pattern="^.{1,10}$" )
checkmate::assert_character(ds$label          , any.missing=F , pattern="^.{1,100}$")
checkmate::assert_numeric(  ds$display_order  , any.missing=F , lower=0, upper=99)

# Assert the combination is unique
combo <- paste0(ds$category, "---", ds$value)
checkmate::assert_character(combo, any.missing = FALSE, unique = TRUE)

# ---- specify-columns-to-upload -----------------------------------------------
# Print colnames that `dplyr::select()`  should contain below:
#   cat(paste0("    ", colnames(ds), collapse=",\n"))

# Define the subset of columns that will be needed in the analyses.
#   The fewer columns that are exported, the fewer things that can break downstream.

ds_slim <-
  ds |>
  # dplyr::slice(1:100) |>
  dplyr::select(
    category,
    value,
    label,
    display_order,
  )

ds_slim

# ---- save-to-disk ------------------------------------------------------------
arrow::write_parquet(ds_slim, config$path_variable_label_derived) # Save as a compressed R-binary file if it's large or has a lot of factors.
