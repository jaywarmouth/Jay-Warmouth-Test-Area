# cloud_data_warehouse.exception_code

> **Schema:** cloud_data_warehouse | **Columns:** 22

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
| 8 | exception_code | INTEGER | YES |  |  |
| 9 | desc_1 | VARCHAR(40) | YES |  |  |
| 10 | desc_2 | VARCHAR(40) | YES |  |  |
| 11 | desc_3 | VARCHAR(40) | YES |  |  |
| 12 | desc_4 | VARCHAR(40) | YES |  |  |
| 13 | desc_5 | VARCHAR(40) | YES |  |  |
| 14 | desc_6 | VARCHAR(40) | YES |  |  |
| 15 | system_specific | VARCHAR(1) | YES |  |  |
| 16 | sponsor_specific | VARCHAR(1) | YES |  |  |
| 17 | plan_specific | VARCHAR(1) | YES |  |  |
| 18 | group_specific | VARCHAR(1) | YES |  |  |
| 19 | pharm_specific | VARCHAR(1) | YES |  |  |
| 20 | card_specific | VARCHAR(1) | YES |  |  |
| 21 | drug_specific | VARCHAR(1) | YES |  |  |
| 22 | active_code | VARCHAR(1) | YES |  |  |
