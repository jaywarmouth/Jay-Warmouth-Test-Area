# cloud_data_warehouse.differential

> **Schema:** cloud_data_warehouse | **Columns:** 45

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
| 8 | system_link | VARCHAR(5) | YES |  |  |
| 9 | system | INTEGER | YES |  |  |
| 10 | sponsor | INTEGER | YES |  |  |
| 11 | group_number | FLOAT8 | YES |  |  |
| 12 | network_number | INTEGER | YES |  |  |
| 13 | nabp | INTEGER | YES |  |  |
| 14 | gpi | VARCHAR(14) | YES |  |  |
| 15 | ndc | NUMERIC(11, 0) | YES |  |  |
| 16 | claim_type | VARCHAR(6) | YES |  |  |
| 17 | diff_number | INTEGER | YES |  |  |
| 18 | date_type | VARCHAR(2) | YES |  |  |
| 19 | sequence_number | INTEGER | YES |  |  |
| 20 | message_eff_date | TIMESTAMP | YES |  |  |
| 21 | message_term_date | TIMESTAMP | YES |  |  |
| 22 | diff_percent | NUMERIC(18, 4) | YES |  |  |
| 23 | disp_fee | NUMERIC(18, 2) | YES |  |  |
| 24 | diff_description | VARCHAR(30) | YES |  |  |
| 25 | generic_add_on | NUMERIC(18, 2) | YES |  |  |
| 26 | otc_add_on | NUMERIC(18, 2) | YES |  |  |
| 27 | compound_add_on | NUMERIC(18, 2) | YES |  |  |
| 28 | brand_add_on | NUMERIC(18, 2) | YES |  |  |
| 29 | mac_table_number | INTEGER | YES |  |  |
| 30 | state_tax_pct | NUMERIC(18, 4) | YES |  |  |
| 31 | hospice_disct_pct | NUMERIC(18, 4) | YES |  |  |
| 32 | overall_disct_pct | NUMERIC(18, 4) | YES |  |  |
| 33 | minimum_fee | NUMERIC(18, 2) | YES |  |  |
| 34 | admin_fee | NUMERIC(18, 2) | YES |  |  |
| 35 | dift_negative_diff | VARCHAR(1) | YES |  |  |
| 36 | gen_tb_gpi | INTEGER | YES |  |  |
| 37 | awp_contract | VARCHAR(1) | YES |  |  |
| 38 | lessor_ucr | VARCHAR(1) | YES |  |  |
| 39 | network_neg_opt | VARCHAR(1) | YES |  |  |
| 40 | neg_apply_opt | VARCHAR(1) | YES |  |  |
| 41 | max_cap | NUMERIC(18, 2) | YES |  |  |
| 42 | add_id | VARCHAR(15) | YES |  |  |
| 43 | change_id | VARCHAR(15) | YES |  |  |
| 44 | add_date | TIMESTAMP | YES |  |  |
| 45 | chg_date | TIMESTAMP | YES |  |  |
