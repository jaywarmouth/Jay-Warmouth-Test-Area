# cloud_data_warehouse.card_range

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
| 8 | group_number | FLOAT8 | YES |  |  |
| 9 | occurrence | INTEGER | YES |  |  |
| 10 | record_type | VARCHAR(1) | YES |  |  |
| 11 | start_id_range | VARCHAR(20) | YES |  |  |
| 12 | stop_id_range | VARCHAR(20) | YES |  |  |
| 13 | cdv | VARCHAR(5) | YES |  |  |
| 14 | eff_date | TIMESTAMP | YES |  |  |
| 15 | term_date | TIMESTAMP | YES |  |  |
| 16 | pdmi_group_number | FLOAT8 | YES |  |  |
| 17 | member_number | VARCHAR(2) | YES |  |  |
| 18 | call_to_activate | VARCHAR(1) | YES |  |  |
| 19 | call_to_act_phone | VARCHAR(12) | YES |  |  |
| 20 | pa_flag | VARCHAR(1) | YES |  |  |
| 21 | pa_phone_number | VARCHAR(12) | YES |  |  |
| 22 | last_num_used_numless | VARCHAR(20) | YES |  |  |
| 23 | numless_eff_flag | VARCHAR(1) | YES |  |  |
| 24 | numless_eff_days | INTEGER | YES |  |  |
| 25 | numless_ter_flag | VARCHAR(1) | YES |  |  |
| 26 | numless_ter_days | INTEGER | YES |  |  |
| 27 | numless_1000_remaining_flag | VARCHAR(1) | YES |  |  |
| 28 | numless_500_remaining_flag | VARCHAR(1) | YES |  |  |
| 29 | numless_1000_remaining_date | TIMESTAMP | YES |  |  |
| 30 | numless_500_remaining_date | TIMESTAMP | YES |  |  |
| 31 | numless_range_added_flag | VARCHAR(1) | YES |  |  |
| 32 | help_desk_phone | VARCHAR(12) | YES |  |  |
| 33 | add_date | TIMESTAMP | YES |  |  |
| 34 | change_date | TIMESTAMP | YES |  |  |
| 35 | add_id | VARCHAR(15) | YES |  |  |
| 36 | change_id | VARCHAR(15) | YES |  |  |
