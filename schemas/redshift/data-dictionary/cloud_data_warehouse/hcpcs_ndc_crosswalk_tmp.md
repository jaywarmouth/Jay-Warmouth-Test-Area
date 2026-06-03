# cloud_data_warehouse.hcpcs_ndc_crosswalk_tmp

> **Schema:** cloud_data_warehouse | **Columns:** 18

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
| 8 | hcspcscode | VARCHAR(10) | YES |  |  |
| 9 | short_description | VARCHAR(250) | YES |  |  |
| 10 | labeler_name | VARCHAR(250) | YES |  |  |
| 11 | ndc_2 | NUMERIC(11, 0) | YES |  |  |
| 12 | drug_name | VARCHAR(250) | YES |  |  |
| 13 | hcpcs_dosage | VARCHAR(250) | YES |  |  |
| 14 | pkg_size | VARCHAR(250) | YES |  |  |
| 15 | pkg_qty | VARCHAR(250) | YES |  |  |
| 16 | bill_units | VARCHAR(250) | YES |  |  |
| 17 | bill_units_pkg | VARCHAR(250) | YES |  |  |
| 18 | file_name | VARCHAR(250) | YES |  |  |
