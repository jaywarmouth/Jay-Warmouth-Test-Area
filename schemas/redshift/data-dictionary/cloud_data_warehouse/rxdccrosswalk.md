# cloud_data_warehouse.rxdccrosswalk

> **Schema:** cloud_data_warehouse | **Columns:** 9

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | ndc_11_digit | VARCHAR(256) | YES |  |  |
| 2 | rxdc_drug_name | VARCHAR(256) | YES |  |  |
| 3 | rxdc_drug_code | VARCHAR(256) | YES |  |  |
| 4 | rxdc_therapeutic_class | VARCHAR(256) | YES |  |  |
| 5 | rxdc_class_code | VARCHAR(256) | YES |  |  |
| 6 | rxdc_brand_indicator | INTEGER | YES |  |  |
| 7 | ndc_data_source | VARCHAR(256) | YES |  |  |
| 8 | therapeutic_class_data_source | VARCHAR(256) | YES |  |  |
| 9 | exclude | BOOLEAN | NO | false | Required |
