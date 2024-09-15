Notes for Ingestion Process
================

1.  For `county`, both "1" and "13" are labelled "Australia".
1.  For `program_funding`, future surveys might say "NIH CTSA/CTR Grant" instead of just "NIH CTSA Grant".
1.  For `redcap_pop`, how can the checkboxes be selected for both "2" ("One Institution/Organization") and "3" ("Multiple Institutions/Organizations")?
1.  For `redcap_instance_count`, the max is "147".  Is this likely?  If not, what is a reasonable upper bound?
1.  If we release the (multivariate) dataset publicly, let's cap some variables so they don't identify the institution.  I think marginals are fine (eg, the earliest year was 2004), but not if it can re-identify their other responses.  Variables to cap include:
    * `redcap_start_date`, limit lower bound to ~2010, .
    * `active_users`, limit upper bound to ~4k.
    * `active_projects`, limit upper bound to ~4k.
    * `logged_events`, limit upper bound to ~1M.
    * `em_no`, limit upper bound to ~25.
