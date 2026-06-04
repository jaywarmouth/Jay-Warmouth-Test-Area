# cloud_data_warehouse.cycles_audit

> **Schema:** cloud_data_warehouse | **Columns:** 18

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | date_of_run | DATE | YES |  |  |
| 2 | transaction_system_number | INTEGER | NO |  | Required |
| 3 | transaction_sponsor_number | INTEGER | NO |  | Required |
| 4 | transaction_group_number | BIGINT | NO |  | Required |
| 5 | transaction_claim_type_indicator | VARCHAR(6) | NO |  | Required |
| 6 | transaction_claim_count | INTEGER | YES |  |  |
| 7 | transaction_amount_paid | NUMERIC(18, 2) | YES |  |  |
| 8 | transaction_period_ending | DATE | YES |  |  |
| 9 | transaction_input_file_name | VARCHAR(765) | NO |  | Required |
| 10 | audit_system_number | INTEGER | YES |  |  |
| 11 | audit_sponsor_number | INTEGER | YES |  |  |
| 12 | audit_group_number | BIGINT | YES |  |  |
| 13 | audit_claim_count | INTEGER | YES |  |  |
| 14 | audit_amount_paid | NUMERIC(18, 2) | YES |  |  |
| 15 | audit_copay_amount | NUMERIC(18, 2) | YES |  |  |
| 16 | audit_period_ending | DATE | YES |  |  |
| 17 | audit_claim_count_difference | INTEGER | YES |  |  |
| 18 | audit_amount_paid_difference | NUMERIC(18, 2) | YES |  |  |
