# cloud_data_warehouse.claimscob

> **Schema:** cloud_data_warehouse | **Columns:** 100

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
| 8 | batch | VARCHAR(10) | NO |  | Required |
| 9 | claim_number | INTEGER | NO |  | Required |
| 10 | other_payer_count | INTEGER | NO |  | Required |
| 11 | op_cov_type | VARCHAR(5) | YES |  |  |
| 12 | op_id_qual | VARCHAR(5) | YES |  |  |
| 13 | op_id | VARCHAR(15) | YES |  |  |
| 14 | op_date | DATE | YES |  |  |
| 15 | op_amt_count | INTEGER | YES |  |  |
| 16 | op_amt_qual_1 | VARCHAR(5) | YES |  |  |
| 17 | op_amt_paid_1 | NUMERIC(18, 2) | YES |  |  |
| 18 | op_amt_qual_2 | VARCHAR(5) | YES |  |  |
| 19 | op_amt_paid_2 | NUMERIC(18, 2) | YES |  |  |
| 20 | op_amt_qual_3 | VARCHAR(5) | YES |  |  |
| 21 | op_amt_paid_3 | NUMERIC(18, 2) | YES |  |  |
| 22 | op_amt_qual_4 | VARCHAR(5) | YES |  |  |
| 23 | op_amt_paid_4 | NUMERIC(18, 2) | YES |  |  |
| 24 | op_amt_qual_5 | VARCHAR(5) | YES |  |  |
| 25 | op_amt_paid_5 | NUMERIC(18, 2) | YES |  |  |
| 26 | op_amt_qual_6 | VARCHAR(5) | YES |  |  |
| 27 | op_amt_paid_6 | NUMERIC(18, 2) | YES |  |  |
| 28 | op_amt_qual_7 | VARCHAR(5) | YES |  |  |
| 29 | op_amt_paid_7 | NUMERIC(18, 2) | YES |  |  |
| 30 | op_amt_qual_8 | VARCHAR(5) | YES |  |  |
| 31 | op_amt_paid_8 | NUMERIC(18, 2) | YES |  |  |
| 32 | op_amt_qual_9 | VARCHAR(5) | YES |  |  |
| 33 | op_amt_paid_9 | NUMERIC(18, 2) | YES |  |  |
| 34 | op_reject_count | INTEGER | YES |  |  |
| 35 | op_reject_code_1 | VARCHAR(6) | YES |  |  |
| 36 | op_reject_code_2 | VARCHAR(6) | YES |  |  |
| 37 | op_reject_code_3 | VARCHAR(6) | YES |  |  |
| 38 | op_reject_code_4 | VARCHAR(6) | YES |  |  |
| 39 | op_reject_code_5 | VARCHAR(6) | YES |  |  |
| 40 | op_pat_resp_amt_count | INTEGER | YES |  |  |
| 41 | op_pat_resp_amt_qual_1 | VARCHAR(5) | YES |  |  |
| 42 | op_pat_resp_amt_1 | NUMERIC(18, 2) | YES |  |  |
| 43 | op_pat_resp_amt_qual_2 | VARCHAR(5) | YES |  |  |
| 44 | op_pat_resp_amt_2 | NUMERIC(18, 2) | YES |  |  |
| 45 | op_pat_resp_amt_qual_3 | VARCHAR(5) | YES |  |  |
| 46 | op_pat_resp_amt_3 | NUMERIC(18, 2) | YES |  |  |
| 47 | op_pat_resp_amt_qual_4 | VARCHAR(5) | YES |  |  |
| 48 | op_pat_resp_amt_4 | NUMERIC(18, 2) | YES |  |  |
| 49 | op_pat_resp_amt_qual_5 | VARCHAR(5) | YES |  |  |
| 50 | op_pat_resp_amt_5 | NUMERIC(18, 2) | YES |  |  |
| 51 | op_pat_resp_amt_qual_6 | VARCHAR(5) | YES |  |  |
| 52 | op_pat_resp_amt_6 | NUMERIC(18, 2) | YES |  |  |
| 53 | op_pat_resp_amt_qual_7 | VARCHAR(5) | YES |  |  |
| 54 | op_pat_resp_amt_7 | NUMERIC(18, 2) | YES |  |  |
| 55 | op_pat_resp_amt_qual_8 | VARCHAR(5) | YES |  |  |
| 56 | op_pat_resp_amt_8 | NUMERIC(18, 2) | YES |  |  |
| 57 | op_pat_resp_amt_qual_9 | VARCHAR(5) | YES |  |  |
| 58 | op_pat_resp_amt_9 | NUMERIC(18, 2) | YES |  |  |
| 59 | op_pat_resp_amt_qual_10 | VARCHAR(5) | YES |  |  |
| 60 | op_pat_resp_amt_10 | NUMERIC(18, 2) | YES |  |  |
| 61 | op_pat_resp_amt_qual_11 | VARCHAR(5) | YES |  |  |
| 62 | op_pat_resp_amt_11 | NUMERIC(18, 2) | YES |  |  |
| 63 | op_pat_resp_amt_qual_12 | VARCHAR(5) | YES |  |  |
| 64 | op_pat_resp_amt_12 | NUMERIC(18, 2) | YES |  |  |
| 65 | op_pat_resp_amt_qual_13 | VARCHAR(5) | YES |  |  |
| 66 | op_pat_resp_amt_13 | NUMERIC(18, 2) | YES |  |  |
| 67 | op_pat_resp_amt_qual_14 | VARCHAR(5) | YES |  |  |
| 68 | op_pat_resp_amt_14 | NUMERIC(18, 2) | YES |  |  |
| 69 | op_pat_resp_amt_qual_15 | VARCHAR(5) | YES |  |  |
| 70 | op_pat_resp_amt_15 | NUMERIC(18, 2) | YES |  |  |
| 71 | op_pat_resp_amt_qual_16 | VARCHAR(5) | YES |  |  |
| 72 | op_pat_resp_amt_16 | NUMERIC(18, 2) | YES |  |  |
| 73 | op_pat_resp_amt_qual_17 | VARCHAR(5) | YES |  |  |
| 74 | op_pat_resp_amt_17 | NUMERIC(18, 2) | YES |  |  |
| 75 | op_pat_resp_amt_qual_18 | VARCHAR(5) | YES |  |  |
| 76 | op_pat_resp_amt_18 | NUMERIC(18, 2) | YES |  |  |
| 77 | op_pat_resp_amt_qual_19 | VARCHAR(5) | YES |  |  |
| 78 | op_pat_resp_amt_19 | NUMERIC(18, 2) | YES |  |  |
| 79 | op_pat_resp_amt_qual_20 | VARCHAR(5) | YES |  |  |
| 80 | op_pat_resp_amt_20 | NUMERIC(18, 2) | YES |  |  |
| 81 | op_pat_resp_amt_qual_21 | VARCHAR(5) | YES |  |  |
| 82 | op_pat_resp_amt_21 | NUMERIC(18, 2) | YES |  |  |
| 83 | op_pat_resp_amt_qual_22 | VARCHAR(5) | YES |  |  |
| 84 | op_pat_resp_amt_22 | NUMERIC(18, 2) | YES |  |  |
| 85 | op_pat_resp_amt_qual_23 | VARCHAR(5) | YES |  |  |
| 86 | op_pat_resp_amt_23 | NUMERIC(18, 2) | YES |  |  |
| 87 | op_pat_resp_amt_qual_24 | VARCHAR(5) | YES |  |  |
| 88 | op_pat_resp_amt_24 | NUMERIC(18, 2) | YES |  |  |
| 89 | op_pat_resp_amt_qual_25 | VARCHAR(5) | YES |  |  |
| 90 | op_pat_resp_amt_25 | NUMERIC(18, 2) | YES |  |  |
| 91 | ben_stage_count | INTEGER | YES |  |  |
| 92 | ben_stage_qual_1 | VARCHAR(5) | YES |  |  |
| 93 | ben_stage_amt_1 | NUMERIC(18, 2) | YES |  |  |
| 94 | ben_stage_qual_2 | VARCHAR(5) | YES |  |  |
| 95 | ben_stage_amt_2 | NUMERIC(18, 2) | YES |  |  |
| 96 | ben_stage_qual_3 | VARCHAR(5) | YES |  |  |
| 97 | ben_stage_amt_3 | NUMERIC(18, 2) | YES |  |  |
| 98 | ben_stage_qual_4 | VARCHAR(5) | YES |  |  |
| 99 | ben_stage_amt_4 | NUMERIC(18, 2) | YES |  |  |
| 100 | claim_key | VARCHAR(14) | YES |  |  |
