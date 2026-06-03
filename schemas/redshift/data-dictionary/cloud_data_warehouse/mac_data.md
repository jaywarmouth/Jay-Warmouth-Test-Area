# cloud_data_warehouse.mac_data

> **Schema:** cloud_data_warehouse | **Columns:** 34

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
| 8 | mac_number | BIGINT | NO |  | Required |
| 9 | gpi | VARCHAR(14) | NO |  | Required |
| 10 | change_date_1 | DATE | YES |  |  |
| 11 | mac_unit_price_1 | NUMERIC(18, 5) | YES |  |  |
| 12 | change_date_2 | DATE | YES |  |  |
| 13 | mac_unit_price_2 | NUMERIC(18, 5) | YES |  |  |
| 14 | change_date_3 | DATE | YES |  |  |
| 15 | mac_unit_price_3 | NUMERIC(18, 5) | YES |  |  |
| 16 | change_date_4 | DATE | YES |  |  |
| 17 | mac_unit_price_4 | NUMERIC(18, 5) | YES |  |  |
| 18 | change_date_5 | DATE | YES |  |  |
| 19 | mac_unit_price_5 | NUMERIC(18, 5) | YES |  |  |
| 20 | change_date_6 | DATE | YES |  |  |
| 21 | mac_unit_price_6 | NUMERIC(18, 5) | YES |  |  |
| 22 | change_date_7 | DATE | YES |  |  |
| 23 | mac_unit_price_7 | NUMERIC(18, 5) | YES |  |  |
| 24 | change_date_8 | DATE | YES |  |  |
| 25 | mac_unit_price_8 | NUMERIC(18, 5) | YES |  |  |
| 26 | change_date_9 | DATE | YES |  |  |
| 27 | mac_unit_price_9 | NUMERIC(18, 5) | YES |  |  |
| 28 | change_date_10 | DATE | YES |  |  |
| 29 | mac_unit_price_10 | NUMERIC(18, 5) | YES |  |  |
| 30 | type_code | VARCHAR(2) | YES |  |  |
| 31 | ndc | VARCHAR(11) | YES |  |  |
| 32 | on_generic_only | VARCHAR(1) | YES |  |  |
| 33 | prevails_flag | VARCHAR(1) | YES |  |  |
| 34 | minimum_pack_size | NUMERIC(18, 3) | YES |  |  |
