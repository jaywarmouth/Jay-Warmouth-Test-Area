# cloud_data_warehouse.esirebatedistribution

> **Schema:** cloud_data_warehouse | **Columns:** 32

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | original_id | VARCHAR(50) | YES |  |  |
| 2 | carrier_id | VARCHAR(50) | YES |  |  |
| 3 | contract_id | VARCHAR(50) | YES |  |  |
| 4 | group_id | VARCHAR(50) | YES |  |  |
| 5 | locator_id | VARCHAR(50) | YES |  |  |
| 6 | insurance_code | VARCHAR(50) | YES |  |  |
| 7 | user_defined | VARCHAR(50) | YES |  |  |
| 8 | new_pass_through | VARCHAR(50) | YES |  |  |
| 9 | pass_through_text | VARCHAR(50) | YES |  |  |
| 10 | claim_type | VARCHAR(50) | YES |  |  |
| 11 | formulary_id | VARCHAR(50) | YES |  |  |
| 12 | load_batch_number | VARCHAR(50) | YES |  |  |
| 13 | retail_mail | VARCHAR(50) | YES |  |  |
| 14 | specialty | VARCHAR(50) | YES |  |  |
| 15 | filled_month | VARCHAR(50) | YES |  |  |
| 16 | brand_generic | VARCHAR(50) | YES |  |  |
| 17 | fill_days_supply | INTEGER | YES |  |  |
| 18 | payment_amount | NUMERIC(18, 2) | YES |  |  |
| 19 | claim_count | INTEGER | YES |  |  |
| 20 | per_rx_rate | NUMERIC(18, 2) | YES |  |  |
| 21 | per_rx_calc_amount | NUMERIC(18, 2) | YES |  |  |
| 22 | maf_rate | NUMERIC(18, 2) | YES |  |  |
| 23 | maf_calc_amount | NUMERIC(18, 2) | YES |  |  |
| 24 | percent_share_base_rate | NUMERIC(18, 2) | YES |  |  |
| 25 | rebates_calc_amount | NUMERIC(18, 2) | YES |  |  |
| 26 | percent_share_admin_fee_rate | NUMERIC(18, 2) | YES |  |  |
| 27 | admin_fee_calc_amount | NUMERIC(18, 2) | YES |  |  |
| 28 | pdmi_load_date | TIMESTAMP | YES |  |  |
| 29 | pdmi_batch_claim | VARCHAR(25) | YES |  |  |
| 30 | exclusion_reason | VARCHAR(150) | YES |  |  |
| 31 | file_name_loaded | VARCHAR(150) | YES |  |  |
| 32 | load_date | TIMESTAMP | YES |  |  |
