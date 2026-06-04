# cloud_data_warehouse.accumulator_missing_rxconnect_claims

> **Schema:** cloud_data_warehouse | **Columns:** 26

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | claim_key | VARCHAR(14) | YES |  |  |
| 2 | paid_or_reversal_flag | VARCHAR(1) | YES |  |  |
| 3 | p_date | BIGINT | YES |  |  |
| 4 | etl_insert_date | DATE | YES |  |  |
| 5 | guid | VARCHAR(256) | YES |  |  |
| 6 | batch_number | VARCHAR(8) | YES |  |  |
| 7 | claim_number | BIGINT | YES |  |  |
| 8 | rx_number | BIGINT | YES |  |  |
| 9 | reject_code_1 | BIGINT | YES |  |  |
| 10 | reject_code_2 | BIGINT | YES |  |  |
| 11 | reversal_code | BIGINT | YES |  |  |
| 12 | create_date | DATE | YES |  |  |
| 13 | pharmacy_number | VARCHAR(256) | YES |  |  |
| 14 | group_number | VARCHAR(256) | YES |  |  |
| 15 | rx_date | BIGINT | YES |  |  |
| 16 | pdm_system_number | INTEGER | YES |  |  |
| 17 | pdm_sponsor_number | INTEGER | YES |  |  |
| 18 | claim_ind | VARCHAR(256) | YES |  |  |
| 19 | accumcci | VARCHAR(256) | YES |  |  |
| 20 | keypunch | VARCHAR(256) | YES |  |  |
| 21 | line_number | INTEGER | YES |  |  |
| 22 | available_in_redshift | VARCHAR(1) | YES |  |  |
| 23 | available_in_rds | VARCHAR(1) | YES |  |  |
| 24 | date_of_reversal | DATE | YES |  |  |
| 25 | process_date | DATE | YES |  |  |
| 26 | adj_code_1 | INTEGER | YES |  |  |
