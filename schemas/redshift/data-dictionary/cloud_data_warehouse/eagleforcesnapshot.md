# cloud_data_warehouse.eagleforcesnapshot

> **Schema:** cloud_data_warehouse | **Columns:** 36

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
| 8 | claim_key | VARCHAR(14) | YES |  |  |
| 9 | batch_master | VARCHAR(8) | YES |  |  |
| 10 | claim_number | INTEGER | YES |  |  |
| 11 | claim_type | VARCHAR(1) | YES |  |  |
| 12 | bin | VARCHAR(8) | YES |  |  |
| 13 | pcn | VARCHAR(10) | YES |  |  |
| 14 | group_number | FLOAT8 | YES |  |  |
| 15 | medication | VARCHAR(12) | YES |  |  |
| 16 | date_of_service | DATE | YES |  |  |
| 17 | member_id | VARCHAR(12) | YES |  |  |
| 18 | f_name | VARCHAR(12) | YES |  |  |
| 19 | l_name | VARCHAR(15) | YES |  |  |
| 20 | gender | VARCHAR(1) | YES |  |  |
| 21 | dob | DATE | YES |  |  |
| 22 | address | VARCHAR(100) | YES |  |  |
| 23 | city | VARCHAR(50) | YES |  |  |
| 24 | state | VARCHAR(2) | YES |  |  |
| 25 | zip | VARCHAR(15) | YES |  |  |
| 26 | token | VARCHAR(50) | YES |  |  |
| 27 | result | VARCHAR(10) | YES |  |  |
| 28 | excep_code | VARCHAR(10) | YES |  |  |
| 29 | info | VARCHAR(200) | YES |  |  |
| 30 | pdmi_result | VARCHAR(10) | YES |  |  |
| 31 | post_status | VARCHAR(3) | YES |  |  |
| 32 | post_message | VARCHAR(50) | YES |  |  |
| 33 | send_date | DATE | YES |  |  |
| 34 | receive_date | DATE | YES |  |  |
| 35 | add_date | DATE | YES |  |  |
| 36 | user_id | VARCHAR(20) | YES |  |  |
