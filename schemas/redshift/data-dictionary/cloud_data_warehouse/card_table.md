# cloud_data_warehouse.card_table

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
| 8 | ct_card_number_on_card | VARCHAR(20) | YES |  |  |
| 9 | ct_system_number | INTEGER | YES |  |  |
| 10 | ct_sponsor_number | INTEGER | YES |  |  |
| 11 | ct_cardholder_number | VARCHAR(14) | YES |  |  |
| 12 | ct_member_number | VARCHAR(2) | YES |  |  |
| 13 | ct_card_seq_number | INTEGER | YES |  |  |
| 14 | ct_medical_id_number | VARCHAR(20) | YES |  |  |
| 15 | ct_add_date | DATE | YES |  |  |
| 16 | ct_chg_date | DATE | YES |  |  |
