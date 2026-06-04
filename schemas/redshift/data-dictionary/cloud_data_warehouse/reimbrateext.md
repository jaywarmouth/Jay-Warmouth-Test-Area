# cloud_data_warehouse.reimbrateext

> **Schema:** cloud_data_warehouse | **Columns:** 51

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
| 8 | reimb_rate_number | INTEGER | NO |  | Required |
| 9 | gen_type | VARCHAR(6) | NO |  | Required |
| 10 | reimb_rate_descr | VARCHAR(50) | YES |  |  |
| 11 | reimb_rate_descr_code | BIGINT | YES |  |  |
| 12 | awp_percent | NUMERIC(18, 4) | YES |  |  |
| 13 | fee | NUMERIC(18, 2) | YES |  |  |
| 14 | mac_table | INTEGER | YES |  |  |
| 15 | mac_fee | NUMERIC(18, 2) | YES |  |  |
| 16 | flat_fee | NUMERIC(18, 2) | YES |  |  |
| 17 | cap_amt | NUMERIC(18, 2) | YES |  |  |
| 18 | per_month | VARCHAR(1) | YES |  |  |
| 19 | active | VARCHAR(1) | YES |  |  |
| 20 | otc_fee | NUMERIC(18, 2) | YES |  |  |
| 21 | pay_as_contract_rate | VARCHAR(1) | YES |  |  |
| 22 | mark_percent | NUMERIC(18, 4) | YES |  |  |
| 23 | mark_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 24 | plus_diff_table_1 | INTEGER | YES |  |  |
| 25 | plus_diff_table_eff_date_1 | TIMESTAMP | YES |  |  |
| 26 | plus_diff_table_2 | INTEGER | YES |  |  |
| 27 | plus_diff_table_eff_date_2 | TIMESTAMP | YES |  |  |
| 28 | plus_diff_table_3 | INTEGER | YES |  |  |
| 29 | plus_diff_table_eff_date_3 | TIMESTAMP | YES |  |  |
| 30 | pdm_mac_flag | VARCHAR(1) | YES |  |  |
| 31 | min_reimb_amt | NUMERIC(18, 2) | YES |  |  |
| 32 | elect_fee | NUMERIC(18, 2) | YES |  |  |
| 33 | inc_fee | NUMERIC(18, 2) | YES |  |  |
| 34 | discount_net_fee | NUMERIC(18, 2) | YES |  |  |
| 35 | mac_awp_percent | NUMERIC(18, 4) | YES |  |  |
| 36 | mac_awp_number | INTEGER | YES |  |  |
| 37 | awp_factor | NUMERIC(18, 4) | YES |  |  |
| 38 | mac_factor_table | INTEGER | YES |  |  |
| 39 | cap_340b | NUMERIC(18, 2) | YES |  |  |
| 40 | eft_fee | NUMERIC(18, 2) | YES |  |  |
| 41 | wac_fee | NUMERIC(18, 2) | YES |  |  |
| 42 | wac_percent | NUMERIC(18, 4) | YES |  |  |
| 43 | disp_fee_340b | NUMERIC(18, 2) | YES |  |  |
| 44 | reimb_fix_amt | NUMERIC(18, 2) | YES |  |  |
| 45 | reimb_cap_amt | NUMERIC(18, 2) | YES |  |  |
| 46 | add_id | VARCHAR(15) | YES |  |  |
| 47 | change_id | VARCHAR(15) | YES |  |  |
| 48 | add_date | TIMESTAMP | YES |  |  |
| 49 | change_date | TIMESTAMP | YES |  |  |
| 50 | ext_date | TIMESTAMP | YES |  |  |
| 51 | add_on_percent | NUMERIC(18, 4) | YES |  |  |
