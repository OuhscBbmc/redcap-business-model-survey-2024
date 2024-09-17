rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------
#Load any source files that contain/define functions, but that don't load any other types of variables
#   into memory.  Avoid side effects and don't pollute the global environment.
# source("SomethingSomething.R")

# ---- load-packages -----------------------------------------------------------
library(ggplot2) #For graphing
# import::from("magrittr", "%>%")
requireNamespace("dplyr")
# requireNamespace("RColorBrewer")
# requireNamespace("scales") #For formating values in graphs
# requireNamespace("mgcv) #For the Generalized Additive Model that smooths the longitudinal graphs.
# requireNamespace("TabularManifest") # remotes::install_github("Melinae/TabularManifest")

# ---- declare-globals ---------------------------------------------------------
options(show.signif.stars = FALSE) #Turn off the annotations on p-values
config                      <- config::get()

# ---- load-data ---------------------------------------------------------------
ds <- arrow::read_parquet(config$path_institution_derived) # 'ds' stands for 'datasets'

# ---- tweak-data --------------------------------------------------------------
ds <-
  ds # |>
  # dplyr::mutate(
  # )

# ---- marginals-inst1 ---------------------------------------------------------------
TabularManifest::histogram_discrete(ds, variable_name="inst1_country_cut3")
TabularManifest::histogram_discrete(ds, variable_name="inst1_country_usa")
TabularManifest::histogram_discrete(ds, variable_name="inst1_status")
TabularManifest::histogram_discrete(ds, variable_name="inst1_growth")
TabularManifest::histogram_discrete(ds, variable_name="inst1_model")
TabularManifest::histogram_discrete(ds, variable_name="inst1_funding_institution")
TabularManifest::histogram_discrete(ds, variable_name="inst1_funding_ctsa")
TabularManifest::histogram_discrete(ds, variable_name="inst1_funding_project")
TabularManifest::histogram_discrete(ds, variable_name="inst1_funding_cost_recovery")
TabularManifest::histogram_discrete(ds, variable_name="inst1_funding_other")
TabularManifest::histogram_discrete(ds, variable_name="inst1_dept_home")
TabularManifest::histogram_continuous(ds, variable_name="inst1_admin_total"        , bin_width = 1, rounded_digits = 1)
TabularManifest::histogram_continuous(ds, variable_name="inst1_admin_total_fte"    , bin_width = 1, rounded_digits = 1)
TabularManifest::histogram_continuous(ds, variable_name="inst1_admin_server"       , bin_width = 1, rounded_digits = 1)
TabularManifest::histogram_continuous(ds, variable_name="inst1_admin_server_fte"   , bin_width = 1, rounded_digits = 1)
TabularManifest::histogram_continuous(ds, variable_name="inst1_admin_user"         , bin_width = 1, rounded_digits = 1)
TabularManifest::histogram_continuous(ds, variable_name="inst1_admin_user_fte"     , bin_width = 1, rounded_digits = 1)
TabularManifest::histogram_continuous(ds, variable_name="inst1_admin_code"         , bin_width = 1, rounded_digits = 1)
TabularManifest::histogram_continuous(ds, variable_name="inst1_admin_coding_fte"   , bin_width = 1, rounded_digits = 1)
TabularManifest::histogram_discrete(ds, variable_name="inst1_complete")
# This helps start the code for graphing each variable.
#   - Make sure you change it to `histogram_continuous()` for the appropriate variables.
#   - Make sure the graph doesn't reveal PHI.
#   - Don't graph the IDs (or other uinque values) of large datasets.  The graph will be worth and could take a long time on large datasets.
# for(column in colnames(ds)) {
#   cat('TabularManifest::histogram_discrete(ds, variable_name="', column,'")\n', sep="")
# }

# ---- marginals-inst2 ---------------------------------------------------------------
TabularManifest::histogram_discrete(  ds, "inst2_instance_count")
TabularManifest::histogram_continuous(ds, "inst2_instance_count", bin_width = 1, rounded_digits = 1)
TabularManifest::histogram_discrete(  ds, "inst2_instance_count_uncapped")
TabularManifest::histogram_discrete(  ds, "inst2_client_limited")
TabularManifest::histogram_discrete(  ds, "inst2_client_institution_single")
TabularManifest::histogram_discrete(  ds, "inst2_client_institution_multiple")
TabularManifest::histogram_discrete(  ds, "inst2_client_other")
TabularManifest::histogram_discrete(  ds, "inst2_start_year")
TabularManifest::histogram_continuous(ds, "inst2_start_year"        , bin_width = 1, rounded_digits = 1)
TabularManifest::histogram_continuous(ds, "inst2_user_count"        , bin_width = 1000, rounded_digits = 1)
TabularManifest::histogram_continuous(ds, "inst2_project_count"     , bin_width = 1000, rounded_digits = 1)
TabularManifest::histogram_continuous(ds, "inst2_log_count_recent"  , bin_width = 1000000, rounded_digits = 1)
TabularManifest::histogram_continuous(ds, "inst2_em_count"          , bin_width = 5, rounded_digits = 1)
TabularManifest::histogram_discrete(  ds, "inst2_allow_create")
TabularManifest::histogram_discrete(  ds, "inst2_allow_production_move")
TabularManifest::histogram_discrete(  ds, "inst2_allow_production_change")
TabularManifest::histogram_discrete(  ds, "inst2_allow_repeating_change")
TabularManifest::histogram_discrete(  ds, "inst2_allow_events")
TabularManifest::histogram_discrete(  ds, "inst2_authenticate")
TabularManifest::histogram_discrete(  ds, "inst2_complete")

# ---- marginals-inst3 ---------------------------------------------------------------
TabularManifest::histogram_discrete(  ds, "inst3_users")
TabularManifest::histogram_discrete(  ds, "inst3_create")
TabularManifest::histogram_discrete(  ds, "inst3_create_charge")
TabularManifest::histogram_discrete(  ds, "inst3_design")
TabularManifest::histogram_discrete(  ds, "inst3_design_charge")
TabularManifest::histogram_discrete(  ds, "inst3_build")
TabularManifest::histogram_discrete(  ds, "inst3_build_charge")
TabularManifest::histogram_discrete(  ds, "inst3_maintain")
TabularManifest::histogram_discrete(  ds, "inst3_maintain_charge")
TabularManifest::histogram_discrete(  ds, "inst3_ts")
TabularManifest::histogram_discrete(  ds, "inst3_ts_charge")
TabularManifest::histogram_discrete(  ds, "inst3_em")
TabularManifest::histogram_discrete(  ds, "inst3_em_charge")
TabularManifest::histogram_discrete(  ds, "inst3_cc")
TabularManifest::histogram_discrete(  ds, "inst3_cc_charge")
TabularManifest::histogram_discrete(  ds, "inst3_api")
TabularManifest::histogram_discrete(  ds, "inst3_api_charge")
TabularManifest::histogram_discrete(  ds, "inst3_recovery")
TabularManifest::histogram_discrete(  ds, "inst3_recovery_charge")
TabularManifest::histogram_discrete(  ds, "inst3_mobile")
TabularManifest::histogram_discrete(  ds, "inst3_mobile_charge")
TabularManifest::histogram_discrete(  ds, "inst3_random")
TabularManifest::histogram_discrete(  ds, "inst3_random_charge")
TabularManifest::histogram_discrete(  ds, "inst3_econ")
TabularManifest::histogram_discrete(  ds, "inst3_econ_charge")
TabularManifest::histogram_discrete(  ds, "inst3_mycap")
TabularManifest::histogram_discrete(  ds, "inst3_mycap_charge")
TabularManifest::histogram_discrete(  ds, "inst3_mlm")
TabularManifest::histogram_discrete(  ds, "inst3_mlm_charge")
TabularManifest::histogram_discrete(  ds, "inst3_cdp")
TabularManifest::histogram_discrete(  ds, "inst3_cdp_charge")
TabularManifest::histogram_discrete(  ds, "inst3_cdm")
TabularManifest::histogram_discrete(  ds, "inst3_cdm_charge")
TabularManifest::histogram_discrete(  ds, "inst3_group")
TabularManifest::histogram_discrete(  ds, "inst3_group_charge")
TabularManifest::histogram_discrete(  ds, "inst3_ind")
TabularManifest::histogram_discrete(  ds, "inst3_ind_charge")
TabularManifest::histogram_discrete(  ds, "inst3_train_live")
TabularManifest::histogram_discrete(  ds, "inst3_train_live_charge")
TabularManifest::histogram_discrete(  ds, "inst3_train_other")
TabularManifest::histogram_discrete(  ds, "inst3_train_other_charge")
TabularManifest::histogram_discrete(  ds, "inst3_complete")

# ---- marginals-inst4 ---------------------------------------------------------
TabularManifest::histogram_discrete(  ds, "inst4_charge_type_effort_hourly"               )
TabularManifest::histogram_discrete(  ds, "inst4_charge_type_effort_fte"                  )
TabularManifest::histogram_discrete(  ds, "inst4_charge_type_service"                     )
TabularManifest::histogram_discrete(  ds, "inst4_charge_type_subscription"                )
TabularManifest::histogram_discrete(  ds, "inst4_charge_type_other"                       )
TabularManifest::histogram_discrete(  ds, "inst4_charge_reason_cost_recovery"             )
TabularManifest::histogram_discrete(  ds, "inst4_charge_reason_demand_management"         )
TabularManifest::histogram_discrete(  ds, "inst4_charge_reason_additional_support"        )
TabularManifest::histogram_discrete(  ds, "inst4_charge_reason_advanced_services"         )
TabularManifest::histogram_discrete(  ds, "inst4_charge_reason_additional_fte"            )
TabularManifest::histogram_discrete(  ds, "inst4_charge_reason_support_specific"          )
TabularManifest::histogram_discrete(  ds, "inst4_charge_reason_other"                     )
TabularManifest::histogram_discrete(  ds, "inst4_charge_staff_count"                      )
TabularManifest::histogram_discrete(  ds, "inst4_charge_effort"                           )
TabularManifest::histogram_discrete(  ds, "inst4_charge_success"                          )
TabularManifest::histogram_discrete(  ds, "inst4_manage_satisfied"                        )
TabularManifest::histogram_discrete(  ds, "inst4_regulatory_none"                         )
TabularManifest::histogram_discrete(  ds, "inst4_regulatory_hipaa"                        )
TabularManifest::histogram_discrete(  ds, "inst4_regulatory_cfr_11"                       )
TabularManifest::histogram_discrete(  ds, "inst4_regulatory_gcp"                          )
TabularManifest::histogram_discrete(  ds, "inst4_regulatory_fisma_high"                   )
TabularManifest::histogram_discrete(  ds, "inst4_regulatory_fisma_medium"                 )
TabularManifest::histogram_discrete(  ds, "inst4_regulatory_fisma_low"                    )
TabularManifest::histogram_discrete(  ds, "inst4_regulatory_gdpr"                         )
TabularManifest::histogram_discrete(  ds, "inst4_regulatory_other"                        )
TabularManifest::histogram_discrete(  ds, "inst4_regulatory_charge"                       )
TabularManifest::histogram_discrete(  ds, "inst4_validation"                              )
TabularManifest::histogram_discrete(  ds, "inst4_validation_initial_contractor"           )
TabularManifest::histogram_discrete(  ds, "inst4_validation_initial_institution_redcap"   )
TabularManifest::histogram_discrete(  ds, "inst4_validation_initial_institution_outside"  )
TabularManifest::histogram_discrete(  ds, "inst4_validation_initial_other"                )
TabularManifest::histogram_discrete(  ds, "inst4_validation_module"                       )
TabularManifest::histogram_discrete(  ds, "inst4_validation_project"                      )
TabularManifest::histogram_discrete(  ds, "inst4_validation_committee"                    )
TabularManifest::histogram_discrete(  ds, "inst4_validation_staff_count"                  )
TabularManifest::histogram_continuous(ds, "inst4_validation_staff_count"                  , bin_width = 1, rounded_digits = 1)
TabularManifest::histogram_discrete(  ds, "inst4_validation_staff_level"                  )
TabularManifest::histogram_discrete(  ds, "inst4_audit_support_redcap_admins"             )
TabularManifest::histogram_discrete(  ds, "inst4_audit_support_research_compliance"       )
TabularManifest::histogram_discrete(  ds, "inst4_audit_support_cto"                       )
TabularManifest::histogram_discrete(  ds, "inst4_audit_support_privacy_office"            )
TabularManifest::histogram_discrete(  ds, "inst4_audit_support_it"                        )
TabularManifest::histogram_discrete(  ds, "inst4_audit_support_unsure"                    )
TabularManifest::histogram_discrete(  ds, "inst4_audit_support_not_me"                    )
TabularManifest::histogram_discrete(  ds, "inst4_audit_support_other"                     )
TabularManifest::histogram_discrete(  ds, "inst4_audit_status"                            )
TabularManifest::histogram_continuous(ds, "inst4_request_per_month_count"                 , bin_width = 50, rounded_digits = 1)
TabularManifest::histogram_discrete(  ds, "inst4_ticket"                                  )
TabularManifest::histogram_discrete(  ds, "inst4_ticket_type_servicenow"                  )
TabularManifest::histogram_discrete(  ds, "inst4_ticket_type_freshworks"                  )
TabularManifest::histogram_discrete(  ds, "inst4_ticket_type_zendesk"                     )
TabularManifest::histogram_discrete(  ds, "inst4_ticket_type_zoho"                        )
TabularManifest::histogram_discrete(  ds, "inst4_ticket_type_redcap"                      )
TabularManifest::histogram_discrete(  ds, "inst4_ticket_type_jira"                        )
TabularManifest::histogram_discrete(  ds, "inst4_ticket_type_os_ticket"                   )
TabularManifest::histogram_discrete(  ds, "inst4_ticket_type_other"                       )
TabularManifest::histogram_discrete(  ds, "inst4_ticket_like"                             )
TabularManifest::histogram_discrete(  ds, "inst4_version"                                 )
TabularManifest::histogram_discrete(  ds, "inst4_version_major"                           )
TabularManifest::histogram_discrete(  ds, "inst4_release_standard"                        )
TabularManifest::histogram_discrete(  ds, "inst4_release_lts"                             )
TabularManifest::histogram_discrete(  ds, "inst4_release_dont_know"                       )
TabularManifest::histogram_discrete(  ds, "inst4_server_host"                             )
TabularManifest::histogram_discrete(  ds, "inst4_server_manage_redcap"                    )
TabularManifest::histogram_discrete(  ds, "inst4_server_manage_it"                        )
TabularManifest::histogram_discrete(  ds, "inst4_server_manage_host"                      )
TabularManifest::histogram_discrete(  ds, "inst4_server_manage_other"                     )
TabularManifest::histogram_discrete(  ds, "inst4_server_manage_dont_know"                 )
TabularManifest::histogram_discrete(  ds, "inst4_host_cloud"                              )
TabularManifest::histogram_discrete(  ds, "inst4_upgrade"                                 )
TabularManifest::histogram_discrete(  ds, "inst4_update_barrier_none"                     )
TabularManifest::histogram_discrete(  ds, "inst4_update_barrier_code_mods"                )
TabularManifest::histogram_discrete(  ds, "inst4_update_barrier_it_dept"                  )
TabularManifest::histogram_discrete(  ds, "inst4_update_barrier_part_11"                  )
TabularManifest::histogram_discrete(  ds, "inst4_update_barrier_general"                  )
TabularManifest::histogram_discrete(  ds, "inst4_update_barrier_other"                    )
TabularManifest::histogram_discrete(  ds, "inst4_complete"                                )

# ---- scatterplots ------------------------------------------------------------
g1 <-
  ds |>
  ggplot(aes(x=inst2_user_count, y=inst2_project_count, color=inst1_country_usa)) +
  geom_smooth(method="loess", span=2, se = FALSE) +
  geom_point(shape=1) +
  annotation_logticks(sides = "lb") +
  scale_x_log10(
    breaks = scales::trans_breaks("log10", function(x) 10^x),
    labels = scales::trans_format("log10", scales::math_format(10^.x))
  ) +
  scale_y_log10(
    breaks = scales::trans_breaks("log10", function(x) 10^x),
    labels = scales::trans_format("log10", scales::math_format(10^.x))
  ) +
  scale_color_brewer(palette = "Set1") +
  theme_light() +
  theme(axis.ticks = element_blank())
g1

g1 %+% aes(color=inst2_authenticate)


g1 %+% aes(y = inst1_admin_total)

g1 %+% aes(y = inst2_instance_count)
g1 %+% aes(y = inst2_log_count_recent)
g1 %+% aes(y = inst2_em_count)

# ggplot(ds, aes(x=weight_gear_z, color=forward_gear_count_f, fill=forward_gear_count_f)) +
#   geom_density(alpha=.1) +
#   theme_minimal() +
#   labs(x=expression(z[gear]))

# ---- correlation-matrixes ----------------------------------------------------
# predictor_names <-
#   c(
#     "miles_per_gallon", "displacement_inches_cubed",
#     "cylinder_count", "horsepower",
#     "forward_gear_count"
#   )
#
# cat("### Hyp 1: Prediction of quarter mile time\n\n")
# ds_hyp <- ds[, c("quarter_mile_sec", predictor_names)]
# colnames(ds_hyp) <- gsub("_", "\n", colnames(ds_hyp))
# cor_matrix <- cor(ds_hyp)
# corrplot::corrplot(cor_matrix, method="ellipse", addCoef.col="gray30", tl.col="gray20", diag=F)
# pairs(x=ds_hyp, lower.panel=panel.smooth, upper.panel=panel.smooth)
#
# colnames(cor_matrix) <- gsub("\n", "<br>", colnames(cor_matrix))
# rownames(cor_matrix) <- gsub("\n", "<br>", rownames(cor_matrix))
# knitr::kable(cor_matrix, digits = 3)
# rm(ds_hyp, cor_matrix)
#
# cat("### Hyp 2: Prediction of z-score of weight/gear\n\n")
# ds_hyp <- ds[, c("weight_gear_z", predictor_names)]
# colnames(ds_hyp) <- gsub("_", "\n", colnames(ds_hyp))
# cor_matrix <- cor(ds_hyp)
# corrplot::corrplot(cor_matrix, method="ellipse", addCoef.col="gray30", tl.col="gray20", diag=F)
# pairs(x=ds_hyp, lower.panel=panel.smooth, upper.panel=panel.smooth)
#
# colnames(cor_matrix) <- gsub("\n", "<br>", colnames(cor_matrix))
# rownames(cor_matrix) <- gsub("\n", "<br>", rownames(cor_matrix))
# knitr::kable(cor_matrix, digits = 3)
# rm(ds_hyp, cor_matrix)

# ---- models ------------------------------------------------------------------
# cat("============= Simple model that's just an intercept. =============")
# m0 <- lm(quarter_mile_sec ~ 1, data=ds)
# summary(m0)
#
# cat("============= Model includes one predictor. =============")
# m1 <- lm(quarter_mile_sec ~ 1 + miles_per_gallon, data=ds)
# summary(m1)
#
# cat("The one predictor is significantly tighter.")
# anova(m0, m1)
#
# cat("============= Model includes two predictors. =============")
# m2 <- lm(quarter_mile_sec ~ 1 + miles_per_gallon + forward_gear_count_f, data=ds)
# summary(m2)
#
# cat("The two predictor is significantly tighter.")
# anova(m1, m2)

# ---- model-results-table  -----------------------------------------------
# summary(m2)$coef |>
#   knitr::kable(
#     digits      = 2,
#     format      = "markdown"
#   )

# Uncomment the next line for a dynamic, JavaScript [DataTables](https://datatables.net/) table.
# DT::datatable(round(summary(m2)$coef, digits = 2), options = list(pageLength = 2))
