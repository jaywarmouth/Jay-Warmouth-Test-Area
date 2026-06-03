# cloud_data_warehouse.npi

> **Schema:** cloud_data_warehouse | **Columns:** 30

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
| 8 | npi | VARCHAR(10) | NO |  | Required |
| 9 | entity_code | VARCHAR(1) | YES |  |  |
| 10 | business_name | VARCHAR(45) | YES |  |  |
| 11 | last_name | VARCHAR(35) | YES |  |  |
| 12 | first_name | VARCHAR(20) | YES |  |  |
| 13 | middle_initial | VARCHAR(1) | YES |  |  |
| 14 | location_address_1 | VARCHAR(25) | YES |  |  |
| 15 | location_address_2 | VARCHAR(25) | YES |  |  |
| 16 | location_city | VARCHAR(25) | YES |  |  |
| 17 | location_state | VARCHAR(2) | YES |  |  |
| 18 | location_zip | VARCHAR(5) | YES |  |  |
| 19 | location_zip_5 | INTEGER | YES |  |  |
| 20 | location_country | VARCHAR(2) | YES |  |  |
| 21 | location_phone | VARCHAR(10) | YES |  |  |
| 22 | enumeration_date | TIMESTAMP | YES |  |  |
| 23 | update_date | TIMESTAMP | YES |  |  |
| 24 | add_date | TIMESTAMP | YES |  |  |
| 25 | chg_date | TIMESTAMP | YES |  |  |
| 26 | business_fax | VARCHAR(20) | YES |  |  |
| 27 | practice_fax | VARCHAR(20) | YES |  |  |
| 28 | deactivation_reason_cd | VARCHAR(2) | YES |  |  |
| 29 | deactivation_date | TIMESTAMP | YES |  |  |
| 30 | reactivation_date | TIMESTAMP | YES |  |  |
