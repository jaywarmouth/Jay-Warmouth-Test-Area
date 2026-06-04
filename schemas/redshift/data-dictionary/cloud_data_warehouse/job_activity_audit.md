# cloud_data_warehouse.job_activity_audit

> **Schema:** cloud_data_warehouse | **Columns:** 41

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | jobactivityauditid | INTEGER | NO | "identity"(280364, 0, '1,1'::text) | Required |
| 2 | dateofrun | TIMESTAMP | YES |  |  |
| 3 | etl_findfiletime | TIMESTAMP | YES |  |  |
| 4 | etl_beginindextime | TIMESTAMP | YES |  |  |
| 5 | etl_endtime | TIMESTAMP | YES |  |  |
| 6 | recordsread | INTEGER | YES |  |  |
| 7 | recordsinserted | INTEGER | YES |  |  |
| 8 | recordsupdated | INTEGER | YES |  |  |
| 9 | recordserrored | INTEGER | YES |  |  |
| 10 | processname | VARCHAR(256) | YES |  |  |
| 11 | databasefilename | VARCHAR(256) | YES |  |  |
| 12 | databasefilerecordcount | INTEGER | YES |  |  |
| 13 | transactionfileorigination | VARCHAR(150) | YES |  |  |
| 14 | transactionprocessdate | TIMESTAMP | YES |  |  |
| 15 | transactionsystemnumber | INTEGER | YES |  |  |
| 16 | transactionclaimcount | INTEGER | YES |  |  |
| 17 | transactionamountpaid | NUMERIC(18, 2) | YES |  |  |
| 18 | transactionperiodending | TIMESTAMP | YES |  |  |
| 19 | transactioninputfilerecordcount | INTEGER | YES |  |  |
| 20 | transactioninputfilename | VARCHAR(256) | YES |  |  |
| 21 | auditprocessdate | TIMESTAMP | YES |  |  |
| 22 | auditsystemnumber | INTEGER | YES |  |  |
| 23 | auditclaimcount | INTEGER | YES |  |  |
| 24 | auditamountpaid | NUMERIC(18, 2) | YES |  |  |
| 25 | auditcopayamount | NUMERIC(18, 2) | YES |  |  |
| 26 | auditperiodending | TIMESTAMP | YES |  |  |
| 27 | auditclaimcountdifference | INTEGER | YES |  |  |
| 28 | auditamountpaiddifference | NUMERIC(18, 2) | YES |  |  |
| 29 | warehousename | VARCHAR(150) | YES |  |  |
| 30 | recordrejected | INTEGER | YES |  |  |
| 31 | rejectfilename | VARCHAR(256) | YES |  |  |
| 32 | scd_job_status | VARCHAR(30) | YES |  |  |
| 33 | scd_job_start_time | TIMESTAMP | YES |  |  |
| 34 | copy_start_time | TIMESTAMP | YES |  |  |
| 35 | copy_end_time | TIMESTAMP | YES |  |  |
| 36 | hash_set_calculate_start_time | TIMESTAMP | YES |  |  |
| 37 | hash_set_calculate_end_time | TIMESTAMP | YES |  |  |
| 38 | scd_start_time | TIMESTAMP | YES |  |  |
| 39 | scd_end_time | TIMESTAMP | YES |  |  |
| 40 | filetotalrecords | INTEGER | YES |  |  |
| 41 | records_deleted | INTEGER | YES |  |  |
