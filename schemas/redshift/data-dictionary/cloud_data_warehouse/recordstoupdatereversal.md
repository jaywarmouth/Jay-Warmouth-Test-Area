# cloud_data_warehouse.recordstoupdatereversal

> **Schema:** cloud_data_warehouse | **Columns:** 348

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | meta_surr_key | VARCHAR(80) | YES |  |  |
| 2 | meta_hash_key | VARCHAR(80) | YES |  |  |
| 3 | meta_eff_strt_dt | TIMESTAMP | YES |  |  |
| 4 | meta_eff_end_dt | TIMESTAMP | YES |  |  |
| 5 | meta_curr_ind | CHAR(1) | YES |  |  |
| 6 | claim_key | CHAR(14) | NO |  | Required |
| 7 | batch_number | CHAR(8) | YES |  |  |
| 8 | claim_number | INTEGER | YES |  |  |
| 9 | claim_type | INTEGER | YES |  |  |
| 10 | payment_dir | INTEGER | YES |  |  |
| 11 | cardholder_number | CHAR(10) | YES |  |  |
| 12 | member_number | CHAR(2) | YES |  |  |
| 13 | pharmacy_number | INTEGER | YES |  |  |
| 14 | network_key | CHAR(16) | YES |  |  |
| 15 | chain_number | INTEGER | YES |  |  |
| 16 | reject_code_1 | INTEGER | YES |  |  |
| 17 | reject_code_2 | INTEGER | YES |  |  |
| 18 | process_date | DATE | YES |  |  |
| 19 | rx_number | BIGINT | YES |  |  |
| 20 | rx_date | DATE | YES |  |  |
| 21 | rx_time | TIMESTAMP | YES |  |  |
| 22 | new_refill | CHAR(1) | YES |  |  |
| 23 | generic_code | CHAR(1) | YES |  |  |
| 24 | drug_pref_ind | CHAR(2) | YES |  |  |
| 25 | metric_quantity | NUMERIC(18, 3) | YES |  |  |
| 26 | days_supply | INTEGER | YES |  |  |
| 27 | ing_billed | NUMERIC(18, 2) | YES |  |  |
| 28 | ing_paid | NUMERIC(18, 2) | YES |  |  |
| 29 | disp_fee | NUMERIC(18, 2) | YES |  |  |
| 30 | copay | NUMERIC(18, 2) | YES |  |  |
| 31 | tax | NUMERIC(18, 2) | YES |  |  |
| 32 | admin_fee | NUMERIC(18, 2) | YES |  |  |
| 33 | amount_paid | NUMERIC(18, 2) | YES |  |  |
| 34 | ucr_amount | NUMERIC(18, 2) | YES |  |  |
| 35 | awp_processed | NUMERIC(18, 5) | YES |  |  |
| 36 | generic_savings | NUMERIC(18, 2) | YES |  |  |
| 37 | member_birth | DATE | YES |  |  |
| 38 | sex | CHAR(1) | YES |  |  |
| 39 | cardholder_key | CHAR(20) | YES |  |  |
| 40 | physician_key | CHAR(14) | YES |  |  |
| 41 | diagnosis_code | CHAR(6) | YES |  |  |
| 42 | group_number | BIGINT | YES |  |  |
| 43 | drug_key | CHAR(15) | YES |  |  |
| 44 | gpi | CHAR(14) | YES |  |  |
| 45 | ndc_type_code | INTEGER | YES |  |  |
| 46 | ndc | NUMERIC(11, 0) | YES |  |  |
| 47 | main_drug | CHAR(1) | YES |  |  |
| 48 | benefit_key | CHAR(24) | YES |  |  |
| 49 | copay_key | CHAR(12) | YES |  |  |
| 50 | copay_table | INTEGER | YES |  |  |
| 51 | dispense_table | INTEGER | YES |  |  |
| 52 | plan_key | CHAR(12) | YES |  |  |
| 53 | plan_number | CHAR(4) | YES |  |  |
| 54 | mac_number | INTEGER | YES |  |  |
| 55 | daw_indicator | CHAR(1) | YES |  |  |
| 56 | compound_code | INTEGER | YES |  |  |
| 57 | third_party_code | CHAR(1) | YES |  |  |
| 58 | rx_otc | CHAR(1) | YES |  |  |
| 59 | adjustment_code_2 | INTEGER | YES |  |  |
| 60 | generic_table | INTEGER | YES |  |  |
| 61 | reimb_rate_table | INTEGER | YES |  |  |
| 62 | mail_order_flag | CHAR(1) | YES |  |  |
| 63 | line_number | INTEGER | YES |  |  |
| 64 | claims_counter | INTEGER | YES |  |  |
| 65 | current_claim_indicator | CHAR(1) | YES |  |  |
| 66 | period_ending | DATE | YES |  |  |
| 67 | paid_date | DATE | YES |  |  |
| 68 | price_indicator | CHAR(1) | YES |  |  |
| 69 | adjustment_code | INTEGER | YES |  |  |
| 70 | network_number | INTEGER | YES |  |  |
| 71 | step_therapy_number | INTEGER | YES |  |  |
| 72 | pcp_number | CHAR(14) | YES |  |  |
| 73 | date_key | CHAR(14) | YES |  |  |
| 74 | exception_01 | INTEGER | YES |  |  |
| 75 | override_1 | INTEGER | YES |  |  |
| 76 | rel_code | CHAR(2) | YES |  |  |
| 77 | skip_limit_flag | INTEGER | YES |  |  |
| 78 | exception_02 | INTEGER | YES |  |  |
| 79 | exception_03 | INTEGER | YES |  |  |
| 80 | exception_04 | INTEGER | YES |  |  |
| 81 | exception_05 | INTEGER | YES |  |  |
| 82 | exception_06 | INTEGER | YES |  |  |
| 83 | exception_07 | INTEGER | YES |  |  |
| 84 | exception_08 | INTEGER | YES |  |  |
| 85 | exception_09 | INTEGER | YES |  |  |
| 86 | exception_10 | INTEGER | YES |  |  |
| 87 | exception_11 | INTEGER | YES |  |  |
| 88 | exception_12 | INTEGER | YES |  |  |
| 89 | exception_13 | INTEGER | YES |  |  |
| 90 | exception_14 | INTEGER | YES |  |  |
| 91 | exception_15 | INTEGER | YES |  |  |
| 92 | exception_16 | INTEGER | YES |  |  |
| 93 | exception_17 | INTEGER | YES |  |  |
| 94 | exception_18 | INTEGER | YES |  |  |
| 95 | exception_19 | INTEGER | YES |  |  |
| 96 | exception_20 | INTEGER | YES |  |  |
| 97 | override_2 | INTEGER | YES |  |  |
| 98 | override_3 | INTEGER | YES |  |  |
| 99 | override_4 | INTEGER | YES |  |  |
| 100 | override_5 | INTEGER | YES |  |  |
| 101 | override_6 | INTEGER | YES |  |  |
| 102 | override_7 | INTEGER | YES |  |  |
| 103 | override_8 | INTEGER | YES |  |  |
| 104 | override_9 | INTEGER | YES |  |  |
| 105 | override_10 | INTEGER | YES |  |  |
| 106 | form_gt | INTEGER | YES |  |  |
| 107 | maint_gt | INTEGER | YES |  |  |
| 108 | physician_key_2 | CHAR(18) | YES |  |  |
| 109 | adj_code_1 | INTEGER | YES |  |  |
| 110 | adj_code_info | INTEGER | YES |  |  |
| 111 | coverage_type | CHAR(1) | YES |  |  |
| 112 | orig_rx_date | CHAR(8) | YES |  |  |
| 113 | refills_auth | INTEGER | YES |  |  |
| 114 | refill_count_num | INTEGER | YES |  |  |
| 115 | reversal_code | INTEGER | YES |  |  |
| 116 | sys_number | INTEGER | YES |  |  |
| 117 | sponsor_number | INTEGER | YES |  |  |
| 118 | upd_code | INTEGER | YES |  |  |
| 119 | pho_number | CHAR(14) | YES |  |  |
| 120 | claim_cnty | CHAR(2) | YES |  |  |
| 121 | member_first_name | CHAR(15) | YES |  |  |
| 122 | member_middle_initial | CHAR(1) | YES |  |  |
| 123 | member_last_name | CHAR(20) | YES |  |  |
| 124 | version_number | CHAR(1) | YES |  |  |
| 125 | awp_100_percent | NUMERIC(18, 2) | YES |  |  |
| 126 | diff_ing_paid | NUMERIC(18, 2) | YES |  |  |
| 127 | diff_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 128 | diff_table_number | INTEGER | YES |  |  |
| 129 | mac_reference_price | NUMERIC(18, 2) | YES |  |  |
| 130 | contract_rate_price | NUMERIC(18, 2) | YES |  |  |
| 131 | order_number | CHAR(20) | YES |  |  |
| 132 | dispensing_status | CHAR(1) | YES |  |  |
| 133 | assoc_rx_date | DATE | YES |  |  |
| 134 | assoc_rx_number | BIGINT | YES |  |  |
| 135 | intended_days_supply | INTEGER | YES |  |  |
| 136 | partial_ing_cost_paid | NUMERIC(18, 2) | YES |  |  |
| 137 | intended_met_qty | NUMERIC(18, 3) | YES |  |  |
| 138 | ta_amount | NUMERIC(18, 2) | YES |  |  |
| 139 | other_coverage_code | INTEGER | YES |  |  |
| 140 | other_payor_amount | NUMERIC(18, 2) | YES |  |  |
| 141 | date_of_injury | DATE | YES |  |  |
| 142 | indep_code | INTEGER | YES |  |  |
| 143 | penalty_amount | NUMERIC(18, 2) | YES |  |  |
| 144 | patient_last_name | CHAR(20) | YES |  |  |
| 145 | patient_middle_initial | CHAR(1) | YES |  |  |
| 146 | patient_first_name | CHAR(15) | YES |  |  |
| 147 | sub_clarification_code_1 | INTEGER | YES |  |  |
| 148 | sub_clarification_code_2 | INTEGER | YES |  |  |
| 149 | sub_clarification_code_3 | INTEGER | YES |  |  |
| 150 | pa_mc_code_and_number | NUMERIC(12, 0) | YES |  |  |
| 151 | level_of_service | INTEGER | YES |  |  |
| 152 | max_amt | NUMERIC(18, 2) | YES |  |  |
| 153 | deduct_amt | NUMERIC(18, 2) | YES |  |  |
| 154 | dmr_nabp | INTEGER | YES |  |  |
| 155 | other_payer_order | INTEGER | YES |  |  |
| 156 | nonlics_deduct_amt | NUMERIC(18, 2) | YES |  |  |
| 157 | standard_deduct_amt | NUMERIC(18, 2) | YES |  |  |
| 158 | special_deduct_amt | NUMERIC(18, 2) | YES |  |  |
| 159 | team_member | CHAR(4) | YES |  |  |
| 160 | npi_number | CHAR(10) | YES |  |  |
| 161 | card_seq_number | INTEGER | YES |  |  |
| 162 | add_to_troop | NUMERIC(10, 2) | YES |  |  |
| 163 | pcn | CHAR(10) | YES |  |  |
| 164 | bin_number | INTEGER | YES |  |  |
| 165 | eft_payment | CHAR(1) | YES |  |  |
| 166 | medd_gap_discount | NUMERIC(18, 2) | YES |  |  |
| 167 | medd_beg_phase | CHAR(1) | YES |  |  |
| 168 | medd_end_phase | CHAR(1) | YES |  |  |
| 169 | rxnumber_length | INTEGER | YES |  |  |
| 170 | patient_paid_amount | NUMERIC(18, 2) | YES |  |  |
| 171 | sub_clarification_count | INTEGER | YES |  |  |
| 172 | other_payer_bin | INTEGER | YES |  |  |
| 173 | trans_ref_number | CHAR(10) | YES |  |  |
| 174 | other_payer_pcn | CHAR(14) | YES |  |  |
| 175 | other_payer_group | CHAR(14) | YES |  |  |
| 176 | soj | CHAR(2) | YES |  |  |
| 177 | other_payer_cardholder | CHAR(20) | YES |  |  |
| 178 | compound_dosage_description_code | CHAR(2) | YES |  |  |
| 179 | compound_dispensing_id | CHAR(1) | YES |  |  |
| 180 | compound_count | INTEGER | YES |  |  |
| 181 | amt_applied_period_deduct | NUMERIC(18, 2) | YES |  |  |
| 182 | amt_exceed_period_benefit | NUMERIC(18, 2) | YES |  |  |
| 183 | amt_copay | NUMERIC(18, 2) | YES |  |  |
| 184 | amt_coinsurance | NUMERIC(18, 2) | YES |  |  |
| 185 | amt_attr_processor_fee | NUMERIC(18, 2) | YES |  |  |
| 186 | amt_attr_sales_tax | NUMERIC(18, 2) | YES |  |  |
| 187 | amt_attr_provider_net_select | NUMERIC(18, 2) | YES |  |  |
| 188 | amt_attr_prod_sel_brand | NUMERIC(18, 2) | YES |  |  |
| 189 | amt_attr_prod_sel_non_pf | NUMERIC(18, 2) | YES |  |  |
| 190 | amt_attr_prod_sel_brd_non_pf | NUMERIC(18, 2) | YES |  |  |
| 191 | health_plan_funded_assist_amt | NUMERIC(18, 2) | YES |  |  |
| 192 | gross_amount_due | NUMERIC(18, 2) | YES |  |  |
| 193 | incentive_amount_sub | NUMERIC(18, 2) | YES |  |  |
| 194 | dispensing_fee_sub | NUMERIC(18, 2) | YES |  |  |
| 195 | other_amount_claimed_sub | NUMERIC(18, 2) | YES |  |  |
| 196 | flat_sales_tax_amount_sub | NUMERIC(18, 2) | YES |  |  |
| 197 | pct_sales_tax_amount_sub | NUMERIC(18, 2) | YES |  |  |
| 198 | pct_sales_tax_rate_sub | NUMERIC(18, 4) | YES |  |  |
| 199 | medicaid_subrogation | CHAR(20) | YES |  |  |
| 200 | medicaid_paid_amt | NUMERIC(18, 2) | YES |  |  |
| 201 | pharmacy_service_type | INTEGER | YES |  |  |
| 202 | pharmacist_license | VARCHAR(50) | YES |  |  |
| 203 | sequence_number | VARCHAR(256) | YES |  |  |
| 204 | uid | VARCHAR(36) | YES |  |  |
| 205 | nabp_7 | VARCHAR(7) | YES |  |  |
| 206 | preferred_status | CHAR(1) | YES |  |  |
| 207 | rx_origin_code | INTEGER | YES |  |  |
| 208 | customer_location | INTEGER | YES |  |  |
| 209 | eligibility_clarification_code | INTEGER | YES |  |  |
| 210 | primary_prescriber | CHAR(10) | YES |  |  |
| 211 | basis_of_cost_determination | CHAR(2) | YES |  |  |
| 212 | document_number | INTEGER | YES |  |  |
| 213 | processor_control_flag | CHAR(1) | YES |  |  |
| 214 | dmr_reimbursement_payment_type | INTEGER | YES |  |  |
| 215 | pharmacy_option | CHAR(1) | YES |  |  |
| 216 | pharmacy_name | CHAR(30) | YES |  |  |
| 217 | product_description_abbreviation | CHAR(25) | YES |  |  |
| 218 | alt_cardholder_number | CHAR(13) | YES |  |  |
| 219 | alt_group_number | CHAR(12) | YES |  |  |
| 220 | thera_class | INTEGER | YES |  |  |
| 221 | rx_otc_class | CHAR(1) | YES |  |  |
| 222 | batch_date | DATE | YES |  |  |
| 223 | benefit_code | CHAR(16) | YES |  |  |
| 224 | claim_indicator | CHAR(1) | YES |  |  |
| 225 | rx_date_julian | INTEGER | YES |  |  |
| 226 | batch_date_julian | INTEGER | YES |  |  |
| 227 | county | CHAR(2) | YES |  |  |
| 228 | seq_number | VARCHAR(20) | YES |  |  |
| 229 | physician_number_x | VARCHAR(50) | YES |  |  |
| 230 | cms_part_d_facility | VARCHAR(1) | YES |  |  |
| 231 | approved_msg_code | VARCHAR(3) | YES |  |  |
| 232 | time_hhmm | VARCHAR(4) | YES |  |  |
| 233 | restack_batch | VARCHAR(8) | YES |  |  |
| 234 | restack_claim | INTEGER | YES |  |  |
| 235 | variable_mac_factor_rate | NUMERIC(18, 5) | YES |  |  |
| 236 | patient_residency | VARCHAR(2) | YES |  |  |
| 237 | special_packaging_ind | VARCHAR(1) | YES |  |  |
| 238 | prof_service_code_1 | VARCHAR(2) | YES |  |  |
| 239 | prof_service_code_2 | VARCHAR(2) | YES |  |  |
| 240 | prof_service_code_3 | VARCHAR(2) | YES |  |  |
| 241 | dur_pps_lvl_of_effort | VARCHAR(2) | YES |  |  |
| 242 | troop_amt | NUMERIC(18, 2) | YES |  |  |
| 243 | redemption_count | INTEGER | YES |  |  |
| 244 | date_of_reversal | DATE | YES |  |  |
| 245 | packaging_indicator | VARCHAR(1) | YES |  |  |
| 246 | no_financial_flag | VARCHAR(1) | YES |  |  |
| 247 | claim_type_alpha | VARCHAR(2) | YES |  |  |
| 248 | ltc_indicator | VARCHAR(1) | YES |  |  |
| 249 | dur_lvl_of_effort_1 | VARCHAR(2) | YES |  |  |
| 250 | dur_reason_service_1 | VARCHAR(2) | YES |  |  |
| 251 | dur_prof_service_code_1 | VARCHAR(2) | YES |  |  |
| 252 | dur_result_of_serv_cd_1 | VARCHAR(2) | YES |  |  |
| 253 | dur_lvl_of_effort_2 | VARCHAR(2) | YES |  |  |
| 254 | dur_reason_service_2 | VARCHAR(2) | YES |  |  |
| 255 | dur_prof_service_code_2 | VARCHAR(2) | YES |  |  |
| 256 | dur_result_of_serv_cd_2 | VARCHAR(2) | YES |  |  |
| 257 | dur_lvl_of_effort_3 | VARCHAR(2) | YES |  |  |
| 258 | dur_reason_service_3 | VARCHAR(2) | YES |  |  |
| 259 | dur_prof_service_code_3 | VARCHAR(2) | YES |  |  |
| 260 | dur_result_of_serv_cd_3 | VARCHAR(2) | YES |  |  |
| 261 | dur_lvl_of_effort_4 | VARCHAR(2) | YES |  |  |
| 262 | dur_reason_service_4 | VARCHAR(2) | YES |  |  |
| 263 | dur_prof_service_code_4 | VARCHAR(2) | YES |  |  |
| 264 | dur_result_of_serv_cd_4 | VARCHAR(2) | YES |  |  |
| 265 | dur_lvl_of_effort_5 | VARCHAR(2) | YES |  |  |
| 266 | dur_reason_service_5 | VARCHAR(2) | YES |  |  |
| 267 | dur_prof_service_code_5 | VARCHAR(2) | YES |  |  |
| 268 | dur_result_of_serv_cd_5 | VARCHAR(2) | YES |  |  |
| 269 | dur_lvl_of_effort_6 | VARCHAR(2) | YES |  |  |
| 270 | dur_reason_service_6 | VARCHAR(2) | YES |  |  |
| 271 | dur_prof_service_code_6 | VARCHAR(2) | YES |  |  |
| 272 | dur_result_of_serv_cd_6 | VARCHAR(2) | YES |  |  |
| 273 | dur_lvl_of_effort_7 | VARCHAR(2) | YES |  |  |
| 274 | dur_reason_service_7 | VARCHAR(2) | YES |  |  |
| 275 | dur_prof_service_code_7 | VARCHAR(2) | YES |  |  |
| 276 | dur_result_of_serv_cd_7 | VARCHAR(2) | YES |  |  |
| 277 | dur_lvl_of_effort_8 | VARCHAR(2) | YES |  |  |
| 278 | dur_reason_service_8 | VARCHAR(2) | YES |  |  |
| 279 | dur_prof_service_code_8 | VARCHAR(2) | YES |  |  |
| 280 | dur_result_of_serv_cd_8 | VARCHAR(2) | YES |  |  |
| 281 | dur_lvl_of_effort_9 | VARCHAR(2) | YES |  |  |
| 282 | dur_reason_service_9 | VARCHAR(2) | YES |  |  |
| 283 | dur_prof_service_code_9 | VARCHAR(2) | YES |  |  |
| 284 | dur_result_of_serv_cd_9 | VARCHAR(2) | YES |  |  |
| 285 | scd_claim | VARCHAR(1) | YES |  |  |
| 286 | thresh_5100 | NUMERIC(18, 2) | YES |  |  |
| 287 | c_formulary_id_flag | VARCHAR(1) | YES |  |  |
| 288 | brand_config_occur | INTEGER | YES |  |  |
| 289 | card_id_sent_from_pharm | VARCHAR(20) | YES |  |  |
| 290 | hms_physician_id | VARCHAR(10) | YES |  |  |
| 291 | tier | VARCHAR(1) | YES |  |  |
| 292 | claim_adjudication_time | VARCHAR(26) | YES |  |  |
| 293 | age | INTEGER | YES |  |  |
| 294 | quantity_dispensed | NUMERIC(18, 3) | YES |  |  |
| 295 | previous_restack_batch | VARCHAR(8) | YES |  |  |
| 296 | previous_restack_claim | INTEGER | YES |  |  |
| 297 | wac_ref_price | NUMERIC(18, 2) | YES |  |  |
| 298 | specialty_flag | VARCHAR(1) | YES |  |  |
| 299 | mail_order_indication | VARCHAR(4) | YES |  |  |
| 300 | spcl_patient_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 301 | hms_poid | VARCHAR(10) | YES |  |  |
| 302 | orig_rev_batch | VARCHAR(8) | YES |  |  |
| 303 | orig_rev_claim | INTEGER | YES |  |  |
| 304 | grp_broker_nbr | VARCHAR(4) | YES |  |  |
| 305 | payment_center_id | VARCHAR(6) | YES |  |  |
| 306 | remit_reconciliation_id | VARCHAR(6) | YES |  |  |
| 307 | pdmi_reject_code_1 | VARCHAR(4) | YES |  |  |
| 308 | pdmi_reject_code_2 | VARCHAR(4) | YES |  |  |
| 309 | pdmi_reject_code_3 | VARCHAR(4) | YES |  |  |
| 310 | pdmi_reject_code_4 | VARCHAR(4) | YES |  |  |
| 311 | pdmi_reject_code_5 | VARCHAR(4) | YES |  |  |
| 312 | pdmi_reject_code_6 | VARCHAR(4) | YES |  |  |
| 313 | pdmi_reject_code_7 | VARCHAR(4) | YES |  |  |
| 314 | pdmi_reject_code_8 | VARCHAR(4) | YES |  |  |
| 315 | pdmi_reject_code_9 | VARCHAR(4) | YES |  |  |
| 316 | pdmi_reject_code_10 | VARCHAR(4) | YES |  |  |
| 317 | pdmi_reject_code_11 | VARCHAR(4) | YES |  |  |
| 318 | pdmi_reject_code_12 | VARCHAR(4) | YES |  |  |
| 319 | pdmi_reject_code_13 | VARCHAR(4) | YES |  |  |
| 320 | pdmi_reject_code_14 | VARCHAR(4) | YES |  |  |
| 321 | pdmi_reject_code_15 | VARCHAR(4) | YES |  |  |
| 322 | pdmi_reject_code_16 | VARCHAR(4) | YES |  |  |
| 323 | pdmi_reject_code_17 | VARCHAR(4) | YES |  |  |
| 324 | pdmi_reject_code_18 | VARCHAR(4) | YES |  |  |
| 325 | pdmi_reject_code_19 | VARCHAR(4) | YES |  |  |
| 326 | pdmi_reject_code_20 | VARCHAR(4) | YES |  |  |
| 327 | amount_applied_to_oop | NUMERIC(18, 2) | YES |  |  |
| 328 | n1_claim_key | VARCHAR(14) | YES |  |  |
| 329 | n1_batch_number | VARCHAR(8) | YES |  |  |
| 330 | n1_claim_number | INTEGER | YES |  |  |
| 331 | user_id | VARCHAR(15) | YES |  |  |
| 332 | opioid_factor | NUMERIC(18, 2) | YES |  |  |
| 333 | contract_chain_number | INTEGER | YES |  |  |
| 334 | differential_claim_type | VARCHAR(6) | YES |  |  |
| 335 | carrier_id | VARCHAR(10) | YES |  |  |
| 336 | pharm_electronic_fee | NUMERIC(18, 2) | YES |  |  |
| 337 | vaccine_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 338 | prescriber_id_qualifier | VARCHAR(10) | YES |  |  |
| 339 | ctree_toggle | VARCHAR(1) | YES |  |  |
| 340 | orig_med_gen_code | VARCHAR(1) | YES |  |  |
| 341 | oth_pay_covg_type | VARCHAR(2) | YES |  |  |
| 342 | script_care_claim | VARCHAR(1) | YES |  |  |
| 343 | script_care_net_pricing | VARCHAR(1) | YES |  |  |
| 344 | quantity_prescribed | NUMERIC(18, 3) | YES |  |  |
| 345 | pdmi_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 346 | client_sys_spo_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 347 | client_spo_grp_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 348 | claim_category | VARCHAR(12) | YES |  |  |
