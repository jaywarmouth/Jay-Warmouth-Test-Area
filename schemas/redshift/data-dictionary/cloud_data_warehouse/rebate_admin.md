# cloud_data_warehouse.rebate_admin

> **Schema:** cloud_data_warehouse | **Columns:** 18

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
| 8 | contract_id | VARCHAR(20) | NO |  | Required |
| 9 | admin_fee_type | VARCHAR(6) | NO |  | Required |
| 10 | eff_date | DATE | NO |  | Required |
| 11 | term_date | DATE | NO |  | Required |
| 12 | admin_fee | NUMERIC(18, 2) | YES |  |  |
| 13 | notes | VARCHAR(60) | YES |  |  |
| 14 | mfg_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 15 | client_id | VARCHAR(30) | YES |  |  |
| 16 | formulary_name | VARCHAR(10) | YES |  |  |
| 17 | add_id | VARCHAR(15) | YES |  |  |
| 18 | change_id | VARCHAR(15) | YES |  |  |
