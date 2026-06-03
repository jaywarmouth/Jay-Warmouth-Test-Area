# cloud_data_warehouse.claims_accum

> **Schema:** cloud_data_warehouse | **Columns:** 313

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
| 8 | batch_master | VARCHAR(8) | YES |  |  |
| 9 | claim_number | INTEGER | YES |  |  |
| 10 | claim_type | VARCHAR(1) | YES |  |  |
| 11 | original_batch_key | VARCHAR(8) | YES |  |  |
| 12 | original_claim_number | INTEGER | YES |  |  |
| 13 | limit_number | NUMERIC(19, 0) | YES |  |  |
| 14 | limit_member_number | INTEGER | YES |  |  |
| 15 | limit_bin | INTEGER | YES |  |  |
| 16 | limit_rollup_code | VARCHAR(20) | YES |  |  |
| 17 | limit_roll_date | TIMESTAMP | YES |  |  |
| 18 | limit_number_s | NUMERIC(19, 0) | YES |  |  |
| 19 | limit_member_number_s | INTEGER | YES |  |  |
| 20 | limit_bin_s | INTEGER | YES |  |  |
| 21 | limit_rollup_code_s | VARCHAR(20) | YES |  |  |
| 22 | limit_roll_date_s | TIMESTAMP | YES |  |  |
| 23 | copay_system_number | INTEGER | YES |  |  |
| 24 | copay_sponsor_number | INTEGER | YES |  |  |
| 25 | copay_schedule_number | VARCHAR(4) | YES |  |  |
| 26 | copay_schedule_type | VARCHAR(6) | YES |  |  |
| 27 | reimb_rate_number | INTEGER | YES |  |  |
| 28 | reimb_rate_gen_type | VARCHAR(6) | YES |  |  |
| 29 | except_cardholder_number | VARCHAR(10) | YES |  |  |
| 30 | except_member_number | VARCHAR(2) | YES |  |  |
| 31 | except_bin | INTEGER | YES |  |  |
| 32 | except_gpi | VARCHAR(14) | YES |  |  |
| 33 | pharm_net_network_number | INTEGER | YES |  |  |
| 34 | pharm_net_nabp_number | INTEGER | YES |  |  |
| 35 | pharm_net_state_code | INTEGER | YES |  |  |
| 36 | plan_system_number | INTEGER | YES |  |  |
| 37 | plan_number | VARCHAR(8) | YES |  |  |
| 38 | specialty_table_id | VARCHAR(8) | YES |  |  |
| 39 | specialty_gpi | VARCHAR(14) | YES |  |  |
| 40 | specialty_config_table_id | VARCHAR(8) | YES |  |  |
| 41 | specialty_config_gpi | VARCHAR(14) | YES |  |  |
| 42 | specialty_config_eff_date | TIMESTAMP | YES |  |  |
| 43 | spcfds_specialty_config_id | VARCHAR(8) | YES |  |  |
| 44 | sptds_specialty_table_id | VARCHAR(8) | YES |  |  |
| 45 | tpm_system_number | INTEGER | YES |  |  |
| 46 | tpm_sponsor_number | INTEGER | YES |  |  |
| 47 | tpm_group_number | NUMERIC(19, 0) | YES |  |  |
| 48 | tpm_rec_type | INTEGER | YES |  |  |
| 49 | tpm_sequence_number | INTEGER | YES |  |  |
| 50 | dift_t_link | VARCHAR(5) | YES |  |  |
| 51 | dift_system_number | INTEGER | YES |  |  |
| 52 | dift_sponsor_number | INTEGER | YES |  |  |
| 53 | dift_group_number | NUMERIC(19, 0) | YES |  |  |
| 54 | dift_network_number | INTEGER | YES |  |  |
| 55 | dift_nabp | INTEGER | YES |  |  |
| 56 | dift_gpi | VARCHAR(14) | YES |  |  |
| 57 | dift_ndc | NUMERIC(19, 0) | YES |  |  |
| 58 | dift_claim_type | VARCHAR(6) | YES |  |  |
| 59 | dift_table_number | INTEGER | YES |  |  |
| 60 | dift_date_type | VARCHAR(2) | YES |  |  |
| 61 | dift_sequence_number | INTEGER | YES |  |  |
| 62 | cfg_t_link | VARCHAR(5) | YES |  |  |
| 63 | cfg_system_number | INTEGER | YES |  |  |
| 64 | cfg_sponsor_number | INTEGER | YES |  |  |
| 65 | cfg_group_number | NUMERIC(19, 0) | YES |  |  |
| 66 | cfg_rec_type | VARCHAR(3) | YES |  |  |
| 67 | cfg_date_type | VARCHAR(2) | YES |  |  |
| 68 | cfg_data_type | VARCHAR(3) | YES |  |  |
| 69 | cfg_data | VARCHAR(20) | YES |  |  |
| 70 | cfg_amt_type | VARCHAR(3) | YES |  |  |
| 71 | cfg_occ | INTEGER | YES |  |  |
| 72 | cfg_min_amt | NUMERIC(18, 4) | YES |  |  |
| 73 | cfg_max_amt | NUMERIC(18, 4) | YES |  |  |
| 74 | cfg_sequence_number | INTEGER | YES |  |  |
| 75 | ruc_t_link | VARCHAR(5) | YES |  |  |
| 76 | ruc_system_number | INTEGER | YES |  |  |
| 77 | ruc_sponsor_number | INTEGER | YES |  |  |
| 78 | ruc_group_number | NUMERIC(19, 0) | YES |  |  |
| 79 | ruc_sequence_number | INTEGER | YES |  |  |
| 80 | ruc_t_link_s | VARCHAR(5) | YES |  |  |
| 81 | ruc_system_number_s | INTEGER | YES |  |  |
| 82 | ruc_sponsor_number_s | INTEGER | YES |  |  |
| 83 | ruc_group_number_s | NUMERIC(19, 0) | YES |  |  |
| 84 | ruc_sequence_number_s | INTEGER | YES |  |  |
| 85 | rcp_rollup_code | VARCHAR(20) | YES |  |  |
| 86 | rcp_sequence_number | INTEGER | YES |  |  |
| 87 | nsde_ndc | NUMERIC(19, 0) | YES |  |  |
| 88 | nsdeor_system_number | INTEGER | YES |  |  |
| 89 | nsdeor_sponsor_number | INTEGER | YES |  |  |
| 90 | nsdeor_group_number | NUMERIC(19, 0) | YES |  |  |
| 91 | nsdeor_plan | VARCHAR(8) | YES |  |  |
| 92 | nsdeor_cardholder_number | VARCHAR(10) | YES |  |  |
| 93 | nsdeor_member_number | VARCHAR(2) | YES |  |  |
| 94 | nsdeor_ndc | NUMERIC(19, 0) | YES |  |  |
| 95 | nsdeor_gpi | VARCHAR(14) | YES |  |  |
| 96 | nsdeor_sequence_number | INTEGER | YES |  |  |
| 97 | nm_ndc | NUMERIC(19, 0) | YES |  |  |
| 98 | ndc_ovr_ndc_id | VARCHAR(8) | YES |  |  |
| 99 | ndc_ovr_ndc | NUMERIC(19, 0) | YES |  |  |
| 100 | ndc_ovr_sequence_number | INTEGER | YES |  |  |
| 101 | nloc_sponsor_number | INTEGER | YES |  |  |
| 102 | nloc_group_number | FLOAT8 | YES |  |  |
| 103 | nloc_ndc | NUMERIC(19, 0) | YES |  |  |
| 104 | fvss_batch_master | VARCHAR(8) | YES |  |  |
| 105 | fvss_claim_number | INTEGER | YES |  |  |
| 106 | fvss_claim_type | VARCHAR(1) | YES |  |  |
| 107 | brc_brand_id | VARCHAR(20) | YES |  |  |
| 108 | brc_multi_use_one_time_flag | VARCHAR(1) | YES |  |  |
| 109 | brc_rx_date | TIMESTAMP | YES |  |  |
| 110 | brc_todays_date | TIMESTAMP | YES |  |  |
| 111 | brc_pharmacy_state_code | VARCHAR(2) | YES |  |  |
| 112 | brc_pharmacy_zip_code | VARCHAR(9) | YES |  |  |
| 113 | brc_chain | INTEGER | YES |  |  |
| 114 | brc_nabp_number | INTEGER | YES |  |  |
| 115 | brc_ndc | NUMERIC(38, 0) | YES |  |  |
| 116 | brc_gpi | VARCHAR(14) | YES |  |  |
| 117 | brc_oth_cov_code | INTEGER | YES |  |  |
| 118 | brc_compu_days_supply | INTEGER | YES |  |  |
| 119 | brc_compu_met_quant | NUMERIC(18, 3) | YES |  |  |
| 120 | brc_compu_redemp_count | INTEGER | YES |  |  |
| 121 | brc_compu_sponsor_number | INTEGER | YES |  |  |
| 122 | brc_config_type | VARCHAR(1) | YES |  |  |
| 123 | brc_cob_flag | VARCHAR(1) | YES |  |  |
| 124 | brc_cob38_flag | VARCHAR(1) | YES |  |  |
| 125 | brc_cob8_only_flag | VARCHAR(1) | YES |  |  |
| 126 | brc_srts_flag | VARCHAR(1) | YES |  |  |
| 127 | brc_min_copay_flag | VARCHAR(1) | YES |  |  |
| 128 | brc_limits_apply_flag | VARCHAR(1) | YES |  |  |
| 129 | brc_skip212_reject_flag | VARCHAR(1) | YES |  |  |
| 130 | brc_apply275_reject_flag | VARCHAR(1) | YES |  |  |
| 131 | brc_apply538_reject_flag | VARCHAR(1) | YES |  |  |
| 132 | brc_skip232_reject_flag | VARCHAR(1) | YES |  |  |
| 133 | brc_brchn_reject | VARCHAR(1) | YES |  |  |
| 134 | brc_brben_ds_reject | VARCHAR(1) | YES |  |  |
| 135 | brc_brben_mq_reject | VARCHAR(1) | YES |  |  |
| 136 | brc_mass_primary_reject_flag | VARCHAR(1) | YES |  |  |
| 137 | brc_mass_cob_reject_flag | VARCHAR(1) | YES |  |  |
| 138 | brc_no_mass_reject_flag | VARCHAR(1) | YES |  |  |
| 139 | brc_missing_brcfg_reject | VARCHAR(1) | YES |  |  |
| 140 | brc_missing_brben_reject | VARCHAR(1) | YES |  |  |
| 141 | brc_occurence | INTEGER | YES |  |  |
| 142 | brc_copay | NUMERIC(18, 2) | YES |  |  |
| 143 | brc_max_claim_amt | NUMERIC(18, 2) | YES |  |  |
| 144 | brc_error_status_code | VARCHAR(2) | YES |  |  |
| 145 | brc_error_file | VARCHAR(10) | YES |  |  |
| 146 | brc_error_flag | VARCHAR(1) | YES |  |  |
| 147 | brc_rejected_occ | INTEGER | YES |  |  |
| 148 | brc_pharm_rules_reject_flag | VARCHAR(1) | YES |  |  |
| 149 | brc_bilo_winn_rules_reject_flag | VARCHAR(1) | YES |  |  |
| 150 | brc_apply249_reject_flag | VARCHAR(1) | YES |  |  |
| 151 | disp_mq_multi | NUMERIC(18, 3) | YES |  |  |
| 152 | ws_qty_mult_message | VARCHAR(1) | YES |  |  |
| 153 | brc_brben_term_flag | VARCHAR(1) | YES |  |  |
| 154 | crd_coverage_type | VARCHAR(1) | YES |  |  |
| 155 | pl_max_single | NUMERIC(18, 2) | YES |  |  |
| 156 | pl_max_family | NUMERIC(18, 2) | YES |  |  |
| 157 | pl_ded_single | NUMERIC(18, 2) | YES |  |  |
| 158 | pl_ded_family | NUMERIC(18, 2) | YES |  |  |
| 159 | pl_sing_max | NUMERIC(18, 2) | YES |  |  |
| 160 | pl_family_max | NUMERIC(18, 2) | YES |  |  |
| 161 | pl_lifetime_max | NUMERIC(18, 2) | YES |  |  |
| 162 | pl_troop_amt | NUMERIC(18, 2) | YES |  |  |
| 163 | grp_broker_number | VARCHAR(4) | YES |  |  |
| 164 | grp_limit_kind | VARCHAR(1) | YES |  |  |
| 165 | limit_mbr_max | NUMERIC(18, 2) | YES |  |  |
| 166 | single_copay | NUMERIC(18, 2) | YES |  |  |
| 167 | single_copay_max | NUMERIC(18, 2) | YES |  |  |
| 168 | single_copay_ded | NUMERIC(18, 2) | YES |  |  |
| 169 | family_copay | NUMERIC(18, 2) | YES |  |  |
| 170 | family_copay_max | NUMERIC(18, 2) | YES |  |  |
| 171 | family_copay_ded | NUMERIC(18, 2) | YES |  |  |
| 172 | limit_paid | NUMERIC(18, 2) | YES |  |  |
| 173 | limit_paid_mail | NUMERIC(18, 2) | YES |  |  |
| 174 | max_left | NUMERIC(18, 2) | YES |  |  |
| 175 | max_j_paid | NUMERIC(18, 2) | YES |  |  |
| 176 | max_j_left | NUMERIC(18, 2) | YES |  |  |
| 177 | max_paid | NUMERIC(18, 2) | YES |  |  |
| 178 | max_paid_mail | NUMERIC(18, 2) | YES |  |  |
| 179 | limit_claims_before | INTEGER | YES |  |  |
| 180 | limit_t_ing_bill_before | NUMERIC(18, 2) | YES |  |  |
| 181 | limit_t_copay_before | NUMERIC(18, 2) | YES |  |  |
| 182 | limit_t_disp_before | NUMERIC(18, 2) | YES |  |  |
| 183 | limit_t_tax_before | NUMERIC(18, 2) | YES |  |  |
| 184 | limit_t_ing_paid_before | NUMERIC(18, 2) | YES |  |  |
| 185 | limit_last_qtr_carry_over_before | NUMERIC(18, 2) | YES |  |  |
| 186 | limit_m_claims_before | INTEGER | YES |  |  |
| 187 | limit_m_ing_bill_before | NUMERIC(18, 2) | YES |  |  |
| 188 | limit_m_copay_before | NUMERIC(18, 2) | YES |  |  |
| 189 | limit_m_disp_before | NUMERIC(18, 2) | YES |  |  |
| 190 | limit_m_tax_before | NUMERIC(18, 2) | YES |  |  |
| 191 | limit_m_ing_paid_before | NUMERIC(18, 2) | YES |  |  |
| 192 | limit_last_qtr_carry_over_mail_before | NUMERIC(18, 2) | YES |  |  |
| 193 | limit_ded_amt_only_before | NUMERIC(18, 2) | YES |  |  |
| 194 | limit_med_d_non_lics_ded_amt_before | NUMERIC(18, 2) | YES |  |  |
| 195 | limit_troop_amt_before | NUMERIC(18, 2) | YES |  |  |
| 196 | limit_tot_drug2250_before | NUMERIC(18, 2) | YES |  |  |
| 197 | limit_stand_ded_only_before | NUMERIC(18, 2) | YES |  |  |
| 198 | ex_occurrence_before | INTEGER | YES |  |  |
| 199 | ex_max_dollar_before | NUMERIC(18, 2) | YES |  |  |
| 200 | ex_max_dollar_to_date_before | NUMERIC(18, 2) | YES |  |  |
| 201 | limit_claims_bs | INTEGER | YES |  |  |
| 202 | limit_t_ing_bill_bs | NUMERIC(18, 2) | YES |  |  |
| 203 | limit_t_copay_bs | NUMERIC(18, 2) | YES |  |  |
| 204 | limit_t_disp_bs | NUMERIC(18, 2) | YES |  |  |
| 205 | limit_t_tax_bs | NUMERIC(18, 2) | YES |  |  |
| 206 | limit_t_ing_paid_bs | NUMERIC(18, 2) | YES |  |  |
| 207 | limit_last_qtr_carry_over_bs | NUMERIC(18, 2) | YES |  |  |
| 208 | limit_m_claims_bs | INTEGER | YES |  |  |
| 209 | limit_m_ing_bill_bs | NUMERIC(18, 2) | YES |  |  |
| 210 | limit_m_copay_bs | NUMERIC(18, 2) | YES |  |  |
| 211 | limit_m_disp_bs | NUMERIC(18, 2) | YES |  |  |
| 212 | limit_m_tax_bs | NUMERIC(18, 2) | YES |  |  |
| 213 | limit_m_ing_paid_bs | NUMERIC(18, 2) | YES |  |  |
| 214 | limit_last_qtr_carry_over_mail_bs | NUMERIC(18, 2) | YES |  |  |
| 215 | limit_ded_amt_only_bs | NUMERIC(18, 2) | YES |  |  |
| 216 | limit_med_d_non_lics_ded_amt_bs | NUMERIC(18, 2) | YES |  |  |
| 217 | limit_troop_amt_bs | NUMERIC(18, 2) | YES |  |  |
| 218 | limit_tot_drug2250_bs | NUMERIC(18, 2) | YES |  |  |
| 219 | limit_stand_ded_only_bs | NUMERIC(18, 2) | YES |  |  |
| 220 | limit_claims_after | INTEGER | YES |  |  |
| 221 | limit_t_ing_bill_after | NUMERIC(18, 2) | YES |  |  |
| 222 | limit_t_copay_after | NUMERIC(18, 2) | YES |  |  |
| 223 | limit_t_disp_after | NUMERIC(18, 2) | YES |  |  |
| 224 | limit_t_tax_after | NUMERIC(18, 2) | YES |  |  |
| 225 | limit_t_ing_paid_after | NUMERIC(18, 2) | YES |  |  |
| 226 | limit_last_qtr_carry_over_after | NUMERIC(18, 2) | YES |  |  |
| 227 | limit_m_claims_after | INTEGER | YES |  |  |
| 228 | limit_m_ing_bill_after | NUMERIC(18, 2) | YES |  |  |
| 229 | limit_m_copay_after | NUMERIC(18, 2) | YES |  |  |
| 230 | limit_m_disp_after | NUMERIC(18, 2) | YES |  |  |
| 231 | limit_m_tax_after | NUMERIC(18, 2) | YES |  |  |
| 232 | limit_m_ing_paid_after | NUMERIC(18, 2) | YES |  |  |
| 233 | limit_last_qtr_carry_over_mail_after | NUMERIC(18, 2) | YES |  |  |
| 234 | limit_ded_amt_only_after | NUMERIC(18, 2) | YES |  |  |
| 235 | limit_med_d_non_lics_ded_amt_after | NUMERIC(18, 2) | YES |  |  |
| 236 | limit_troop_amt_after | NUMERIC(18, 2) | YES |  |  |
| 237 | limit_tot_drug2250_after | NUMERIC(18, 2) | YES |  |  |
| 238 | limit_stand_ded_only_after | NUMERIC(18, 2) | YES |  |  |
| 239 | ex_occurrence_after | INTEGER | YES |  |  |
| 240 | ex_max_dollar_after | NUMERIC(18, 2) | YES |  |  |
| 241 | ex_max_dollar_to_date_after | NUMERIC(18, 2) | YES |  |  |
| 242 | limit_claims_as | INTEGER | YES |  |  |
| 243 | limit_t_ing_bill_as | NUMERIC(18, 2) | YES |  |  |
| 244 | limit_t_copay_as | NUMERIC(18, 2) | YES |  |  |
| 245 | limit_t_disp_as | NUMERIC(18, 2) | YES |  |  |
| 246 | limit_t_tax_as | NUMERIC(18, 2) | YES |  |  |
| 247 | limit_t_ing_paid_as | NUMERIC(18, 2) | YES |  |  |
| 248 | limit_last_qtr_carry_over_as | NUMERIC(18, 2) | YES |  |  |
| 249 | limit_m_claims_as | INTEGER | YES |  |  |
| 250 | limit_m_ing_bill_as | NUMERIC(18, 2) | YES |  |  |
| 251 | limit_m_copay_as | NUMERIC(18, 2) | YES |  |  |
| 252 | limit_m_disp_as | NUMERIC(18, 2) | YES |  |  |
| 253 | limit_m_tax_as | NUMERIC(18, 2) | YES |  |  |
| 254 | limit_m_ing_paid_as | NUMERIC(18, 2) | YES |  |  |
| 255 | limit_last_qtr_carry_over_mail_as | NUMERIC(18, 2) | YES |  |  |
| 256 | limit_ded_amt_only_as | NUMERIC(18, 2) | YES |  |  |
| 257 | limit_med_d_non_lics_ded_amt_as | NUMERIC(18, 2) | YES |  |  |
| 258 | limit_troop_amt_as | NUMERIC(18, 2) | YES |  |  |
| 259 | limit_tot_drug2250_as | NUMERIC(18, 2) | YES |  |  |
| 260 | limit_stand_ded_only_as | NUMERIC(18, 2) | YES |  |  |
| 261 | oop_single_limit | NUMERIC(18, 2) | YES |  |  |
| 262 | oop_family_limit | NUMERIC(18, 2) | YES |  |  |
| 263 | ded_single_limit | NUMERIC(18, 2) | YES |  |  |
| 264 | ded_family_limit | NUMERIC(18, 2) | YES |  |  |
| 265 | oop_single_app_amt | NUMERIC(18, 2) | YES |  |  |
| 266 | oop_family_app_amt | NUMERIC(18, 2) | YES |  |  |
| 267 | ded_single_app_amt | NUMERIC(18, 2) | YES |  |  |
| 268 | ded_family_app_amt | NUMERIC(18, 2) | YES |  |  |
| 269 | oop_single_app_amt_ytd | NUMERIC(18, 2) | YES |  |  |
| 270 | oop_family_app_amt_ytd | NUMERIC(18, 2) | YES |  |  |
| 271 | ded_single_app_amt_ytd | NUMERIC(18, 2) | YES |  |  |
| 272 | ded_family_app_amt_ytd | NUMERIC(18, 2) | YES |  |  |
| 273 | nsde_eff_date | TIMESTAMP | YES |  |  |
| 274 | nsde_term_date | TIMESTAMP | YES |  |  |
| 275 | ndc_loc_eff_date | TIMESTAMP | YES |  |  |
| 276 | ndc_loc_term_date | TIMESTAMP | YES |  |  |
| 277 | plan_specialty_config_id | VARCHAR(8) | YES |  |  |
| 278 | plan_specialty_table_id | VARCHAR(8) | YES |  |  |
| 279 | vrx_action_code | VARCHAR(8) | YES |  |  |
| 280 | enroll_begin_date | TIMESTAMP | YES |  |  |
| 281 | enroll_term_date | TIMESTAMP | YES |  |  |
| 282 | enroll_use_date | TIMESTAMP | YES |  |  |
| 283 | nppes_begin_date | TIMESTAMP | YES |  |  |
| 284 | nppes_term_date | TIMESTAMP | YES |  |  |
| 285 | prov_fill_ind | VARCHAR(2) | YES |  |  |
| 286 | pdmi_result | VARCHAR(1) | YES |  |  |
| 287 | ef_result | VARCHAR(1) | YES |  |  |
| 288 | ef_excep_code | VARCHAR(1) | YES |  |  |
| 289 | ef_value_type | VARCHAR(1) | YES |  |  |
| 290 | form_ndc_id | VARCHAR(8) | YES |  |  |
| 291 | plan_ndc_id | VARCHAR(8) | YES |  |  |
| 292 | res_uid | VARCHAR(36) | YES |  |  |
| 293 | res_prod_type | VARCHAR(20) | YES |  |  |
| 294 | res_response_code | VARCHAR(10) | YES |  |  |
| 295 | res_response_msg | VARCHAR(200) | YES |  |  |
| 296 | res_pharm_msg | VARCHAR(200) | YES |  |  |
| 297 | res_ing_cost | NUMERIC(18, 2) | YES |  |  |
| 298 | res_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 299 | res_copay_amt_ovr | NUMERIC(18, 2) | YES |  |  |
| 300 | res_tax | NUMERIC(18, 2) | YES |  |  |
| 301 | res_pdmi_reject_ovr | VARCHAR(10) | YES |  |  |
| 302 | res_source_sys_id | VARCHAR(36) | YES |  |  |
| 303 | res_pi_id | VARCHAR(10) | YES |  |  |
| 304 | file_date | TIMESTAMP | YES |  |  |
| 305 | add_id | VARCHAR(15) | YES |  |  |
| 306 | change_id | VARCHAR(15) | YES |  |  |
| 307 | add_date | TIMESTAMP | YES |  |  |
| 308 | change_date | TIMESTAMP | YES |  |  |
| 309 | claim_key | VARCHAR(14) | YES |  |  |
| 310 | original_claim_key | VARCHAR(14) | YES |  |  |
| 311 | copay_key | VARCHAR(12) | YES |  |  |
| 312 | pharm_net_key | VARCHAR(16) | YES |  |  |
| 313 | plan_key | VARCHAR(16) | YES |  |  |
