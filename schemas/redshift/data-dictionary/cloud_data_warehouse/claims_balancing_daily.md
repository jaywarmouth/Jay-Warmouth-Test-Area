# cloud_data_warehouse.claims_balancing_daily

> **Schema:** cloud_data_warehouse | **Columns:** 8

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | process_date | TIMESTAMP | NO |  | Required |
| 2 | claim_count | INTEGER | YES |  |  |
| 3 | audit_date | TIMESTAMP | YES |  |  |
| 4 | audit_claim_count | INTEGER | YES |  |  |
| 5 | audit_claim_count_difference | INTEGER | YES |  |  |
| 6 | written_claim_count | INTEGER | YES |  |  |
| 7 | total_error_count | INTEGER | YES |  |  |
| 8 | paid_error_count | INTEGER | YES |  |  |
