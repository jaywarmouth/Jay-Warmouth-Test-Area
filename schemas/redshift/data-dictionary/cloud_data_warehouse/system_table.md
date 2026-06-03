# cloud_data_warehouse.system_table

> **Schema:** cloud_data_warehouse | **Columns:** 29

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
| 8 | system_nbr | INTEGER | NO |  | Required |
| 9 | system_name | VARCHAR(30) | YES |  |  |
| 10 | address_1 | VARCHAR(30) | YES |  |  |
| 11 | address_2 | VARCHAR(30) | YES |  |  |
| 12 | city | VARCHAR(18) | YES |  |  |
| 13 | state | VARCHAR(2) | YES |  |  |
| 14 | zip | VARCHAR(5) | YES |  |  |
| 15 | pa_phone | VARCHAR(21) | YES |  |  |
| 16 | help_desk_phone | VARCHAR(14) | YES |  |  |
| 17 | help_desk_fax | VARCHAR(14) | YES |  |  |
| 18 | system_in | VARCHAR(4) | YES |  |  |
| 19 | report_title | VARCHAR(30) | YES |  |  |
| 20 | zip4 | VARCHAR(4) | YES |  |  |
| 21 | system_link | VARCHAR(5) | YES |  |  |
| 22 | active_code | VARCHAR(1) | YES |  |  |
| 23 | state_code | VARCHAR(2) | YES |  |  |
| 24 | benefit_code | VARCHAR(1) | YES |  |  |
| 25 | rebate_flag | VARCHAR(1) | YES |  |  |
| 26 | client_type | VARCHAR(5) | YES |  |  |
| 27 | claim_bin_nbr | INTEGER | YES |  |  |
| 28 | entry_date | DATE | YES |  |  |
| 29 | change_date | DATE | YES |  |  |
