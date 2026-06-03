# cloud_data_warehouse.erx_processor_plan_file

> **Schema:** cloud_data_warehouse | **Columns:** 12

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | processor_plan_id | BIGINT | NO | "identity"(2076098, 0, ('1,1'::character varying)::text) | Required |
| 2 | plan_name | VARCHAR(256) | YES |  |  |
| 3 | plan_id | VARCHAR(256) | YES |  |  |
| 4 | processor_number | VARCHAR(256) | YES |  |  |
| 5 | bin | VARCHAR(256) | YES |  |  |
| 6 | pcn | VARCHAR(256) | YES |  |  |
| 7 | d0 | VARCHAR(256) | YES |  |  |
| 8 | file_name | VARCHAR(256) | YES |  |  |
| 9 | plan_type | VARCHAR(256) | YES |  |  |
| 10 | help_desk_number | VARCHAR(256) | YES |  |  |
| 11 | etl_load_date | TIMESTAMP | YES |  |  |
| 12 | etl_load_by | VARCHAR(256) | YES |  |  |
