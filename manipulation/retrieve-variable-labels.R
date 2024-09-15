map_to_radio <- function(
  d,                               # the primary client table
  .variable,
  .category = .variable
) {
  checkmate::assert_tibble(   d)
  checkmate::assert_character(.variable       , len = 1, any.missing = FALSE)
  checkmate::assert_character(.category       , len = 1, any.missing = FALSE)
  # checkmate::assert_character(.var_out        , len = 1, any.missing = FALSE)
  # checkmate::assert_integer(  .year           , len = 1, any.missing = FALSE, lower = 2003, upper = 2021)
  # checkmate::assert_character(.var_in         , len = 1, any.missing = FALSE)
  # checkmate::assert_character(.response_name  , len = 1, any.missing = FALSE)

  d_lu <-
    config$path_variable_label_derived |>
    arrow::read_parquet() |>
    # dplyr::rename(
    #   variable  = !!.variable
    # ) |>
    dplyr::filter(category == .category)

  level_order <-
    d_lu |>
    dplyr::arrange(display_order) |>
    dplyr::pull(label) |>
    unique()


  d_lu <-
    d_lu |>
    dplyr::mutate(
      label = factor(label, levels = level_order),
    ) |>
    dplyr::select(-display_order)

  missing_levels <-
    base::setdiff(
      unique(na.omit(d[[.variable]])),
      d_lu$value
    )

  if (1L <= length(missing_levels)) {
    stop(
      "The following levels in the dataset are missing in the lookup table:\n  ",
      paste(missing_levels, collapse = ";"), "."
    )
  }
  d[[.variable]]  <- as.character(d[[.variable]])

  # browser()
  by <- rlang::set_names(x = "value", nm = .variable)
  d_lu <-
    d_lu |>
    dplyr::select(
      value,
      variable_new = label,
    )

  d |>
    # dplyr::rename(
    #  .variable_old = !!.variable
    # ) |>
    dplyr::left_join(d_lu, by = by) |>
    dplyr::mutate(
      !!.variable := variable_new, # This preserves the order of the variable within the dataset
    ) |>
    dplyr::select(
      -variable_new,
    )
}

map_to_checkbox <- function( # .variable = "inst1_funding"
  d,                               # the primary client table
  .variable,
  .category = .variable
) {

  d_lu <-
    config$path_variable_label_derived |>
    arrow::read_parquet() |>
    dplyr::filter(category == .category) |>
    dplyr::mutate(
      label = paste0(category, "_", label),
    ) |>
    dplyr::select(
      value,
      label,
    )

  by <- rlang::set_names(x = "value", nm = .variable)

  # browser()
  d_wide <-
    d |>
    dplyr::select(
      institution_index,
      !!.variable,
    ) |>
    tidyr::separate_longer_delim(cols = !!.variable, delim = ",") |>
    # tidyr::drop_na(!!.variable) |> # Drop if they didn't check any box
    dplyr::left_join(d_lu, by = by) |>
    dplyr::select(-!!.variable) |>
    tidyr::pivot_wider(
      id_cols     = "institution_index",
      names_from  = label,
      values_from = label, # Dummy argument that's not really used.
      values_fn   = \(x) {TRUE},
      values_fill = FALSE
    ) |>
    dplyr::select(!`NA`) # Drop the spurious `NA` column, that was created when someone didn't check any box.
  # View(d_wide)

  d |>
    dplyr::left_join(d_wide, by = "institution_index") |>
    dplyr::select(
      -!!.variable
    )
}
