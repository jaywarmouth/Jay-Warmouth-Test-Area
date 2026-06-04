# cloud_data_warehouse.warehouse_status_audit

> **Schema:** cloud_data_warehouse | **Columns:** 24

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | warehouse_status_audit_id | BIGINT | NO | "identity"(274250, 0, ('1,1'::character varying)::text) | Required |
| 2 | warehouse_status | VARCHAR(228) | YES |  |  |
| 3 | warehouse_status_time | TIMESTAMP | YES |  |  |
| 4 | warehouse_status_notes | VARCHAR(256) | YES |  |  |
| 5 | drug_status | VARCHAR(228) | YES |  |  |
| 6 | drug_status_time | TIMESTAMP | YES |  |  |
| 7 | cardholder_status | VARCHAR(228) | YES |  |  |
| 8 | cardholder_status_time | TIMESTAMP | YES |  |  |
| 9 | plan_status | VARCHAR(228) | YES |  |  |
| 10 | plan_status_time | TIMESTAMP | YES |  |  |
| 11 | group_status | VARCHAR(228) | YES |  |  |
| 12 | group_status_time | TIMESTAMP | YES |  |  |
| 13 | phdem_status | VARCHAR(228) | YES |  |  |
| 14 | phdem_status_time | TIMESTAMP | YES |  |  |
| 15 | phnet_status | VARCHAR(228) | YES |  |  |
| 16 | phnet_status_time | TIMESTAMP | YES |  |  |
| 17 | rv601_status | VARCHAR(150) | YES |  |  |
| 18 | rv601_status_time | TIMESTAMP | YES |  |  |
| 19 | reversal_status | VARCHAR(150) | YES |  |  |
| 20 | reversal_status_time | TIMESTAMP | YES |  |  |
| 21 | gpi_status | VARCHAR(150) | YES |  |  |
| 22 | gpi_status_time | TIMESTAMP | YES |  |  |
| 23 | claims_msg_status | VARCHAR(150) | YES |  |  |
| 24 | claims_msg_status_time | TIMESTAMP | YES |  |  |
