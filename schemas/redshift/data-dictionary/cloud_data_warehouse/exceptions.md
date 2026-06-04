# cloud_data_warehouse.exceptions

> **Schema:** cloud_data_warehouse | **Columns:** 51

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
| 8 | cardholder_number | VARCHAR(10) | NO |  | Required |
| 9 | member_number | VARCHAR(2) | NO |  | Required |
| 10 | sponsor | BIGINT | NO |  | Required |
| 11 | gpi | VARCHAR(14) | NO |  | Required |
| 12 | cardholder_key | VARCHAR(20) | YES |  |  |
| 13 | eff_date_1 | DATE | YES |  |  |
| 14 | eff_date_2 | DATE | YES |  |  |
| 15 | eff_date_3 | DATE | YES |  |  |
| 16 | eff_date_4 | DATE | YES |  |  |
| 17 | eff_date_5 | DATE | YES |  |  |
| 18 | term_date_1 | DATE | YES |  |  |
| 19 | term_date_2 | DATE | YES |  |  |
| 20 | term_date_3 | DATE | YES |  |  |
| 21 | term_date_4 | DATE | YES |  |  |
| 22 | term_date_5 | DATE | YES |  |  |
| 23 | pharmacy_number | BIGINT | YES |  |  |
| 24 | chain_number | BIGINT | YES |  |  |
| 25 | physician_number | VARCHAR(10) | YES |  |  |
| 26 | days_supply | BIGINT | YES |  |  |
| 27 | metric_quantity | NUMERIC(18, 3) | YES |  |  |
| 28 | type_code | BIGINT | YES |  |  |
| 29 | ndc | VARCHAR(11) | YES |  |  |
| 30 | copay_override | BIGINT | YES |  |  |
| 31 | reason | VARCHAR(60) | YES |  |  |
| 32 | max_dollar | BIGINT | YES |  |  |
| 33 | max_dollar_to_date | NUMERIC(18, 2) | YES |  |  |
| 34 | occurence | BIGINT | YES |  |  |
| 35 | no_maximum | VARCHAR(1) | YES |  |  |
| 36 | user | VARCHAR(12) | YES |  |  |
| 37 | max_dl_1 | BIGINT | YES |  |  |
| 38 | max_dl_2 | BIGINT | YES |  |  |
| 39 | max_dl_3 | BIGINT | YES |  |  |
| 40 | max_dl_4 | BIGINT | YES |  |  |
| 41 | max_to_date_1 | NUMERIC(18, 2) | YES |  |  |
| 42 | max_to_date_2 | NUMERIC(18, 2) | YES |  |  |
| 43 | max_to_date_3 | NUMERIC(18, 2) | YES |  |  |
| 44 | max_to_date_4 | NUMERIC(18, 2) | YES |  |  |
| 45 | occur_1 | BIGINT | YES |  |  |
| 46 | occur_2 | BIGINT | YES |  |  |
| 47 | occur_3 | BIGINT | YES |  |  |
| 48 | occur_4 | BIGINT | YES |  |  |
| 49 | med_code | VARCHAR(1) | YES |  |  |
| 50 | enter_date | DATE | YES |  |  |
| 51 | change_date | DATE | YES |  |  |
