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
  `host_cloud_other`                        = readr::col_character(),
  `upgrade`                                 = readr::col_double(),
  `upgrade_oth`                             = readr::col_character(),
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
    inst1_program_status                                = `program_status`,
    inst1_program_growth                                = `program_growth`,
    inst1_program_model                                 = `program_model`,
    inst1_program_funding                               = `program_funding`,
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
    # redcap_instance_count                               = `redcap_instance_count`,
    # redcap_pop                                          = `redcap_pop`,
    # redcap_start_date                                   = `redcap_start_date`,
    # active_users                                        = `active_users`,
    # active_projects                                     = `active_projects`,
    # logged_events                                       = `logged_events`,
    # em_no                                               = `em_no`,
    # ccus_createprojects                                 = `ccus_createprojects`,
    # ccus_moveprod                                       = `ccus_moveprod`,
    # ccus_changerequests                                 = `ccus_changerequests`,
    # ccus_repeatingsetup                                 = `ccus_repeatingsetup`,
    # ccus_addevents                                      = `ccus_addevents`,
    # ccus_authenticate                                   = `ccus_authenticate`,
    # institutional_questionnaire2_complete               = `institutional_questionnaire2_complete`,
    # manageusers                                         = `manageusers`,
    # create                                              = `create`,
    # create_charge                                       = `create_charge`,
    # design                                              = `design`,
    # design_charge                                       = `design_charge`,
    # build                                               = `build`,
    # build_charge                                        = `build_charge`,
    # maintain                                            = `maintain`,
    # maintain_charge                                     = `maintain_charge`,
    # ts                                                  = `ts`,
    # ts_charge                                           = `ts_charge`,
    # em                                                  = `em`,
    # em_charge                                           = `em_charge`,
    # cc                                                  = `cc`,
    # cc_charge                                           = `cc_charge`,
    # api                                                 = `api`,
    # api_charge                                          = `api_charge`,
    # recovery                                            = `recovery`,
    # recovery_charge                                     = `recovery_charge`,
    # mobile                                              = `mobile`,
    # mobile_charge                                       = `mobile_charge`,
    # random                                              = `random`,
    # random_charge                                       = `random_charge`,
    # econ                                                = `econ`,
    # econ_charge                                         = `econ_charge`,
    # mycap                                               = `mycap`,
    # mycap_charge                                        = `mycap_charge`,
    # mlm                                                 = `mlm`,
    # mlm_charge                                          = `mlm_charge`,
    # cdp                                                 = `cdp`,
    # cdp_charge                                          = `cdp_charge`,
    # cdm                                                 = `cdm`,
    # cdm_charge                                          = `cdm_charge`,
    # group                                               = `group`,
    # group_charge                                        = `group_charge`,
    # ind                                                 = `ind`,
    # ind_charge                                          = `ind_charge`,
    # l_train                                             = `l_train`,
    # l_train_charge                                      = `l_train_charge`,
    # s_train                                             = `s_train`,
    # s_train_charge                                      = `s_train_charge`,
    # institutional_questionnaire3_complete               = `institutional_questionnaire3_complete`,
    # charge_type                                         = `charge_type`,
    # charge_reasons                                      = `charge_reasons`,
    # charge_staff                                        = `charge_staff`,
    # charge_effort                                       = `charge_effort`,
    # charge_success                                      = `charge_success`,
    # fee_mange_sat                                       = `fee_mange_sat`,
    # sec_type                                            = `sec_type`,
    # sec_charge                                          = `sec_charge`,
    # sys_validation                                      = `sys_validation`,
    # who_val_initial                                     = `who_val_initial`,
    # module_val                                          = `module_val`,
    # project_val                                         = `project_val`,
    # rsvc                                                = `rsvc`,
    # staff_val                                           = `staff_val`,
    # sys_val_effort                                      = `sys_val_effort`,
    # audit_support                                       = `audit_support`,
    # audit_status                                        = `audit_status`,
    # monthly_requests                                    = `monthly_requests`,
    # ticket                                              = `ticket`,
    # ticket_type                                         = `ticket_type`,
    # likesetup_ticketing                                 = `likesetup_ticketing`,
    # version                                             = `version`,
    # release                                             = `release`,
    # server_host                                         = `server_host`,
    # server_manage                                       = `server_manage`,
    # server_manage_other                                 = `server_manage_other`,
    # host_cloud                                          = `host_cloud`,
    # host_cloud_other                                    = `host_cloud_other`,
    # upgrade                                             = `upgrade`,
    # upgrade_oth                                         = `upgrade_oth`,
    # update_barriers                                     = `update_barriers`,
    # institutional_questionnaire4_complete               = `institutional_questionnaire4_complete`,
  ) |>
  # dplyr::mutate(
  # ) |>
  # dplyr::arrange(subject_id) # |>
  tibble::rowid_to_column("instituion_index") # Add a unique index if necessary

# ---- groom-institution-1 -----------------------------------------------------

ds <-
  ds |>
  dplyr::mutate(
    inst1_county_usa    = dplyr::if_else(inst1_country == 4L, TRUE, FALSE, missing = NA),
    inst1_country_cut3  =
      dplyr::case_match(
        inst1_country,
        4L        ~ "USA",
        1L        ~ "Australia", # Both 1 & 13 are labelled Australia
        13L       ~ "Australia",
        .default  = "Other" # As of Sept 2024, all other countries are <=10
      )
  ) |>
  map_to_label("inst1_program_model") |> # defined in manipulation/retrieve-variable-labels.R
  dplyr::mutate(
    inst1_complete  = REDCapR::constant_to_form_completion(inst1_complete),
  ) |>
  dplyr::select(tidyselect::starts_with("inst1_")) |>
  dplyr::select(
    -inst1_country,
  ) #|>  View()


# ---- verify-values -----------------------------------------------------------
# OuhscMunge::verify_value_headstart(ds)
checkmate::assert_integer(  ds$subject_id , any.missing=F , lower=1001, upper=1200 , unique=T)
checkmate::assert_integer(  ds$county_id  , any.missing=F , lower=1, upper=77     )
checkmate::assert_numeric(  ds$gender_id  , any.missing=F , lower=1, upper=255     )
checkmate::assert_character(ds$race       , any.missing=F , pattern="^.{5,41}$"    )
checkmate::assert_character(ds$ethnicity  , any.missing=F , pattern="^.{18,30}$"   )

# ---- specify-columns-to-upload -----------------------------------------------
# Print colnames that `dplyr::select()`  should contain below:
#   cat(paste0("    ", colnames(ds), collapse=",\n"))

# Define the subset of columns that will be needed in the analyses.
#   The fewer columns that are exported, the fewer things that can break downstream.

ds_slim <-
  ds |>
  # dplyr::slice(1:100) |>
  dplyr::select(
    subject_id,
    county_id,
    gender_id,
    race,
    ethnicity,
  )

ds_slim

# ---- save-to-disk ------------------------------------------------------------
# If there's no PHI, a rectangular CSV is usually adequate, and it's portable to other machines and software.
# readr::write_csv(ds_slim, path_out_unified)
# readr::write_rds(ds_slim, path_out_unified, compress="gz") # Save as a compressed R-binary file if it's large or has a lot of factors.


# ---- save-to-db --------------------------------------------------------------
# If a database already exists, this single function uploads to a SQL Server database.
# OuhscMunge::upload_sqls_odbc(
#   d             = ds_slim,
#   schema_name   = "skeleton",         # Or config$schema_name,
#   table_name    = "subject",
#   dsn_name      = "skeleton-example", # Or config$dsn_qqqqq,
#   timezone      = config$time_zone_local, # Uncomment if uploading non-UTC datetimes
#   clear_table   = T,
#   create_table  = F
# ) # 0.012 minutes


# If there's no PHI, a local database like SQLite fits a nice niche if
#   * the data is relational and
#   * later, only portions need to be queried/retrieved at a time (b/c everything won't need to be loaded into R's memory)
# cat(dput(colnames(ds)), sep = "\n")
sql_create <- c(
  "
    DROP TABLE if exists subject;
  ",
  "
    CREATE TABLE `subject` (
      subject_id      integer  not null primary key,
      county_id       integer  not null,
      gender_id       integer  not null,
      race            integer  not null,
      ethnicity       integer  not null
    );
  "
)

# Remove old DB
# if( file.exists(path_db) ) file.remove(path_db)

# Create directory if necessary.
if (fs::dir_exists(fs::path_dir(path_db)))
  fs::dir_create(fs::path_dir(path_db))

# Open connection
cnn <- DBI::dbConnect(drv = RSQLite::SQLite(), dbname = path_db)
result <- DBI::dbSendQuery(cnn, "PRAGMA foreign_keys=ON;") #This needs to be activated each time a connection is made. #http://stackoverflow.com/questions/15301643/sqlite3-forgets-to-use-foreign-keys
DBI::dbClearResult(result)
DBI::dbListTables(cnn)

# Create tables
sql_create |>
  purrr::walk(~DBI::dbExecute(cnn, .))
DBI::dbListTables(cnn)

# Write to database
DBI::dbWriteTable(cnn, name="subject",            value=ds_slim,        append=TRUE, row.names=FALSE)

# Allow database to optimize its internal arrangement
DBI::dbExecute(cnn, "VACUUM;")

# Close connection
DBI::dbDisconnect(cnn)
