# cloud_data_warehouse.claims_msg_header

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
| 8 | batch_master | VARCHAR(8) | YES |  |  |
| 9 | claim_number | INTEGER | YES |  |  |
| 10 | segment_id | VARCHAR(4) | YES |  |  |
| 11 | seq_id | INTEGER | YES |  |  |
| 12 | ver_number | VARCHAR(2) | YES |  |  |
| 13 | trans_code | VARCHAR(2) | YES |  |  |
| 14 | transaction_count | VARCHAR(1) | YES |  |  |
| 15 | resp_status | VARCHAR(1) | YES |  |  |
| 16 | provider_qualifier | VARCHAR(2) | YES |  |  |
| 17 | pharmacy_number | INTEGER | YES |  |  |
| 18 | pharm_digit_7 | INTEGER | YES |  |  |
| 19 | npi | VARCHAR(10) | YES |  |  |
| 20 | rx_date | TIMESTAMP | YES |  |  |
| 21 | message | VARCHAR(200) | YES |  |  |
