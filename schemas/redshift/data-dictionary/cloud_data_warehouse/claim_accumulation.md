# cloud_data_warehouse.claim_accumulation

> **Schema:** cloud_data_warehouse | **Columns:** 89

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | claim_key | VARCHAR(14) | YES |  |  |
| 2 | paid_or_reversal_flag | VARCHAR(1) | YES |  |  |
| 3 | claim_batch_number | VARCHAR(8) | YES |  |  |
| 4 | claim_number | INTEGER | YES |  |  |
| 5 | claims_counter | INTEGER | YES |  |  |
| 6 | claim_type | INTEGER | YES |  |  |
| 7 | payment_direct | INTEGER | YES |  |  |
| 8 | pharmacy_number | VARCHAR(6) | YES |  |  |
| 9 | chain_number | INTEGER | YES |  |  |
| 10 | pharmacy_name | VARCHAR(60) | YES |  |  |
| 11 | reject_code_01 | INTEGER | YES |  |  |
| 12 | reject_code_02 | INTEGER | YES |  |  |
| 13 | rx_number | BIGINT | YES |  |  |
| 14 | rx_date | BIGINT | YES |  |  |
| 15 | drug_type_code | INTEGER | YES |  |  |
| 16 | national_drug_code | VARCHAR(11) | YES |  |  |
| 17 | product_name | VARCHAR(25) | YES |  |  |
| 18 | new_refill_ind | VARCHAR(1) | YES |  |  |
| 19 | metric_quantity | NUMERIC(18, 3) | YES |  |  |
| 20 | days_supply | INTEGER | YES |  |  |
| 21 | ingredient_cost_billed | NUMERIC(18, 2) | YES |  |  |
| 22 | ingredient_cost_paid | NUMERIC(18, 2) | YES |  |  |
| 23 | dispensing_fee | NUMERIC(18, 2) | YES |  |  |
| 24 | copay | NUMERIC(18, 2) | YES |  |  |
| 25 | tax | NUMERIC(18, 2) | YES |  |  |
| 26 | total_amount_paid | NUMERIC(18, 2) | YES |  |  |
| 27 | ucr_amount | NUMERIC(18, 2) | YES |  |  |
| 28 | member_birth_date | BIGINT | YES |  |  |
| 29 | member_sex | VARCHAR(1) | YES |  |  |
| 30 | cardholder_number | VARCHAR(10) | YES |  |  |
| 31 | member_number | VARCHAR(2) | YES |  |  |
| 32 | alternate_card_number | VARCHAR(13) | YES |  |  |
| 33 | patient_relationship | VARCHAR(1) | YES |  |  |
| 34 | dea_number | VARCHAR(50) | YES |  |  |
| 35 | diagnosis_code | VARCHAR(6) | YES |  |  |
| 36 | pdm_system_number | INTEGER | YES |  |  |
| 37 | pdm_sponsor_number | INTEGER | YES |  |  |
| 38 | pdm_group_number | VARCHAR(20) | YES |  |  |
| 39 | group_number | VARCHAR(20) | YES |  |  |
| 40 | generic_code | VARCHAR(1) | YES |  |  |
| 41 | mac_number | INTEGER | YES |  |  |
| 42 | daw_ind | VARCHAR(1) | YES |  |  |
| 43 | therapeutic_class_code | INTEGER | YES |  |  |
| 44 | rx_otc_code | VARCHAR(1) | YES |  |  |
| 45 | gpi | VARCHAR(14) | YES |  |  |
| 46 | exception_code_01 | INTEGER | YES |  |  |
| 47 | override_code_01 | INTEGER | YES |  |  |
| 48 | period_ending_date | BIGINT | YES |  |  |
| 49 | paid_date | VARCHAR(256) | YES |  |  |
| 50 | compound_code | INTEGER | YES |  |  |
| 51 | batch_date | BIGINT | YES |  |  |
| 52 | claim_counter | INTEGER | YES |  |  |
| 53 | mail_order | VARCHAR(1) | YES |  |  |
| 54 | benefit_code | VARCHAR(16) | YES |  |  |
| 55 | awp | NUMERIC(18, 2) | YES |  |  |
| 56 | claim_ind | VARCHAR(1) | YES |  |  |
| 57 | drug_preference_ind | VARCHAR(1) | YES |  |  |
| 58 | pricing_ind | VARCHAR(1) | YES |  |  |
| 59 | drug_manufacturer | VARCHAR(10) | YES |  |  |
| 60 | controlled_substance | VARCHAR(5) | YES |  |  |
| 61 | last_name | VARCHAR(20) | YES |  |  |
| 62 | first_name | VARCHAR(15) | YES |  |  |
| 63 | middle_init | VARCHAR(1) | YES |  |  |
| 64 | third_party_code | VARCHAR(1) | YES |  |  |
| 65 | pharmacy_npi_number | VARCHAR(10) | YES |  |  |
| 66 | d0_rx_number | BIGINT | YES |  |  |
| 67 | other_coverage_code | INTEGER | YES |  |  |
| 68 | deductible_amount | NUMERIC(18, 2) | YES |  |  |
| 69 | number_on_card | VARCHAR(20) | YES |  |  |
| 70 | filler_1 | VARCHAR(3) | YES |  |  |
| 71 | filler_2 | VARCHAR(3) | YES |  |  |
| 72 | amountcopay | NUMERIC(18, 2) | YES |  |  |
| 73 | amountcoinsurance | NUMERIC(18, 2) | YES |  |  |
| 74 | physician_number | VARCHAR(14) | YES |  |  |
| 75 | physician_name | VARCHAR(100) | YES |  |  |
| 76 | p_date | BIGINT | YES |  |  |
| 77 | reversal_date | BIGINT | YES |  |  |
| 78 | amount_applied_to_oop | NUMERIC(18, 2) | YES |  |  |
| 79 | accumulator_applied_ind | VARCHAR(10) | YES |  |  |
| 80 | diagnosis_code_icd10 | VARCHAR(10) | YES |  |  |
| 81 | amount_coinsurance | NUMERIC(18, 2) | YES |  |  |
| 82 | amount_copay | NUMERIC(18, 2) | YES |  |  |
| 83 | penalty_amount | NUMERIC(18, 2) | YES |  |  |
| 84 | admin_fee_claims | NUMERIC(18, 2) | YES |  |  |
| 85 | filler_one | VARCHAR(1) | YES |  |  |
| 86 | filler_two | VARCHAR(30) | YES |  |  |
| 87 | etl_insert_date | DATE | YES |  |  |
| 88 | uid | VARCHAR(256) | YES |  |  |
| 89 | process_date | DATE | YES |  |  |
