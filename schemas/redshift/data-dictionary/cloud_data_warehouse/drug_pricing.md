# cloud_data_warehouse.drug_pricing

> **Schema:** cloud_data_warehouse | **Columns:** 134

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | meta_surr_key | VARCHAR(1000) | YES |  |  |
| 2 | meta_hash_key | VARCHAR(1000) | YES |  |  |
| 3 | meta_src_sys_nm | VARCHAR(80) | YES |  |  |
| 4 | meta_iud_flg | VARCHAR(1) | YES |  |  |
| 5 | meta_eff_strt_dt | TIMESTAMP | YES |  |  |
| 6 | meta_eff_end_dt | TIMESTAMP | YES |  |  |
| 7 | meta_curr_ind | VARCHAR(3) | YES |  |  |
| 8 | drug_key | VARCHAR(15) | YES |  |  |
| 9 | ndc_type_code | INTEGER | YES |  |  |
| 10 | ndc | NUMERIC(11, 0) | YES |  |  |
| 11 | awp_pack_price_1 | NUMERIC(18, 2) | YES |  |  |
| 12 | awp_unit_price_1 | NUMERIC(18, 5) | YES |  |  |
| 13 | awp_eff_date_1 | DATE | YES |  |  |
| 14 | awp_term_date_1 | DATE | YES |  |  |
| 15 | awp_pack_price_2 | NUMERIC(18, 2) | YES |  |  |
| 16 | awp_unit_price_2 | NUMERIC(18, 5) | YES |  |  |
| 17 | awp_eff_date_2 | DATE | YES |  |  |
| 18 | awp_term_date_2 | DATE | YES |  |  |
| 19 | awp_pack_price_3 | NUMERIC(18, 2) | YES |  |  |
| 20 | awp_unit_price_3 | NUMERIC(18, 5) | YES |  |  |
| 21 | awp_eff_date_3 | DATE | YES |  |  |
| 22 | awp_term_date_3 | DATE | YES |  |  |
| 23 | awp_pack_price_4 | NUMERIC(18, 2) | YES |  |  |
| 24 | awp_unit_price_4 | NUMERIC(18, 5) | YES |  |  |
| 25 | awp_eff_date_4 | DATE | YES |  |  |
| 26 | awp_term_date_4 | DATE | YES |  |  |
| 27 | awp_pack_price_5 | NUMERIC(18, 2) | YES |  |  |
| 28 | awp_unit_price_5 | NUMERIC(18, 5) | YES |  |  |
| 29 | awp_eff_date_5 | DATE | YES |  |  |
| 30 | awp_term_date_5 | DATE | YES |  |  |
| 31 | awp_pack_price_6 | NUMERIC(18, 2) | YES |  |  |
| 32 | awp_unit_price_6 | NUMERIC(18, 5) | YES |  |  |
| 33 | awp_eff_date_6 | DATE | YES |  |  |
| 34 | awp_term_date_6 | DATE | YES |  |  |
| 35 | mac_pack_price_1 | NUMERIC(18, 2) | YES |  |  |
| 36 | mac_unit_price_1 | NUMERIC(18, 5) | YES |  |  |
| 37 | mac_eff_date_1 | DATE | YES |  |  |
| 38 | mac_term_date_1 | DATE | YES |  |  |
| 39 | mac_pack_price_2 | NUMERIC(18, 2) | YES |  |  |
| 40 | mac_unit_price_2 | NUMERIC(18, 5) | YES |  |  |
| 41 | mac_eff_date_2 | DATE | YES |  |  |
| 42 | mac_term_date_2 | DATE | YES |  |  |
| 43 | mac_pack_price_3 | NUMERIC(18, 2) | YES |  |  |
| 44 | mac_unit_price_3 | NUMERIC(18, 5) | YES |  |  |
| 45 | mac_eff_date_3 | DATE | YES |  |  |
| 46 | mac_term_date_3 | DATE | YES |  |  |
| 47 | mac_pack_price_4 | NUMERIC(18, 2) | YES |  |  |
| 48 | mac_unit_price_4 | NUMERIC(18, 5) | YES |  |  |
| 49 | mac_eff_date_4 | DATE | YES |  |  |
| 50 | mac_term_date_4 | DATE | YES |  |  |
| 51 | mac_pack_price_5 | NUMERIC(18, 2) | YES |  |  |
| 52 | mac_unit_price_5 | NUMERIC(18, 5) | YES |  |  |
| 53 | mac_eff_date_5 | DATE | YES |  |  |
| 54 | mac_term_date_5 | DATE | YES |  |  |
| 55 | mac_pack_price_6 | NUMERIC(18, 2) | YES |  |  |
| 56 | mac_unit_price_6 | NUMERIC(18, 5) | YES |  |  |
| 57 | mac_eff_date_6 | DATE | YES |  |  |
| 58 | mac_term_date_6 | DATE | YES |  |  |
| 59 | wac_pack_price_1 | NUMERIC(18, 2) | YES |  |  |
| 60 | wac_unit_price_1 | NUMERIC(18, 5) | YES |  |  |
| 61 | wac_eff_date_1 | DATE | YES |  |  |
| 62 | wac_term_date_1 | DATE | YES |  |  |
| 63 | wac_pack_price_2 | NUMERIC(18, 2) | YES |  |  |
| 64 | wac_unit_price_2 | NUMERIC(18, 5) | YES |  |  |
| 65 | wac_eff_date_2 | DATE | YES |  |  |
| 66 | wac_term_date_2 | DATE | YES |  |  |
| 67 | wac_pack_price_3 | NUMERIC(18, 2) | YES |  |  |
| 68 | wac_unit_price_3 | NUMERIC(18, 5) | YES |  |  |
| 69 | wac_eff_date_3 | DATE | YES |  |  |
| 70 | wac_term_date_3 | DATE | YES |  |  |
| 71 | wac_pack_price_4 | NUMERIC(18, 2) | YES |  |  |
| 72 | wac_unit_price_4 | NUMERIC(18, 5) | YES |  |  |
| 73 | wac_eff_date_4 | DATE | YES |  |  |
| 74 | wac_term_date_4 | DATE | YES |  |  |
| 75 | wac_pack_price_5 | NUMERIC(18, 2) | YES |  |  |
| 76 | wac_unit_price_5 | NUMERIC(18, 5) | YES |  |  |
| 77 | wac_eff_date_5 | DATE | YES |  |  |
| 78 | wac_term_date_5 | DATE | YES |  |  |
| 79 | wac_pack_price_6 | NUMERIC(18, 2) | YES |  |  |
| 80 | wac_unit_price_6 | NUMERIC(18, 5) | YES |  |  |
| 81 | wac_eff_date_6 | DATE | YES |  |  |
| 82 | wac_term_date_6 | DATE | YES |  |  |
| 83 | nadac_pack_price_1 | NUMERIC(18, 2) | YES |  |  |
| 84 | nadac_unit_price_1 | NUMERIC(18, 5) | YES |  |  |
| 85 | nadac_eff_date_1 | DATE | YES |  |  |
| 86 | nadac_term_date_1 | DATE | YES |  |  |
| 87 | nadac_pack_price_2 | NUMERIC(18, 2) | YES |  |  |
| 88 | nadac_unit_price_2 | NUMERIC(18, 5) | YES |  |  |
| 89 | nadac_eff_date_2 | DATE | YES |  |  |
| 90 | nadac_term_date_2 | DATE | YES |  |  |
| 91 | nadac_pack_price_3 | NUMERIC(18, 2) | YES |  |  |
| 92 | nadac_unit_price_3 | NUMERIC(18, 5) | YES |  |  |
| 93 | nadac_eff_date_3 | DATE | YES |  |  |
| 94 | nadac_term_date_3 | DATE | YES |  |  |
| 95 | nadac_pack_price_4 | NUMERIC(18, 2) | YES |  |  |
| 96 | nadac_unit_price_4 | NUMERIC(18, 5) | YES |  |  |
| 97 | nadac_eff_date_4 | DATE | YES |  |  |
| 98 | nadac_term_date_4 | DATE | YES |  |  |
| 99 | nadac_pack_price_5 | NUMERIC(18, 2) | YES |  |  |
| 100 | nadac_unit_price_5 | NUMERIC(18, 5) | YES |  |  |
| 101 | nadac_eff_date_5 | DATE | YES |  |  |
| 102 | nadac_term_date_5 | DATE | YES |  |  |
| 103 | nadac_pack_price_6 | NUMERIC(18, 2) | YES |  |  |
| 104 | nadac_unit_price_6 | NUMERIC(18, 5) | YES |  |  |
| 105 | nadac_eff_date_6 | DATE | YES |  |  |
| 106 | nadac_term_date_6 | DATE | YES |  |  |
| 107 | mccpp_pack_price_1 | NUMERIC(18, 2) | YES |  |  |
| 108 | mccpp_unit_price_1 | NUMERIC(18, 5) | YES |  |  |
| 109 | mccpp_eff_date_1 | DATE | YES |  |  |
| 110 | mccpp_term_date_1 | DATE | YES |  |  |
| 111 | mccpp_pack_price_2 | NUMERIC(18, 2) | YES |  |  |
| 112 | mccpp_unit_price_2 | NUMERIC(18, 5) | YES |  |  |
| 113 | mccpp_eff_date_2 | DATE | YES |  |  |
| 114 | mccpp_term_date_2 | DATE | YES |  |  |
| 115 | mccpp_pack_price_3 | NUMERIC(18, 2) | YES |  |  |
| 116 | mccpp_unit_price_3 | NUMERIC(18, 5) | YES |  |  |
| 117 | mccpp_eff_date_3 | DATE | YES |  |  |
| 118 | mccpp_term_date_3 | DATE | YES |  |  |
| 119 | mccpp_pack_price_4 | NUMERIC(18, 2) | YES |  |  |
| 120 | mccpp_unit_price_4 | NUMERIC(18, 5) | YES |  |  |
| 121 | mccpp_eff_date_4 | DATE | YES |  |  |
| 122 | mccpp_term_date_4 | DATE | YES |  |  |
| 123 | mccpp_pack_price_5 | NUMERIC(18, 2) | YES |  |  |
| 124 | mccpp_unit_price_5 | NUMERIC(18, 5) | YES |  |  |
| 125 | mccpp_eff_date_5 | DATE | YES |  |  |
| 126 | mccpp_term_date_5 | DATE | YES |  |  |
| 127 | mccpp_pack_price_6 | NUMERIC(18, 2) | YES |  |  |
| 128 | mccpp_unit_price_6 | NUMERIC(18, 5) | YES |  |  |
| 129 | mccpp_eff_date_6 | DATE | YES |  |  |
| 130 | mccpp_term_date_6 | DATE | YES |  |  |
| 131 | add_date | DATE | YES |  |  |
| 132 | change_date | DATE | YES |  |  |
| 133 | add_id | VARCHAR(15) | YES |  |  |
| 134 | change_id | VARCHAR(15) | YES |  |  |
