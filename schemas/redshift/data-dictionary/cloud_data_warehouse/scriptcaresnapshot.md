# cloud_data_warehouse.scriptcaresnapshot

> **Schema:** cloud_data_warehouse | **Columns:** 55

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
| 8 | claim_key | VARCHAR(14) | YES |  |  |
| 9 | batch_number | VARCHAR(8) | YES |  |  |
| 10 | claim_number | INTEGER | YES |  |  |
| 11 | claim_type | VARCHAR(1) | YES |  |  |
| 12 | bin_number | INTEGER | YES |  |  |
| 13 | software_cert_id_sub | VARCHAR(10) | YES |  |  |
| 14 | ing_cost_sub | NUMERIC(18, 2) | YES |  |  |
| 15 | disp_fee_sub | NUMERIC(18, 2) | YES |  |  |
| 16 | flat_sales_tax_amt_sub | NUMERIC(18, 2) | YES |  |  |
| 17 | percent_sales_tax_amt_sub | NUMERIC(18, 2) | YES |  |  |
| 18 | incentive_amt_sub | NUMERIC(18, 2) | YES |  |  |
| 19 | other_amt_claimed_sub | NUMERIC(18, 2) | YES |  |  |
| 20 | gross_amt_due_sub | NUMERIC(18, 2) | YES |  |  |
| 21 | usual_custom_charge_i_sub | NUMERIC(18, 2) | YES |  |  |
| 22 | patient_paid_amt_sub | NUMERIC(18, 2) | YES |  |  |
| 23 | basis_cost_determination_sub | VARCHAR(2) | YES |  |  |
| 24 | employer_id_sub | VARCHAR(15) | YES |  |  |
| 25 | cmpd_ingr_drug_cost_sub | NUMERIC(18, 2) | YES |  |  |
| 26 | ingredient_cost_paid_resp | NUMERIC(18, 2) | YES |  |  |
| 27 | disp_fee_paid_resp | NUMERIC(18, 2) | YES |  |  |
| 28 | flat_sales_tax_amt_paid_resp | NUMERIC(18, 2) | YES |  |  |
| 29 | percent_sales_tax_amt_paid_resp | NUMERIC(18, 2) | YES |  |  |
| 30 | incentive_amt_paid_resp | NUMERIC(18, 2) | YES |  |  |
| 31 | other_amt_claimed_paid_resp | NUMERIC(18, 2) | YES |  |  |
| 32 | total_amt_paid_resp | NUMERIC(18, 2) | YES |  |  |
| 33 | usual_custom_charge_or_esp | NUMERIC(18, 2) | YES |  |  |
| 34 | est_generic_savings_resp | NUMERIC(18, 2) | YES |  |  |
| 35 | basis_reimb_determination_resp | INTEGER | YES |  |  |
| 36 | prior_auth_nbr_assign_resp | BIGINT | YES |  |  |
| 37 | ing_cost_billed | NUMERIC(18, 2) | YES |  |  |
| 38 | ing_cost_paid | NUMERIC(18, 2) | YES |  |  |
| 39 | disp_fee | NUMERIC(18, 2) | YES |  |  |
| 40 | tax | NUMERIC(18, 2) | YES |  |  |
| 41 | calc_amt | NUMERIC(18, 2) | YES |  |  |
| 42 | ucr_amt | NUMERIC(18, 2) | YES |  |  |
| 43 | basis_cost_determ | VARCHAR(2) | YES |  |  |
| 44 | mac_refer_price | NUMERIC(18, 2) | YES |  |  |
| 45 | contract_rate | NUMERIC(18, 2) | YES |  |  |
| 46 | awp_100_perc | NUMERIC(18, 2) | YES |  |  |
| 47 | price_ind | VARCHAR(1) | YES |  |  |
| 48 | rej_code_1 | INTEGER | YES |  |  |
| 49 | rej_code_2 | INTEGER | YES |  |  |
| 50 | except_code_1 | INTEGER | YES |  |  |
| 51 | except_code_2 | INTEGER | YES |  |  |
| 52 | mac_number | INTEGER | YES |  |  |
| 53 | trans_date | DATE | YES |  |  |
| 54 | network_pricing_applies | VARCHAR(1) | YES |  |  |
| 55 | add_date | DATE | YES |  |  |
