# cloud_data_warehouse.step_trigger

> **Schema:** cloud_data_warehouse | **Columns:** 19

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
| 8 | step_table_no | INTEGER | YES |  |  |
| 9 | primary_gpi | VARCHAR(14) | YES |  |  |
| 10 | eff_date | TIMESTAMP | YES |  |  |
| 11 | term_date | TIMESTAMP | YES |  |  |
| 12 | pharm_message_1 | VARCHAR(60) | YES |  |  |
| 13 | pharm_message_2 | VARCHAR(60) | YES |  |  |
| 14 | brand_gen_ind | VARCHAR(1) | YES |  |  |
| 15 | nbr_look_back_drugs | INTEGER | YES |  |  |
| 16 | max_age | INTEGER | YES |  |  |
| 17 | min_age | INTEGER | YES |  |  |
| 18 | add_date | TIMESTAMP | YES |  |  |
| 19 | change_date | TIMESTAMP | YES |  |  |
