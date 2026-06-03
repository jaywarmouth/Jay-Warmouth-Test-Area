# cloud_data_warehouse.reimb_rate_data

> **Schema:** cloud_data_warehouse | **Columns:** 173

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
| 8 | reimb_rate_number | INTEGER | YES |  |  |
| 9 | reimb_desc | CHAR(50) | YES |  |  |
| 10 | o_gen_code | CHAR(6) | YES |  |  |
| 11 | o_reim_desc_type | FLOAT8 | YES |  |  |
| 12 | o_awp_pcnt | NUMERIC(18, 4) | YES |  |  |
| 13 | o_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 14 | o_mac_tbl | INTEGER | YES |  |  |
| 15 | o_mac_fee | NUMERIC(18, 2) | YES |  |  |
| 16 | o_flat_fee | NUMERIC(18, 2) | YES |  |  |
| 17 | o_cap_amt | NUMERIC(18, 2) | YES |  |  |
| 18 | o_per_month | VARCHAR(1) | YES |  |  |
| 19 | o_active | VARCHAR(1) | YES |  |  |
| 20 | o_otc_fee | NUMERIC(18, 2) | YES |  |  |
| 21 | o_pay_as_contract_rate | VARCHAR(1) | YES |  |  |
| 22 | o_marketing_percentage | NUMERIC(18, 4) | YES |  |  |
| 23 | o_marketing_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 24 | o_plus_diff_table_1 | INTEGER | YES |  |  |
| 25 | o_plus_diff_table_eff_1 | TIMESTAMP | YES |  |  |
| 26 | o_plus_diff_table_2 | INTEGER | YES |  |  |
| 27 | o_plus_diff_table_eff_2 | TIMESTAMP | YES |  |  |
| 28 | o_plus_diff_table_3 | INTEGER | YES |  |  |
| 29 | o_plus_diff_table_eff_3 | TIMESTAMP | YES |  |  |
| 30 | o_pdm_mac_flag | VARCHAR(1) | YES |  |  |
| 31 | o_min_reimb_amt | NUMERIC(18, 2) | YES |  |  |
| 32 | o_electronic_fee | NUMERIC(18, 2) | YES |  |  |
| 33 | o_incentive_fee | NUMERIC(18, 2) | YES |  |  |
| 34 | o_disc_net_fee | NUMERIC(18, 2) | YES |  |  |
| 35 | o_mac_awp_prcnt | NUMERIC(18, 4) | YES |  |  |
| 36 | o_mac_awp_num | INTEGER | YES |  |  |
| 37 | o_awp_litigation_factor | NUMERIC(18, 4) | YES |  |  |
| 38 | o_mac_factor_table | INTEGER | YES |  |  |
| 39 | o_340b_cap | NUMERIC(18, 2) | YES |  |  |
| 40 | o_eft_fee | NUMERIC(18, 2) | YES |  |  |
| 41 | o_wac_fee | NUMERIC(18, 2) | YES |  |  |
| 42 | o_wac_prcnt | NUMERIC(18, 4) | YES |  |  |
| 43 | o_340b_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 44 | o_reimb_fixed_amt | NUMERIC(18, 2) | YES |  |  |
| 45 | o_reimb_cap_amt | NUMERIC(18, 2) | YES |  |  |
| 46 | o_add_id | VARCHAR(15) | YES |  |  |
| 47 | o_change_id | VARCHAR(15) | YES |  |  |
| 48 | o_add_date | TIMESTAMP | YES |  |  |
| 49 | o_chg_date | TIMESTAMP | YES |  |  |
| 50 | m_gen_code | CHAR(6) | YES |  |  |
| 51 | m_reim_desc_type | FLOAT8 | YES |  |  |
| 52 | m_awp_pcnt | NUMERIC(18, 4) | YES |  |  |
| 53 | m_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 54 | m_mac_tbl | INTEGER | YES |  |  |
| 55 | m_mac_fee | NUMERIC(18, 2) | YES |  |  |
| 56 | m_flat_fee | NUMERIC(18, 2) | YES |  |  |
| 57 | m_cap_amt | NUMERIC(18, 2) | YES |  |  |
| 58 | m_per_month | VARCHAR(1) | YES |  |  |
| 59 | m_active | VARCHAR(1) | YES |  |  |
| 60 | m_otc_fee | NUMERIC(18, 2) | YES |  |  |
| 61 | m_pay_as_contract_rate | VARCHAR(1) | YES |  |  |
| 62 | m_marketing_percentage | NUMERIC(18, 4) | YES |  |  |
| 63 | m_marketing_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 64 | m_plus_diff_table_1 | INTEGER | YES |  |  |
| 65 | m_plus_diff_table_eff_1 | TIMESTAMP | YES |  |  |
| 66 | m_plus_diff_table_2 | INTEGER | YES |  |  |
| 67 | m_plus_diff_table_eff_2 | TIMESTAMP | YES |  |  |
| 68 | m_plus_diff_table_3 | INTEGER | YES |  |  |
| 69 | m_plus_diff_table_eff_3 | TIMESTAMP | YES |  |  |
| 70 | m_pdm_mac_flag | VARCHAR(1) | YES |  |  |
| 71 | m_min_reimb_amt | NUMERIC(18, 2) | YES |  |  |
| 72 | m_electronic_fee | NUMERIC(18, 2) | YES |  |  |
| 73 | m_incentive_fee | NUMERIC(18, 2) | YES |  |  |
| 74 | m_disc_net_fee | NUMERIC(18, 2) | YES |  |  |
| 75 | m_mac_awp_prcnt | NUMERIC(18, 4) | YES |  |  |
| 76 | m_mac_awp_num | INTEGER | YES |  |  |
| 77 | m_awp_litigation_factor | NUMERIC(18, 4) | YES |  |  |
| 78 | m_mac_factor_table | INTEGER | YES |  |  |
| 79 | m_340b_cap | NUMERIC(18, 2) | YES |  |  |
| 80 | m_eft_fee | NUMERIC(18, 2) | YES |  |  |
| 81 | m_wac_fee | NUMERIC(18, 2) | YES |  |  |
| 82 | m_wac_prcnt | NUMERIC(18, 4) | YES |  |  |
| 83 | m_340b_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 84 | m_reimb_fixed_amt | NUMERIC(18, 2) | YES |  |  |
| 85 | m_reimb_cap_amt | NUMERIC(18, 2) | YES |  |  |
| 86 | m_add_id | VARCHAR(15) | YES |  |  |
| 87 | m_change_id | VARCHAR(15) | YES |  |  |
| 88 | m_add_date | TIMESTAMP | YES |  |  |
| 89 | m_chg_date | TIMESTAMP | YES |  |  |
| 90 | n_gen_code | VARCHAR(6) | YES |  |  |
| 91 | n_reim_desc_type | FLOAT8 | YES |  |  |
| 92 | n_awp_pcnt | NUMERIC(18, 4) | YES |  |  |
| 93 | n_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 94 | n_mac_tbl | INTEGER | YES |  |  |
| 95 | n_mac_fee | NUMERIC(18, 2) | YES |  |  |
| 96 | n_flat_fee | NUMERIC(18, 2) | YES |  |  |
| 97 | n_cap_amt | NUMERIC(18, 2) | YES |  |  |
| 98 | n_per_month | VARCHAR(1) | YES |  |  |
| 99 | n_active | VARCHAR(1) | YES |  |  |
| 100 | n_otc_fee | NUMERIC(18, 2) | YES |  |  |
| 101 | n_pay_as_contract_rate | VARCHAR(1) | YES |  |  |
| 102 | n_marketing_percentage | NUMERIC(18, 4) | YES |  |  |
| 103 | n_marketing_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 104 | n_plus_diff_table_1 | INTEGER | YES |  |  |
| 105 | n_plus_diff_table_eff_1 | TIMESTAMP | YES |  |  |
| 106 | n_plus_diff_table_2 | INTEGER | YES |  |  |
| 107 | n_plus_diff_table_eff_2 | TIMESTAMP | YES |  |  |
| 108 | n_plus_diff_table_3 | INTEGER | YES |  |  |
| 109 | n_plus_diff_table_eff_3 | TIMESTAMP | YES |  |  |
| 110 | n_pdm_mac_flag | VARCHAR(1) | YES |  |  |
| 111 | n_min_reimb_amt | NUMERIC(18, 2) | YES |  |  |
| 112 | n_electronic_fee | NUMERIC(18, 2) | YES |  |  |
| 113 | n_incentive_fee | NUMERIC(18, 2) | YES |  |  |
| 114 | n_disc_net_fee | NUMERIC(18, 2) | YES |  |  |
| 115 | n_mac_awp_prcnt | NUMERIC(18, 4) | YES |  |  |
| 116 | n_mac_awp_num | INTEGER | YES |  |  |
| 117 | n_awp_litigation_factor | NUMERIC(18, 4) | YES |  |  |
| 118 | n_mac_factor_table | INTEGER | YES |  |  |
| 119 | n_340b_cap | NUMERIC(18, 2) | YES |  |  |
| 120 | n_eft_fee | NUMERIC(18, 2) | YES |  |  |
| 121 | n_wac_fee | NUMERIC(18, 2) | YES |  |  |
| 122 | n_wac_prcnt | NUMERIC(18, 4) | YES |  |  |
| 123 | n_340b_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 124 | n_reimb_fixed_amt | NUMERIC(18, 2) | YES |  |  |
| 125 | n_reimb_cap_amt | NUMERIC(18, 2) | YES |  |  |
| 126 | n_add_id | VARCHAR(15) | YES |  |  |
| 127 | n_change_id | VARCHAR(15) | YES |  |  |
| 128 | n_add_date | TIMESTAMP | YES |  |  |
| 129 | n_chg_date | TIMESTAMP | YES |  |  |
| 130 | y_gen_code | CHAR(6) | YES |  |  |
| 131 | y_reim_desc_type | FLOAT8 | YES |  |  |
| 132 | y_awp_pcnt | NUMERIC(18, 4) | YES |  |  |
| 133 | y_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 134 | y_mac_tbl | INTEGER | YES |  |  |
| 135 | y_mac_fee | NUMERIC(18, 2) | YES |  |  |
| 136 | y_flat_fee | NUMERIC(18, 2) | YES |  |  |
| 137 | y_cap_amt | NUMERIC(18, 2) | YES |  |  |
| 138 | y_per_month | VARCHAR(1) | YES |  |  |
| 139 | y_active | VARCHAR(1) | YES |  |  |
| 140 | y_otc_fee | NUMERIC(18, 2) | YES |  |  |
| 141 | y_pay_as_contract_rate | VARCHAR(1) | YES |  |  |
| 142 | y_marketing_percentage | NUMERIC(18, 4) | YES |  |  |
| 143 | y_marketing_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 144 | y_plus_diff_table_1 | INTEGER | YES |  |  |
| 145 | y_plus_diff_table_eff_1 | TIMESTAMP | YES |  |  |
| 146 | y_plus_diff_table_2 | INTEGER | YES |  |  |
| 147 | y_plus_diff_table_eff_2 | TIMESTAMP | YES |  |  |
| 148 | y_plus_diff_table_3 | INTEGER | YES |  |  |
| 149 | y_plus_diff_table_eff_3 | TIMESTAMP | YES |  |  |
| 150 | y_pdm_mac_flag | VARCHAR(1) | YES |  |  |
| 151 | y_min_reimb_amt | NUMERIC(18, 2) | YES |  |  |
| 152 | y_electronic_fee | NUMERIC(18, 2) | YES |  |  |
| 153 | y_incentive_fee | NUMERIC(18, 2) | YES |  |  |
| 154 | y_disc_net_fee | NUMERIC(18, 2) | YES |  |  |
| 155 | y_mac_awp_prcnt | NUMERIC(18, 4) | YES |  |  |
| 156 | y_mac_awp_num | INTEGER | YES |  |  |
| 157 | y_awp_litigation_factor | NUMERIC(18, 4) | YES |  |  |
| 158 | y_mac_factor_table | INTEGER | YES |  |  |
| 159 | y_340b_cap | NUMERIC(18, 2) | YES |  |  |
| 160 | y_eft_fee | NUMERIC(18, 2) | YES |  |  |
| 161 | y_wac_fee | NUMERIC(18, 2) | YES |  |  |
| 162 | y_wac_prcnt | NUMERIC(18, 4) | YES |  |  |
| 163 | y_340b_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 164 | y_reimb_fixed_amt | NUMERIC(18, 2) | YES |  |  |
| 165 | y_reimb_cap_amt | NUMERIC(18, 2) | YES |  |  |
| 166 | y_add_id | VARCHAR(15) | YES |  |  |
| 167 | y_change_id | VARCHAR(15) | YES |  |  |
| 168 | y_add_date | TIMESTAMP | YES |  |  |
| 169 | y_chg_date | TIMESTAMP | YES |  |  |
| 170 | o_add_on_percent | NUMERIC(18, 4) | YES |  |  |
| 171 | m_add_on_percent | NUMERIC(18, 4) | YES |  |  |
| 172 | n_add_on_percent | NUMERIC(18, 4) | YES |  |  |
| 173 | y_add_on_percent | NUMERIC(18, 4) | YES |  |  |
