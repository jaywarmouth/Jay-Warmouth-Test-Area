# cloud_data_warehouse.limit_daily

> **Schema:** cloud_data_warehouse | **Columns:** 109

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
| 8 | system_nbr | INTEGER | YES |  |  |
| 9 | sponsor_nbr | INTEGER | YES |  |  |
| 10 | group_nbr | INTEGER | YES |  |  |
| 11 | cardholder_nbr | VARCHAR(10) | YES |  |  |
| 12 | member_nbr | VARCHAR(2) | YES |  |  |
| 13 | bin | INTEGER | YES |  |  |
| 14 | roll_up_code | VARCHAR(20) | YES |  |  |
| 15 | roll_date | TIMESTAMP | YES |  |  |
| 16 | extract_date | TIMESTAMP | YES |  |  |
| 17 | claims | INTEGER | YES |  |  |
| 18 | t_ing_bil | NUMERIC(18, 2) | YES |  |  |
| 19 | t_copay | NUMERIC(18, 2) | YES |  |  |
| 20 | t_disp | NUMERIC(18, 2) | YES |  |  |
| 21 | t_tax | NUMERIC(18, 2) | YES |  |  |
| 22 | t_ing_paid | NUMERIC(18, 2) | YES |  |  |
| 23 | rx_1 | INTEGER | YES |  |  |
| 24 | rx_date_1 | TIMESTAMP | YES |  |  |
| 25 | ing_bil1 | NUMERIC(18, 2) | YES |  |  |
| 26 | copay_1 | NUMERIC(18, 2) | YES |  |  |
| 27 | disp_1 | NUMERIC(18, 2) | YES |  |  |
| 28 | tax_1 | NUMERIC(18, 2) | YES |  |  |
| 29 | ing_paid_1 | NUMERIC(18, 2) | YES |  |  |
| 30 | rej_1 | INTEGER | YES |  |  |
| 31 | rx_2 | INTEGER | YES |  |  |
| 32 | rx_date_2 | TIMESTAMP | YES |  |  |
| 33 | ing_bil_2 | NUMERIC(18, 2) | YES |  |  |
| 34 | copay_2 | NUMERIC(18, 2) | YES |  |  |
| 35 | disp_2 | NUMERIC(18, 2) | YES |  |  |
| 36 | tax_2 | NUMERIC(18, 2) | YES |  |  |
| 37 | ing_paid_2 | NUMERIC(18, 2) | YES |  |  |
| 38 | rej_2 | INTEGER | YES |  |  |
| 39 | rx_3 | INTEGER | YES |  |  |
| 40 | rx_date_3 | TIMESTAMP | YES |  |  |
| 41 | ing_bil_3 | NUMERIC(18, 2) | YES |  |  |
| 42 | copay_3 | NUMERIC(18, 2) | YES |  |  |
| 43 | disp_3 | NUMERIC(18, 2) | YES |  |  |
| 44 | tax_3 | NUMERIC(18, 2) | YES |  |  |
| 45 | ing_paid_3 | NUMERIC(18, 2) | YES |  |  |
| 46 | rej_3 | INTEGER | YES |  |  |
| 47 | met_date | TIMESTAMP | YES |  |  |
| 48 | last_qtr_carry_over | NUMERIC(18, 2) | YES |  |  |
| 49 | deduct_flag | VARCHAR(1) | YES |  |  |
| 50 | deduct_date | TIMESTAMP | YES |  |  |
| 51 | stop_flag | VARCHAR(1) | YES |  |  |
| 52 | stop_date | TIMESTAMP | YES |  |  |
| 53 | medical_deduct | NUMERIC(18, 2) | YES |  |  |
| 54 | med_out_of_pocket | NUMERIC(18, 2) | YES |  |  |
| 55 | met_date_max | TIMESTAMP | YES |  |  |
| 56 | half_letter | TIMESTAMP | YES |  |  |
| 57 | eob_letter | TIMESTAMP | YES |  |  |
| 58 | sponsor_carry_over | INTEGER | YES |  |  |
| 59 | add_to_max | NUMERIC(18, 2) | YES |  |  |
| 60 | recalc_date_1 | TIMESTAMP | YES |  |  |
| 61 | recalc_code_1 | INTEGER | YES |  |  |
| 62 | recalc_date_2 | TIMESTAMP | YES |  |  |
| 63 | recalc_code_2 | INTEGER | YES |  |  |
| 64 | recalc_date_3 | TIMESTAMP | YES |  |  |
| 65 | recalc_code_3 | INTEGER | YES |  |  |
| 66 | dont_recalc_flag | VARCHAR(1) | YES |  |  |
| 67 | m_claims | INTEGER | YES |  |  |
| 68 | m_ing_bil | NUMERIC(18, 2) | YES |  |  |
| 69 | m_copay | NUMERIC(18, 2) | YES |  |  |
| 70 | m_disp | NUMERIC(18, 2) | YES |  |  |
| 71 | m_tax | NUMERIC(18, 2) | YES |  |  |
| 72 | m_ing_paid | NUMERIC(18, 2) | YES |  |  |
| 73 | met_date_deduct_mail | TIMESTAMP | YES |  |  |
| 74 | last_qtr_carry_over_mail | NUMERIC(18, 2) | YES |  |  |
| 75 | met_date_max_mail | TIMESTAMP | YES |  |  |
| 76 | add_to_max_mail | NUMERIC(18, 2) | YES |  |  |
| 77 | letter_code | VARCHAR(10) | YES |  |  |
| 78 | deduct_amt_only | NUMERIC(18, 2) | YES |  |  |
| 79 | ta_begin_bal | NUMERIC(18, 2) | YES |  |  |
| 80 | ta_lcd | INTEGER | YES |  |  |
| 81 | ta_run_bal | NUMERIC(18, 2) | YES |  |  |
| 82 | retail_penalty_amt | NUMERIC(18, 2) | YES |  |  |
| 83 | mail_penalty_amt | NUMERIC(18, 2) | YES |  |  |
| 84 | troop_amt | NUMERIC(18, 2) | YES |  |  |
| 85 | add_to_troop | NUMERIC(18, 2) | YES |  |  |
| 86 | tot_drug_2250 | NUMERIC(18, 2) | YES |  |  |
| 87 | tot_drug_5100 | NUMERIC(18, 2) | YES |  |  |
| 88 | stand_deduct_only | NUMERIC(18, 2) | YES |  |  |
| 89 | med_add_to_deduct | NUMERIC(18, 2) | YES |  |  |
| 90 | med_add_to_amt_paid | NUMERIC(18, 2) | YES |  |  |
| 91 | add_to_single_max | NUMERIC(18, 2) | YES |  |  |
| 92 | add_to_family_max | NUMERIC(18, 2) | YES |  |  |
| 93 | add_to_life_max | NUMERIC(18, 2) | YES |  |  |
| 94 | add_to_troop_fir | NUMERIC(18, 2) | YES |  |  |
| 95 | add_to_tds_fir | NUMERIC(18, 2) | YES |  |  |
| 96 | last_fir_date | TIMESTAMP | YES |  |  |
| 97 | add_to_deduct_fir | NUMERIC(18, 2) | YES |  |  |
| 98 | rest_k_limit | VARCHAR(1) | YES |  |  |
| 99 | carry_forward_oop | NUMERIC(18, 2) | YES |  |  |
| 100 | carry_forward_ded | NUMERIC(18, 2) | YES |  |  |
| 101 | pdm_add_to_ded | NUMERIC(18, 2) | YES |  |  |
| 102 | pdm_add_to_oop | NUMERIC(18, 2) | YES |  |  |
| 103 | add_id | VARCHAR(15) | YES |  |  |
| 104 | change_id | VARCHAR(15) | YES |  |  |
| 105 | diff_ing_cost_paid | NUMERIC(18, 2) | YES |  |  |
| 106 | diff_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 107 | limit_mbr_max | NUMERIC(18, 2) | YES |  |  |
| 108 | add_date | TIMESTAMP | YES |  |  |
| 109 | change_date | TIMESTAMP | YES |  |  |
