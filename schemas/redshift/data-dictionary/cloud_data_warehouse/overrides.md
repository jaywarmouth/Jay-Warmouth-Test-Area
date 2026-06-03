# cloud_data_warehouse.overrides

> **Schema:** cloud_data_warehouse | **Columns:** 49

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
| 12 | type_code | BIGINT | NO |  | Required |
| 13 | effective_date | DATE | NO |  | Required |
| 14 | cardholder_key | VARCHAR(20) | YES |  |  |
| 15 | termination_date | DATE | YES |  |  |
| 16 | pharmacy_number | BIGINT | YES |  |  |
| 17 | chain_number | BIGINT | YES |  |  |
| 18 | physician_number | VARCHAR(10) | YES |  |  |
| 19 | days_supply | BIGINT | YES |  |  |
| 20 | metric_quantity | NUMERIC(18, 3) | YES |  |  |
| 21 | ndc | VARCHAR(11) | YES |  |  |
| 22 | copay_schedule | BIGINT | YES |  |  |
| 23 | reason | VARCHAR(60) | YES |  |  |
| 24 | max_claim_amount | NUMERIC(18, 2) | YES |  |  |
| 25 | copay_fix | NUMERIC(18, 2) | YES |  |  |
| 26 | copay_percentage | NUMERIC(18, 2) | YES |  |  |
| 27 | pay_pharm_billed | BIGINT | YES |  |  |
| 28 | rx_per_time_frame | BIGINT | YES |  |  |
| 29 | invalid_birth_date | DATE | YES |  |  |
| 30 | pay_pharm_cap | NUMERIC(18, 2) | YES |  |  |
| 31 | create_flag | VARCHAR(1) | YES |  |  |
| 32 | dispensing_fee | NUMERIC(18, 2) | YES |  |  |
| 33 | copay_schedule_type_new | VARCHAR(6) | YES |  |  |
| 34 | copay_schedule_type_old | VARCHAR(6) | YES |  |  |
| 35 | refill_number | BIGINT | YES |  |  |
| 36 | prior_authorization | BIGINT | YES |  |  |
| 37 | reason_code | BIGINT | YES |  |  |
| 38 | record_type | VARCHAR(1) | YES |  |  |
| 39 | user | VARCHAR(12) | YES |  |  |
| 40 | occurrence | BIGINT | YES |  |  |
| 41 | generic_incentive_flag | VARCHAR(1) | YES |  |  |
| 42 | refill_prcnt | NUMERIC(18, 2) | YES |  |  |
| 43 | plan_max | NUMERIC(18, 2) | YES |  |  |
| 44 | post_a_reject | BIGINT | YES |  |  |
| 45 | unit_per_day | NUMERIC(18, 2) | YES |  |  |
| 46 | skip_limit_flag | VARCHAR(1) | YES |  |  |
| 47 | enter_date | DATE | YES |  |  |
| 48 | change_date | DATE | YES |  |  |
| 49 | ov_maximizer_percent | NUMERIC(18, 4) | YES |  |  |
