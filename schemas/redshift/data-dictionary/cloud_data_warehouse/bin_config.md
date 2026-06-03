# cloud_data_warehouse.bin_config

> **Schema:** cloud_data_warehouse | **Columns:** 26

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
| 11 | bin_number | VARCHAR(10) | YES |  |  |
| 12 | other_cov_code | INTEGER | YES |  |  |
| 13 | ix | CHAR(1) | YES |  |  |
| 14 | sequence_number | INTEGER | YES |  |  |
| 15 | eff_date | TIMESTAMP | YES |  |  |
| 16 | term_date | TIMESTAMP | YES |  |  |
| 17 | bin_config_type | VARCHAR(12) | YES |  |  |
| 18 | value_type | VARCHAR(20) | YES |  |  |
| 19 | except_code | INTEGER | YES |  |  |
| 20 | reject_code | INTEGER | YES |  |  |
| 21 | primary_msg | VARCHAR(39) | YES |  |  |
| 22 | secondary_msg | VARCHAR(200) | YES |  |  |
| 23 | add_id | VARCHAR(15) | YES |  |  |
| 24 | change_id | VARCHAR(15) | YES |  |  |
| 25 | add_date | TIMESTAMP | YES |  |  |
| 26 | change_date | TIMESTAMP | YES |  |  |
