# cloud_data_warehouse.claim_fix_history_report

> **Schema:** cloud_data_warehouse | **Columns:** 16

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | record_type | VARCHAR(6) | YES |  |  |
| 2 | claim_key | VARCHAR(42) | YES |  |  |
| 3 | pde_batch_nbr | VARCHAR(8) | YES |  |  |
| 4 | pde_claim_nbr | INTEGER | YES |  |  |
| 5 | pde_record_nbr | VARCHAR(3) | YES |  |  |
| 6 | original_sponsor_nbr | INTEGER | YES |  |  |
| 7 | new_sponsor_nbr | INTEGER | YES |  |  |
| 8 | original_cardholder_nbr | VARCHAR(30) | YES |  |  |
| 9 | new_cardholder_nbr | VARCHAR(30) | YES |  |  |
| 10 | original_member_nbr | VARCHAR(6) | YES |  |  |
| 11 | new_member_nbr | VARCHAR(6) | YES |  |  |
| 12 | user_id | VARCHAR(36) | YES |  |  |
| 13 | file_name | VARCHAR(750) | YES |  |  |
| 14 | warehouse_change_date | TIMESTAMP | YES |  |  |
| 15 | original_cardholder_key | VARCHAR(60) | YES |  |  |
| 16 | new_cardholder_key | VARCHAR(60) | YES |  |  |
