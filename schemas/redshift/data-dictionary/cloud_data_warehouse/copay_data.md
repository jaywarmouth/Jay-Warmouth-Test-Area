# cloud_data_warehouse.copay_data

> **Schema:** cloud_data_warehouse | **Columns:** 42

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
| 8 | system | INTEGER | YES |  |  |
| 9 | sponsor | INTEGER | YES |  |  |
| 10 | copay_number | VARCHAR(4) | YES |  |  |
| 11 | schedule_type | VARCHAR(6) | YES |  |  |
| 12 | copay_name | VARCHAR(30) | YES |  |  |
| 13 | type_code_1 | INTEGER | YES |  |  |
| 14 | fixed_1 | NUMERIC(18, 2) | YES |  |  |
| 15 | percent_1 | NUMERIC(18, 4) | YES |  |  |
| 16 | minimum_1 | NUMERIC(18, 2) | YES |  |  |
| 17 | maximum_1 | NUMERIC(18, 2) | YES |  |  |
| 18 | dspayment_1 | INTEGER | YES |  |  |
| 19 | type_code_2 | INTEGER | YES |  |  |
| 20 | fixed_2 | NUMERIC(18, 2) | YES |  |  |
| 21 | percent_2 | NUMERIC(18, 4) | YES |  |  |
| 22 | minimum_2 | NUMERIC(18, 2) | YES |  |  |
| 23 | maximum_2 | NUMERIC(18, 2) | YES |  |  |
| 24 | dspayment_2 | INTEGER | YES |  |  |
| 25 | type_code_3 | INTEGER | YES |  |  |
| 26 | fixed_3 | NUMERIC(18, 2) | YES |  |  |
| 27 | percent_3 | NUMERIC(18, 4) | YES |  |  |
| 28 | minimum_3 | NUMERIC(18, 2) | YES |  |  |
| 29 | maximum_3 | NUMERIC(18, 2) | YES |  |  |
| 30 | dspayment_3 | INTEGER | YES |  |  |
| 31 | card_line_1 | VARCHAR(50) | YES |  |  |
| 32 | card_line_2 | VARCHAR(50) | YES |  |  |
| 33 | activity | VARCHAR(1) | YES |  |  |
| 34 | type_of_copay | VARCHAR(2) | YES |  |  |
| 35 | plus_diff_amt_ret | NUMERIC(18, 4) | YES |  |  |
| 36 | plus_diff_amt_dmr_e | NUMERIC(18, 4) | YES |  |  |
| 37 | plus_diff_amt_dmr_n | NUMERIC(18, 4) | YES |  |  |
| 38 | copay_max_ben_1 | NUMERIC(18, 2) | YES |  |  |
| 39 | copay_max_ben_2 | NUMERIC(18, 2) | YES |  |  |
| 40 | copay_max_ben_3 | NUMERIC(18, 2) | YES |  |  |
| 41 | enter_date | DATE | YES |  |  |
| 42 | change_date | DATE | YES |  |  |
