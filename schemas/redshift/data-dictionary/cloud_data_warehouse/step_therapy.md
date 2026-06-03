# cloud_data_warehouse.step_therapy

> **Schema:** cloud_data_warehouse | **Columns:** 21

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
| 8 | step_number | INTEGER | YES |  |  |
| 9 | primary_gpi | VARCHAR(14) | YES |  |  |
| 10 | step_gpi | VARCHAR(14) | YES |  |  |
| 11 | number_of_days | INTEGER | YES |  |  |
| 12 | effective_date | TIMESTAMP | YES |  |  |
| 13 | termination_date | TIMESTAMP | YES |  |  |
| 14 | status | CHAR(1) | YES |  |  |
| 15 | reject_number | INTEGER | YES |  |  |
| 16 | age | INTEGER | YES |  |  |
| 17 | age_g_l_flag | VARCHAR(1) | YES |  |  |
| 18 | add_date | TIMESTAMP | YES |  |  |
| 19 | change_date | TIMESTAMP | YES |  |  |
| 20 | brand_generic_id | VARCHAR(1) | YES |  |  |
| 21 | day_supply_duration | INTEGER | YES |  |  |
