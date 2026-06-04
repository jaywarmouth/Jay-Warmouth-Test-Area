# cloud_data_warehouse.sponsor

> **Schema:** cloud_data_warehouse | **Columns:** 85

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | meta_surr_key | VARCHAR(1000) | YES |  |  |
| 2 | meta_hash_key | VARCHAR(1000) | YES |  |  |
| 3 | meta_src_sys_nm | VARCHAR(80) | YES |  |  |
| 4 | meta_iud_flg | VARCHAR(1) | YES |  |  |
| 5 | meta_eff_strt_dt | TIMESTAMP | YES |  |  |
| 6 | meta_eff_end_dt | TIMESTAMP | YES |  |  |
| 7 | meta_curr_ind | VARCHAR(3) | YES |  |  |
| 8 | sponsor_number | INTEGER | YES |  |  |
| 9 | system_number | INTEGER | YES |  |  |
| 10 | sponsor_name | VARCHAR(50) | YES |  |  |
| 11 | street_1 | VARCHAR(50) | YES |  |  |
| 12 | street_2 | VARCHAR(50) | YES |  |  |
| 13 | city | VARCHAR(25) | YES |  |  |
| 14 | state | VARCHAR(2) | YES |  |  |
| 15 | zip | INTEGER | YES |  |  |
| 16 | zip_4 | INTEGER | YES |  |  |
| 17 | detail | INTEGER | YES |  |  |
| 18 | suspended_claims | INTEGER | YES |  |  |
| 19 | active_option | VARCHAR(1) | YES |  |  |
| 20 | drug_interactions | VARCHAR(1) | YES |  |  |
| 21 | dose_check | VARCHAR(1) | YES |  |  |
| 22 | drug_disease | VARCHAR(1) | YES |  |  |
| 23 | duplicate_therapy | VARCHAR(1) | YES |  |  |
| 24 | no_financial | VARCHAR(1) | YES |  |  |
| 25 | person_codes | VARCHAR(1) | YES |  |  |
| 26 | nf_nabp8 | INTEGER | YES |  |  |
| 27 | rented_network_flag | VARCHAR(1) | YES |  |  |
| 28 | mail_retail_flag | VARCHAR(1) | YES |  |  |
| 29 | differential_flag | VARCHAR(1) | YES |  |  |
| 30 | eligibility_flag | VARCHAR(1) | YES |  |  |
| 31 | cob_claims_proc_flag | VARCHAR(1) | YES |  |  |
| 32 | one_time_claim_flag | VARCHAR(1) | YES |  |  |
| 33 | preload_ca_range | VARCHAR(1) | YES |  |  |
| 34 | one_time_roll_flag | VARCHAR(1) | YES |  |  |
| 35 | roll_date_level | VARCHAR(1) | YES |  |  |
| 36 | old_time_frame | INTEGER | YES |  |  |
| 37 | account_type | VARCHAR(10) | YES |  |  |
| 38 | hps_nault_rx | VARCHAR(1) | YES |  |  |
| 39 | tc_multiple_use_ot | VARCHAR(1) | YES |  |  |
| 40 | tcdmr | VARCHAR(1) | YES |  |  |
| 41 | compound_pa_flag | VARCHAR(1) | YES |  |  |
| 42 | rx_eob_flag | VARCHAR(1) | YES |  |  |
| 43 | tpa | VARCHAR(4) | YES |  |  |
| 44 | numberless_card_id_flag | VARCHAR(1) | YES |  |  |
| 45 | id_card_mask | VARCHAR(20) | YES |  |  |
| 46 | tc_program_type | VARCHAR(3) | YES |  |  |
| 47 | tc_medicaid_tricare | VARCHAR(1) | YES |  |  |
| 48 | real_time_claims | VARCHAR(1) | YES |  |  |
| 49 | tc_include_disp_fee_flag | VARCHAR(1) | YES |  |  |
| 50 | brand_id_flag | VARCHAR(1) | YES |  |  |
| 51 | dur_conf_index | VARCHAR(10) | YES |  |  |
| 52 | hps_mac_client_pricing | VARCHAR(1) | YES |  |  |
| 53 | hps_admin_fee_generic_tbl | INTEGER | YES |  |  |
| 54 | utilization_pct_change | NUMERIC(18, 2) | YES |  |  |
| 55 | medicaid_subrogation | VARCHAR(1) | YES |  |  |
| 56 | nsde_flag | VARCHAR(1) | YES |  |  |
| 57 | medd_flag | VARCHAR(1) | YES |  |  |
| 58 | bin_flag | VARCHAR(1) | YES |  |  |
| 59 | look_back_days | INTEGER | YES |  |  |
| 60 | rev_admin_fee | VARCHAR(1) | YES |  |  |
| 61 | ef_flag | VARCHAR(1) | YES |  |  |
| 62 | vrx_flag | VARCHAR(1) | YES |  |  |
| 63 | ef_switch | VARCHAR(1) | YES |  |  |
| 64 | ef_def_result | VARCHAR(1) | YES |  |  |
| 65 | ef_def_excep | VARCHAR(1) | YES |  |  |
| 66 | days_in_group | INTEGER | YES |  |  |
| 67 | claim_look_back_days | INTEGER | YES |  |  |
| 68 | disc_block_pct | NUMERIC(18, 2) | YES |  |  |
| 69 | ot_zip | VARCHAR(1) | YES |  |  |
| 70 | config_flag | VARCHAR(1) | YES |  |  |
| 71 | tcnoc | VARCHAR(1) | YES |  |  |
| 72 | limit_summary | INTEGER | YES |  |  |
| 73 | alt_reimb_sched | VARCHAR(1) | YES |  |  |
| 74 | dupe_dem_check | VARCHAR(1) | YES |  |  |
| 75 | prior_auth_exempt | VARCHAR(1) | YES |  |  |
| 76 | entry_date | DATE | YES |  |  |
| 77 | change_date | DATE | YES |  |  |
| 78 | ndc_include | VARCHAR(1) | YES |  |  |
| 79 | titration_rules_apply | VARCHAR(1) | YES |  |  |
| 80 | rej_pa_msg_applies_flag | VARCHAR(1) | YES |  |  |
| 81 | skip_260_reject | VARCHAR(1) | YES |  |  |
| 82 | state_comp_applies | VARCHAR(1) | YES |  |  |
| 83 | bin_check_rej | VARCHAR(1) | YES |  |  |
| 84 | static_id_check | VARCHAR(1) | YES |  |  |
| 85 | compu_grp_x_walk | VARCHAR(1) | YES |  |  |
