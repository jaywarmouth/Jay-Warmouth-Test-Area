# cloud_data_warehouse.inlog

> **Schema:** cloud_data_warehouse | **Columns:** 76

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
| 8 | inl_system_nbr | BIGINT | NO |  | Required |
| 9 | inl_sponsor_nbr | BIGINT | NO |  | Required |
| 10 | inl_group_nbr | VARCHAR(20) | NO |  | Required |
| 11 | inl_period_ending | DATE | YES |  |  |
| 12 | inl_alt_group_nbr | VARCHAR(20) | YES |  |  |
| 13 | inl_group_name | VARCHAR(30) | YES |  |  |
| 14 | inl_sys_claim_inv_num | BIGINT | YES |  |  |
| 15 | inl_spo_claim_inv_num | BIGINT | YES |  |  |
| 16 | inl_grp_claim_inv_num | BIGINT | YES |  |  |
| 17 | inl_claim_count | BIGINT | YES |  |  |
| 18 | inl_claim_inv_amt | NUMERIC(18, 2) | YES |  |  |
| 19 | inl_copay | NUMERIC(18, 2) | YES |  |  |
| 20 | inl_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 21 | inl_ing_cost | NUMERIC(18, 2) | YES |  |  |
| 22 | inl_tax | NUMERIC(18, 2) | YES |  |  |
| 23 | inl_diff_admin | NUMERIC(18, 2) | YES |  |  |
| 24 | inl_sys_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 25 | inl_spo_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 26 | inl_grp_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 27 | inl_sys_admin_inv_num | BIGINT | YES |  |  |
| 28 | inl_spo_admin_inv_num | BIGINT | YES |  |  |
| 29 | inl_grp_admin_inv_num | BIGINT | YES |  |  |
| 30 | inl_claim_paid_flag | VARCHAR(1) | YES |  |  |
| 31 | inl_admin_paid_flag | VARCHAR(1) | YES |  |  |
| 32 | inl_claim_paid_date | DATE | YES |  |  |
| 33 | inl_admin_paid_date | DATE | YES |  |  |
| 34 | inl_check_charge | NUMERIC(18, 2) | YES |  |  |
| 35 | inl_mkt_charge | NUMERIC(18, 2) | YES |  |  |
| 36 | inl_number_of_checks | BIGINT | YES |  |  |
| 37 | inl_special_period_ending | DATE | YES |  |  |
| 38 | inl_ta_amt | NUMERIC(18, 2) | YES |  |  |
| 39 | inl_rented_network_claims | BIGINT | YES |  |  |
| 40 | inl_rented_network_amount | NUMERIC(18, 2) | YES |  |  |
| 41 | inl_claim_chk_rec_date | DATE | YES |  |  |
| 42 | inl_claim_chk_ref_num | VARCHAR(20) | YES |  |  |
| 43 | inl_claim_chk_ref_amt | NUMERIC(18, 2) | YES |  |  |
| 44 | inl_admin_chk_rec_date | DATE | YES |  |  |
| 45 | inl_admin_chk_ref_num | VARCHAR(20) | YES |  |  |
| 46 | inl_admin_chk_ref_amt | NUMERIC(18, 2) | YES |  |  |
| 47 | inl_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 48 | inl_sys_card_fee | NUMERIC(18, 2) | YES |  |  |
| 49 | inl_spo_card_fee | NUMERIC(18, 2) | YES |  |  |
| 50 | inl_grp_card_fee | NUMERIC(18, 2) | YES |  |  |
| 51 | inl_sys_card_inv | BIGINT | YES |  |  |
| 52 | inl_spo_card_inv | BIGINT | YES |  |  |
| 53 | inl_grp_card_inv | BIGINT | YES |  |  |
| 54 | inl_num_of_cards | BIGINT | YES |  |  |
| 55 | inl_client_discount_fee | NUMERIC(18, 2) | YES |  |  |
| 56 | inl_pdm_discount_fee | NUMERIC(18, 2) | YES |  |  |
| 57 | inl_broker_claim_count | BIGINT | YES |  |  |
| 58 | inl_broker_amt_sys | NUMERIC(18, 2) | YES |  |  |
| 59 | inl_broker_amt_spo | NUMERIC(18, 2) | YES |  |  |
| 60 | inl_broker_amt_grp | NUMERIC(18, 2) | YES |  |  |
| 61 | inl_med_sub_claim_count | BIGINT | YES |  |  |
| 62 | eps_claim_count | BIGINT | YES |  |  |
| 63 | eps_sys_admin_amount | NUMERIC(18, 2) | YES |  |  |
| 64 | eps_spo_admin_amount | NUMERIC(18, 2) | YES |  |  |
| 65 | eps_grp_admin_amount | NUMERIC(18, 2) | YES |  |  |
| 66 | eps_claim_amount | NUMERIC(18, 2) | YES |  |  |
| 67 | serv_fee_claim_count | BIGINT | YES |  |  |
| 68 | serv_fee_sys_admin_amount | NUMERIC(18, 2) | YES |  |  |
| 69 | serv_fee_spo_admin_amount | NUMERIC(18, 2) | YES |  |  |
| 70 | serv_fee_grp_admin_amount | NUMERIC(18, 2) | YES |  |  |
| 71 | serv_fee_claim_amount | NUMERIC(18, 2) | YES |  |  |
| 72 | no_fin_claim_count | BIGINT | YES |  |  |
| 73 | no_fin_sys_admin_amount | NUMERIC(18, 2) | YES |  |  |
| 74 | no_fin_spo_admin_amount | NUMERIC(18, 2) | YES |  |  |
| 75 | no_fin_grp_admin_amount | NUMERIC(18, 2) | YES |  |  |
| 76 | no_fin_claim_amount | NUMERIC(18, 2) | YES |  |  |
