# cloud_data_warehouse.physician_sponsor

> **Schema:** cloud_data_warehouse | **Columns:** 41

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
| 8 | physician_sponsor | INTEGER | YES |  |  |
| 9 | physician_number | VARCHAR(14) | YES |  |  |
| 10 | physician_last_name | VARCHAR(30) | YES |  |  |
| 11 | physician_first_name | VARCHAR(30) | YES |  |  |
| 12 | physician_mi | VARCHAR(1) | YES |  |  |
| 13 | physician_address_1 | VARCHAR(40) | YES |  |  |
| 14 | physician_address_2 | VARCHAR(40) | YES |  |  |
| 15 | physician_city | VARCHAR(30) | YES |  |  |
| 16 | physician_state | VARCHAR(2) | YES |  |  |
| 17 | phys_zip | VARCHAR(10) | YES |  |  |
| 18 | physician_zip_code | VARCHAR(10) | YES |  |  |
| 19 | phys_zip4 | VARCHAR(10) | YES |  |  |
| 20 | physician_specialty | VARCHAR(10) | YES |  |  |
| 21 | phys_secondary_specialty_1 | VARCHAR(10) | YES |  |  |
| 22 | phys_secondary_specialty_2 | VARCHAR(10) | YES |  |  |
| 23 | phys_secondary_specialty_3 | VARCHAR(10) | YES |  |  |
| 24 | phys_secondary_specialty_4 | VARCHAR(10) | YES |  |  |
| 25 | phys_state_id | VARCHAR(14) | YES |  |  |
| 26 | phys_oh_med_id | VARCHAR(14) | YES |  |  |
| 27 | phys_dea_number | VARCHAR(14) | YES |  |  |
| 28 | phys_eff_date | TIMESTAMP | YES |  |  |
| 29 | phys_ter_date | TIMESTAMP | YES |  |  |
| 30 | phys_status | VARCHAR(1) | YES |  |  |
| 31 | phys_print_flag | VARCHAR(1) | YES |  |  |
| 32 | phys_system_phy_id_num | VARCHAR(14) | YES |  |  |
| 33 | phys_pho_nbr_1 | VARCHAR(14) | YES |  |  |
| 34 | phys_eff_1 | TIMESTAMP | YES |  |  |
| 35 | phys_pho_nbr_2 | VARCHAR(14) | YES |  |  |
| 36 | phys_eff_2 | TIMESTAMP | YES |  |  |
| 37 | phys_pho_nbr_3 | VARCHAR(14) | YES |  |  |
| 38 | phys_eff_3 | TIMESTAMP | YES |  |  |
| 39 | phys_ind_grp | VARCHAR(3) | YES |  |  |
| 40 | phys_manual_date | TIMESTAMP | YES |  |  |
| 41 | phys_file_date | TIMESTAMP | YES |  |  |
