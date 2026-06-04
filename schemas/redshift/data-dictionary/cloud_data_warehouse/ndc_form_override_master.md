# cloud_data_warehouse.ndc_form_override_master

> **Schema:** cloud_data_warehouse | **Columns:** 35

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
| 8 | ndc_id | VARCHAR(8) | YES |  |  |
| 9 | ndc | NUMERIC(11, 0) | YES |  |  |
| 10 | sequence_nbr | INTEGER | YES |  |  |
| 11 | eff_date | TIMESTAMP | YES |  |  |
| 12 | term_date | TIMESTAMP | YES |  |  |
| 13 | status_code_c | VARCHAR(1) | YES |  |  |
| 14 | status_code | VARCHAR(1) | YES |  |  |
| 15 | copay_sched_type_c | VARCHAR(1) | YES |  |  |
| 16 | copay_sched_type | VARCHAR(6) | YES |  |  |
| 17 | copay_nbr_c | VARCHAR(1) | YES |  |  |
| 18 | copay_nbr | INTEGER | YES |  |  |
| 19 | days_supply_c | VARCHAR(1) | YES |  |  |
| 20 | days_supply | INTEGER | YES |  |  |
| 21 | reimb_number_c | VARCHAR(1) | YES |  |  |
| 22 | reimb_number | INTEGER | YES |  |  |
| 23 | reimb_sched_c | VARCHAR(1) | YES |  |  |
| 24 | reimb_sched | VARCHAR(6) | YES |  |  |
| 25 | skip_limit_c | VARCHAR(1) | YES |  |  |
| 26 | skip_limit | VARCHAR(1) | YES |  |  |
| 27 | return_msg_c | VARCHAR(1) | YES |  |  |
| 28 | return_msg | VARCHAR(39) | YES |  |  |
| 29 | addition_msg_c | VARCHAR(1) | YES |  |  |
| 30 | addition_msg | VARCHAR(200) | YES |  |  |
| 31 | reject_code_c | VARCHAR(1) | YES |  |  |
| 32 | reject_code | VARCHAR(4) | YES |  |  |
| 33 | comments | VARCHAR(100) | YES |  |  |
| 34 | add_date | TIMESTAMP | YES |  |  |
| 35 | change_date | TIMESTAMP | YES |  |  |
