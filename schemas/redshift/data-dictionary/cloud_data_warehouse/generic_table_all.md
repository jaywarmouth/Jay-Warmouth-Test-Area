# cloud_data_warehouse.generic_table_all

> **Schema:** cloud_data_warehouse | **Columns:** 63

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
| 8 | table_number | BIGINT | NO |  | Required |
| 9 | gpi | VARCHAR(14) | NO |  | Required |
| 10 | maximum_days | BIGINT | YES |  |  |
| 11 | status_code | VARCHAR(1) | YES |  |  |
| 12 | mac_drug_code | VARCHAR(1) | YES |  |  |
| 13 | ndc_type_code | BIGINT | YES |  |  |
| 14 | ndc | VARCHAR(11) | YES |  |  |
| 15 | cross_reference | VARCHAR(1) | YES |  |  |
| 16 | copay | BIGINT | YES |  |  |
| 17 | rx_otc_code | VARCHAR(1) | YES |  |  |
| 18 | maximum_age | BIGINT | YES |  |  |
| 19 | generic_code | VARCHAR(1) | YES |  |  |
| 20 | duration | BIGINT | YES |  |  |
| 21 | duration_kind | VARCHAR(1) | YES |  |  |
| 22 | metric_quantity_per_rx | NUMERIC(10, 3) | YES |  |  |
| 23 | time_frame | BIGINT | YES |  |  |
| 24 | metric_quantity_per_time | NUMERIC(10, 3) | YES |  |  |
| 25 | rx_quantity_per_time | BIGINT | YES |  |  |
| 26 | reject_number | BIGINT | YES |  |  |
| 27 | metric_quantity_per_copay | NUMERIC(10, 3) | YES |  |  |
| 28 | copay_per_month_flag | VARCHAR(1) | YES |  |  |
| 29 | skip_limit_flag | VARCHAR(1) | YES |  |  |
| 30 | generic_table_override_flag | VARCHAR(1) | YES |  |  |
| 31 | copay_schedule_type | VARCHAR(6) | YES |  |  |
| 32 | mail_mandate_flag | VARCHAR(1) | YES |  |  |
| 33 | preferred_message | VARCHAR(30) | YES |  |  |
| 34 | gpi_prior_auth_req | VARCHAR(14) | YES |  |  |
| 35 | reimbursement_schedule_type | VARCHAR(6) | YES |  |  |
| 36 | auto_create_gpi | VARCHAR(14) | YES |  |  |
| 37 | minimum_age_limit | BIGINT | YES |  |  |
| 38 | effective_date | DATE | YES |  |  |
| 39 | term_date | DATE | YES |  |  |
| 40 | manufacturer | VARCHAR(10) | YES |  |  |
| 41 | female_max_age_years | BIGINT | YES |  |  |
| 42 | female_max_age_months | BIGINT | YES |  |  |
| 43 | female_min_age_years | BIGINT | YES |  |  |
| 44 | female_min_age_months | BIGINT | YES |  |  |
| 45 | male_max_age_years | BIGINT | YES |  |  |
| 46 | male_max_age_months | BIGINT | YES |  |  |
| 47 | male_min_age_years | BIGINT | YES |  |  |
| 48 | male_min_age_months | BIGINT | YES |  |  |
| 49 | gender_max_min_flag | VARCHAR(1) | YES |  |  |
| 50 | daw_1_copay_schedule | VARCHAR(6) | YES |  |  |
| 51 | days_supply_per_timeframe | BIGINT | YES |  |  |
| 52 | plan_max_mult | VARCHAR(1) | YES |  |  |
| 53 | unit_per_day | NUMERIC(18, 2) | YES |  |  |
| 54 | post_a_reject | BIGINT | YES |  |  |
| 55 | min_day_supply | BIGINT | YES |  |  |
| 56 | min_qty | NUMERIC(18, 3) | YES |  |  |
| 57 | plan_max_benefit | NUMERIC(18, 2) | YES |  |  |
| 58 | reimb_sched_nbr | BIGINT | YES |  |  |
| 59 | gen_cd_cov | VARCHAR(1) | YES |  |  |
| 60 | max_claim_amt | NUMERIC(18, 2) | YES |  |  |
| 61 | add_id | VARCHAR(15) | YES |  |  |
| 62 | change_id | VARCHAR(15) | YES |  |  |
| 63 | claim_cost_per_time_frame | NUMERIC(18, 2) | YES |  |  |
