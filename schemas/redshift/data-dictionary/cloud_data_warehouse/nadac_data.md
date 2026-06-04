# cloud_data_warehouse.nadac_data

> **Schema:** cloud_data_warehouse | **Columns:** 12

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | ndc_description | VARCHAR(500) | YES |  |  |
| 2 | ndc | VARCHAR(11) | YES |  |  |
| 3 | nadac_per_unit | NUMERIC(18, 5) | YES |  |  |
| 4 | effective_date | DATE | YES |  |  |
| 5 | pricing_unit | VARCHAR(20) | YES |  |  |
| 6 | pharmacy_type_indicator | VARCHAR(20) | YES |  |  |
| 7 | otc | VARCHAR(20) | YES |  |  |
| 8 | explanation_code | VARCHAR(20) | YES |  |  |
| 9 | classification_for_rate_setting | VARCHAR(20) | YES |  |  |
| 10 | corresponding_generic_drug_nadac_per_unit | NUMERIC(18, 5) | YES |  |  |
| 11 | corresponding_generic_drug_effective_date | DATE | YES |  |  |
| 12 | as_of_date | DATE | YES |  |  |
