# cloud_data_warehouse.esi_corrections

> **Schema:** cloud_data_warehouse | **Columns:** 27

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | carrier_operational_id | VARCHAR(50) | YES |  |  |
| 2 | load_batch_nbr | VARCHAR(50) | YES |  |  |
| 3 | mail_retail_cde | VARCHAR(50) | YES |  |  |
| 4 | pass_through_txt | VARCHAR(14) | YES |  |  |
| 5 | fill_drug_formulary_id | VARCHAR(50) | YES |  |  |
| 6 | contract_operational_id | VARCHAR(50) | YES |  |  |
| 7 | elig_group_operational_id | VARCHAR(50) | YES |  |  |
| 8 | insurance_cde | VARCHAR(50) | YES |  |  |
| 9 | locator_id | VARCHAR(50) | YES |  |  |
| 10 | brand_generic_cde | VARCHAR(50) | YES |  |  |
| 11 | serviced_dte | TIMESTAMP | YES |  |  |
| 12 | total_claims | VARCHAR(50) | YES |  |  |
| 13 | brand_claims | VARCHAR(50) | YES |  |  |
| 14 | service_qtr | VARCHAR(50) | YES |  |  |
| 15 | orig_guarantee_rate | NUMERIC(18, 2) | YES |  |  |
| 16 | orig_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 17 | orig_admin_fee_amount | NUMERIC(18, 2) | YES |  |  |
| 18 | orig_net_guarantee | NUMERIC(18, 2) | YES |  |  |
| 19 | corrected_guarantee_rate | NUMERIC(18, 2) | YES |  |  |
| 20 | corrected_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 21 | corrected_admin_fee_amount | NUMERIC(18, 2) | YES |  |  |
| 22 | corrected_net_guarantee | NUMERIC(18, 2) | YES |  |  |
| 23 | diff_guarantee_rate | NUMERIC(18, 2) | YES |  |  |
| 24 | diff_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 25 | diff_admin_fee_amount | NUMERIC(18, 2) | YES |  |  |
| 26 | diff_net_guarantee | NUMERIC(18, 2) | YES |  |  |
| 27 | pdmi_load_date | TIMESTAMP | YES |  |  |
