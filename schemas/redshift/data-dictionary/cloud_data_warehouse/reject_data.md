# cloud_data_warehouse.reject_data

> **Schema:** cloud_data_warehouse | **Columns:** 26

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
| 8 | reject_number | BIGINT | NO |  | Required |
| 9 | desc_1 | VARCHAR(40) | YES |  |  |
| 10 | desc_2 | VARCHAR(40) | YES |  |  |
| 11 | reject_description | VARCHAR(256) | YES |  |  |
| 12 | cost_savings_group | VARCHAR(8) | YES |  |  |
| 13 | compu_32_x | VARCHAR(2) | YES |  |  |
| 14 | compu_message | VARCHAR(39) | YES |  |  |
| 15 | pt_master_seq | VARCHAR(4) | YES |  |  |
| 16 | pt_error | VARCHAR(2) | YES |  |  |
| 17 | active_code | VARCHAR(1) | YES |  |  |
| 18 | exception_override | VARCHAR(1) | YES |  |  |
| 19 | override_override | VARCHAR(1) | YES |  |  |
| 20 | priority_code | BIGINT | YES |  |  |
| 21 | group_priority_code | BIGINT | YES |  |  |
| 22 | canadian_err_code | VARCHAR(2) | YES |  |  |
| 23 | override_type_code | BIGINT | YES |  |  |
| 24 | compu_d0 | VARCHAR(4) | YES |  |  |
| 25 | medd_569_rej_flag | VARCHAR(4) | YES |  |  |
| 26 | mcet_override | VARCHAR(1) | YES |  |  |
