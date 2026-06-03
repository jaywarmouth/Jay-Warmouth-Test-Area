# cloud_data_warehouse.cms_payor_exclusions

> **Schema:** cloud_data_warehouse | **Columns:** 12

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | cms_payor_exclusion_id | BIGINT | NO | "identity"(764466, 0, ('1,1'::character varying)::text) | Required |
| 2 | contract_id | VARCHAR(256) | YES |  |  |
| 3 | plan_id | VARCHAR(256) | YES |  |  |
| 4 | contract_year | VARCHAR(256) | YES |  |  |
| 5 | effective_start_date | DATE | YES |  |  |
| 6 | effective_end_date | DATE | YES |  |  |
| 7 | bin | VARCHAR(256) | YES |  |  |
| 8 | pcn | VARCHAR(256) | YES |  |  |
| 9 | created_date | TIMESTAMP | YES |  |  |
| 10 | created_by | VARCHAR(256) | YES |  |  |
| 11 | etl_load_date | TIMESTAMP | YES |  |  |
| 12 | etl_load_by | VARCHAR(256) | YES |  |  |
