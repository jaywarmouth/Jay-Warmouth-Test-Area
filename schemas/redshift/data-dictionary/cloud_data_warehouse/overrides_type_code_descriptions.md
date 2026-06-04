# cloud_data_warehouse.overrides_type_code_descriptions

> **Schema:** cloud_data_warehouse | **Columns:** 11

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
| 8 | type_code | BIGINT | NO |  | Required |
| 9 | type_code_description | VARCHAR(100) | YES |  |  |
| 10 | type_code_descr_ovr | VARCHAR(100) | YES |  |  |
| 11 | override_disp | VARCHAR(1) | YES |  |  |
