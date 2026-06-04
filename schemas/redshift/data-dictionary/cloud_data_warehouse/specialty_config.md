# cloud_data_warehouse.specialty_config

> **Schema:** cloud_data_warehouse | **Columns:** 25

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
| 8 | table_id | VARCHAR(8) | NO |  | Required |
| 9 | gpi | VARCHAR(14) | NO |  | Required |
| 10 | eff_date | DATE | NO |  | Required |
| 11 | status_code | VARCHAR(1) | YES |  |  |
| 12 | copay_schedule_type | VARCHAR(6) | YES |  |  |
| 13 | copay_number | BIGINT | YES |  |  |
| 14 | max_day_supply | BIGINT | YES |  |  |
| 15 | skip_limit_flag | VARCHAR(1) | YES |  |  |
| 16 | term_date | DATE | YES |  |  |
| 17 | pref_message | VARCHAR(30) | YES |  |  |
| 18 | injec_cov_stat_code | VARCHAR(1) | YES |  |  |
| 19 | script_per_member | BIGINT | YES |  |  |
| 20 | unit_per_day | NUMERIC(18, 2) | YES |  |  |
| 21 | reimb_sched_type | VARCHAR(6) | YES |  |  |
| 22 | reimb_sched_number | BIGINT | YES |  |  |
| 23 | add_id | VARCHAR(15) | YES |  |  |
| 24 | change_id | VARCHAR(15) | YES |  |  |
| 25 | copay_per_month_flag | VARCHAR(1) | YES |  |  |
