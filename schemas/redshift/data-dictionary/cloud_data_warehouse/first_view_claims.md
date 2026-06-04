# cloud_data_warehouse.first_view_claims

> **Schema:** cloud_data_warehouse | **Columns:** 54

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
| 8 | batch_master | VARCHAR(8) | YES |  |  |
| 9 | claim_number | INTEGER | YES |  |  |
| 10 | claim_type | VARCHAR(1) | YES |  |  |
| 11 | other_cov_code_orig | INTEGER | YES |  |  |
| 12 | other_cov_code_proc | INTEGER | YES |  |  |
| 13 | copay_orig | NUMERIC(18, 4) | YES |  |  |
| 14 | rej_code_1 | INTEGER | YES |  |  |
| 15 | rej_code_2 | INTEGER | YES |  |  |
| 16 | req_bin | INTEGER | YES |  |  |
| 17 | req_pcn | VARCHAR(10) | YES |  |  |
| 18 | req_claim_uid | VARCHAR(36) | YES |  |  |
| 19 | req_pharmacy | VARCHAR(15) | YES |  |  |
| 20 | req_group_nbr | VARCHAR(15) | YES |  |  |
| 21 | req_rx_nbr | INTEGER | YES |  |  |
| 22 | req_rx_date | TIMESTAMP | YES |  |  |
| 23 | req_ndc | NUMERIC(12, 0) | YES |  |  |
| 24 | req_met_qty | NUMERIC(18, 3) | YES |  |  |
| 25 | req_days_supply | INTEGER | YES |  |  |
| 26 | req_pri_copay_amt | NUMERIC(18, 2) | YES |  |  |
| 27 | req_pri_amt_paid | NUMERIC(18, 2) | YES |  |  |
| 28 | req_flat_sales_tax | NUMERIC(18, 2) | YES |  |  |
| 29 | req_sales_tax_rate | NUMERIC(18, 4) | YES |  |  |
| 30 | req_sales_tax_basis | NUMERIC(18, 4) | YES |  |  |
| 31 | req_unr_charge | NUMERIC(18, 2) | YES |  |  |
| 32 | req_cardholder | VARCHAR(20) | YES |  |  |
| 33 | req_patient_dob | TIMESTAMP | YES |  |  |
| 34 | req_physician | VARCHAR(15) | YES |  |  |
| 35 | req_oth_cov_code | INTEGER | YES |  |  |
| 36 | res_uid | VARCHAR(36) | YES |  |  |
| 37 | res_product_type | VARCHAR(20) | YES |  |  |
| 38 | res_response_code | VARCHAR(10) | YES |  |  |
| 39 | res_response_msg | VARCHAR(200) | YES |  |  |
| 40 | res_pharmacy_msg | VARCHAR(200) | YES |  |  |
| 41 | res_ing_cost | NUMERIC(18, 2) | YES |  |  |
| 42 | res_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 43 | res_copay_amt_ovr | NUMERIC(18, 2) | YES |  |  |
| 44 | res_tax | NUMERIC(18, 2) | YES |  |  |
| 45 | res_pdmi_reject_ovr | VARCHAR(10) | YES |  |  |
| 46 | resource_sys_id | VARCHAR(36) | YES |  |  |
| 47 | res_piid | VARCHAR(10) | YES |  |  |
| 48 | raw_payload | VARCHAR(2048) | YES |  |  |
| 49 | add_to_file_date_time | TIMESTAMP | YES |  |  |
| 50 | add_id | VARCHAR(15) | YES |  |  |
| 51 | change_id | VARCHAR(15) | YES |  |  |
| 52 | add_date | TIMESTAMP | YES |  |  |
| 53 | change_date | TIMESTAMP | YES |  |  |
| 54 | claim_key | VARCHAR(14) | YES |  |  |
