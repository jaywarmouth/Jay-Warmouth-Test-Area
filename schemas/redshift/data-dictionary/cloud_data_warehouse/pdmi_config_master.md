# cloud_data_warehouse.pdmi_config_master

> **Schema:** cloud_data_warehouse | **Columns:** 59

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | meta_surr_key | VARCHAR(1000) | YES |  |  |
| 2 | meta_hash_key | VARCHAR(1000) | YES |  |  |
| 3 | meta_eff_strt_dt | TIMESTAMP | YES |  |  |
| 4 | meta_eff_end_dt | TIMESTAMP | YES |  |  |
| 5 | meta_curr_ind | VARCHAR(3) | YES |  |  |
| 6 | meta_iud_flg | VARCHAR(10) | YES |  |  |
| 7 | meta_src_sys_nm | VARCHAR(10) | YES |  |  |
| 8 | t_link | VARCHAR(5) | YES |  |  |
| 9 | system_spon_grp | VARCHAR(28) | YES |  |  |
| 10 | system_nbr | INTEGER | YES |  |  |
| 11 | sponsor_nbr | INTEGER | YES |  |  |
| 12 | group_nbr | FLOAT8 | YES |  |  |
| 13 | rec_type | VARCHAR(3) | YES |  |  |
| 14 | date_type | VARCHAR(2) | YES |  |  |
| 15 | data_type | VARCHAR(3) | YES |  |  |
| 16 | data | VARCHAR(26) | YES |  |  |
| 17 | amt_type | VARCHAR(3) | YES |  |  |
| 18 | occ | INTEGER | YES |  |  |
| 19 | min_amt | NUMERIC(18, 4) | YES |  |  |
| 20 | max_amt | NUMERIC(18, 4) | YES |  |  |
| 21 | mq_min_amt | NUMERIC(18, 3) | YES |  |  |
| 22 | mq_max_amt | NUMERIC(18, 3) | YES |  |  |
| 23 | ds_min_amt | BIGINT | YES |  |  |
| 24 | ds_max_amt | BIGINT | YES |  |  |
| 25 | seq_nbr | INTEGER | YES |  |  |
| 26 | eff_date | TIMESTAMP | YES |  |  |
| 27 | term_date | TIMESTAMP | YES |  |  |
| 28 | brand_id | VARCHAR(20) | YES |  |  |
| 29 | disp_fee | NUMERIC(18, 2) | YES |  |  |
| 30 | cms_excl_date | TIMESTAMP | YES |  |  |
| 31 | cms_last_name | VARCHAR(35) | YES |  |  |
| 32 | cms_first_name | VARCHAR(25) | YES |  |  |
| 33 | cms_middle_name | VARCHAR(25) | YES |  |  |
| 34 | cms_bus_name | VARCHAR(70) | YES |  |  |
| 35 | cms_general | VARCHAR(50) | YES |  |  |
| 36 | cms_specialty | VARCHAR(150) | YES |  |  |
| 37 | cms_ein | VARCHAR(9) | YES |  |  |
| 38 | cms_dob | VARCHAR(8) | YES |  |  |
| 39 | cms_address_1 | VARCHAR(55) | YES |  |  |
| 40 | cms_address_2 | VARCHAR(55) | YES |  |  |
| 41 | cms_city | VARCHAR(40) | YES |  |  |
| 42 | cms_state | VARCHAR(2) | YES |  |  |
| 43 | cms_zip | VARCHAR(5) | YES |  |  |
| 44 | cms_last_update_date | TIMESTAMP | YES |  |  |
| 45 | rej_code | INTEGER | YES |  |  |
| 46 | compu_msg | VARCHAR(39) | YES |  |  |
| 47 | compu_additional | VARCHAR(200) | YES |  |  |
| 48 | ds_min_amt_rec_type_006 | NUMERIC(18, 4) | YES |  |  |
| 49 | ds_max_amt_rec_type_006 | NUMERIC(18, 4) | YES |  |  |
| 50 | mq_min_amt_rec_type_006 | NUMERIC(18, 4) | YES |  |  |
| 51 | mq_max_amt_rec_type_006 | NUMERIC(18, 4) | YES |  |  |
| 52 | service_fee | NUMERIC(18, 2) | YES |  |  |
| 53 | copay_table | INTEGER | YES |  |  |
| 54 | plan_number | VARCHAR(8) | YES |  |  |
| 55 | copay_amt | NUMERIC(18, 4) | YES |  |  |
| 56 | add_id | VARCHAR(15) | YES |  |  |
| 57 | change_id | VARCHAR(15) | YES |  |  |
| 58 | add_date | TIMESTAMP | YES |  |  |
| 59 | change_date | TIMESTAMP | YES |  |  |
