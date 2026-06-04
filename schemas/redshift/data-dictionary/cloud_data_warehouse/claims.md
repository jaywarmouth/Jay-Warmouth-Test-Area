# cloud_data_warehouse.claims

> **Schema:** cloud_data_warehouse | **Columns:** 357

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
| 8 | claim_key | VARCHAR(14) | NO |  | Required |
| 9 | batch_number | VARCHAR(8) | YES |  |  |
| 10 | claim_number | BIGINT | YES |  |  |
| 11 | claim_type | BIGINT | YES |  |  |
| 12 | payment_dir | BIGINT | YES |  |  |
| 13 | cardholder_number | VARCHAR(10) | YES |  |  |
| 14 | member_number | VARCHAR(2) | YES |  |  |
| 15 | pharmacy_number | BIGINT | YES |  |  |
| 16 | network_key | VARCHAR(16) | YES |  |  |
| 17 | chain_number | BIGINT | YES |  |  |
| 18 | reject_code_1 | BIGINT | YES |  |  |
| 19 | reject_code_2 | BIGINT | YES |  |  |
| 20 | process_date | DATE | YES |  |  |
| 21 | rx_number | BIGINT | YES |  |  |
| 22 | rx_date | DATE | YES |  |  |
| 23 | rx_time | TIMESTAMP | YES |  |  |
| 24 | new_refill | VARCHAR(1) | YES |  |  |
| 25 | generic_code | VARCHAR(1) | YES |  |  |
| 26 | drug_pref_ind | VARCHAR(2) | YES |  |  |
| 27 | metric_quantity | NUMERIC(18, 3) | YES |  |  |
| 28 | days_supply | BIGINT | YES |  |  |
| 29 | ing_billed | NUMERIC(18, 2) | YES |  |  |
| 30 | ing_paid | NUMERIC(18, 2) | YES |  |  |
| 31 | disp_fee | NUMERIC(18, 2) | YES |  |  |
| 32 | copay | NUMERIC(18, 2) | YES |  |  |
| 33 | tax | NUMERIC(18, 2) | YES |  |  |
| 34 | admin_fee | NUMERIC(18, 2) | YES |  |  |
| 35 | amount_paid | NUMERIC(18, 2) | YES |  |  |
| 36 | ucr_amount | NUMERIC(18, 2) | YES |  |  |
| 37 | awp_processed | NUMERIC(18, 5) | YES |  |  |
| 38 | generic_savings | NUMERIC(18, 2) | YES |  |  |
| 39 | member_birth | DATE | YES |  |  |
| 40 | sex | VARCHAR(1) | YES |  |  |
| 41 | cardholder_key | VARCHAR(20) | YES |  |  |
| 42 | physician_key | VARCHAR(14) | YES |  |  |
| 43 | diagnosis_code | VARCHAR(6) | YES |  |  |
| 44 | group_number | BIGINT | YES |  |  |
| 45 | drug_key | VARCHAR(15) | YES |  |  |
| 46 | gpi | VARCHAR(14) | YES |  |  |
| 47 | ndc_type_code | BIGINT | YES |  |  |
| 48 | ndc | NUMERIC(11, 0) | YES |  |  |
| 49 | main_drug | VARCHAR(1) | YES |  |  |
| 50 | benefit_key | VARCHAR(24) | YES |  |  |
| 51 | copay_key | VARCHAR(12) | YES |  |  |
| 52 | copay_table | BIGINT | YES |  |  |
| 53 | dispense_table | BIGINT | YES |  |  |
| 54 | plan_key | VARCHAR(16) | YES |  |  |
| 55 | plan_number | VARCHAR(8) | YES |  |  |
| 56 | mac_number | BIGINT | YES |  |  |
| 57 | daw_indicator | VARCHAR(1) | YES |  |  |
| 58 | compound_code | BIGINT | YES |  |  |
| 59 | third_party_code | VARCHAR(1) | YES |  |  |
| 60 | rx_otc | VARCHAR(1) | YES |  |  |
| 61 | adjustment_code_2 | BIGINT | YES |  |  |
| 62 | generic_table | BIGINT | YES |  |  |
| 63 | reimb_rate_table | BIGINT | YES |  |  |
| 64 | mail_order_flag | VARCHAR(1) | YES |  |  |
| 65 | line_number | BIGINT | YES |  |  |
| 66 | claims_counter | BIGINT | YES |  |  |
| 67 | current_claim_indicator | VARCHAR(1) | YES |  |  |
| 68 | period_ending | DATE | YES |  |  |
| 69 | paid_date | DATE | YES |  |  |
| 70 | price_indicator | VARCHAR(1) | YES |  |  |
| 71 | adjustment_code | BIGINT | YES |  |  |
| 72 | network_number | BIGINT | YES |  |  |
| 73 | step_therapy_number | BIGINT | YES |  |  |
| 74 | pcp_number | VARCHAR(14) | YES |  |  |
| 75 | date_key | VARCHAR(14) | YES |  |  |
| 76 | exception_01 | BIGINT | YES |  |  |
| 77 | override_1 | BIGINT | YES |  |  |
| 78 | rel_code | VARCHAR(2) | YES |  |  |
| 79 | skip_limit_flag | BIGINT | YES |  |  |
| 80 | exception_02 | BIGINT | YES |  |  |
| 81 | exception_03 | BIGINT | YES |  |  |
| 82 | exception_04 | BIGINT | YES |  |  |
| 83 | exception_05 | BIGINT | YES |  |  |
| 84 | exception_06 | BIGINT | YES |  |  |
| 85 | exception_07 | BIGINT | YES |  |  |
| 86 | exception_08 | BIGINT | YES |  |  |
| 87 | exception_09 | BIGINT | YES |  |  |
| 88 | exception_10 | BIGINT | YES |  |  |
| 89 | exception_11 | BIGINT | YES |  |  |
| 90 | exception_12 | BIGINT | YES |  |  |
| 91 | exception_13 | BIGINT | YES |  |  |
| 92 | exception_14 | BIGINT | YES |  |  |
| 93 | exception_15 | BIGINT | YES |  |  |
| 94 | exception_16 | BIGINT | YES |  |  |
| 95 | exception_17 | BIGINT | YES |  |  |
| 96 | exception_18 | BIGINT | YES |  |  |
| 97 | exception_19 | BIGINT | YES |  |  |
| 98 | exception_20 | BIGINT | YES |  |  |
| 99 | override_2 | BIGINT | YES |  |  |
| 100 | override_3 | BIGINT | YES |  |  |
| 101 | override_4 | BIGINT | YES |  |  |
| 102 | override_5 | BIGINT | YES |  |  |
| 103 | override_6 | BIGINT | YES |  |  |
| 104 | override_7 | BIGINT | YES |  |  |
| 105 | override_8 | BIGINT | YES |  |  |
| 106 | override_9 | BIGINT | YES |  |  |
| 107 | override_10 | BIGINT | YES |  |  |
| 108 | form_gt | BIGINT | YES |  |  |
| 109 | maint_gt | BIGINT | YES |  |  |
| 110 | physician_key_2 | VARCHAR(18) | YES |  |  |
| 111 | adj_code_1 | BIGINT | YES |  |  |
| 112 | adj_code_info | BIGINT | YES |  |  |
| 113 | coverage_type | VARCHAR(1) | YES |  |  |
| 114 | orig_rx_date | VARCHAR(8) | YES |  |  |
| 115 | refills_auth | BIGINT | YES |  |  |
| 116 | refill_count_num | BIGINT | YES |  |  |
| 117 | reversal_code | BIGINT | YES |  |  |
| 118 | sys_number | BIGINT | YES |  |  |
| 119 | sponsor_number | BIGINT | YES |  |  |
| 120 | upd_code | BIGINT | YES |  |  |
| 121 | pho_number | VARCHAR(14) | YES |  |  |
| 122 | claim_cnty | VARCHAR(2) | YES |  |  |
| 123 | member_first_name | VARCHAR(15) | YES |  |  |
| 124 | member_middle_initial | VARCHAR(1) | YES |  |  |
| 125 | member_last_name | VARCHAR(20) | YES |  |  |
| 126 | version_number | VARCHAR(1) | YES |  |  |
| 127 | awp_100_percent | NUMERIC(18, 2) | YES |  |  |
| 128 | diff_ing_paid | NUMERIC(18, 2) | YES |  |  |
| 129 | diff_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 130 | diff_table_number | BIGINT | YES |  |  |
| 131 | mac_reference_price | NUMERIC(18, 2) | YES |  |  |
| 132 | contract_rate_price | NUMERIC(18, 2) | YES |  |  |
| 133 | order_number | VARCHAR(20) | YES |  |  |
| 134 | dispensing_status | VARCHAR(1) | YES |  |  |
| 135 | assoc_rx_date | DATE | YES |  |  |
| 136 | assoc_rx_number | BIGINT | YES |  |  |
| 137 | intended_days_supply | BIGINT | YES |  |  |
| 138 | partial_ing_cost_paid | NUMERIC(18, 2) | YES |  |  |
| 139 | intended_met_qty | NUMERIC(18, 3) | YES |  |  |
| 140 | ta_amount | NUMERIC(18, 2) | YES |  |  |
| 141 | other_coverage_code | BIGINT | YES |  |  |
| 142 | other_payor_amount | NUMERIC(18, 2) | YES |  |  |
| 143 | date_of_injury | DATE | YES |  |  |
| 144 | indep_code | BIGINT | YES |  |  |
| 145 | penalty_amount | NUMERIC(18, 2) | YES |  |  |
| 146 | patient_last_name | VARCHAR(20) | YES |  |  |
| 147 | patient_middle_initial | VARCHAR(1) | YES |  |  |
| 148 | patient_first_name | VARCHAR(15) | YES |  |  |
| 149 | sub_clarification_code_1 | BIGINT | YES |  |  |
| 150 | sub_clarification_code_2 | BIGINT | YES |  |  |
| 151 | sub_clarification_code_3 | BIGINT | YES |  |  |
| 152 | pa_mc_code_and_number | NUMERIC(12, 0) | YES |  |  |
| 153 | level_of_service | BIGINT | YES |  |  |
| 154 | max_amt | NUMERIC(18, 2) | YES |  |  |
| 155 | deduct_amt | NUMERIC(18, 2) | YES |  |  |
| 156 | dmr_nabp | BIGINT | YES |  |  |
| 157 | other_payer_order | BIGINT | YES |  |  |
| 158 | nonlics_deduct_amt | NUMERIC(18, 2) | YES |  |  |
| 159 | standard_deduct_amt | NUMERIC(18, 2) | YES |  |  |
| 160 | special_deduct_amt | NUMERIC(18, 2) | YES |  |  |
| 161 | team_member | VARCHAR(4) | YES |  |  |
| 162 | npi_number | VARCHAR(10) | YES |  |  |
| 163 | card_seq_number | BIGINT | YES |  |  |
| 164 | add_to_troop | NUMERIC(18, 2) | YES |  |  |
| 165 | pcn | VARCHAR(10) | YES |  |  |
| 166 | bin_number | BIGINT | YES |  |  |
| 167 | eft_payment | VARCHAR(1) | YES |  |  |
| 168 | medd_gap_discount | NUMERIC(18, 2) | YES |  |  |
| 169 | medd_beg_phase | VARCHAR(1) | YES |  |  |
| 170 | medd_end_phase | VARCHAR(1) | YES |  |  |
| 171 | rxnumber_length | BIGINT | YES |  |  |
| 172 | patient_paid_amount | NUMERIC(18, 2) | YES |  |  |
| 173 | sub_clarification_count | BIGINT | YES |  |  |
| 174 | other_payer_bin | BIGINT | YES |  |  |
| 175 | trans_ref_number | VARCHAR(10) | YES |  |  |
| 176 | other_payer_pcn | VARCHAR(14) | YES |  |  |
| 177 | other_payer_group | VARCHAR(14) | YES |  |  |
| 178 | soj | VARCHAR(2) | YES |  |  |
| 179 | other_payer_cardholder | VARCHAR(20) | YES |  |  |
| 180 | compound_dosage_description_code | VARCHAR(2) | YES |  |  |
| 181 | compound_dispensing_id | VARCHAR(1) | YES |  |  |
| 182 | compound_count | BIGINT | YES |  |  |
| 183 | amt_applied_period_deduct | NUMERIC(18, 2) | YES |  |  |
| 184 | amt_exceed_period_benefit | NUMERIC(18, 2) | YES |  |  |
| 185 | amt_copay | NUMERIC(18, 2) | YES |  |  |
| 186 | amt_coinsurance | NUMERIC(18, 2) | YES |  |  |
| 187 | amt_attr_processor_fee | NUMERIC(18, 2) | YES |  |  |
| 188 | amt_attr_sales_tax | NUMERIC(18, 2) | YES |  |  |
| 189 | amt_attr_provider_net_select | NUMERIC(18, 2) | YES |  |  |
| 190 | amt_attr_prod_sel_brand | NUMERIC(18, 2) | YES |  |  |
| 191 | amt_attr_prod_sel_non_pf | NUMERIC(18, 2) | YES |  |  |
| 192 | amt_attr_prod_sel_brd_non_pf | NUMERIC(18, 2) | YES |  |  |
| 193 | health_plan_funded_assist_amt | NUMERIC(18, 2) | YES |  |  |
| 194 | gross_amount_due | NUMERIC(18, 2) | YES |  |  |
| 195 | incentive_amount_sub | NUMERIC(18, 2) | YES |  |  |
| 196 | dispensing_fee_sub | NUMERIC(18, 2) | YES |  |  |
| 197 | other_amount_claimed_sub | NUMERIC(18, 2) | YES |  |  |
| 198 | flat_sales_tax_amount_sub | NUMERIC(18, 2) | YES |  |  |
| 199 | pct_sales_tax_amount_sub | NUMERIC(18, 2) | YES |  |  |
| 200 | pct_sales_tax_rate_sub | NUMERIC(18, 4) | YES |  |  |
| 201 | medicaid_subrogation | VARCHAR(20) | YES |  |  |
| 202 | medicaid_paid_amt | NUMERIC(18, 2) | YES |  |  |
| 203 | pharmacy_service_type | BIGINT | YES |  |  |
| 204 | pharmacist_license | VARCHAR(50) | YES |  |  |
| 205 | sequence_number | VARCHAR(20) | YES |  |  |
| 206 | uid | VARCHAR(36) | YES |  |  |
| 207 | nabp_7 | VARCHAR(7) | YES |  |  |
| 208 | preferred_status | VARCHAR(1) | YES |  |  |
| 209 | rx_origin_code | BIGINT | YES |  |  |
| 210 | customer_location | BIGINT | YES |  |  |
| 211 | eligibility_clarification_code | BIGINT | YES |  |  |
| 212 | primary_prescriber | VARCHAR(10) | YES |  |  |
| 213 | basis_of_cost_determination | VARCHAR(2) | YES |  |  |
| 214 | document_number | BIGINT | YES |  |  |
| 215 | processor_control_flag | VARCHAR(1) | YES |  |  |
| 216 | dmr_reimbursement_payment_type | BIGINT | YES |  |  |
| 217 | pharmacy_option | VARCHAR(1) | YES |  |  |
| 218 | pharmacy_name | VARCHAR(30) | YES |  |  |
| 219 | product_description_abbreviation | VARCHAR(25) | YES |  |  |
| 220 | alt_cardholder_number | VARCHAR(13) | YES |  |  |
| 221 | alt_group_number | VARCHAR(12) | YES |  |  |
| 222 | thera_class | BIGINT | YES |  |  |
| 223 | rx_otc_class | VARCHAR(1) | YES |  |  |
| 224 | batch_date | DATE | YES |  |  |
| 225 | benefit_code | VARCHAR(16) | YES |  |  |
| 226 | claim_indicator | VARCHAR(1) | YES |  |  |
| 227 | rx_date_julian | BIGINT | YES |  |  |
| 228 | batch_date_julian | BIGINT | YES |  |  |
| 229 | county | VARCHAR(2) | YES |  |  |
| 230 | seq_number | VARCHAR(20) | YES |  |  |
| 231 | physician_number_x | VARCHAR(50) | YES |  |  |
| 232 | cms_part_d_facility | VARCHAR(1) | YES |  |  |
| 233 | approved_msg_code | VARCHAR(3) | YES |  |  |
| 234 | time_hhmm | VARCHAR(4) | YES |  |  |
| 235 | restack_batch | VARCHAR(8) | YES |  |  |
| 236 | restack_claim | BIGINT | YES |  |  |
| 237 | variable_mac_factor_rate | NUMERIC(18, 5) | YES |  |  |
| 238 | patient_residency | VARCHAR(2) | YES |  |  |
| 239 | special_packaging_ind | VARCHAR(1) | YES |  |  |
| 240 | prof_service_code_1 | VARCHAR(2) | YES |  |  |
| 241 | prof_service_code_2 | VARCHAR(2) | YES |  |  |
| 242 | prof_service_code_3 | VARCHAR(2) | YES |  |  |
| 243 | dur_pps_lvl_of_effort | VARCHAR(2) | YES |  |  |
| 244 | troop_amt | NUMERIC(18, 2) | YES |  |  |
| 245 | redemption_count | BIGINT | YES |  |  |
| 246 | date_of_reversal | DATE | YES |  |  |
| 247 | packaging_indicator | VARCHAR(1) | YES |  |  |
| 248 | no_financial_flag | VARCHAR(1) | YES |  |  |
| 249 | claim_type_alpha | VARCHAR(2) | YES |  |  |
| 250 | ltc_indicator | VARCHAR(1) | YES |  |  |
| 251 | dur_lvl_of_effort_1 | VARCHAR(2) | YES |  |  |
| 252 | dur_reason_service_1 | VARCHAR(2) | YES |  |  |
| 253 | dur_prof_service_code_1 | VARCHAR(2) | YES |  |  |
| 254 | dur_result_of_serv_cd_1 | VARCHAR(2) | YES |  |  |
| 255 | dur_lvl_of_effort_2 | VARCHAR(2) | YES |  |  |
| 256 | dur_reason_service_2 | VARCHAR(2) | YES |  |  |
| 257 | dur_prof_service_code_2 | VARCHAR(2) | YES |  |  |
| 258 | dur_result_of_serv_cd_2 | VARCHAR(2) | YES |  |  |
| 259 | dur_lvl_of_effort_3 | VARCHAR(2) | YES |  |  |
| 260 | dur_reason_service_3 | VARCHAR(2) | YES |  |  |
| 261 | dur_prof_service_code_3 | VARCHAR(2) | YES |  |  |
| 262 | dur_result_of_serv_cd_3 | VARCHAR(2) | YES |  |  |
| 263 | dur_lvl_of_effort_4 | VARCHAR(2) | YES |  |  |
| 264 | dur_reason_service_4 | VARCHAR(2) | YES |  |  |
| 265 | dur_prof_service_code_4 | VARCHAR(2) | YES |  |  |
| 266 | dur_result_of_serv_cd_4 | VARCHAR(2) | YES |  |  |
| 267 | dur_lvl_of_effort_5 | VARCHAR(2) | YES |  |  |
| 268 | dur_reason_service_5 | VARCHAR(2) | YES |  |  |
| 269 | dur_prof_service_code_5 | VARCHAR(2) | YES |  |  |
| 270 | dur_result_of_serv_cd_5 | VARCHAR(2) | YES |  |  |
| 271 | dur_lvl_of_effort_6 | VARCHAR(2) | YES |  |  |
| 272 | dur_reason_service_6 | VARCHAR(2) | YES |  |  |
| 273 | dur_prof_service_code_6 | VARCHAR(2) | YES |  |  |
| 274 | dur_result_of_serv_cd_6 | VARCHAR(2) | YES |  |  |
| 275 | dur_lvl_of_effort_7 | VARCHAR(2) | YES |  |  |
| 276 | dur_reason_service_7 | VARCHAR(2) | YES |  |  |
| 277 | dur_prof_service_code_7 | VARCHAR(2) | YES |  |  |
| 278 | dur_result_of_serv_cd_7 | VARCHAR(2) | YES |  |  |
| 279 | dur_lvl_of_effort_8 | VARCHAR(2) | YES |  |  |
| 280 | dur_reason_service_8 | VARCHAR(2) | YES |  |  |
| 281 | dur_prof_service_code_8 | VARCHAR(2) | YES |  |  |
| 282 | dur_result_of_serv_cd_8 | VARCHAR(2) | YES |  |  |
| 283 | dur_lvl_of_effort_9 | VARCHAR(2) | YES |  |  |
| 284 | dur_reason_service_9 | VARCHAR(2) | YES |  |  |
| 285 | dur_prof_service_code_9 | VARCHAR(2) | YES |  |  |
| 286 | dur_result_of_serv_cd_9 | VARCHAR(2) | YES |  |  |
| 287 | scd_claim | VARCHAR(1) | YES |  |  |
| 288 | thresh_5100 | NUMERIC(18, 2) | YES |  |  |
| 289 | c_formulary_id_flag | VARCHAR(1) | YES |  |  |
| 290 | brand_config_occur | BIGINT | YES |  |  |
| 291 | card_id_sent_from_pharm | VARCHAR(20) | YES |  |  |
| 292 | hms_physician_id | VARCHAR(10) | YES |  |  |
| 293 | tier | VARCHAR(1) | YES |  |  |
| 294 | claim_adjudication_time | VARCHAR(26) | YES |  |  |
| 295 | age | BIGINT | YES |  |  |
| 296 | quantity_dispensed | NUMERIC(18, 3) | YES |  |  |
| 297 | previous_restack_batch | VARCHAR(8) | YES |  |  |
| 298 | previous_restack_claim | BIGINT | YES |  |  |
| 299 | wac_ref_price | NUMERIC(18, 2) | YES |  |  |
| 300 | specialty_flag | VARCHAR(1) | YES |  |  |
| 301 | mail_order_indication | VARCHAR(4) | YES |  |  |
| 302 | spcl_patient_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 303 | hms_poid | VARCHAR(10) | YES |  |  |
| 304 | orig_rev_batch | VARCHAR(8) | YES |  |  |
| 305 | orig_rev_claim | BIGINT | YES |  |  |
| 306 | grp_broker_nbr | VARCHAR(4) | YES |  |  |
| 307 | payment_center_id | VARCHAR(6) | YES |  |  |
| 308 | remit_reconciliation_id | VARCHAR(6) | YES |  |  |
| 309 | pdmi_reject_code_1 | VARCHAR(4) | YES |  |  |
| 310 | pdmi_reject_code_2 | VARCHAR(4) | YES |  |  |
| 311 | pdmi_reject_code_3 | VARCHAR(4) | YES |  |  |
| 312 | pdmi_reject_code_4 | VARCHAR(4) | YES |  |  |
| 313 | pdmi_reject_code_5 | VARCHAR(4) | YES |  |  |
| 314 | pdmi_reject_code_6 | VARCHAR(4) | YES |  |  |
| 315 | pdmi_reject_code_7 | VARCHAR(4) | YES |  |  |
| 316 | pdmi_reject_code_8 | VARCHAR(4) | YES |  |  |
| 317 | pdmi_reject_code_9 | VARCHAR(4) | YES |  |  |
| 318 | pdmi_reject_code_10 | VARCHAR(4) | YES |  |  |
| 319 | pdmi_reject_code_11 | VARCHAR(4) | YES |  |  |
| 320 | pdmi_reject_code_12 | VARCHAR(4) | YES |  |  |
| 321 | pdmi_reject_code_13 | VARCHAR(4) | YES |  |  |
| 322 | pdmi_reject_code_14 | VARCHAR(4) | YES |  |  |
| 323 | pdmi_reject_code_15 | VARCHAR(4) | YES |  |  |
| 324 | pdmi_reject_code_16 | VARCHAR(4) | YES |  |  |
| 325 | pdmi_reject_code_17 | VARCHAR(4) | YES |  |  |
| 326 | pdmi_reject_code_18 | VARCHAR(4) | YES |  |  |
| 327 | pdmi_reject_code_19 | VARCHAR(4) | YES |  |  |
| 328 | pdmi_reject_code_20 | VARCHAR(4) | YES |  |  |
| 329 | amount_applied_to_oop | NUMERIC(18, 2) | YES |  |  |
| 330 | n1_claim_key | VARCHAR(14) | YES |  |  |
| 331 | n1_batch_number | VARCHAR(8) | YES |  |  |
| 332 | n1_claim_number | BIGINT | YES |  |  |
| 333 | user_id | VARCHAR(15) | YES |  |  |
| 334 | opioid_factor | NUMERIC(18, 2) | YES |  |  |
| 335 | contract_chain_number | BIGINT | YES |  |  |
| 336 | differential_claim_type | VARCHAR(6) | YES |  |  |
| 337 | carrier_id | VARCHAR(10) | YES |  |  |
| 338 | pharm_electronic_fee | NUMERIC(18, 2) | YES |  |  |
| 339 | vaccine_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 340 | prescriber_id_qualifier | VARCHAR(10) | YES |  |  |
| 341 | ctree_toggle | VARCHAR(1) | YES |  |  |
| 342 | orig_med_gen_code | VARCHAR(1) | YES |  |  |
| 343 | oth_pay_covg_type | VARCHAR(2) | YES |  |  |
| 344 | script_care_claim | VARCHAR(1) | YES |  |  |
| 345 | script_care_net_pricing | VARCHAR(1) | YES |  |  |
| 346 | quantity_prescribed | NUMERIC(18, 3) | YES |  |  |
| 347 | pdmi_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 348 | client_sys_spo_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 349 | client_spo_grp_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 350 | claim_category | VARCHAR(12) | YES |  |  |
| 351 | client_basis_of_cost | VARCHAR(2) | YES |  |  |
| 352 | pharm_basis_of_cost | VARCHAR(2) | YES |  |  |
| 353 | group_from_pharm | VARCHAR(15) | YES |  |  |
| 354 | tax_exempt_flag | CHAR(1) | YES |  |  |
| 355 | network_reimb_id | VARCHAR(10) | YES |  |  |
| 356 | copay_n1_amount | NUMERIC(18, 2) | YES |  |  |
| 357 | calcamtpaid | NUMERIC(23, 2) | YES |  |  |
