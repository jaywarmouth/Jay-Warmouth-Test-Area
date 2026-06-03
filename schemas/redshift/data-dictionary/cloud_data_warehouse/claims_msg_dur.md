# cloud_data_warehouse.claims_msg_dur

> **Schema:** cloud_data_warehouse | **Columns:** 20

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
| 12 | conflict_code | VARCHAR(2) | YES |  |  |
| 13 | severity | INTEGER | YES |  |  |
| 14 | other_pharmacy | INTEGER | YES |  |  |
| 15 | prev_fill_date | TIMESTAMP | YES |  |  |
| 16 | prev_met_quan | NUMERIC(18, 3) | YES |  |  |
| 17 | database_ind | VARCHAR(1) | YES |  |  |
| 18 | other_prescri | INTEGER | YES |  |  |
| 19 | free_text | VARCHAR(30) | YES |  |  |
| 20 | add_text | VARCHAR(100) | YES |  |  |
