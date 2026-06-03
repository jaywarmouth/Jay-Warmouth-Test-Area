# cloud_data_warehouse.activity_audit

> **Schema:** cloud_data_warehouse | **Columns:** 14

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | rec_id | INTEGER | NO | "identity"(1876541, 0, ('1,1'::character varying)::text) | Required |
| 2 | rec_source | VARCHAR(250) | YES |  |  |
| 3 | dateofrun | TIMESTAMP | YES |  |  |
| 4 | insert_date | TIMESTAMP | YES |  |  |
| 5 | etl_begin_index_time | TIMESTAMP | YES |  |  |
| 6 | etl_end_time | TIMESTAMP | YES |  |  |
| 7 | records_read | INTEGER | YES |  |  |
| 8 | records_inserted | INTEGER | YES |  |  |
| 9 | records_updated | INTEGER | YES |  |  |
| 10 | process_name | VARCHAR(256) | YES |  |  |
| 11 | database_file_name | VARCHAR(256) | YES |  |  |
| 12 | scd_job_status | VARCHAR(30) | YES |  |  |
| 13 | recordserrored | INTEGER | YES |  |  |
| 14 | rejectfilename | VARCHAR(256) | YES |  |  |
