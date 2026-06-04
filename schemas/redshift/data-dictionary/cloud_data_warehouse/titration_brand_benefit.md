# cloud_data_warehouse.titration_brand_benefit

> **Schema:** cloud_data_warehouse | **Columns:** 27

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
| 8 | titration_brand_id | VARCHAR(20) | YES |  |  |
| 9 | ndcgpi | VARCHAR(14) | YES |  |  |
| 10 | redemp_count_min | INTEGER | YES |  |  |
| 11 | redemp_count_max | INTEGER | YES |  |  |
| 12 | claim_cob | CHAR(1) | YES |  |  |
| 13 | sequence_nbr | INTEGER | YES |  |  |
| 14 | days_between_flag | CHAR(1) | YES |  |  |
| 15 | month_ben | CHAR(1) | YES |  |  |
| 16 | days_between_min | INTEGER | YES |  |  |
| 17 | days_between_max | INTEGER | YES |  |  |
| 18 | copay | NUMERIC(18, 2) | YES |  |  |
| 19 | max_claim_amt | NUMERIC(18, 2) | YES |  |  |
| 20 | reject_code | INTEGER | YES |  |  |
| 21 | eff_date | TIMESTAMP | YES |  |  |
| 22 | term_date | TIMESTAMP | YES |  |  |
| 23 | titration_type | CHAR(1) | YES |  |  |
| 24 | add_id | VARCHAR(15) | YES |  |  |
| 25 | change_id | VARCHAR(15) | YES |  |  |
| 26 | add_date | TIMESTAMP | YES |  |  |
| 27 | change_date | TIMESTAMP | YES |  |  |
