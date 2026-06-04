# cloud_data_warehouse.claims_demographics

> **Schema:** cloud_data_warehouse | **Columns:** 16

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
| 8 | batch_number | VARCHAR(8) | YES |  |  |
| 9 | claim_number | INTEGER | YES |  |  |
| 10 | patient_street | VARCHAR(30) | YES |  |  |
| 11 | patient_city | VARCHAR(20) | YES |  |  |
| 12 | patient_state | VARCHAR(2) | YES |  |  |
| 13 | patient_zip_code | VARCHAR(15) | YES |  |  |
| 14 | patient_phone_number | VARCHAR(10) | YES |  |  |
| 15 | patient_card_id | VARCHAR(20) | YES |  |  |
| 16 | claims_demographics_key | VARCHAR(14) | YES |  |  |
