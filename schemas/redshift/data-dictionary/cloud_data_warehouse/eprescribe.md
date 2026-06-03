# cloud_data_warehouse.eprescribe

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
| 8 | system_number | INTEGER | YES |  |  |
| 9 | sponsor_number | INTEGER | YES |  |  |
| 10 | group_number | FLOAT8 | YES |  |  |
| 11 | cardholder_number | CHAR(10) | YES |  |  |
| 12 | member_number | CHAR(2) | YES |  |  |
| 13 | provider_npidea | VARCHAR(14) | YES |  |  |
| 14 | request_date_time | TIMESTAMP | YES |  |  |
| 15 | system_date_time | TIMESTAMP | YES |  |  |
| 16 | request_type | CHAR(3) | YES |  |  |
| 17 | request_dep_sent | CHAR(1) | YES |  |  |
| 18 | provider_type | CHAR(3) | YES |  |  |
| 19 | member_name | VARCHAR(35) | YES |  |  |
| 20 | plan_number | CHAR(8) | YES |  |  |
| 21 | birth_date | TIMESTAMP | YES |  |  |
| 22 | eff_date | TIMESTAMP | YES |  |  |
| 23 | term_date | TIMESTAMP | YES |  |  |
| 24 | crd_manual_change_date | TIMESTAMP | YES |  |  |
| 25 | crd_file_change_date | TIMESTAMP | YES |  |  |
| 26 | clm_start_date | TIMESTAMP | YES |  |  |
| 27 | clm_end_date | TIMESTAMP | YES |  |  |
| 28 | gender | CHAR(1) | YES |  |  |
| 29 | cov_id | VARCHAR(8) | YES |  |  |
| 30 | copay_id | VARCHAR(8) | YES |  |  |
| 31 | formulary_id | VARCHAR(12) | YES |  |  |
| 32 | crd_rel_code | CHAR(1) | YES |  |  |
| 33 | cat_cardholder_number | VARCHAR(20) | YES |  |  |
| 34 | clm_count | INTEGER | YES |  |  |
| 35 | clm_consent | CHAR(1) | YES |  |  |
| 36 | clm_status_reason | VARCHAR(25) | YES |  |  |
| 37 | bill_status | CHAR(1) | YES |  |  |
| 38 | bill_reason | VARCHAR(25) | YES |  |  |
| 39 | aaa_status_code | VARCHAR(5) | YES |  |  |
| 40 | request_file_name | VARCHAR(25) | YES |  |  |
| 41 | duplicate | SMALLINT | YES |  |  |
| 42 | add_id | VARCHAR(15) | YES |  |  |
| 43 | change_id | VARCHAR(15) | YES |  |  |
| 44 | add_date | TIMESTAMP | YES |  |  |
| 45 | change_date | TIMESTAMP | YES |  |  |
