# cloud_data_warehouse.cardholder_data

> **Schema:** cloud_data_warehouse | **Columns:** 90

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
| 8 | cardholder_key | VARCHAR(20) | YES |  |  |
| 9 | cardholder_number | VARCHAR(10) | YES |  |  |
| 10 | member_number | VARCHAR(2) | YES |  |  |
| 11 | alt_cardholder_number | VARCHAR(26) | YES |  |  |
| 12 | first_name | VARCHAR(15) | YES |  |  |
| 13 | middle_initial | VARCHAR(1) | YES |  |  |
| 14 | birth_date | TIMESTAMP | YES |  |  |
| 15 | sex | VARCHAR(1) | YES |  |  |
| 16 | relationship_code | VARCHAR(1) | YES |  |  |
| 17 | city | VARCHAR(20) | YES |  |  |
| 18 | state | VARCHAR(2) | YES |  |  |
| 19 | zip | BIGINT | YES |  |  |
| 20 | grp_1 | VARCHAR(20) | YES |  |  |
| 21 | eff_date_1 | TIMESTAMP | YES |  |  |
| 22 | ter_date_1 | TIMESTAMP | YES |  |  |
| 23 | coverage_type_1 | VARCHAR(1) | YES |  |  |
| 24 | cobra_flag_1 | VARCHAR(1) | YES |  |  |
| 25 | last_name | VARCHAR(30) | YES |  |  |
| 26 | street_1 | VARCHAR(100) | YES |  |  |
| 27 | street_2 | VARCHAR(100) | YES |  |  |
| 28 | spon_number | BIGINT | YES |  |  |
| 29 | card_number_on_card | VARCHAR(20) | YES |  |  |
| 30 | eob_production | VARCHAR(1) | YES |  |  |
| 31 | grp_2 | VARCHAR(20) | YES |  |  |
| 32 | eff_date_2 | TIMESTAMP | YES |  |  |
| 33 | ter_date_2 | TIMESTAMP | YES |  |  |
| 34 | coverage_type_2 | VARCHAR(1) | YES |  |  |
| 35 | cobra_flag_2 | VARCHAR(1) | YES |  |  |
| 36 | grp_3 | VARCHAR(20) | YES |  |  |
| 37 | eff_date_3 | TIMESTAMP | YES |  |  |
| 38 | ter_date_3 | TIMESTAMP | YES |  |  |
| 39 | coverage_type_3 | VARCHAR(1) | YES |  |  |
| 40 | cobra_flag_3 | VARCHAR(1) | YES |  |  |
| 41 | grp_4 | VARCHAR(20) | YES |  |  |
| 42 | eff_date_4 | TIMESTAMP | YES |  |  |
| 43 | ter_date_4 | TIMESTAMP | YES |  |  |
| 44 | coverage_type_4 | VARCHAR(1) | YES |  |  |
| 45 | cobra_flag_4 | VARCHAR(1) | YES |  |  |
| 46 | grp_5 | VARCHAR(20) | YES |  |  |
| 47 | eff_date_5 | TIMESTAMP | YES |  |  |
| 48 | ter_date_5 | TIMESTAMP | YES |  |  |
| 49 | coverage_type_5 | VARCHAR(1) | YES |  |  |
| 50 | cobra_flag_5 | VARCHAR(1) | YES |  |  |
| 51 | grp_6 | VARCHAR(20) | YES |  |  |
| 52 | eff_date_6 | TIMESTAMP | YES |  |  |
| 53 | ter_date_6 | TIMESTAMP | YES |  |  |
| 54 | coverage_type_6 | VARCHAR(1) | YES |  |  |
| 55 | cobra_flag_6 | VARCHAR(1) | YES |  |  |
| 56 | grp_7 | VARCHAR(20) | YES |  |  |
| 57 | eff_date_7 | TIMESTAMP | YES |  |  |
| 58 | ter_date_7 | TIMESTAMP | YES |  |  |
| 59 | coverage_type_7 | VARCHAR(1) | YES |  |  |
| 60 | cobra_flag_7 | VARCHAR(1) | YES |  |  |
| 61 | grp_8 | VARCHAR(20) | YES |  |  |
| 62 | eff_date_8 | TIMESTAMP | YES |  |  |
| 63 | ter_date_8 | TIMESTAMP | YES |  |  |
| 64 | coverage_type_8 | VARCHAR(1) | YES |  |  |
| 65 | cobra_flag_8 | VARCHAR(1) | YES |  |  |
| 66 | grp_9 | VARCHAR(20) | YES |  |  |
| 67 | eff_date_9 | TIMESTAMP | YES |  |  |
| 68 | ter_date_9 | TIMESTAMP | YES |  |  |
| 69 | coverage_type_9 | VARCHAR(1) | YES |  |  |
| 70 | cobra_flag_9 | VARCHAR(1) | YES |  |  |
| 71 | grp_10 | VARCHAR(20) | YES |  |  |
| 72 | eff_date_10 | TIMESTAMP | YES |  |  |
| 73 | ter_date_10 | TIMESTAMP | YES |  |  |
| 74 | coverage_type_10 | VARCHAR(1) | YES |  |  |
| 75 | cobra_flag_10 | VARCHAR(1) | YES |  |  |
| 76 | team_member | VARCHAR(4) | YES |  |  |
| 77 | zip_4 | BIGINT | YES |  |  |
| 78 | physician_lock | VARCHAR(1) | YES |  |  |
| 79 | insurance_carrier | BIGINT | YES |  |  |
| 80 | roll_date_1 | TIMESTAMP | YES |  |  |
| 81 | roll_date_2 | TIMESTAMP | YES |  |  |
| 82 | roll_date_3 | TIMESTAMP | YES |  |  |
| 83 | no_update | VARCHAR(1) | YES |  |  |
| 84 | cwa_soj | VARCHAR(2) | YES |  |  |
| 85 | medicare_member | VARCHAR(1) | YES |  |  |
| 86 | wellness_flag | VARCHAR(1) | YES |  |  |
| 87 | medical_id | VARCHAR(20) | YES |  |  |
| 88 | ssn | VARCHAR(9) | YES |  |  |
| 89 | manual_change_date | DATE | YES |  |  |
| 90 | file_change_date | DATE | YES |  |  |
