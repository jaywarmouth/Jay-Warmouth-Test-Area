# cloud_data_warehouse.drug_data

> **Schema:** cloud_data_warehouse | **Columns:** 168

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
| 9 | ndc_type_code | BIGINT | YES |  |  |
| 10 | ndc | VARCHAR(11) | YES |  |  |
| 11 | gpi | VARCHAR(14) | YES |  |  |
| 12 | prod_abbr | VARCHAR(25) | YES |  |  |
| 13 | generic_code | VARCHAR(1) | YES |  |  |
| 14 | thera_class | BIGINT | YES |  |  |
| 15 | rx_otc_code | VARCHAR(1) | YES |  |  |
| 16 | dea_code | VARCHAR(5) | YES |  |  |
| 17 | prod | VARCHAR(12) | YES |  |  |
| 18 | awp_price_1 | NUMERIC(18, 5) | YES |  |  |
| 19 | awp_date_1 | DATE | YES |  |  |
| 20 | awp_price_2 | NUMERIC(18, 5) | YES |  |  |
| 21 | awp_date_2 | DATE | YES |  |  |
| 22 | awp_price_3 | NUMERIC(18, 5) | YES |  |  |
| 23 | awp_date_3 | DATE | YES |  |  |
| 24 | awp_price_4 | NUMERIC(18, 5) | YES |  |  |
| 25 | awp_date_4 | DATE | YES |  |  |
| 26 | mac_price_1 | NUMERIC(18, 5) | YES |  |  |
| 27 | manuf_name_abbr | VARCHAR(10) | YES |  |  |
| 28 | thera_equiv | VARCHAR(2) | YES |  |  |
| 29 | legend_change_date | DATE | YES |  |  |
| 30 | desi | VARCHAR(1) | YES |  |  |
| 31 | third_party_code | VARCHAR(1) | YES |  |  |
| 32 | act_code | VARCHAR(1) | YES |  |  |
| 33 | package_size | NUMERIC(18, 3) | YES |  |  |
| 34 | route_admin | VARCHAR(2) | YES |  |  |
| 35 | dosage_form | VARCHAR(4) | YES |  |  |
| 36 | ter_date | DATE | YES |  |  |
| 37 | prior_auth_flag | VARCHAR(1) | YES |  |  |
| 38 | brand_name_code | VARCHAR(1) | YES |  |  |
| 39 | mac_date_1 | DATE | YES |  |  |
| 40 | mac_price_2 | NUMERIC(18, 5) | YES |  |  |
| 41 | mac_date_2 | DATE | YES |  |  |
| 42 | maint_code | VARCHAR(1) | YES |  |  |
| 43 | reimb_code | VARCHAR(1) | YES |  |  |
| 44 | labeler_type_code | VARCHAR(1) | YES |  |  |
| 45 | wholesaler_acquisition_cost | NUMERIC(18, 6) | YES |  |  |
| 46 | inner_pack_code | VARCHAR(1) | YES |  |  |
| 47 | clinic_pack_code | VARCHAR(1) | YES |  |  |
| 48 | price_spread_code | VARCHAR(1) | YES |  |  |
| 49 | status_flag | VARCHAR(1) | YES |  |  |
| 50 | unit_cost_factor | NUMERIC(18, 3) | YES |  |  |
| 51 | progen_rebate | VARCHAR(1) | YES |  |  |
| 52 | brand_multi_combo | VARCHAR(2) | YES |  |  |
| 53 | sponsor_number | BIGINT | YES |  |  |
| 54 | dollar_rank | VARCHAR(1) | YES |  |  |
| 55 | rx_rank | VARCHAR(1) | YES |  |  |
| 56 | single_combination_code | VARCHAR(1) | YES |  |  |
| 57 | ppg_indicator_code | VARCHAR(1) | YES |  |  |
| 58 | hfpg_indicator_code | VARCHAR(1) | YES |  |  |
| 59 | drug_name_code | VARCHAR(6) | YES |  |  |
| 60 | metric_strength | NUMERIC(18, 3) | YES |  |  |
| 61 | size_u_m | VARCHAR(2) | YES |  |  |
| 62 | next_smaller_suffix | BIGINT | YES |  |  |
| 63 | next_larger_suffix | BIGINT | YES |  |  |
| 64 | dp_price_code | VARCHAR(1) | YES |  |  |
| 65 | dp_pack_price_1 | NUMERIC(18, 2) | YES |  |  |
| 66 | dp_pack_price_2 | NUMERIC(18, 2) | YES |  |  |
| 67 | dp_pack_price_3 | NUMERIC(18, 2) | YES |  |  |
| 68 | dp_pack_price_4 | NUMERIC(18, 2) | YES |  |  |
| 69 | pre_by_identification_number | VARCHAR(12) | YES |  |  |
| 70 | sup_by_identification_number | VARCHAR(12) | YES |  |  |
| 71 | drug_effective_date | DATE | YES |  |  |
| 72 | drug_dps_effective_date_1 | DATE | YES |  |  |
| 73 | drug_dps_effective_date_2 | DATE | YES |  |  |
| 74 | drug_dps_effective_date_3 | DATE | YES |  |  |
| 75 | drug_dps_termination_date_1 | DATE | YES |  |  |
| 76 | drug_dps_termination_date_2 | DATE | YES |  |  |
| 77 | drug_dps_termination_date_3 | DATE | YES |  |  |
| 78 | ddi_patient_code | BIGINT | YES |  |  |
| 79 | pcm_patient_code | BIGINT | YES |  |  |
| 80 | allergy_patient_code | BIGINT | YES |  |  |
| 81 | drug_error_record | VARCHAR(3) | YES |  |  |
| 82 | drug_error_date | DATE | YES |  |  |
| 83 | drug_reimbursement_schedule | VARCHAR(6) | YES |  |  |
| 84 | drug_copay_schedule_type | VARCHAR(6) | YES |  |  |
| 85 | drug_quantity_limit | NUMERIC(18, 3) | YES |  |  |
| 86 | repack_flag | VARCHAR(1) | YES |  |  |
| 87 | drug_awp_litigation | VARCHAR(1) | YES |  |  |
| 88 | drug_app_type | VARCHAR(1) | YES |  |  |
| 89 | drug_app_type_source | VARCHAR(1) | YES |  |  |
| 90 | kdc_1 | BIGINT | YES |  |  |
| 91 | kdc_2 | BIGINT | YES |  |  |
| 92 | kdc_3 | BIGINT | YES |  |  |
| 93 | gen_cross_ref_type_cd | VARCHAR(1) | YES |  |  |
| 94 | gen_id_no | VARCHAR(10) | YES |  |  |
| 95 | disp_unit | VARCHAR(1) | YES |  |  |
| 96 | unit_dose | VARCHAR(1) | YES |  |  |
| 97 | prod_name | VARCHAR(25) | YES |  |  |
| 98 | mac_prc_cd | VARCHAR(1) | YES |  |  |
| 99 | awp_prc_cd | VARCHAR(1) | YES |  |  |
| 100 | awp_pack_price_1 | NUMERIC(18, 2) | YES |  |  |
| 101 | awp_pack_price_2 | NUMERIC(18, 2) | YES |  |  |
| 102 | awp_pack_price_3 | NUMERIC(18, 2) | YES |  |  |
| 103 | awp_pack_price_4 | NUMERIC(18, 2) | YES |  |  |
| 104 | source | VARCHAR(15) | YES |  |  |
| 105 | gppc | VARCHAR(8) | YES |  |  |
| 106 | medispan_key | VARCHAR(12) | YES |  |  |
| 107 | dd_act_code | VARCHAR(1) | YES |  |  |
| 108 | last_change_notes | VARCHAR(30) | YES |  |  |
| 109 | first_data_gcn_number | VARCHAR(5) | YES |  |  |
| 110 | first_data_gi | VARCHAR(1) | YES |  |  |
| 111 | first_data_gpi | VARCHAR(1) | YES |  |  |
| 112 | type_code_16 | VARCHAR(1) | YES |  |  |
| 113 | fda_non_touch | VARCHAR(1) | YES |  |  |
| 114 | type_code_32 | VARCHAR(1) | YES |  |  |
| 115 | type_code_33 | VARCHAR(1) | YES |  |  |
| 116 | canadian_drug_id | VARCHAR(8) | YES |  |  |
| 117 | canada_margin_1 | NUMERIC(18, 5) | YES |  |  |
| 118 | canada_eff_date_1 | DATE | YES |  |  |
| 119 | canada_margin_2 | NUMERIC(18, 5) | YES |  |  |
| 120 | canada_eff_date_2 | DATE | YES |  |  |
| 121 | canada_margin_3 | NUMERIC(18, 5) | YES |  |  |
| 122 | canada_eff_date_3 | DATE | YES |  |  |
| 123 | canada_margin_4 | NUMERIC(18, 5) | YES |  |  |
| 124 | canada_eff_date_4 | DATE | YES |  |  |
| 125 | canada_margin_5 | NUMERIC(18, 5) | YES |  |  |
| 126 | canada_eff_date_5 | DATE | YES |  |  |
| 127 | dpc_cd | VARCHAR(3) | YES |  |  |
| 128 | ppc_cd | VARCHAR(3) | YES |  |  |
| 129 | limited_distr_cd | VARCHAR(2) | YES |  |  |
| 130 | awp_pack_price_5 | NUMERIC(18, 2) | YES |  |  |
| 131 | awp_price_5 | NUMERIC(18, 5) | YES |  |  |
| 132 | awp_date_5 | DATE | YES |  |  |
| 133 | awp_pack_price_6 | NUMERIC(18, 2) | YES |  |  |
| 134 | awp_price_6 | NUMERIC(18, 5) | YES |  |  |
| 135 | awp_date_6 | DATE | YES |  |  |
| 136 | whlsr_pk_cost | NUMERIC(18, 2) | YES |  |  |
| 137 | whlsr_eff_date | DATE | YES |  |  |
| 138 | whlsr_acquisition_cost_2 | NUMERIC(18, 5) | YES |  |  |
| 139 | whlsr_pk_cost_2 | NUMERIC(18, 2) | YES |  |  |
| 140 | whlsr_eff_date_2 | DATE | YES |  |  |
| 141 | delivery_mult_qty_flag | VARCHAR(1) | YES |  |  |
| 142 | abridged_ind | VARCHAR(1) | YES |  |  |
| 143 | comprehensive_ind | VARCHAR(1) | YES |  |  |
| 144 | brand_id | VARCHAR(20) | YES |  |  |
| 145 | notes_1 | VARCHAR(40) | YES |  |  |
| 146 | notes_2 | VARCHAR(40) | YES |  |  |
| 147 | system_number | BIGINT | YES |  |  |
| 148 | man_date | DATE | YES |  |  |
| 149 | medi_date | DATE | YES |  |  |
| 150 | whlsr_acquisition_cost_3 | NUMERIC(18, 5) | YES |  |  |
| 151 | whlsr_pk_cost_3 | NUMERIC(18, 2) | YES |  |  |
| 152 | whlsr_eff_date_3 | DATE | YES |  |  |
| 153 | whlsr_acquisition_cost_4 | NUMERIC(18, 5) | YES |  |  |
| 154 | whlsr_pk_cost_4 | NUMERIC(18, 2) | YES |  |  |
| 155 | whlsr_eff_date_4 | DATE | YES |  |  |
| 156 | whlsr_acquisition_cost_5 | NUMERIC(18, 5) | YES |  |  |
| 157 | whlsr_pk_cost_5 | NUMERIC(18, 2) | YES |  |  |
| 158 | whlsr_eff_date_5 | DATE | YES |  |  |
| 159 | whlsr_acquisition_cost_6 | NUMERIC(18, 5) | YES |  |  |
| 160 | whlsr_pk_cost_6 | NUMERIC(18, 2) | YES |  |  |
| 161 | whlsr_eff_date_6 | DATE | YES |  |  |
| 162 | mod_code | VARCHAR(6) | YES |  |  |
| 163 | mac_pack_price_1 | NUMERIC(18, 2) | YES |  |  |
| 164 | mac_pack_price_2 | NUMERIC(18, 2) | YES |  |  |
| 165 | orig_med_gen_code | VARCHAR(1) | YES |  |  |
| 166 | cfg_add_id | VARCHAR(15) | YES |  |  |
| 167 | cfg_change_id | VARCHAR(15) | YES |  |  |
| 168 | ndc_action | VARCHAR(1) | YES |  |  |
