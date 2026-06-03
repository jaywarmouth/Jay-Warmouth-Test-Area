# cloud_data_warehouse.drug_340b

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
| 8 | group_nbr | FLOAT8 | YES |  |  |
| 9 | pharmacy_nbr | INTEGER | YES |  |  |
| 10 | ndc | NUMERIC(11, 0) | YES |  |  |
| 11 | eff_date | TIMESTAMP | YES |  |  |
| 12 | unit_cost | NUMERIC(18, 5) | YES |  |  |
| 13 | add_date | TIMESTAMP | YES |  |  |
| 14 | change_date | TIMESTAMP | YES |  |  |
| 15 | term_date | TIMESTAMP | YES |  |  |
| 16 | version_nbr | VARCHAR(256) | YES |  |  |
