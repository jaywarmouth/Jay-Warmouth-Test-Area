# cloud_data_warehouse.pharm_network

> **Schema:** cloud_data_warehouse | **Columns:** 77

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
| 8 | network_number | BIGINT | YES |  |  |
| 9 | nabp_number | BIGINT | YES |  |  |
| 10 | state_code | BIGINT | YES |  |  |
| 11 | description | VARCHAR(40) | YES |  |  |
| 12 | eff_date_1 | DATE | YES |  |  |
| 13 | eff_date_2 | DATE | YES |  |  |
| 14 | eff_date_3 | DATE | YES |  |  |
| 15 | term_date_1 | DATE | YES |  |  |
| 16 | term_date_2 | DATE | YES |  |  |
| 17 | term_date_3 | DATE | YES |  |  |
| 18 | pdm_chain_number_1 | BIGINT | YES |  |  |
| 19 | pharmacy_name | VARCHAR(35) | YES |  |  |
| 20 | chain_eff_date_1 | DATE | YES |  |  |
| 21 | pdm_chain_number_2 | BIGINT | YES |  |  |
| 22 | chain_eff_date_2 | DATE | YES |  |  |
| 23 | pdm_chain_number_3 | BIGINT | YES |  |  |
| 24 | chain_eff_date_3 | DATE | YES |  |  |
| 25 | reimb_rate_number_1 | BIGINT | YES |  |  |
| 26 | rr_description | VARCHAR(30) | YES |  |  |
| 27 | rr_eff_date_1 | DATE | YES |  |  |
| 28 | reimb_rate_number_2 | BIGINT | YES |  |  |
| 29 | rr_eff_date_2 | DATE | YES |  |  |
| 30 | reimb_rate_number_3 | BIGINT | YES |  |  |
| 31 | rr_eff_date_3 | DATE | YES |  |  |
| 32 | reimb_rate_number_4 | BIGINT | YES |  |  |
| 33 | rr_eff_date_4 | DATE | YES |  |  |
| 34 | reimb_rate_number_5 | BIGINT | YES |  |  |
| 35 | rr_eff_date_5 | DATE | YES |  |  |
| 36 | mail_order_flag | VARCHAR(1) | YES |  |  |
| 37 | reject_205_override | VARCHAR(1) | YES |  |  |
| 38 | mail_days_switch | BIGINT | YES |  |  |
| 39 | program_name_1 | VARCHAR(3) | YES |  |  |
| 40 | update_1 | DATE | YES |  |  |
| 41 | program_name_2 | VARCHAR(3) | YES |  |  |
| 42 | update_2 | DATE | YES |  |  |
| 43 | program_name_3 | VARCHAR(3) | YES |  |  |
| 44 | update_3 | DATE | YES |  |  |
| 45 | program_name_4 | VARCHAR(3) | YES |  |  |
| 46 | update_4 | DATE | YES |  |  |
| 47 | program_name_5 | VARCHAR(3) | YES |  |  |
| 48 | update_5 | DATE | YES |  |  |
| 49 | copay_logic | VARCHAR(1) | YES |  |  |
| 50 | chain_load_flag | VARCHAR(1) | YES |  |  |
| 51 | reject_204_override | VARCHAR(1) | YES |  |  |
| 52 | pharm_net_key | VARCHAR(16) | NO |  | Required |
| 53 | contract_pdb_flag | VARCHAR(1) | YES |  |  |
| 54 | override_225_flag | VARCHAR(1) | YES |  |  |
| 55 | continue_search | VARCHAR(1) | YES |  |  |
| 56 | progen_chain | BIGINT | YES |  |  |
| 57 | network_description | VARCHAR(50) | YES |  |  |
| 58 | price_prevails_flag | VARCHAR(1) | YES |  |  |
| 59 | pos_tip | VARCHAR(1) | YES |  |  |
| 60 | group_nbr | VARCHAR(20) | YES |  |  |
| 61 | loe_exclusion_flag | VARCHAR(1) | YES |  |  |
| 62 | tc_special_disp_fee | VARCHAR(1) | YES |  |  |
| 63 | sngl_src_gen_exclusion_flag | VARCHAR(1) | YES |  |  |
| 64 | pharm_specialty_flag | VARCHAR(1) | YES |  |  |
| 65 | type_code_44_flag | VARCHAR(1) | YES |  |  |
| 66 | eff_date_4 | DATE | YES |  |  |
| 67 | eff_date_5 | DATE | YES |  |  |
| 68 | term_date_4 | DATE | YES |  |  |
| 69 | term_date_5 | DATE | YES |  |  |
| 70 | pdm_chain_number_4 | BIGINT | YES |  |  |
| 71 | pdm_chain_number_5 | BIGINT | YES |  |  |
| 72 | chain_eff_date_4 | DATE | YES |  |  |
| 73 | chain_eff_date_5 | DATE | YES |  |  |
| 74 | spec_form_type_code | BIGINT | YES |  |  |
| 75 | spec_form_gen_tbl | BIGINT | YES |  |  |
| 76 | add_date | DATE | YES |  |  |
| 77 | chg_date | DATE | YES |  |  |
