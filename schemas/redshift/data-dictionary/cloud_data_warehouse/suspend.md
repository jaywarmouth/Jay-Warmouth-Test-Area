# cloud_data_warehouse.suspend

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
| 8 | system_number | INTEGER | YES |  |  |
| 9 | sponsor_number | INTEGER | YES |  |  |
| 10 | group_number | FLOAT8 | YES |  |  |
| 11 | period_ending | DATE | YES |  |  |
| 12 | alt_group_number | VARCHAR(20) | YES |  |  |
| 13 | invoice_amount | FLOAT8 | YES |  |  |
| 14 | claim_count | INTEGER | YES |  |  |
| 15 | grp_invoice_number | INTEGER | YES |  |  |
| 16 | spo_invoice_number | INTEGER | YES |  |  |
| 17 | sys_invoice_number | INTEGER | YES |  |  |
| 18 | release_flag | VARCHAR(1) | YES |  |  |
| 19 | paid_date | DATE | YES |  |  |
| 20 | differential_amount | NUMERIC(12, 2) | YES |  |  |
| 21 | admin_fee | FLOAT8 | YES |  |  |
| 22 | manual_date | DATE | YES |  |  |
| 23 | file_date | DATE | YES |  |  |
| 24 | release_date | DATE | YES |  |  |
| 25 | deposit_date | DATE | YES |  |  |
