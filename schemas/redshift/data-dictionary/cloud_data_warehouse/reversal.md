# cloud_data_warehouse.reversal

> **Schema:** cloud_data_warehouse | **Columns:** 325

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
| 8 | reversal_key | VARCHAR(14) | NO |  | Required |
| 9 | batch_master | VARCHAR(8) | YES |  |  |
| 10 | claim_number | BIGINT | YES |  |  |
| 11 | claim_type | BIGINT | YES |  |  |
| 12 | payment_dir | BIGINT | YES |  |  |
| 13 | cardholder_number | VARCHAR(10) | YES |  |  |
| 14 | member_number | BIGINT | YES |  |  |
| 15 | rel_code | VARCHAR(1) | YES |  |  |
| 16 | member_birth_date | DATE | YES |  |  |
| 17 | member_sex | VARCHAR(1) | YES |  |  |
| 18 | member_first | VARCHAR(12) | YES |  |  |
| 19 | member_mi | VARCHAR(1) | YES |  |  |
| 20 | member_last | VARCHAR(15) | YES |  |  |
| 21 | pharmacy_number | BIGINT | YES |  |  |
| 22 | chain_number | BIGINT | YES |  |  |
| 23 | system_number | BIGINT | YES |  |  |
| 24 | sponsor_number | BIGINT | YES |  |  |
| 25 | group_number | VARCHAR(20) | YES |  |  |
| 26 | coverage_type | VARCHAR(1) | YES |  |  |
| 27 | plan_number | VARCHAR(8) | YES |  |  |
| 28 | other_coverage_code | BIGINT | YES |  |  |
| 29 | rx_date | DATE | YES |  |  |
| 30 | rx_number | BIGINT | YES |  |  |
| 31 | new_refill | VARCHAR(1) | YES |  |  |
| 32 | refill_count_num | BIGINT | YES |  |  |
| 33 | met_quan | NUMERIC(18, 3) | YES |  |  |
| 34 | days_supply | BIGINT | YES |  |  |
| 35 | compound_code | BIGINT | YES |  |  |
| 36 | type_code | BIGINT | YES |  |  |
| 37 | ndc | VARCHAR(12) | YES |  |  |
| 38 | gpi | VARCHAR(14) | YES |  |  |
| 39 | third_party | VARCHAR(1) | YES |  |  |
| 40 | main_drug | VARCHAR(1) | YES |  |  |
| 41 | gen_code | VARCHAR(1) | YES |  |  |
| 42 | mac_number | BIGINT | YES |  |  |
| 43 | generic_table | BIGINT | YES |  |  |
| 44 | form_gt | BIGINT | YES |  |  |
| 45 | maint_gt | BIGINT | YES |  |  |
| 46 | step_therapy_number | BIGINT | YES |  |  |
| 47 | preferred_status | VARCHAR(1) | YES |  |  |
| 48 | daw_indicator_x | VARCHAR(1) | YES |  |  |
| 49 | tax | NUMERIC(18, 2) | YES |  |  |
| 50 | disp_fee | NUMERIC(18, 2) | YES |  |  |
| 51 | copay | NUMERIC(18, 2) | YES |  |  |
| 52 | ing_cost_billed | NUMERIC(18, 2) | YES |  |  |
| 53 | ing_cost_paid | NUMERIC(18, 2) | YES |  |  |
| 54 | admin_fee | NUMERIC(18, 2) | YES |  |  |
| 55 | physician_number_x | VARCHAR(15) | YES |  |  |
| 56 | orig_rx_date | DATE | YES |  |  |
| 57 | refills_auth | BIGINT | YES |  |  |
| 58 | rx_origin_code | BIGINT | YES |  |  |
| 59 | ucr_amount | NUMERIC(18, 2) | YES |  |  |
| 60 | sub_clarification_count | BIGINT | YES |  |  |
| 61 | sub_clarification_code_1 | BIGINT | YES |  |  |
| 62 | sub_clarification_code_2 | BIGINT | YES |  |  |
| 63 | sub_clarifiction_code_3 | BIGINT | YES |  |  |
| 64 | customer_location | BIGINT | YES |  |  |
| 65 | elig_clarification_code | BIGINT | YES |  |  |
| 66 | pa_mc_code_and_number | NUMERIC(12, 0) | YES |  |  |
| 67 | other_payer_bin | BIGINT | YES |  |  |
| 68 | level_of_service | BIGINT | YES |  |  |
| 69 | primary_prescriber | VARCHAR(10) | YES |  |  |
| 70 | trans_ref_number | VARCHAR(10) | YES |  |  |
| 71 | basis_of_cost_determination | VARCHAR(2) | YES |  |  |
| 72 | patient_paid_amount | NUMERIC(18, 2) | YES |  |  |
| 73 | period_ending | BIGINT | YES |  |  |
| 74 | paid_date | DATE | YES |  |  |
| 75 | document_number | BIGINT | YES |  |  |
| 76 | line_number | BIGINT | YES |  |  |
| 77 | time_hhmm | VARCHAR(4) | YES |  |  |
| 78 | processor_control_flag | VARCHAR(1) | YES |  |  |
| 79 | version_number | VARCHAR(1) | YES |  |  |
| 80 | rej_code_1 | BIGINT | YES |  |  |
| 81 | rej_code_2 | BIGINT | YES |  |  |
| 82 | reversal_code | BIGINT | YES |  |  |
| 83 | adj_code_1 | BIGINT | YES |  |  |
| 84 | adj_code_informational | BIGINT | YES |  |  |
| 85 | exception_01 | BIGINT | YES |  |  |
| 86 | exception_02 | BIGINT | YES |  |  |
| 87 | exception_03 | BIGINT | YES |  |  |
| 88 | exception_04 | BIGINT | YES |  |  |
| 89 | exception_05 | BIGINT | YES |  |  |
| 90 | exception_06 | BIGINT | YES |  |  |
| 91 | exception_07 | BIGINT | YES |  |  |
| 92 | exception_08 | BIGINT | YES |  |  |
| 93 | exception_09 | BIGINT | YES |  |  |
| 94 | exception_10 | BIGINT | YES |  |  |
| 95 | exception_11 | BIGINT | YES |  |  |
| 96 | exception_12 | BIGINT | YES |  |  |
| 97 | exception_13 | BIGINT | YES |  |  |
| 98 | exception_14 | BIGINT | YES |  |  |
| 99 | exception_15 | BIGINT | YES |  |  |
| 100 | exception_16 | BIGINT | YES |  |  |
| 101 | exception_17 | BIGINT | YES |  |  |
| 102 | exception_18 | BIGINT | YES |  |  |
| 103 | exception_19 | BIGINT | YES |  |  |
| 104 | exception_20 | BIGINT | YES |  |  |
| 105 | override_01 | BIGINT | YES |  |  |
| 106 | override_02 | BIGINT | YES |  |  |
| 107 | override_03 | BIGINT | YES |  |  |
| 108 | override_04 | BIGINT | YES |  |  |
| 109 | override_05 | BIGINT | YES |  |  |
| 110 | override_06 | BIGINT | YES |  |  |
| 111 | override_07 | BIGINT | YES |  |  |
| 112 | override_08 | BIGINT | YES |  |  |
| 113 | override_09 | BIGINT | YES |  |  |
| 114 | override_10 | BIGINT | YES |  |  |
| 115 | skip_limit_flag | BIGINT | YES |  |  |
| 116 | copay_table | BIGINT | YES |  |  |
| 117 | disp_table | BIGINT | YES |  |  |
| 118 | network_number | BIGINT | YES |  |  |
| 119 | dmr_reim_payment_type | BIGINT | YES |  |  |
| 120 | pharmacy_option | VARCHAR(1) | YES |  |  |
| 121 | max_amt | NUMERIC(18, 2) | YES |  |  |
| 122 | deduct_amt | NUMERIC(18, 2) | YES |  |  |
| 123 | gen_saving_net | NUMERIC(18, 2) | YES |  |  |
| 124 | other_payor_amount | NUMERIC(18, 2) | YES |  |  |
| 125 | upd_code | BIGINT | YES |  |  |
| 126 | pho | VARCHAR(14) | YES |  |  |
| 127 | other_payer_pcn | VARCHAR(14) | YES |  |  |
| 128 | pcp | VARCHAR(14) | YES |  |  |
| 129 | other_payer_group | VARCHAR(14) | YES |  |  |
| 130 | county | VARCHAR(2) | YES |  |  |
| 131 | soj | VARCHAR(2) | YES |  |  |
| 132 | awp_100_perc | NUMERIC(18, 2) | YES |  |  |
| 133 | diff_ing_paid | NUMERIC(18, 2) | YES |  |  |
| 134 | diff_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 135 | diff_table_number | BIGINT | YES |  |  |
| 136 | mac_reference_price | NUMERIC(18, 2) | YES |  |  |
| 137 | contract_rate_price | NUMERIC(18, 2) | YES |  |  |
| 138 | order_number | VARCHAR(20) | YES |  |  |
| 139 | other_payer_cardholder | VARCHAR(20) | YES |  |  |
| 140 | dispensing_status | VARCHAR(1) | YES |  |  |
| 141 | assoc_rx_date | DATE | YES |  |  |
| 142 | assoc_rx_number | BIGINT | YES |  |  |
| 143 | intended_met_qty | NUMERIC(18, 3) | YES |  |  |
| 144 | intended_days_supply | BIGINT | YES |  |  |
| 145 | par_ing_cost_paid | NUMERIC(18, 2) | YES |  |  |
| 146 | ta_amount | NUMERIC(18, 2) | YES |  |  |
| 147 | dmr_nabp | BIGINT | YES |  |  |
| 148 | date_of_injury | DATE | YES |  |  |
| 149 | indep_code | BIGINT | YES |  |  |
| 150 | penalty_amount | NUMERIC(18, 2) | YES |  |  |
| 151 | other_payer_order | BIGINT | YES |  |  |
| 152 | nonlics_deduct_amt | NUMERIC(18, 2) | YES |  |  |
| 153 | standard_deduct_amt | NUMERIC(18, 2) | YES |  |  |
| 154 | special_deduct_amt | NUMERIC(18, 2) | YES |  |  |
| 155 | team_member | VARCHAR(4) | YES |  |  |
| 156 | npi_number | VARCHAR(10) | YES |  |  |
| 157 | card_seq_number | BIGINT | YES |  |  |
| 158 | add_to_troop | NUMERIC(18, 2) | YES |  |  |
| 159 | pcn | VARCHAR(10) | YES |  |  |
| 160 | bin_number | BIGINT | YES |  |  |
| 161 | eft_payment | VARCHAR(1) | YES |  |  |
| 162 | medd_gap_discount | NUMERIC(18, 2) | YES |  |  |
| 163 | medd_beg_phase | VARCHAR(1) | YES |  |  |
| 164 | medd_end_phase | VARCHAR(1) | YES |  |  |
| 165 | rx_number_length | BIGINT | YES |  |  |
| 166 | compound_dosage_desc_code | VARCHAR(2) | YES |  |  |
| 167 | compound_dispensing_ind | VARCHAR(1) | YES |  |  |
| 168 | compound_count | BIGINT | YES |  |  |
| 169 | amt_applied_period_deductible | NUMERIC(18, 2) | YES |  |  |
| 170 | amt_exceed_period_benefit_max | NUMERIC(18, 2) | YES |  |  |
| 171 | amt_copay | NUMERIC(18, 2) | YES |  |  |
| 172 | amt_coinsurance | NUMERIC(18, 2) | YES |  |  |
| 173 | amt_attr_processor_fee | NUMERIC(18, 2) | YES |  |  |
| 174 | amt_attr_sales_tax | NUMERIC(18, 2) | YES |  |  |
| 175 | amt_attr_provider_net_select | NUMERIC(18, 2) | YES |  |  |
| 176 | amt_attr_prod_sel_brand | NUMERIC(18, 2) | YES |  |  |
| 177 | amt_attr_prod_sel_non_pf | NUMERIC(18, 2) | YES |  |  |
| 178 | amt_attr_prod_sel_brd_non_pf | NUMERIC(18, 2) | YES |  |  |
| 179 | amt_attr_coverage_gap | NUMERIC(18, 2) | YES |  |  |
| 180 | health_plan_funded_assist_amt | NUMERIC(18, 2) | YES |  |  |
| 181 | gross_amount_due | NUMERIC(18, 2) | YES |  |  |
| 182 | incentive_amount_sub | NUMERIC(18, 2) | YES |  |  |
| 183 | dispensing_fee_sub | NUMERIC(18, 2) | YES |  |  |
| 184 | other_amount_claimed_sub | NUMERIC(18, 2) | YES |  |  |
| 185 | flat_sales_tax_amount_sub | NUMERIC(18, 2) | YES |  |  |
| 186 | pct_sales_tax_amount_sub | NUMERIC(18, 2) | YES |  |  |
| 187 | pct_sales_tax_rate_sub | NUMERIC(18, 4) | YES |  |  |
| 188 | medicaid_subrogation | VARCHAR(20) | YES |  |  |
| 189 | medicaid_paid_amt | NUMERIC(18, 2) | YES |  |  |
| 190 | pharmacy_service_type | BIGINT | YES |  |  |
| 191 | pharmacist_license | VARCHAR(15) | YES |  |  |
| 192 | seq_number | VARCHAR(17) | YES |  |  |
| 193 | uid | VARCHAR(36) | YES |  |  |
| 194 | cms_part_d_facility | VARCHAR(1) | YES |  |  |
| 195 | approved_msg_code | VARCHAR(3) | YES |  |  |
| 196 | nabp_7 | VARCHAR(7) | YES |  |  |
| 197 | proc_date | DATE | YES |  |  |
| 198 | state_1_code | BIGINT | YES |  |  |
| 199 | state_2_code | BIGINT | YES |  |  |
| 200 | adj_date | DATE | YES |  |  |
| 201 | adj_code | VARCHAR(1) | YES |  |  |
| 202 | restack_batch | VARCHAR(8) | YES |  |  |
| 203 | restack_claim | BIGINT | YES |  |  |
| 204 | variable_mac_factor_rate | NUMERIC(18, 5) | YES |  |  |
| 205 | patient_residency | VARCHAR(2) | YES |  |  |
| 206 | special_packaging_ind | VARCHAR(1) | YES |  |  |
| 207 | prof_service_code1 | VARCHAR(2) | YES |  |  |
| 208 | prof_service_code2 | VARCHAR(2) | YES |  |  |
| 209 | prof_service_code3 | VARCHAR(2) | YES |  |  |
| 210 | dur_pps_lvl_of_effort | VARCHAR(2) | YES |  |  |
| 211 | troop_amt | NUMERIC(18, 2) | YES |  |  |
| 212 | redemption_count | BIGINT | YES |  |  |
| 213 | date_of_reversal | DATE | YES |  |  |
| 214 | packaging_indicator | VARCHAR(1) | YES |  |  |
| 215 | no_financial_flag | VARCHAR(1) | YES |  |  |
| 216 | claim_type_alpha | VARCHAR(2) | YES |  |  |
| 217 | ltc_indicator | VARCHAR(1) | YES |  |  |
| 218 | dur_lvl_of_effort_1 | VARCHAR(2) | YES |  |  |
| 219 | dur_reason_service_1 | VARCHAR(2) | YES |  |  |
| 220 | dur_prof_service_code_1 | VARCHAR(2) | YES |  |  |
| 221 | dur_result_of_serv_cd_1 | VARCHAR(2) | YES |  |  |
| 222 | dur_lvl_of_effort_2 | VARCHAR(2) | YES |  |  |
| 223 | dur_reason_service_2 | VARCHAR(2) | YES |  |  |
| 224 | dur_prof_service_code_2 | VARCHAR(2) | YES |  |  |
| 225 | dur_result_of_serv_cd_2 | VARCHAR(2) | YES |  |  |
| 226 | dur_lvl_of_effort_3 | VARCHAR(2) | YES |  |  |
| 227 | dur_reason_service_3 | VARCHAR(2) | YES |  |  |
| 228 | dur_prof_service_code_3 | VARCHAR(2) | YES |  |  |
| 229 | dur_result_of_serv_cd_3 | VARCHAR(2) | YES |  |  |
| 230 | dur_lvl_of_effort_4 | VARCHAR(2) | YES |  |  |
| 231 | dur_reason_service_4 | VARCHAR(2) | YES |  |  |
| 232 | dur_prof_service_code_4 | VARCHAR(2) | YES |  |  |
| 233 | dur_result_of_serv_cd_4 | VARCHAR(2) | YES |  |  |
| 234 | dur_lvl_of_effort_5 | VARCHAR(2) | YES |  |  |
| 235 | dur_reason_service_5 | VARCHAR(2) | YES |  |  |
| 236 | dur_prof_service_code_5 | VARCHAR(2) | YES |  |  |
| 237 | dur_result_of_serv_cd_5 | VARCHAR(2) | YES |  |  |
| 238 | dur_lvl_of_effort_6 | VARCHAR(2) | YES |  |  |
| 239 | dur_reason_service_6 | VARCHAR(2) | YES |  |  |
| 240 | dur_prof_service_code_6 | VARCHAR(2) | YES |  |  |
| 241 | dur_result_of_serv_cd_6 | VARCHAR(2) | YES |  |  |
| 242 | dur_lvl_of_effort_7 | VARCHAR(2) | YES |  |  |
| 243 | dur_reason_service_7 | VARCHAR(2) | YES |  |  |
| 244 | dur_prof_service_code_7 | VARCHAR(2) | YES |  |  |
| 245 | dur_result_of_serv_cd_7 | VARCHAR(2) | YES |  |  |
| 246 | dur_lvl_of_effort_8 | VARCHAR(2) | YES |  |  |
| 247 | dur_reason_service_8 | VARCHAR(2) | YES |  |  |
| 248 | dur_prof_service_code_8 | VARCHAR(2) | YES |  |  |
| 249 | dur_result_of_serv_cd_8 | VARCHAR(2) | YES |  |  |
| 250 | dur_lvl_of_effort_9 | VARCHAR(2) | YES |  |  |
| 251 | dur_reason_service_9 | VARCHAR(2) | YES |  |  |
| 252 | dur_prof_service_code_9 | VARCHAR(2) | YES |  |  |
| 253 | dur_result_of_serv_cd_9 | VARCHAR(2) | YES |  |  |
| 254 | scd_claim | VARCHAR(1) | YES |  |  |
| 255 | thresh_5100 | NUMERIC(18, 2) | YES |  |  |
| 256 | c_formulary_id_flag | VARCHAR(1) | YES |  |  |
| 257 | brand_config_occur | BIGINT | YES |  |  |
| 258 | card_id_sent_from_pharm | VARCHAR(20) | YES |  |  |
| 259 | hms_physician_id | VARCHAR(10) | YES |  |  |
| 260 | tier | VARCHAR(1) | YES |  |  |
| 261 | claim_adjudication_time | VARCHAR(26) | YES |  |  |
| 262 | age | BIGINT | YES |  |  |
| 263 | quantity_dispensed | NUMERIC(18, 3) | YES |  |  |
| 264 | previous_restack_batch | VARCHAR(8) | YES |  |  |
| 265 | previous_restack_claim | BIGINT | YES |  |  |
| 266 | wac_ref_price | NUMERIC(18, 2) | YES |  |  |
| 267 | specialty_flag | VARCHAR(1) | YES |  |  |
| 268 | mail_order_indication | VARCHAR(4) | YES |  |  |
| 269 | spcl_patient_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 270 | price_indicator | VARCHAR(1) | YES |  |  |
| 271 | hms_poid | VARCHAR(10) | YES |  |  |
| 272 | orig_rev_batch | VARCHAR(8) | YES |  |  |
| 273 | orig_rev_claim | BIGINT | YES |  |  |
| 274 | grp_broker_nbr | VARCHAR(4) | YES |  |  |
| 275 | payment_center_id | VARCHAR(6) | YES |  |  |
| 276 | remit_reconciliation_id | VARCHAR(6) | YES |  |  |
| 277 | pdmi_reject_code_1 | VARCHAR(4) | YES |  |  |
| 278 | pdmi_reject_code_2 | VARCHAR(4) | YES |  |  |
| 279 | pdmi_reject_code_3 | VARCHAR(4) | YES |  |  |
| 280 | pdmi_reject_code_4 | VARCHAR(4) | YES |  |  |
| 281 | pdmi_reject_code_5 | VARCHAR(4) | YES |  |  |
| 282 | pdmi_reject_code_6 | VARCHAR(4) | YES |  |  |
| 283 | pdmi_reject_code_7 | VARCHAR(4) | YES |  |  |
| 284 | pdmi_reject_code_8 | VARCHAR(4) | YES |  |  |
| 285 | pdmi_reject_code_9 | VARCHAR(4) | YES |  |  |
| 286 | pdmi_reject_code_10 | VARCHAR(4) | YES |  |  |
| 287 | pdmi_reject_code_11 | VARCHAR(4) | YES |  |  |
| 288 | pdmi_reject_code_12 | VARCHAR(4) | YES |  |  |
| 289 | pdmi_reject_code_13 | VARCHAR(4) | YES |  |  |
| 290 | pdmi_reject_code_14 | VARCHAR(4) | YES |  |  |
| 291 | pdmi_reject_code_15 | VARCHAR(4) | YES |  |  |
| 292 | pdmi_reject_code_16 | VARCHAR(4) | YES |  |  |
| 293 | pdmi_reject_code_17 | VARCHAR(4) | YES |  |  |
| 294 | pdmi_reject_code_18 | VARCHAR(4) | YES |  |  |
| 295 | pdmi_reject_code_19 | VARCHAR(4) | YES |  |  |
| 296 | pdmi_reject_code_20 | VARCHAR(4) | YES |  |  |
| 297 | amount_applied_to_oop | NUMERIC(18, 2) | YES |  |  |
| 298 | n1_claim_key | VARCHAR(14) | YES |  |  |
| 299 | n1_batch_number | VARCHAR(8) | YES |  |  |
| 300 | n1_claim_number | BIGINT | YES |  |  |
| 301 | user_id | VARCHAR(15) | YES |  |  |
| 302 | opioid_factor | NUMERIC(18, 2) | YES |  |  |
| 303 | contract_chain_number | BIGINT | YES |  |  |
| 304 | ctree_toggle | VARCHAR(1) | YES |  |  |
| 305 | differential_claim_type | VARCHAR(6) | YES |  |  |
| 306 | carrier_id | VARCHAR(10) | YES |  |  |
| 307 | pharm_electronic_fee | NUMERIC(18, 2) | YES |  |  |
| 308 | vaccine_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 309 | prescriber_id_qualifier | VARCHAR(10) | YES |  |  |
| 310 | orig_med_gen_code | VARCHAR(1) | YES |  |  |
| 311 | oth_pay_covg_type | VARCHAR(2) | YES |  |  |
| 312 | script_care_claim | VARCHAR(1) | YES |  |  |
| 313 | script_care_net_pricing | VARCHAR(1) | YES |  |  |
| 314 | quantity_prescribed | NUMERIC(18, 3) | YES |  |  |
| 315 | pdmi_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 316 | client_sys_spo_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 317 | client_spo_grp_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 318 | claim_category | VARCHAR(12) | YES |  |  |
| 319 | add_id | VARCHAR(15) | YES |  |  |
| 320 | change_id | VARCHAR(15) | YES |  |  |
| 321 | client_basis_of_cost | VARCHAR(2) | YES |  |  |
| 322 | pharm_basis_of_cost | VARCHAR(2) | YES |  |  |
| 323 | group_from_pharm | VARCHAR(15) | YES |  |  |
| 324 | tax_exempt_flag | CHAR(1) | YES |  |  |
| 325 | network_reimb_id | VARCHAR(10) | YES |  |  |
