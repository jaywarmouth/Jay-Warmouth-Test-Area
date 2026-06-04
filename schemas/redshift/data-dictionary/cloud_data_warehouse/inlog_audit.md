# cloud_data_warehouse.inlog_audit

> **Schema:** cloud_data_warehouse | **Columns:** 16

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | date_of_run | DATE | YES |  |  |
| 2 | transaction_system_number | INTEGER | NO |  | Required |
| 3 | transaction_sponsor_number | INTEGER | NO |  | Required |
| 4 | transaction_group_number | BIGINT | NO |  | Required |
| 5 | transaction_claim_count | INTEGER | YES |  |  |
| 6 | transaction_amount_paid | NUMERIC(18, 2) | YES |  |  |
| 7 | transaction_period_ending | DATE | YES |  |  |
| 8 | transaction_input_file_name | VARCHAR(765) | NO |  | Required |
| 9 | audit_system_number | INTEGER | YES |  |  |
| 10 | audit_sponsor_number | INTEGER | YES |  |  |
| 11 | audit_group_number | BIGINT | YES |  |  |
| 12 | audit_claim_count | INTEGER | YES |  |  |
| 13 | audit_amount_paid | NUMERIC(18, 2) | YES |  |  |
| 14 | audit_period_ending | DATE | YES |  |  |
| 15 | audit_claim_count_difference | INTEGER | YES |  |  |
| 16 | audit_amount_paid_difference | NUMERIC(18, 2) | YES |  |  |
