# cloud_data_warehouse.generic_drug_desc_master

> **Schema:** cloud_data_warehouse | **Columns:** 21

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
| 8 | drug_status_code | VARCHAR(1) | YES |  |  |
| 9 | drug_status_code_name | VARCHAR(30) | YES |  |  |
| 10 | desc_1 | VARCHAR(40) | YES |  |  |
| 11 | desc_2 | VARCHAR(40) | YES |  |  |
| 12 | desc_3 | VARCHAR(40) | YES |  |  |
| 13 | desc_4 | VARCHAR(40) | YES |  |  |
| 14 | field_notes_1 | VARCHAR(30) | YES |  |  |
| 15 | field_notes_2 | VARCHAR(30) | YES |  |  |
| 16 | formulary_flag | VARCHAR(1) | YES |  |  |
| 17 | maintenance_flag | VARCHAR(1) | YES |  |  |
| 18 | drug_status_flag | VARCHAR(1) | YES |  |  |
| 19 | ndc_exclusion_flag | VARCHAR(1) | YES |  |  |
| 20 | add_date | TIMESTAMP | YES |  |  |
| 21 | change_date | TIMESTAMP | YES |  |  |
