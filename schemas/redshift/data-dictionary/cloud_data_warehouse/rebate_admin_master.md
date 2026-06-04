# cloud_data_warehouse.rebate_admin_master

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
| 8 | system_number | BIGINT | NO |  | Required |
| 9 | sponsor_number | BIGINT | NO |  | Required |
| 10 | group_number | VARCHAR(20) | NO |  | Required |
| 11 | esi_contract | VARCHAR(20) | NO |  | Required |
| 12 | fee_type | VARCHAR(6) | NO |  | Required |
| 13 | rec_type | VARCHAR(10) | NO |  | Required |
| 14 | seq_no | BIGINT | NO |  | Required |
| 15 | eff_date | DATE | YES |  |  |
| 16 | term_date | DATE | YES |  |  |
| 17 | pay_out_level | VARCHAR(1) | YES |  |  |
| 18 | adm_fee_pay_rate | NUMERIC(18, 2) | YES |  |  |
| 19 | percent_fee | NUMERIC(18, 4) | YES |  |  |
| 20 | true_up | VARCHAR(1) | YES |  |  |
| 21 | true_up_share | VARCHAR(1) | YES |  |  |
| 22 | client_id | VARCHAR(30) | YES |  |  |
| 23 | formulary_name | VARCHAR(10) | YES |  |  |
| 24 | add_id | VARCHAR(15) | YES |  |  |
| 25 | change_id | VARCHAR(15) | YES |  |  |
