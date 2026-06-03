# cloud_data_warehouse.state_compliance

> **Schema:** cloud_data_warehouse | **Columns:** 60

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
| 8 | state_id | VARCHAR(2) | NO |  | Required |
| 9 | rec_type | VARCHAR(3) | NO |  | Required |
| 10 | date_type | VARCHAR(2) | NO |  | Required |
| 11 | data_type | VARCHAR(3) | NO |  | Required |
| 12 | data | VARCHAR(14) | NO |  | Required |
| 13 | occ | INTEGER | NO |  | Required |
| 14 | seq_nbr | INTEGER | NO |  | Required |
| 15 | eff_date | TIMESTAMP | YES |  |  |
| 16 | term_date | TIMESTAMP | YES |  |  |
| 17 | lob_1 | VARCHAR(10) | YES |  |  |
| 18 | lob_2 | VARCHAR(10) | YES |  |  |
| 19 | lob_3 | VARCHAR(10) | YES |  |  |
| 20 | lob_4 | VARCHAR(10) | YES |  |  |
| 21 | lob_5 | VARCHAR(10) | YES |  |  |
| 22 | lob_6 | VARCHAR(10) | YES |  |  |
| 23 | lob_7 | VARCHAR(10) | YES |  |  |
| 24 | lob_8 | VARCHAR(10) | YES |  |  |
| 25 | lob_9 | VARCHAR(10) | YES |  |  |
| 26 | lob_10 | VARCHAR(10) | YES |  |  |
| 27 | lob_11 | VARCHAR(10) | YES |  |  |
| 28 | lob_12 | VARCHAR(10) | YES |  |  |
| 29 | lob_13 | VARCHAR(10) | YES |  |  |
| 30 | lob_14 | VARCHAR(10) | YES |  |  |
| 31 | lob_15 | VARCHAR(10) | YES |  |  |
| 32 | lob_16 | VARCHAR(10) | YES |  |  |
| 33 | lob_17 | VARCHAR(10) | YES |  |  |
| 34 | lob_18 | VARCHAR(10) | YES |  |  |
| 35 | lob_19 | VARCHAR(10) | YES |  |  |
| 36 | lob_20 | VARCHAR(10) | YES |  |  |
| 37 | lob_21 | VARCHAR(10) | YES |  |  |
| 38 | lob_22 | VARCHAR(10) | YES |  |  |
| 39 | lob_23 | VARCHAR(10) | YES |  |  |
| 40 | lob_24 | VARCHAR(10) | YES |  |  |
| 41 | lob_25 | VARCHAR(10) | YES |  |  |
| 42 | trans_fee_001 | NUMERIC(18, 2) | YES |  |  |
| 43 | price_source_002 | VARCHAR(10) | YES |  |  |
| 44 | low_val_disp_002 | NUMERIC(18, 2) | YES |  |  |
| 45 | price_source_disp_002 | NUMERIC(18, 2) | YES |  |  |
| 46 | percent_002 | NUMERIC(18, 4) | YES |  |  |
| 47 | days_supply_elec_003 | INTEGER | YES |  |  |
| 48 | days_supply_paper_003 | INTEGER | YES |  |  |
| 49 | copay_cap_30_day_004 | NUMERIC(18, 2) | YES |  |  |
| 50 | copay_cap_90_day_004 | NUMERIC(18, 2) | YES |  |  |
| 51 | copay_type_code_004 | INTEGER | YES |  |  |
| 52 | tax_percent_005 | NUMERIC(18, 4) | YES |  |  |
| 53 | flat_tax_005 | NUMERIC(18, 2) | YES |  |  |
| 54 | rebate_amt_006 | NUMERIC(18, 2) | YES |  |  |
| 55 | rebate_type_006 | VARCHAR(5) | YES |  |  |
| 56 | add_id | VARCHAR(15) | YES |  |  |
| 57 | change_id | VARCHAR(15) | YES |  |  |
| 58 | add_date | TIMESTAMP | YES |  |  |
| 59 | change_date | TIMESTAMP | YES |  |  |
| 60 | cap_90_app_flag_004 | VARCHAR(1) | YES |  |  |
