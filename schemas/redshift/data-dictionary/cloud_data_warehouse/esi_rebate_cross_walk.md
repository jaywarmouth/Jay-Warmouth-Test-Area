# cloud_data_warehouse.esi_rebate_cross_walk

> **Schema:** cloud_data_warehouse | **Columns:** 12

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | id | INTEGER | NO |  | Required |
| 2 | formulary_gt | INTEGER | YES |  |  |
| 3 | system_number | INTEGER | YES |  |  |
| 4 | sponsor_number | INTEGER | YES |  |  |
| 5 | sponsor_account_type | VARCHAR(10) | YES |  |  |
| 6 | plan_formulary_gt1 | INTEGER | YES |  |  |
| 7 | plan_formulary_gt2 | INTEGER | YES |  |  |
| 8 | rebate_contract_id | VARCHAR(20) | YES |  |  |
| 9 | rebate_carrier_id | VARCHAR(20) | YES |  |  |
| 10 | rebate_flag | CHAR(1) | YES |  |  |
| 11 | effective_date | DATE | YES |  |  |
| 12 | term_date | DATE | YES |  |  |
