# cloud_data_warehouse.claimcompound

> **Schema:** cloud_data_warehouse | **Columns:** 31

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
| 8 | batch_master | VARCHAR(10) | NO |  | Required |
| 9 | claim_number | INTEGER | NO |  | Required |
| 10 | ing_number | INTEGER | NO |  | Required |
| 11 | ndc | NUMERIC(11, 0) | YES |  |  |
| 12 | metric_quantity | NUMERIC(18, 3) | YES |  |  |
| 13 | ing_cost_billed | NUMERIC(18, 2) | YES |  |  |
| 14 | ing_bcd | INTEGER | YES |  |  |
| 15 | reject_code_1 | INTEGER | YES |  |  |
| 16 | reject_code_2 | INTEGER | YES |  |  |
| 17 | pdm_ing_cost | NUMERIC(18, 2) | YES |  |  |
| 18 | awp_cost | NUMERIC(18, 2) | YES |  |  |
| 19 | exception_code_1 | INTEGER | YES |  |  |
| 20 | exception_code_2 | INTEGER | YES |  |  |
| 21 | exception_code_3 | INTEGER | YES |  |  |
| 22 | exception_code_4 | INTEGER | YES |  |  |
| 23 | exception_code_5 | INTEGER | YES |  |  |
| 24 | generic_code | VARCHAR(1) | YES |  |  |
| 25 | medd_drug_type | VARCHAR(1) | YES |  |  |
| 26 | mac_reference_price | NUMERIC(18, 2) | YES |  |  |
| 27 | contract_rate_price | NUMERIC(18, 2) | YES |  |  |
| 28 | pde_ing_cost_paid | NUMERIC(18, 2) | YES |  |  |
| 29 | ndc_type_code | INTEGER | YES |  |  |
| 30 | wac_reference_price | NUMERIC(18, 2) | YES |  |  |
| 31 | claim_key | VARCHAR(14) | YES |  |  |
