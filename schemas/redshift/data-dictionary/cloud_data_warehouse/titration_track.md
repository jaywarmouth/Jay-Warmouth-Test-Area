# cloud_data_warehouse.titration_track

> **Schema:** cloud_data_warehouse | **Columns:** 29

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
| 8 | cardholder_number | VARCHAR(10) | YES |  |  |
| 9 | member_number | VARCHAR(2) | YES |  |  |
| 10 | sponsor_number | INTEGER | YES |  |  |
| 11 | ndc_gpi | VARCHAR(14) | YES |  |  |
| 12 | sequence_nbr | INTEGER | YES |  |  |
| 13 | fill_number | INTEGER | YES |  |  |
| 14 | start_date | TIMESTAMP | YES |  |  |
| 15 | claim_key | VARCHAR(14) | YES |  |  |
| 16 | paid_flag | VARCHAR(1) | YES |  |  |
| 17 | rx_date | TIMESTAMP | YES |  |  |
| 18 | met_quantity | NUMERIC(18, 3) | YES |  |  |
| 19 | claim_days_supply | BIGINT | YES |  |  |
| 20 | claim_ndc | NUMERIC(11, 0) | YES |  |  |
| 21 | rules_breached | VARCHAR(1) | YES |  |  |
| 22 | titration_type | VARCHAR(1) | YES |  |  |
| 23 | days_between_min | INTEGER | YES |  |  |
| 24 | days_between_max | INTEGER | YES |  |  |
| 25 | add_id | VARCHAR(15) | YES |  |  |
| 26 | change_id | VARCHAR(15) | YES |  |  |
| 27 | add_date | TIMESTAMP | YES |  |  |
| 28 | change_date | TIMESTAMP | YES |  |  |
| 29 | cardholder_key | VARCHAR(20) | YES |  |  |
