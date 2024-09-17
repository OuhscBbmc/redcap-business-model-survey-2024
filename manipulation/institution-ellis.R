rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
base::source("manipulation/retrieve-variable-labels.R")

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path

# Import only certain functions of a package into the search path.
# import::from("magrittr", "%>%")

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("readr"        )
requireNamespace("tidyr"        )
requireNamespace("arrow"        )
requireNamespace("dplyr"        ) # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("checkmate"    ) # For asserting conditions meet expected patterns/conditions. # remotes::install_github("mllg/checkmate")
requireNamespace("OuhscMunge"   ) # remotes::install_github(repo="OuhscBbmc/OuhscMunge")

# ---- declare-globals ---------------------------------------------------------
# Constant values that won't change.
config                         <- config::get()

# Execute to specify the column types.  It might require some manual adjustment (eg doubles to integers).
#   OuhscMunge::readr_spec_aligned(config$path_institution_raw)

col_types <- readr::cols_only(
  # inst1
  `country`                                 = readr::col_integer(),
  `st_region`                               = readr::col_character(),
  `program_status`                          = readr::col_integer(),
  `program_growth`                          = readr::col_integer(),
  `program_model`                           = readr::col_integer(),
  `program_funding`                         = readr::col_character(),
  `support_type`                            = readr::col_integer(),
  `totaladmin`                              = readr::col_integer(),
  `total_fte`                               = readr::col_double(),
  `admin_server`                            = readr::col_double(),
  `admin_server_fte`                        = readr::col_double(),
  `admin_user`                              = readr::col_double(),
  `admin_user_fte`                          = readr::col_double(),
  `admin_code`                              = readr::col_double(),
  `admin_coding_fte`                        = readr::col_double(),
  `sal_entry`                               = readr::col_character(),
  `sal_mid`                                 = readr::col_character(),
  `sal_sen`                                 = readr::col_character(),
  `institutional_questionnaire_complete`    = readr::col_integer(),

  # inst2
  `redcap_instance_count`                   = readr::col_integer(),
  `redcap_pop`                              = readr::col_character(),
  `redcap_start_date`                       = readr::col_date(format = ""),
  `active_users`                            = readr::col_integer(),
  `active_projects`                         = readr::col_integer(),
  `logged_events`                           = readr::col_double(),
  `em_no`                                   = readr::col_integer(),
  `ccus_createprojects`                     = readr::col_integer(),
  `ccus_moveprod`                           = readr::col_integer(),
  `ccus_changerequests`                     = readr::col_integer(),
  `ccus_repeatingsetup`                     = readr::col_integer(),
  `ccus_addevents`                          = readr::col_integer(),
  `ccus_authenticate`                       = readr::col_integer(),
  `institutional_questionnaire2_complete`   = readr::col_integer(),

  # inst3
  `manageusers`                             = readr::col_integer(),
  `create`                                  = readr::col_integer(),
  `create_charge`                           = readr::col_integer(),
  `design`                                  = readr::col_integer(),
  `design_charge`                           = readr::col_integer(),
  `build`                                   = readr::col_integer(),
  `build_charge`                            = readr::col_integer(),
  `maintain`                                = readr::col_integer(),
  `maintain_charge`                         = readr::col_integer(),
  `ts`                                      = readr::col_integer(),
  `ts_charge`                               = readr::col_integer(),
  `em`                                      = readr::col_integer(),
  `em_charge`                               = readr::col_integer(),
  `cc`                                      = readr::col_integer(),
  `cc_charge`                               = readr::col_integer(),
  `api`                                     = readr::col_integer(),
  `api_charge`                              = readr::col_integer(),
  `recovery`                                = readr::col_integer(),
  `recovery_charge`                         = readr::col_integer(),
  `mobile`                                  = readr::col_integer(),
  `mobile_charge`                           = readr::col_integer(),
  `random`                                  = readr::col_integer(),
  `random_charge`                           = readr::col_integer(),
  `econ`                                    = readr::col_integer(),
  `econ_charge`                             = readr::col_integer(),
  `mycap`                                   = readr::col_integer(),
  `mycap_charge`                            = readr::col_integer(),
  `mlm`                                     = readr::col_integer(),
  `mlm_charge`                              = readr::col_integer(),
  `cdp`                                     = readr::col_integer(),
  `cdp_charge`                              = readr::col_integer(),
  `cdm`                                     = readr::col_integer(),
  `cdm_charge`                              = readr::col_integer(),
  `group`                                   = readr::col_integer(),
  `group_charge`                            = readr::col_integer(),
  `ind`                                     = readr::col_integer(),
  `ind_charge`                              = readr::col_integer(),
  `l_train`                                 = readr::col_integer(),
  `l_train_charge`                          = readr::col_integer(),
  `s_train`                                 = readr::col_integer(),
  `s_train_charge`                          = readr::col_integer(),
  `institutional_questionnaire3_complete`   = readr::col_integer(),

  # inst4
  `charge_type`                             = readr::col_character(),
  `charge_reasons`                          = readr::col_character(),
  `charge_staff`                            = readr::col_integer(),
  `charge_effort`                           = readr::col_integer(),
  `charge_success`                          = readr::col_integer(),
  # `charge_success_reason`                   = readr::col_character(),
  # `charge_challenge`                        = readr::col_character(),
  # `bill_mang`                               = readr::col_character(),
  `fee_mange_sat`                           = readr::col_integer(),
  `sec_type`                                = readr::col_character(),
  `sec_charge`                              = readr::col_integer(),
  # `sec_charge_model`                        = readr::col_character(),
  `sys_validation`                          = readr::col_integer(),
  `who_val_initial`                         = readr::col_character(),
  # `val_initial_cost`                        = readr::col_character(),
  # `who_val_ongoing`                         = readr::col_number(),
  # `val_ongoing_cost`                        = readr::col_logical(),
  `module_val`                              = readr::col_double(),
  `project_val`                             = readr::col_double(),
  `rsvc`                                    = readr::col_double(),
  `staff_val`                               = readr::col_double(),
  `sys_val_effort`                          = readr::col_double(),
  `audit_support`                           = readr::col_character(),
  `audit_status`                            = readr::col_double(),
  `monthly_requests`                        = readr::col_double(),
  `ticket`                                  = readr::col_double(),
  `ticket_type`                             = readr::col_character(),
  # `ticket_type_other`                       = readr::col_character(),
  `likesetup_ticketing`                     = readr::col_double(),
  # `whyuse_ticketing`                        = readr::col_character(),
  # `bestparts_ticketing`                     = readr::col_character(),
  # `improvements_ticketing`                  = readr::col_character(),
  `version`                                 = readr::col_character(),
  `release`                                 = readr::col_character(),
  `server_host`                             = readr::col_double(),
  # `host_combination`                        = readr::col_character(),
  `server_manage`                           = readr::col_character(),
  `server_manage_other`                     = readr::col_character(),
  `host_cloud`                              = readr::col_double(),
  # `host_cloud_other`                        = readr::col_character(),
  `upgrade`                                 = readr::col_double(),
  # `upgrade_oth`                             = readr::col_character(),
  # `upgrade_needed`                          = readr::col_character(),
  `update_barriers`                         = readr::col_character(),
  # `update_barriers_other`                   = readr::col_character(),
  `institutional_questionnaire4_complete`   = readr::col_double()
)

# ---- load-data ---------------------------------------------------------------
# Read the CSVs
ds <- readr::read_csv(config$path_institution_raw  , col_types=col_types)
# readr::problems(ds)
rm(col_types)


# ---- tweak-data --------------------------------------------------------------
# OuhscMunge::column_rename_headstart(ds) # Help write `dplyr::select()` call.
ds <-
  ds |>
  dplyr::select(
    inst1_country                                       = `country`,
    # inst1_region                                        = `st_region`,
    inst1_status                                        = `program_status`,
    inst1_growth                                        = `program_growth`,
    inst1_model                                         = `program_model`,
    inst1_funding                                       = `program_funding`,
    inst1_dept_home                                     = `support_type`,
    inst1_admin_total                                   = `totaladmin`,
    inst1_admin_total_fte                               = `total_fte`,
    inst1_admin_server                                  = `admin_server`,
    inst1_admin_server_fte                              = `admin_server_fte`,
    inst1_admin_user                                    = `admin_user`,
    inst1_admin_user_fte                                = `admin_user_fte`,
    inst1_admin_code                                    = `admin_code`,
    inst1_admin_coding_fte                              = `admin_coding_fte`,
    inst1_salary_entry                                  = `sal_entry`,
    inst1_salary_mid                                    = `sal_mid`,
    inst1_salary_senior                                 = `sal_sen`,
    inst1_complete                                      = `institutional_questionnaire_complete`,

    inst2_instance_count_uncapped                       = `redcap_instance_count`,
    inst2_client                                        = `redcap_pop`,
    inst2_start_date                                    = `redcap_start_date`,
    inst2_user_count                                    = `active_users`,
    inst2_project_count                                 = `active_projects`,
    inst2_log_count_recent                              = `logged_events`,
    inst2_em_count                                      = `em_no`,
    inst2_allow_create                                  = `ccus_createprojects`,
    inst2_allow_production_move                         = `ccus_moveprod`,
    inst2_allow_production_change                       = `ccus_changerequests`,
    inst2_allow_repeating_change                        = `ccus_repeatingsetup`,
    inst2_allow_events                                  = `ccus_addevents`,
    inst2_authenticate                                  = `ccus_authenticate`,
    inst2_complete                                      = `institutional_questionnaire2_complete`,

    inst3_users                         = `manageusers`,
    inst3_create                        = `create`,
    inst3_create_charge                 = `create_charge`,
    inst3_design                        = `design`,
    inst3_design_charge                 = `design_charge`,
    inst3_build                         = `build`,
    inst3_build_charge                  = `build_charge`,
    inst3_maintain                      = `maintain`,
    inst3_maintain_charge               = `maintain_charge`,
    inst3_ts                            = `ts`,
    inst3_ts_charge                     = `ts_charge`,
    inst3_em                            = `em`,
    inst3_em_charge                     = `em_charge`,
    inst3_cc                            = `cc`,
    inst3_cc_charge                     = `cc_charge`,
    inst3_api                           = `api`,
    inst3_api_charge                    = `api_charge`,
    inst3_recovery                      = `recovery`,
    inst3_recovery_charge               = `recovery_charge`,
    inst3_mobile                        = `mobile`,
    inst3_mobile_charge                 = `mobile_charge`,
    inst3_random                        = `random`,
    inst3_random_charge                 = `random_charge`,
    inst3_econ                          = `econ`,
    inst3_econ_charge                   = `econ_charge`,
    inst3_mycap                         = `mycap`,
    inst3_mycap_charge                  = `mycap_charge`,
    inst3_mlm                           = `mlm`,
    inst3_mlm_charge                    = `mlm_charge`,
    inst3_cdp                           = `cdp`,
    inst3_cdp_charge                    = `cdp_charge`,
    inst3_cdm                           = `cdm`,
    inst3_cdm_charge                    = `cdm_charge`,
    inst3_group                         = `group`,
    inst3_group_charge                  = `group_charge`,
    inst3_ind                           = `ind`,
    inst3_ind_charge                    = `ind_charge`,
    inst3_train_live                    = `l_train`,
    inst3_train_live_charge             = `l_train_charge`,
    inst3_train_other                   = `s_train`,
    inst3_train_other_charge            = `s_train_charge`,
    inst3_complete                      = `institutional_questionnaire3_complete`,

    inst4_charge_type                                         = `charge_type`,
    inst4_charge_reason                                       = `charge_reasons`,
    inst4_charge_staff_count                                  = `charge_staff`,
    inst4_charge_effort                                       = `charge_effort`,
    inst4_charge_success                                      = `charge_success`,
    inst4_manage_satisfied                                    = `fee_mange_sat`,
    inst4_regulatory                                          = `sec_type`,
    inst4_regulatory_charge                                   = `sec_charge`,
    inst4_validation                                          = `sys_validation`,
    inst4_validation_initial                                  = `who_val_initial`,
    inst4_validation_module                                   = `module_val`,
    inst4_validation_project                                  = `project_val`,
    inst4_validation_committee                                = `rsvc`,
    inst4_validation_staff_count                              = `staff_val`,
    inst4_validation_staff_level                              = `sys_val_effort`,
    inst4_audit_support                                       = `audit_support`,
    inst4_audit_status                                        = `audit_status`,
    inst4_request_per_month_count                             = `monthly_requests`,
    inst4_ticket                                              = `ticket`,
    inst4_ticket_type                                         = `ticket_type`,
    inst4_ticket_like                                         = `likesetup_ticketing`,
    inst4_version_preclean                                    = `version`,
    inst4_release                                             = `release`,
    inst4_server_host                                         = `server_host`,
    inst4_server_manage                                       = `server_manage`,
    # inst4_server_manage_other                                 = `server_manage_other`,
    inst4_host_cloud                                          = `host_cloud`,
    # inst4_host_cloud_other                                    = `host_cloud_other`,
    inst4_upgrade                                             = `upgrade`,
    # inst4_upgrade_oth                                         = `upgrade_oth`,
    inst4_update_barriers                                     = `update_barriers`,
    inst4_complete                                            = `institutional_questionnaire4_complete`,
  ) |>
  # dplyr::mutate(
  # ) |>
  # dplyr::arrange(subject_id) # |>
  tibble::rowid_to_column("institution_index") # Add a unique index if necessary

# ---- groom-institution-1 -----------------------------------------------------
ds <-
  ds |>
  dplyr::mutate(
    inst1_country_usa    = dplyr::if_else(inst1_country == 4L, TRUE, FALSE, missing = NA),
    inst1_country_cut3  =
      dplyr::case_match(
        inst1_country,
        4L        ~ "USA",
        1L        ~ "Australia", # Both 1 & 13 are labelled Australia
        13L       ~ "Australia",
        .default  = "Other" # As of Sept 2024, all other countries are <=10
      )
  ) |>
  map_to_radio(   "inst1_status") |> # defined in manipulation/retrieve-variable-labels.R
  map_to_radio(   "inst1_growth") |>
  map_to_radio(   "inst1_model") |>
  map_to_checkbox("inst1_funding") |> # defined in manipulation/retrieve-variable-labels.R
  map_to_radio(   "inst1_dept_home") |>
  dplyr::mutate(
    inst1_complete  = REDCapR::constant_to_form_completion(inst1_complete),
  ) |>
  # dplyr::select(tidyselect::starts_with("inst1_")) |>
  dplyr::select(
    -inst1_country,
  ) #|>  View()

# ---- groom-institution-2 -----------------------------------------------------
ds <-
  ds |>
  dplyr::mutate(
    inst2_start_year              = as.integer(lubridate::year(inst2_start_date)),
    inst2_instance_count          = pmin(inst2_instance_count_uncapped, 10L),
    inst2_allow_create            = as.logical(inst2_allow_create               ),
    inst2_allow_production_move   = as.logical(inst2_allow_production_move      ),
    inst2_allow_repeating_change  = as.logical(inst2_allow_repeating_change     ),
    inst2_allow_events            = as.logical(inst2_allow_events               ),
    inst2_complete                = REDCapR::constant_to_form_completion(inst2_complete),
  ) |>
  map_to_checkbox("inst2_client") |>
  map_to_radio(   "inst2_allow_production_change") |>
  map_to_radio(   "inst2_authenticate") |>
  # dplyr::select(tidyselect::starts_with("inst2_")) |>
  dplyr::select(
    -inst2_start_date
  )

# ---- groom-institution-3 -----------------------------------------------------
ds <-
  ds |>
  dplyr::mutate(
    inst3_complete                = REDCapR::constant_to_form_completion(inst3_complete),
  ) |>
  map_to_radio("inst3_users"               , .category = "always_sometimes_never") |>
  map_to_radio("inst3_create"              , .category = "always_sometimes_never") |>
  map_to_radio("inst3_create_charge"       , .category = "always_sometimes_never") |>
  map_to_radio("inst3_design"              , .category = "always_sometimes_never") |>
  map_to_radio("inst3_design_charge"       , .category = "always_sometimes_never") |>
  map_to_radio("inst3_build"               , .category = "always_sometimes_never") |>
  map_to_radio("inst3_build_charge"        , .category = "always_sometimes_never") |>
  map_to_radio("inst3_maintain"            , .category = "always_sometimes_never") |>
  map_to_radio("inst3_maintain_charge"     , .category = "always_sometimes_never") |>
  map_to_radio("inst3_ts"                  , .category = "always_sometimes_never") |>
  map_to_radio("inst3_ts_charge"           , .category = "always_sometimes_never") |>
  map_to_radio("inst3_em"                  , .category = "always_sometimes_never") |>
  map_to_radio("inst3_em_charge"           , .category = "always_sometimes_never") |>
  map_to_radio("inst3_cc"                  , .category = "always_sometimes_never") |>
  map_to_radio("inst3_cc_charge"           , .category = "always_sometimes_never") |>
  map_to_radio("inst3_api"                 , .category = "always_sometimes_never") |>
  map_to_radio("inst3_api_charge"          , .category = "always_sometimes_never") |>
  map_to_radio("inst3_recovery"            , .category = "always_sometimes_never") |>
  map_to_radio("inst3_recovery_charge"     , .category = "always_sometimes_never") |>
  map_to_radio("inst3_mobile"              , .category = "always_sometimes_never") |>
  map_to_radio("inst3_mobile_charge"       , .category = "always_sometimes_never") |>
  map_to_radio("inst3_random"              , .category = "always_sometimes_never") |>
  map_to_radio("inst3_random_charge"       , .category = "always_sometimes_never") |>
  map_to_radio("inst3_econ"                , .category = "always_sometimes_never") |>
  map_to_radio("inst3_econ_charge"         , .category = "always_sometimes_never") |>
  map_to_radio("inst3_mycap"               , .category = "always_sometimes_never") |>
  map_to_radio("inst3_mycap_charge"        , .category = "always_sometimes_never") |>
  map_to_radio("inst3_mlm"                 , .category = "always_sometimes_never") |>
  map_to_radio("inst3_mlm_charge"          , .category = "always_sometimes_never") |>
  map_to_radio("inst3_cdp"                 , .category = "always_sometimes_never") |>
  map_to_radio("inst3_cdp_charge"          , .category = "always_sometimes_never") |>
  map_to_radio("inst3_cdm"                 , .category = "always_sometimes_never") |>
  map_to_radio("inst3_cdm_charge"          , .category = "always_sometimes_never") |>
  map_to_radio("inst3_group"               , .category = "always_sometimes_never") |>
  map_to_radio("inst3_group_charge"        , .category = "always_sometimes_never") |>
  map_to_radio("inst3_ind"                 , .category = "always_sometimes_never") |>
  map_to_radio("inst3_ind_charge"          , .category = "always_sometimes_never") |>
  map_to_radio("inst3_train_live"          , .category = "always_sometimes_never") |>
  map_to_radio("inst3_train_live_charge"   , .category = "always_sometimes_never") |>
  map_to_radio("inst3_train_other"         , .category = "always_sometimes_never") |>
  map_to_radio("inst3_train_other_charge"  , .category = "always_sometimes_never")# |>
  # dplyr::select(tidyselect::starts_with("inst3_"))


# ---- groom-institution-4 -----------------------------------------------------
warning("inst4 instrument hasn't been ingested yet.")
ds <-
  ds |>
  dplyr::mutate(
    inst4_version = sub("(?i).*?(?:\\b|v)(1\\d\\.\\d{1,2}).+$", "\\1", inst4_version_preclean),
    inst4_version_major = sub("^(\\d{1,2})\\.\\d{1,2}", "\\1", inst4_version)
  ) |>
  map_to_checkbox(  "inst4_charge_type") |>
  map_to_checkbox(  "inst4_charge_reason") |>
  dplyr::mutate(
    inst4_charge_staff_count =
      dplyr::case_match(
        inst1_model,
        "no/minimal user support" ~ 0L,
        "no charge"               ~ 0L,
        "charge users"            ~ inst4_charge_staff_count,
        "both"                    ~ inst4_charge_staff_count,
        .default                  = NA_integer_
      )
  ) |>
  map_to_radio(  "inst4_charge_effort") |>
  map_to_radio(  "inst4_charge_success") |>
  map_to_radio(  "inst4_manage_satisfied") |>
  map_to_checkbox("inst4_regulatory") |>
  map_to_radio(  "inst4_regulatory_charge") |>
  # map_to_checkbox(  "inst4_validation") |>
  # map_to_checkbox(  "inst4_validation_initial") |>
  # map_to_checkbox(  "inst4_validation_module") |>
  # map_to_checkbox(  "inst4_validation_project") |>
  # map_to_checkbox(  "inst4_validation_committee") |>
  # map_to_checkbox(  "inst4_validation_staff_count") |>
  # map_to_checkbox(  "inst4_validation_staff_level") |>
  # map_to_checkbox(  "inst4_audit_support") |>
  # map_to_checkbox(  "inst4_audit_status") |>
  # map_to_checkbox(  "inst4_request_per_month_count") |>
  # map_to_checkbox(  "inst4_ticket") |>
  # map_to_checkbox(  "inst4_ticket_type") |>
  # map_to_checkbox(  "inst4_ticket_like") |>
  # map_to_checkbox(  "inst4_version_preclean") |>
  # map_to_checkbox(  "inst4_release") |>
  # map_to_checkbox(  "inst4_server_host") |>
  # map_to_checkbox(  "inst4_server_manage") |>
  # map_to_checkbox(  "inst4_host_cloud") |>
  # map_to_checkbox(  "inst4_upgrade") |>
  # map_to_checkbox(  "inst4_update_barriers") |>
  dplyr::mutate(
    inst4_complete                = REDCapR::constant_to_form_completion(inst4_complete),
  ) |>
  # dplyr::select(tidyselect::starts_with("inst4_version"))
  # dplyr::select(tidyselect::starts_with("inst4_")) |>
  dplyr::select(
    -inst4_version_preclean
  )

# ---- reestablish-column-order ------------------------------------------------
ds <-
  ds |>
  dplyr::select(
    institution_index,
    tidyselect::matches("inst1_(?!complete)", perl = TRUE), # A "negative-lookahead"
    inst1_complete,
    tidyselect::matches("inst2_(?!complete)", perl = TRUE),
    inst2_complete,
    tidyselect::matches("inst3_(?!complete)", perl = TRUE),
    inst3_complete,
    tidyselect::matches("inst4_(?!complete)", perl = TRUE),
    inst4_complete,
  )

# ---- verify-values-inst1 -----------------------------------------------------------
#checkmate::assert_integer(  ds$institution_index      , any.missing=F , lower=1, upper=999  , unique=T)
checkmate::assert_character(ds$inst1_country_cut3     , any.missing=F , pattern="^.{3,9}$"  )
checkmate::assert_logical(  ds$inst1_country_usa       , any.missing=F                       )
checkmate::assert_factor(   ds$inst1_status           , any.missing=T)
checkmate::assert_factor(   ds$inst1_growth           , any.missing=T)
checkmate::assert_factor(   ds$inst1_model            , any.missing=T)
# checkmate::assert_character(ds$inst1_funding          , any.missing=T , pattern="^.{1,7}$"  )
checkmate::assert_logical(  ds$inst1_funding_institution   , any.missing=F                       )
checkmate::assert_logical(  ds$inst1_funding_ctsa          , any.missing=F                       )
checkmate::assert_logical(  ds$inst1_funding_project       , any.missing=F                       )
checkmate::assert_logical(  ds$inst1_funding_cost_recovery , any.missing=F                       )
checkmate::assert_logical(  ds$inst1_funding_other         , any.missing=F                       )
checkmate::assert_factor(   ds$inst1_dept_home        , any.missing=T)
checkmate::assert_integer(  ds$inst1_admin_total      , any.missing=T , lower=1, upper=25   )
checkmate::assert_numeric(  ds$inst1_admin_total_fte  , any.missing=T , lower=0, upper=20   )
checkmate::assert_numeric(  ds$inst1_admin_server     , any.missing=T , lower=0, upper=10   )
checkmate::assert_numeric(  ds$inst1_admin_server_fte , any.missing=T , lower=0, upper=10   )
checkmate::assert_numeric(  ds$inst1_admin_user       , any.missing=T , lower=1, upper=20   )
checkmate::assert_numeric(  ds$inst1_admin_user_fte   , any.missing=T , lower=0, upper=20   )
checkmate::assert_numeric(  ds$inst1_admin_code       , any.missing=T , lower=0, upper=10   )
checkmate::assert_numeric(  ds$inst1_admin_coding_fte , any.missing=T , lower=0, upper=10   )
# checkmate::assert_character(ds$inst1_salary_entry     , any.missing=T , pattern="^.{1,100}$" )
# checkmate::assert_character(ds$inst1_salary_mid       , any.missing=T , pattern="^.{1,100}$" )
# checkmate::assert_character(ds$inst1_salary_senior    , any.missing=T , pattern="^.{1,100}$" )
checkmate::assert_factor(   ds$inst1_complete         , any.missing=F                       )

# ---- verify-values-inst2 -----------------------------------------------------------
checkmate::assert_integer( ds$inst2_instance_count                , any.missing=T , lower=1, upper=10       )
checkmate::assert_integer( ds$inst2_instance_count_uncapped       , any.missing=T , lower=1, upper=9999       )
checkmate::assert_logical( ds$inst2_client_limited                , any.missing=F                             )
checkmate::assert_logical( ds$inst2_client_institution_single     , any.missing=F                             )
checkmate::assert_logical( ds$inst2_client_institution_multiple   , any.missing=F                             )
checkmate::assert_logical( ds$inst2_client_other                  , any.missing=F                             )
checkmate::assert_integer( ds$inst2_start_year                    , any.missing=T                             )
checkmate::assert_integer( ds$inst2_user_count                    , any.missing=T , lower=20, upper=99999     )
checkmate::assert_integer( ds$inst2_project_count                 , any.missing=T , lower=5, upper=99999      )
checkmate::assert_numeric( ds$inst2_log_count_recent              , any.missing=T , lower=5, upper=99999999   )
checkmate::assert_integer( ds$inst2_em_count                      , any.missing=T , lower=0, upper=999        )
checkmate::assert_logical( ds$inst2_allow_create                  , any.missing=T                             )
checkmate::assert_logical( ds$inst2_allow_production_move         , any.missing=T                             )
checkmate::assert_factor(  ds$inst2_allow_production_change       , any.missing=T                             )
checkmate::assert_logical( ds$inst2_allow_repeating_change        , any.missing=T                             )
checkmate::assert_logical( ds$inst2_allow_events                  , any.missing=T                             )
checkmate::assert_factor(  ds$inst2_authenticate                  , any.missing=T                             )
checkmate::assert_factor(  ds$inst2_complete                      , any.missing=F                             )

# ---- verify-values-inst3 -----------------------------------------------------------
checkmate::assert_factor(  ds$inst3_users              , any.missing=T)
checkmate::assert_factor(  ds$inst3_create             , any.missing=T)
checkmate::assert_factor(  ds$inst3_create_charge      , any.missing=T)
checkmate::assert_factor(  ds$inst3_design             , any.missing=T)
checkmate::assert_factor(  ds$inst3_design_charge      , any.missing=T)
checkmate::assert_factor(  ds$inst3_build              , any.missing=T)
checkmate::assert_factor(  ds$inst3_build_charge       , any.missing=T)
checkmate::assert_factor(  ds$inst3_maintain           , any.missing=T)
checkmate::assert_factor(  ds$inst3_maintain_charge    , any.missing=T)
checkmate::assert_factor(  ds$inst3_ts                 , any.missing=T)
checkmate::assert_factor(  ds$inst3_ts_charge          , any.missing=T)
checkmate::assert_factor(  ds$inst3_em                 , any.missing=T)
checkmate::assert_factor(  ds$inst3_em_charge          , any.missing=T)
checkmate::assert_factor(  ds$inst3_cc                 , any.missing=T)
checkmate::assert_factor(  ds$inst3_cc_charge          , any.missing=T)
checkmate::assert_factor(  ds$inst3_api                , any.missing=T)
checkmate::assert_factor(  ds$inst3_api_charge         , any.missing=T)
checkmate::assert_factor(  ds$inst3_recovery           , any.missing=T)
checkmate::assert_factor(  ds$inst3_recovery_charge    , any.missing=T)
checkmate::assert_factor(  ds$inst3_mobile             , any.missing=T)
checkmate::assert_factor(  ds$inst3_mobile_charge      , any.missing=T)
checkmate::assert_factor(  ds$inst3_random             , any.missing=T)
checkmate::assert_factor(  ds$inst3_random_charge      , any.missing=T)
checkmate::assert_factor(  ds$inst3_econ               , any.missing=T)
checkmate::assert_factor(  ds$inst3_econ_charge        , any.missing=T)
checkmate::assert_factor(  ds$inst3_mycap              , any.missing=T)
checkmate::assert_factor(  ds$inst3_mycap_charge       , any.missing=T)
checkmate::assert_factor(  ds$inst3_mlm                , any.missing=T)
checkmate::assert_factor(  ds$inst3_mlm_charge         , any.missing=T)
checkmate::assert_factor(  ds$inst3_cdp                , any.missing=T)
checkmate::assert_factor(  ds$inst3_cdp_charge         , any.missing=T)
checkmate::assert_factor(  ds$inst3_cdm                , any.missing=T)
checkmate::assert_factor(  ds$inst3_cdm_charge         , any.missing=T)
checkmate::assert_factor(  ds$inst3_group              , any.missing=T)
checkmate::assert_factor(  ds$inst3_group_charge       , any.missing=T)
checkmate::assert_factor(  ds$inst3_ind                , any.missing=T)
checkmate::assert_factor(  ds$inst3_ind_charge         , any.missing=T)
checkmate::assert_factor(  ds$inst3_train_live         , any.missing=T)
checkmate::assert_factor(  ds$inst3_train_live_charge  , any.missing=T)
checkmate::assert_factor(  ds$inst3_train_other        , any.missing=T)
checkmate::assert_factor(  ds$inst3_train_other_charge , any.missing=T)
checkmate::assert_factor(  ds$inst3_complete           , any.missing=F)

# ---- verify-values-inst4 -----------------------------------------------------
# OuhscMunge::verify_value_headstart(ds)
checkmate::assert_logical(  ds$inst4_charge_type_effort_hourly , any.missing=F                       )
checkmate::assert_logical(  ds$inst4_charge_type_effort_fte    , any.missing=F                       )
checkmate::assert_logical(  ds$inst4_charge_type_service       , any.missing=F                       )
checkmate::assert_logical(  ds$inst4_charge_type_subscription  , any.missing=F                       )
checkmate::assert_logical(  ds$inst4_charge_type_other         , any.missing=F                       )
checkmate::assert_logical(  ds$inst4_charge_reason_cost_recovery       , any.missing=F                       )
checkmate::assert_logical(  ds$inst4_charge_reason_demand_management   , any.missing=F                       )
checkmate::assert_logical(  ds$inst4_charge_reason_additional_support, , any.missing=F                       )
checkmate::assert_logical(  ds$inst4_charge_reason_advanced_services   , any.missing=F                       )
checkmate::assert_logical(  ds$inst4_charge_reason_additional_fte      , any.missing=F                       )
checkmate::assert_logical(  ds$inst4_charge_reason_support_specific    , any.missing=F                       )
checkmate::assert_logical(  ds$inst4_charge_reason_other               , any.missing=F                       )
checkmate::assert_integer(  ds$inst4_charge_staff_count      , any.missing=T , lower=0, upper=15   )
checkmate::assert_factor(   ds$inst4_charge_effort           , any.missing=T )
checkmate::assert_factor(   ds$inst4_charge_success          , any.missing=T )
checkmate::assert_factor(   ds$inst4_manage_satisfied        , any.missing=T )

checkmate::assert_logical(  ds$inst4_regulatory_none          , any.missing=F )
checkmate::assert_logical(  ds$inst4_regulatory_hipaa         , any.missing=F )
checkmate::assert_logical(  ds$inst4_regulatory_cfr_11        , any.missing=F )
checkmate::assert_logical(  ds$inst4_regulatory_gcp           , any.missing=F )
checkmate::assert_logical(  ds$inst4_regulatory_fisma_high    , any.missing=F )
checkmate::assert_logical(  ds$inst4_regulatory_fisma_medium  , any.missing=F )
checkmate::assert_logical(  ds$inst4_regulatory_fisma_low     , any.missing=F )
checkmate::assert_logical(  ds$inst4_regulatory_gdpr          , any.missing=F )
checkmate::assert_logical(  ds$inst4_regulatory_other         , any.missing=F )
checkmate::assert_factor(   ds$inst4_regulatory_charge        , any.missing=T )
# checkmate::assert_integer(  ds$inst4_validation              , any.missing=T , lower=0, upper=2    )
# checkmate::assert_character(ds$inst4_validation_initial      , any.missing=T , pattern="^.{1,5}$"  )
# checkmate::assert_numeric(  ds$inst4_validation_module       , any.missing=T , lower=0, upper=1    )
# checkmate::assert_numeric(  ds$inst4_validation_project      , any.missing=T , lower=0, upper=1    )
# checkmate::assert_numeric(  ds$inst4_validation_committee    , any.missing=T , lower=0, upper=1    )
# checkmate::assert_numeric(  ds$inst4_validation_staff_count  , any.missing=T , lower=1, upper=8    )
# checkmate::assert_numeric(  ds$inst4_validation_staff_level  , any.missing=T , lower=1, upper=3    )
# checkmate::assert_character(ds$inst4_audit_support           , any.missing=T , pattern="^.{1,9}$"  )
# checkmate::assert_numeric(  ds$inst4_audit_status            , any.missing=T , lower=0, upper=99   )
# checkmate::assert_numeric(  ds$inst4_request_per_month_count , any.missing=T , lower=3, upper=1100 )
# checkmate::assert_numeric(  ds$inst4_ticket                  , any.missing=T , lower=0, upper=1    )
# checkmate::assert_character(ds$inst4_ticket_type             , any.missing=T , pattern="^.{1,5}$"  )
# checkmate::assert_numeric(  ds$inst4_ticket_like             , any.missing=T , lower=1, upper=3    )
# checkmate::assert_character(ds$inst4_release                 , any.missing=T , pattern="^.{1,3}$"  )
# checkmate::assert_numeric(  ds$inst4_server_host             , any.missing=T , lower=1, upper=99   )
# checkmate::assert_character(ds$inst4_server_manage           , any.missing=T , pattern="^.{1,5}$"  )
# checkmate::assert_numeric(  ds$inst4_host_cloud              , any.missing=T , lower=1, upper=98   )
# checkmate::assert_numeric(  ds$inst4_upgrade                 , any.missing=T , lower=1, upper=98   )
# checkmate::assert_character(ds$inst4_update_barriers         , any.missing=T , pattern="^.{1,6}$"  )
# checkmate::assert_factor(   ds$inst4_complete                , any.missing=F                       )
# checkmate::assert_character(ds$inst4_version                 , any.missing=T , pattern="^.{4,5}$"  )
# checkmate::assert_character(ds$inst4_version_major           , any.missing=T , pattern="^.{2,2}$"  )

# ---- specify-columns-to-upload -----------------------------------------------
# Print colnames that `dplyr::select()`  should contain below:
#   cat(paste0("    ", colnames(ds), collapse=",\n"))

# Define the subset of columns that will be needed in the analyses.
#   The fewer columns that are exported, the fewer things that can break downstream.

ds_slim <-
  ds |>
  # dplyr::slice(1:100) |>
  dplyr::select(
    institution_index,

    inst1_country_cut3,
    inst1_country_usa,
    inst1_status,
    inst1_growth,
    inst1_model,
    # inst1_funding,
    inst1_funding_institution,
    inst1_funding_ctsa,
    inst1_funding_project,
    inst1_funding_cost_recovery,
    inst1_funding_other,
    inst1_dept_home,
    inst1_admin_total,
    inst1_admin_total_fte,
    inst1_admin_server,
    inst1_admin_server_fte,
    inst1_admin_user,
    inst1_admin_user_fte,
    inst1_admin_code,
    inst1_admin_coding_fte,
    # inst1_salary_entry,
    # inst1_salary_mid,
    # inst1_salary_senior,
    inst1_complete,

    inst2_instance_count,
    inst2_instance_count_uncapped,
    inst2_client_limited,
    inst2_client_institution_single,
    inst2_client_institution_multiple,
    inst2_client_other,
    inst2_start_year,
    inst2_user_count,
    inst2_project_count,
    inst2_log_count_recent,
    inst2_em_count,
    inst2_allow_create,
    inst2_allow_production_move,
    inst2_allow_production_change,
    inst2_allow_repeating_change,
    inst2_allow_events,
    inst2_authenticate,
    inst2_complete,

    inst3_users,
    inst3_create,
    inst3_create_charge,
    inst3_design,
    inst3_design_charge,
    inst3_build,
    inst3_build_charge,
    inst3_maintain,
    inst3_maintain_charge,
    inst3_ts,
    inst3_ts_charge,
    inst3_em,
    inst3_em_charge,
    inst3_cc,
    inst3_cc_charge,
    inst3_api,
    inst3_api_charge,
    inst3_recovery,
    inst3_recovery_charge,
    inst3_mobile,
    inst3_mobile_charge,
    inst3_random,
    inst3_random_charge,
    inst3_econ,
    inst3_econ_charge,
    inst3_mycap,
    inst3_mycap_charge,
    inst3_mlm,
    inst3_mlm_charge,
    inst3_cdp,
    inst3_cdp_charge,
    inst3_cdm,
    inst3_cdm_charge,
    inst3_group,
    inst3_group_charge,
    inst3_ind,
    inst3_ind_charge,
    inst3_train_live,
    inst3_train_live_charge,
    inst3_train_other,
    inst3_train_other_charge,
    inst3_complete,

  )

ds_slim

# ---- save-to-disk ------------------------------------------------------------
# If there's no PHI, a rectangular CSV is usually adequate, and it's portable to other machines and software.
# readr::write_csv(ds_slim, path_out_unified)
arrow::write_parquet(ds_slim, config$path_institution_derived)
