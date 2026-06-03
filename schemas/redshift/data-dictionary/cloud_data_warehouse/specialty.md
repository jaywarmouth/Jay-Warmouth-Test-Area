# cloud_data_warehouse.specialty

> **Schema:** cloud_data_warehouse | **Columns:** 15

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
| 10 | eff_date | DATE | YES |  |  |
| 11 | term_date | DATE | YES |  |  |
| 12 | lim_dist_flag | VARCHAR(1) | YES |  |  |
| 13 | brand_gen_id | VARCHAR(1) | YES |  |  |
| 14 | add_id | VARCHAR(15) | YES |  |  |
| 15 | change_id | VARCHAR(15) | YES |  |  |
