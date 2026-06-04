# cloud_data_warehouse.brand_benefit

> **Schema:** cloud_data_warehouse | **Columns:** 28

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
| 8 | brand_benefit_id | VARCHAR(20) | YES |  |  |
| 9 | ndc_gpi | VARCHAR(14) | YES |  |  |
| 10 | territory_id | VARCHAR(8) | YES |  |  |
| 11 | oth_pay_rej_found | VARCHAR(4) | YES |  |  |
| 12 | eff_date | TIMESTAMP | YES |  |  |
| 13 | redemp_count_min | INTEGER | YES |  |  |
| 14 | redemp_count_max | INTEGER | YES |  |  |
| 15 | cob | VARCHAR(1) | YES |  |  |
| 16 | days_supply_min | INTEGER | YES |  |  |
| 17 | days_supply_max | INTEGER | YES |  |  |
| 18 | met_qty_min | NUMERIC(18, 3) | YES |  |  |
| 19 | met_qty_max | NUMERIC(18, 3) | YES |  |  |
| 20 | occurence | INTEGER | YES |  |  |
| 21 | copay | NUMERIC(18, 2) | YES |  |  |
| 22 | max_claim_amt | NUMERIC(18, 2) | YES |  |  |
| 23 | term_date | TIMESTAMP | YES |  |  |
| 24 | add_date | TIMESTAMP | YES |  |  |
| 25 | change_date | TIMESTAMP | YES |  |  |
| 26 | max_awp_wac_pct | NUMERIC(18, 4) | YES |  |  |
| 27 | alt_reimb_gen_type | VARCHAR(6) | YES |  |  |
| 28 | benefit_msg_flag | VARCHAR(1) | YES |  |  |
