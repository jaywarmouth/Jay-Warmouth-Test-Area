# cloud_data_warehouse.pharmacy_data

> **Schema:** cloud_data_warehouse | **Columns:** 12

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
| 8 | pharmacy_number | BIGINT | NO |  | Required |
| 9 | pharmacy_name | VARCHAR(100) | YES |  |  |
| 10 | city | VARCHAR(18) | YES |  |  |
| 11 | state | VARCHAR(2) | YES |  |  |
| 12 | zip | VARCHAR(5) | YES |  |  |
