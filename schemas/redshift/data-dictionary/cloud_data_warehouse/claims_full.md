# cloud_data_warehouse.claims_full

> **Schema:** cloud_data_warehouse | **Columns:** 357

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | claim_key | VARCHAR(14) | YES |  |  |
| 2 | batch_number | VARCHAR(8) | YES |  |  |
| 3 | claim_number | INTEGER | YES |  |  |
| 4 | claim_type | INTEGER | YES |  |  |
| 5 | payment_dir | INTEGER | YES |  |  |
| 6 | cardholder_number | VARCHAR(10) | YES |  |  |
| 7 | member_number | VARCHAR(2) | YES |  |  |
| 8 | pharmacy_number | INTEGER | YES |  |  |
| 9 | network_key | VARCHAR(16) | YES |  |  |
| 10 | chain_number | INTEGER | YES |  |  |
| 11 | reject_code_1 | INTEGER | YES |  |  |
| 12 | reject_code_2 | INTEGER | YES |  |  |
| 13 | process_date | TIMESTAMP | YES |  |  |
| 14 | rx_number | BIGINT | YES |  |  |
| 15 | rx_date | TIMESTAMP | YES |  |  |
| 16 | rx_time | TIMESTAMP | YES |  |  |
| 17 | new_refill | VARCHAR(1) | YES |  |  |
| 18 | generic_code | VARCHAR(1) | YES |  |  |
| 19 | drug_pref_ind | VARCHAR(2) | YES |  |  |
| 20 | metric_quantity | NUMERIC(18, 3) | YES |  |  |
| 21 | days_supply | INTEGER | YES |  |  |
| 22 | ing_billed | NUMERIC(18, 2) | YES |  |  |
| 23 | ing_paid | NUMERIC(18, 2) | YES |  |  |
| 24 | disp_fee | NUMERIC(18, 2) | YES |  |  |
| 25 | copay | NUMERIC(18, 2) | YES |  |  |
| 26 | tax | NUMERIC(18, 2) | YES |  |  |
| 27 | admin_fee | NUMERIC(18, 2) | YES |  |  |
| 28 | amount_paid | NUMERIC(18, 2) | YES |  |  |
| 29 | ucr_amount | NUMERIC(18, 2) | YES |  |  |
| 30 | awp_processed | NUMERIC(18, 5) | YES |  |  |
| 31 | generic_savings | NUMERIC(18, 2) | YES |  |  |
| 32 | member_birth | TIMESTAMP | YES |  |  |
| 33 | sex | VARCHAR(1) | YES |  |  |
| 34 | cardholder_key | VARCHAR(20) | YES |  |  |
| 35 | physician_key | VARCHAR(14) | YES |  |  |
| 36 | diagnosis_code | VARCHAR(6) | YES |  |  |
| 37 | group_number | FLOAT8 | YES |  |  |
| 38 | drug_key | VARCHAR(15) | YES |  |  |
| 39 | gpi | VARCHAR(14) | YES |  |  |
| 40 | ndc_type_code | INTEGER | YES |  |  |
| 41 | ndc | NUMERIC(11, 0) | YES |  |  |
| 42 | main_drug | VARCHAR(1) | YES |  |  |
| 43 | benefit_key | VARCHAR(24) | YES |  |  |
| 44 | copay_key | VARCHAR(12) | YES |  |  |
| 45 | copay_table | INTEGER | YES |  |  |
| 46 | dispense_table | INTEGER | YES |  |  |
| 47 | mac_number | INTEGER | YES |  |  |
| 48 | daw_indicator | VARCHAR(1) | YES |  |  |
| 49 | compound_code | INTEGER | YES |  |  |
| 50 | third_party_code | VARCHAR(1) | YES |  |  |
| 51 | rx_otc | VARCHAR(1) | YES |  |  |
| 52 | adjustment_code_2 | INTEGER | YES |  |  |
| 53 | generic_table | INTEGER | YES |  |  |
| 54 | reimb_rate_table | INTEGER | YES |  |  |
| 55 | mail_order_flag | VARCHAR(1) | YES |  |  |
| 56 | line_number | INTEGER | YES |  |  |
| 57 | claims_counter | INTEGER | YES |  |  |
| 58 | current_claim_indicator | VARCHAR(1) | YES |  |  |
| 59 | period_ending | TIMESTAMP | YES |  |  |
| 60 | paid_date | TIMESTAMP | YES |  |  |
| 61 | price_indicator | VARCHAR(1) | YES |  |  |
| 62 | adjustment_code | INTEGER | YES |  |  |
| 63 | network_number | INTEGER | YES |  |  |
| 64 | step_therapy_number | INTEGER | YES |  |  |
| 65 | pcp_number | VARCHAR(14) | YES |  |  |
| 66 | date_key | VARCHAR(14) | YES |  |  |
| 67 | exception_01 | INTEGER | YES |  |  |
| 68 | override_1 | INTEGER | YES |  |  |
| 69 | rel_code | VARCHAR(2) | YES |  |  |
| 70 | skip_limit_flag | INTEGER | YES |  |  |
| 71 | exception_02 | INTEGER | YES |  |  |
| 72 | exception_03 | INTEGER | YES |  |  |
| 73 | exception_04 | INTEGER | YES |  |  |
| 74 | exception_05 | INTEGER | YES |  |  |
| 75 | exception_06 | INTEGER | YES |  |  |
| 76 | exception_07 | INTEGER | YES |  |  |
| 77 | exception_08 | INTEGER | YES |  |  |
| 78 | exception_09 | INTEGER | YES |  |  |
| 79 | exception_10 | INTEGER | YES |  |  |
| 80 | exception_11 | INTEGER | YES |  |  |
| 81 | exception_12 | INTEGER | YES |  |  |
| 82 | exception_13 | INTEGER | YES |  |  |
| 83 | exception_14 | INTEGER | YES |  |  |
| 84 | exception_15 | INTEGER | YES |  |  |
| 85 | exception_16 | INTEGER | YES |  |  |
| 86 | exception_17 | INTEGER | YES |  |  |
| 87 | exception_18 | INTEGER | YES |  |  |
| 88 | exception_19 | INTEGER | YES |  |  |
| 89 | exception_20 | INTEGER | YES |  |  |
| 90 | override_2 | INTEGER | YES |  |  |
| 91 | override_3 | INTEGER | YES |  |  |
| 92 | override_4 | INTEGER | YES |  |  |
| 93 | override_5 | INTEGER | YES |  |  |
| 94 | override_6 | INTEGER | YES |  |  |
| 95 | override_7 | INTEGER | YES |  |  |
| 96 | override_8 | INTEGER | YES |  |  |
| 97 | override_9 | INTEGER | YES |  |  |
| 98 | override_10 | INTEGER | YES |  |  |
| 99 | form_gt | INTEGER | YES |  |  |
| 100 | maint_gt | INTEGER | YES |  |  |
| 101 | physician_key2 | VARCHAR(18) | YES |  |  |
| 102 | adj_code_1 | INTEGER | YES |  |  |
| 103 | adj_code_info | INTEGER | YES |  |  |
| 104 | coverage_type | VARCHAR(1) | YES |  |  |
| 105 | orig_rx_date | VARCHAR(8) | YES |  |  |
| 106 | refills_auth | INTEGER | YES |  |  |
| 107 | refill_count_num | INTEGER | YES |  |  |
| 108 | reversal_code | INTEGER | YES |  |  |
| 109 | sys_number | INTEGER | YES |  |  |
| 110 | sponsor_number | INTEGER | YES |  |  |
| 111 | upd_code | INTEGER | YES |  |  |
| 112 | pho_number | VARCHAR(14) | YES |  |  |
| 113 | claim_cnty | VARCHAR(2) | YES |  |  |
| 114 | member_first_name | VARCHAR(15) | YES |  |  |
| 115 | member_middle_initial | VARCHAR(1) | YES |  |  |
| 116 | member_last_name | VARCHAR(20) | YES |  |  |
| 117 | version_number | VARCHAR(1) | YES |  |  |
| 118 | awp_100_percent | NUMERIC(18, 2) | YES |  |  |
| 119 | diff_ing_paid | NUMERIC(18, 2) | YES |  |  |
| 120 | diff_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 121 | diff_table_number | INTEGER | YES |  |  |
| 122 | mac_reference_price | NUMERIC(18, 2) | YES |  |  |
| 123 | contract_rate_price | NUMERIC(18, 2) | YES |  |  |
| 124 | order_number | VARCHAR(20) | YES |  |  |
| 125 | dispensing_status | VARCHAR(1) | YES |  |  |
| 126 | assoc_rx_date | TIMESTAMP | YES |  |  |
| 127 | assoc_rx_number | BIGINT | YES |  |  |
| 128 | intended_days_supply | INTEGER | YES |  |  |
| 129 | partial_ing_cost_paid | NUMERIC(18, 2) | YES |  |  |
| 130 | intended_met_qty | NUMERIC(18, 3) | YES |  |  |
| 131 | ta_amount | NUMERIC(18, 2) | YES |  |  |
| 132 | other_coverage_code | INTEGER | YES |  |  |
| 133 | other_payor_amount | NUMERIC(18, 2) | YES |  |  |
| 134 | date_of_injury | TIMESTAMP | YES |  |  |
| 135 | indep_code | INTEGER | YES |  |  |
| 136 | penalty_amount | NUMERIC(18, 2) | YES |  |  |
| 137 | patient_last_name | VARCHAR(20) | YES |  |  |
| 138 | patient_middle_initial | VARCHAR(1) | YES |  |  |
| 139 | patient_first_name | VARCHAR(15) | YES |  |  |
| 140 | sub_clarification_code1 | INTEGER | YES |  |  |
| 141 | sub_clarification_code2 | INTEGER | YES |  |  |
| 142 | sub_clarification_code3 | INTEGER | YES |  |  |
| 143 | pa_mc_code_and_number | NUMERIC(12, 0) | YES |  |  |
| 144 | level_of_service | INTEGER | YES |  |  |
| 145 | max_amt | NUMERIC(18, 2) | YES |  |  |
| 146 | deduct_amt | NUMERIC(18, 2) | YES |  |  |
| 147 | dmr_nabp | INTEGER | YES |  |  |
| 148 | other_payer_order | INTEGER | YES |  |  |
| 149 | nonlics_deduct_amt | NUMERIC(18, 2) | YES |  |  |
| 150 | standard_deduct_amt | NUMERIC(18, 2) | YES |  |  |
| 151 | special_deduct_amt | NUMERIC(18, 2) | YES |  |  |
| 152 | team_member | VARCHAR(4) | YES |  |  |
| 153 | npi_number | VARCHAR(10) | YES |  |  |
| 154 | card_seq_number | INTEGER | YES |  |  |
| 155 | purge_status | INTEGER | YES |  |  |
| 156 | data_error_message | VARCHAR(150) | YES |  |  |
| 157 | pcn | VARCHAR(10) | YES |  |  |
| 158 | bin_number | INTEGER | YES |  |  |
| 159 | eft_payment | VARCHAR(1) | YES |  |  |
| 160 | medd_gap_discount | NUMERIC(18, 2) | YES |  |  |
| 161 | medd_beg_phase | VARCHAR(1) | YES |  |  |
| 162 | medd_end_phase | VARCHAR(1) | YES |  |  |
| 163 | rxnumber_length | INTEGER | YES |  |  |
| 164 | patient_paid_amount | NUMERIC(18, 2) | YES |  |  |
| 165 | sub_clarification_count | INTEGER | YES |  |  |
| 166 | other_payer_bin | INTEGER | YES |  |  |
| 167 | trans_ref_number | VARCHAR(10) | YES |  |  |
| 168 | other_payer_pcn | VARCHAR(14) | YES |  |  |
| 169 | other_payer_group | VARCHAR(14) | YES |  |  |
| 170 | soj | VARCHAR(2) | YES |  |  |
| 171 | other_payer_cardholder | VARCHAR(20) | YES |  |  |
| 172 | compound_dosage_description_code | VARCHAR(2) | YES |  |  |
| 173 | compound_dispensing_id | VARCHAR(1) | YES |  |  |
| 174 | compound_count | INTEGER | YES |  |  |
| 175 | amt_applied_period_deduct | NUMERIC(18, 2) | YES |  |  |
| 176 | amt_exceed_period_benefit | NUMERIC(18, 2) | YES |  |  |
| 177 | amt_copay | NUMERIC(18, 2) | YES |  |  |
| 178 | amt_coinsurance | NUMERIC(18, 2) | YES |  |  |
| 179 | amt_attr_processor_fee | NUMERIC(18, 2) | YES |  |  |
| 180 | amt_attr_sales_tax | NUMERIC(18, 2) | YES |  |  |
| 181 | amt_attr_provider_net_select | NUMERIC(18, 2) | YES |  |  |
| 182 | amt_attr_prod_sel_brand | NUMERIC(18, 2) | YES |  |  |
| 183 | amt_attr_prod_sel_non_pf | NUMERIC(18, 2) | YES |  |  |
| 184 | amt_attr_prod_sel_brd_non_pf | NUMERIC(18, 2) | YES |  |  |
| 185 | health_plan_funded_assist_amt | NUMERIC(18, 2) | YES |  |  |
| 186 | gross_amount_due | NUMERIC(18, 2) | YES |  |  |
| 187 | incentive_amount_sub | NUMERIC(18, 2) | YES |  |  |
| 188 | dispensing_fee_sub | NUMERIC(18, 2) | YES |  |  |
| 189 | other_amount_claimed_sub | NUMERIC(18, 2) | YES |  |  |
| 190 | flat_sales_tax_amount_sub | NUMERIC(18, 2) | YES |  |  |
| 191 | pct_sales_tax_amount_sub | NUMERIC(18, 2) | YES |  |  |
| 192 | pct_sales_tax_rate_sub | NUMERIC(18, 4) | YES |  |  |
| 193 | medicaid_subrogation | VARCHAR(20) | YES |  |  |
| 194 | medicaid_paid_amt | NUMERIC(18, 2) | YES |  |  |
| 195 | pharmacy_service_type | INTEGER | YES |  |  |
| 196 | pharmacist_license | VARCHAR(50) | YES |  |  |
| 197 | sequence_number | VARCHAR(20) | YES |  |  |
| 198 | uid | VARCHAR(36) | YES |  |  |
| 199 | nabp_7 | VARCHAR(7) | YES |  |  |
| 200 | preferred_status | VARCHAR(1) | YES |  |  |
| 201 | rx_origin_code | INTEGER | YES |  |  |
| 202 | customer_location | INTEGER | YES |  |  |
| 203 | eligibility_clarification_code | INTEGER | YES |  |  |
| 204 | primary_prescriber | VARCHAR(10) | YES |  |  |
| 205 | basis_of_cost_determination | VARCHAR(2) | YES |  |  |
| 206 | document_number | INTEGER | YES |  |  |
| 207 | time | TIME | YES |  |  |
| 208 | processor_control_flag | VARCHAR(1) | YES |  |  |
| 209 | dmr_reimbursement_payment_type | INTEGER | YES |  |  |
| 210 | pharmacy_option | VARCHAR(1) | YES |  |  |
| 211 | pharmacy_name | VARCHAR(30) | YES |  |  |
| 212 | product_description_abbreviation | VARCHAR(25) | YES |  |  |
| 213 | alt_cardholder_number | VARCHAR(13) | YES |  |  |
| 214 | alt_group_number | VARCHAR(12) | YES |  |  |
| 215 | thera_class | INTEGER | YES |  |  |
| 216 | rx_otc_class | VARCHAR(1) | YES |  |  |
| 217 | batch_date | TIMESTAMP | YES |  |  |
| 218 | benefit_code | VARCHAR(16) | YES |  |  |
| 219 | claim_indicator | VARCHAR(1) | YES |  |  |
| 220 | rx_date_julian | INTEGER | YES |  |  |
| 221 | batch_date_julian | INTEGER | YES |  |  |
| 222 | county | VARCHAR(2) | YES |  |  |
| 223 | seq_number | VARCHAR(20) | YES |  |  |
| 224 | physician_number_x | VARCHAR(50) | YES |  |  |
| 225 | cms_part_d_facility | VARCHAR(1) | YES |  |  |
| 226 | approved_msg_code | VARCHAR(3) | YES |  |  |
| 227 | time_hhmm | VARCHAR(4) | YES |  |  |
| 228 | restack_batch | VARCHAR(8) | YES |  |  |
| 229 | restack_claim | INTEGER | YES |  |  |
| 230 | variable_mac_factor_rate | NUMERIC(18, 5) | YES |  |  |
| 231 | patient_residency | VARCHAR(2) | YES |  |  |
| 232 | special_packaging_ind | VARCHAR(1) | YES |  |  |
| 233 | prof_service_code_1 | VARCHAR(2) | YES |  |  |
| 234 | prof_service_code_2 | VARCHAR(2) | YES |  |  |
| 235 | prof_service_code_3 | VARCHAR(2) | YES |  |  |
| 236 | dur_pps_lvl_of_effort | VARCHAR(2) | YES |  |  |
| 237 | troop_amt | NUMERIC(18, 2) | YES |  |  |
| 238 | etl_date | TIMESTAMP | YES |  |  |
| 239 | etl_indicator | VARCHAR(1) | YES |  |  |
| 240 | manual_change_date | TIMESTAMP | YES |  |  |
| 241 | redemption_count | INTEGER | YES |  |  |
| 242 | date_of_reversal | TIMESTAMP | YES |  |  |
| 243 | packaging_indicator | VARCHAR(1) | YES |  |  |
| 244 | no_financial_flag | VARCHAR(1) | YES |  |  |
| 245 | claim_type_alpha | VARCHAR(2) | YES |  |  |
| 246 | ltc_indicator | VARCHAR(1) | YES |  |  |
| 247 | dur_lvl_of_effort_1 | VARCHAR(2) | YES |  |  |
| 248 | dur_reason_service_1 | VARCHAR(2) | YES |  |  |
| 249 | dur_prof_service_code_1 | VARCHAR(2) | YES |  |  |
| 250 | dur_result_of_serv_cd_1 | VARCHAR(2) | YES |  |  |
| 251 | dur_lvl_of_effort_2 | VARCHAR(2) | YES |  |  |
| 252 | dur_reason_service_2 | VARCHAR(2) | YES |  |  |
| 253 | dur_prof_service_code_2 | VARCHAR(2) | YES |  |  |
| 254 | dur_result_of_serv_cd_2 | VARCHAR(2) | YES |  |  |
| 255 | dur_lvl_of_effort_3 | VARCHAR(2) | YES |  |  |
| 256 | dur_reason_service_3 | VARCHAR(2) | YES |  |  |
| 257 | dur_prof_service_code_3 | VARCHAR(2) | YES |  |  |
| 258 | dur_result_of_serv_cd_3 | VARCHAR(2) | YES |  |  |
| 259 | dur_lvl_of_effort_4 | VARCHAR(2) | YES |  |  |
| 260 | dur_reason_service_4 | VARCHAR(2) | YES |  |  |
| 261 | dur_prof_service_code_4 | VARCHAR(2) | YES |  |  |
| 262 | dur_result_of_serv_cd_4 | VARCHAR(2) | YES |  |  |
| 263 | dur_lvl_of_effort_5 | VARCHAR(2) | YES |  |  |
| 264 | dur_reason_service_5 | VARCHAR(2) | YES |  |  |
| 265 | dur_prof_service_code_5 | VARCHAR(2) | YES |  |  |
| 266 | dur_result_of_serv_cd_5 | VARCHAR(2) | YES |  |  |
| 267 | dur_lvl_of_effort_6 | VARCHAR(2) | YES |  |  |
| 268 | dur_reason_service_6 | VARCHAR(2) | YES |  |  |
| 269 | dur_prof_service_code_6 | VARCHAR(2) | YES |  |  |
| 270 | dur_result_of_serv_cd_6 | VARCHAR(2) | YES |  |  |
| 271 | dur_lvl_of_effort_7 | VARCHAR(2) | YES |  |  |
| 272 | dur_reason_service_7 | VARCHAR(2) | YES |  |  |
| 273 | dur_prof_service_code_7 | VARCHAR(2) | YES |  |  |
| 274 | dur_result_of_serv_cd_7 | VARCHAR(2) | YES |  |  |
| 275 | dur_lvl_of_effort_8 | VARCHAR(2) | YES |  |  |
| 276 | dur_reason_service_8 | VARCHAR(2) | YES |  |  |
| 277 | dur_prof_service_code_8 | VARCHAR(2) | YES |  |  |
| 278 | dur_result_of_serv_cd_8 | VARCHAR(2) | YES |  |  |
| 279 | dur_lvl_of_effort_9 | VARCHAR(2) | YES |  |  |
| 280 | dur_reason_service_9 | VARCHAR(2) | YES |  |  |
| 281 | dur_prof_service_code_9 | VARCHAR(2) | YES |  |  |
| 282 | dur_result_of_serv_cd_9 | VARCHAR(2) | YES |  |  |
| 283 | scd_claim | VARCHAR(1) | YES |  |  |
| 284 | thresh_5100 | NUMERIC(18, 2) | YES |  |  |
| 285 | c_formulary_id_flag | VARCHAR(1) | YES |  |  |
| 286 | brand_config_occur | INTEGER | YES |  |  |
| 287 | card_id_sent_from_pharm | VARCHAR(20) | YES |  |  |
| 288 | hms_physician_id | VARCHAR(10) | YES |  |  |
| 289 | tier | VARCHAR(1) | YES |  |  |
| 290 | claim_adjudication_time | VARCHAR(26) | YES |  |  |
| 291 | age | INTEGER | YES |  |  |
| 292 | quantity_dispensed | NUMERIC(18, 3) | YES |  |  |
| 293 | previous_restack_batch | VARCHAR(8) | YES |  |  |
| 294 | previous_restack_claim | INTEGER | YES |  |  |
| 295 | wac_ref_price | NUMERIC(18, 2) | YES |  |  |
| 296 | specialty_flag | VARCHAR(1) | YES |  |  |
| 297 | mail_order_indication | VARCHAR(4) | YES |  |  |
| 298 | spcl_patient_disp_fee | NUMERIC(18, 2) | YES |  |  |
| 299 | hms_poid | VARCHAR(10) | YES |  |  |
| 300 | orig_rev_batch | VARCHAR(8) | YES |  |  |
| 301 | orig_rev_claim | INTEGER | YES |  |  |
| 302 | grp_broker_nbr | VARCHAR(4) | YES |  |  |
| 303 | last_modified_date | TIMESTAMP | YES |  |  |
| 304 | last_modified_time | TIMESTAMP | YES |  |  |
| 305 | last_modified_by | VARCHAR(20) | YES |  |  |
| 306 | payment_center_id | VARCHAR(6) | YES |  |  |
| 307 | remit_reconciliation_id | VARCHAR(6) | YES |  |  |
| 308 | pdmi_reject_code_1 | VARCHAR(4) | YES |  |  |
| 309 | pdmi_reject_code_2 | VARCHAR(4) | YES |  |  |
| 310 | pdmi_reject_code_3 | VARCHAR(4) | YES |  |  |
| 311 | pdmi_reject_code_4 | VARCHAR(4) | YES |  |  |
| 312 | pdmi_reject_code_5 | VARCHAR(4) | YES |  |  |
| 313 | pdmi_reject_code_6 | VARCHAR(4) | YES |  |  |
| 314 | pdmi_reject_code_7 | VARCHAR(4) | YES |  |  |
| 315 | pdmi_reject_code_8 | VARCHAR(4) | YES |  |  |
| 316 | pdmi_reject_code_9 | VARCHAR(4) | YES |  |  |
| 317 | pdmi_reject_code_10 | VARCHAR(4) | YES |  |  |
| 318 | pdmi_reject_code_11 | VARCHAR(4) | YES |  |  |
| 319 | pdmi_reject_code_12 | VARCHAR(4) | YES |  |  |
| 320 | pdmi_reject_code_13 | VARCHAR(4) | YES |  |  |
| 321 | pdmi_reject_code_14 | VARCHAR(4) | YES |  |  |
| 322 | pdmi_reject_code_15 | VARCHAR(4) | YES |  |  |
| 323 | pdmi_reject_code_16 | VARCHAR(4) | YES |  |  |
| 324 | pdmi_reject_code_17 | VARCHAR(4) | YES |  |  |
| 325 | pdmi_reject_code_18 | VARCHAR(4) | YES |  |  |
| 326 | pdmi_reject_code_19 | VARCHAR(4) | YES |  |  |
| 327 | pdmi_reject_code_20 | VARCHAR(4) | YES |  |  |
| 328 | amount_applied_to_oop | NUMERIC(18, 2) | YES |  |  |
| 329 | n1_claim_key | VARCHAR(14) | YES |  |  |
| 330 | n1_batch_number | VARCHAR(8) | YES |  |  |
| 331 | n1_claim_number | INTEGER | YES |  |  |
| 332 | userid | VARCHAR(15) | YES |  |  |
| 333 | opioid_factor | NUMERIC(18, 2) | YES |  |  |
| 334 | contract_chain_number | INTEGER | YES |  |  |
| 335 | differential_claim_type | VARCHAR(6) | YES |  |  |
| 336 | carrier_id | VARCHAR(10) | YES |  |  |
| 337 | pharm_electronic_fee | NUMERIC(18, 2) | YES |  |  |
| 338 | vaccine_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 339 | prescriber_id_qualifier | VARCHAR(10) | YES |  |  |
| 340 | ctree_toggle | VARCHAR(1) | YES |  |  |
| 341 | orig_med_gen_code | VARCHAR(1) | YES |  |  |
| 342 | oth_pay_covg_type | VARCHAR(2) | YES |  |  |
| 343 | script_care_claim | VARCHAR(1) | YES |  |  |
| 344 | script_care_net_pricing | VARCHAR(1) | YES |  |  |
| 345 | quantity_prescribed | NUMERIC(18, 3) | YES |  |  |
| 346 | pdmi_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 347 | client_sys_spo_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 348 | client_spo_grp_admin_fee | NUMERIC(18, 2) | YES |  |  |
| 349 | claim_category | VARCHAR(12) | YES |  |  |
| 350 | plan_key | VARCHAR(16) | YES |  |  |
| 351 | plan_number | VARCHAR(8) | YES |  |  |
| 352 | add_to_troop | NUMERIC(18, 2) | YES |  |  |
| 353 | client_basis_of_cost | VARCHAR(2) | YES |  |  |
| 354 | pharm_basis_of_cost | VARCHAR(2) | YES |  |  |
| 355 | group_from_pharm | VARCHAR(15) | YES |  |  |
| 356 | tax_exempt_flag | VARCHAR(1) | YES |  |  |
| 357 | network_reimb_id | VARCHAR(10) | YES |  |  |
