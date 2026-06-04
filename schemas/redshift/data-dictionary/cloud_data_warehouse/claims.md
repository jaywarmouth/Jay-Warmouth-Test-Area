# cloud_data_warehouse.claims

> **Schema:** cloud_data_warehouse | **Columns:** 357

## Overview

This table stores adjudicated pharmacy prescription claim transactions in the PBM data warehouse, including member, prescriber, pharmacy, drug, plan, pricing, cost-share, reject/override, DUR, and coordination-of-benefits details used for clinical oversight, financial reporting, reconciliation, and downstream analytics.

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | meta_surr_key | VARCHAR(1000) | YES |  | ETL surrogate key assigned to this warehouse claim record. |
| 2 | meta_hash_key | VARCHAR(1000) | YES |  | ETL hash key representing the record business-content signature. |
| 3 | meta_src_sys_nm | VARCHAR(80) | YES |  | Source system name from which the claim record was ingested. |
| 4 | meta_iud_flg | VARCHAR(1) | YES |  | ETL insert/update/delete indicator for record lifecycle action. |
| 5 | meta_eff_strt_dt | TIMESTAMP | YES |  | ETL effective start timestamp for this record version. |
| 6 | meta_eff_end_dt | TIMESTAMP | YES |  | ETL effective end timestamp for this record version. |
| 7 | meta_curr_ind | VARCHAR(3) | YES |  | ETL current-record indicator for slowly changing history tracking. |
| 8 | claim_key | VARCHAR(14) | NO |  | Unique warehouse claim identifier for the pharmacy claim transaction. |
| 9 | batch_number | VARCHAR(8) | YES |  | Source adjudication batch number that grouped this claim during processing. |
| 10 | claim_number | BIGINT | YES |  | Original claim transaction number assigned by the adjudication platform. |
| 11 | claim_type | BIGINT | YES |  | Numeric claim type classification (for example paid, reversed, or adjusted). |
| 12 | payment_dir | BIGINT | YES |  | Payment direction indicator showing pay-to-pharmacy versus recoupment/reversal flow. |
| 13 | cardholder_number | VARCHAR(10) | YES |  | Member cardholder identifier submitted on the claim. |
| 14 | member_number | VARCHAR(2) | YES |  | Dependent/member sequence under the cardholder account. |
| 15 | pharmacy_number | BIGINT | YES |  | Pharmacy identifier used by the claim processing platform. |
| 16 | network_key | VARCHAR(16) | YES |  | Key linking the claim to the participating pharmacy network configuration. |
| 17 | chain_number | BIGINT | YES |  | Pharmacy chain identifier associated to the dispensing pharmacy. |
| 18 | reject_code_1 | BIGINT | YES |  | Primary adjudication reject code returned when claim edits fail. |
| 19 | reject_code_2 | BIGINT | YES |  | Secondary adjudication reject code returned when additional edits fail. |
| 20 | process_date | DATE | YES |  | Date the claim was processed/adjudicated by the PBM system. |
| 21 | rx_number | BIGINT | YES |  | Prescription number as dispensed by the pharmacy. |
| 22 | rx_date | DATE | YES |  | Date the prescription was written or service date, per source feed rules. |
| 23 | rx_time | TIMESTAMP | YES |  | Timestamp associated to claim submission/adjudication event. |
| 24 | new_refill | VARCHAR(1) | YES |  | Indicator showing whether the fill is new or a refill. |
| 25 | generic_code | VARCHAR(1) | YES |  | Brand/generic product indicator used during adjudication. |
| 26 | drug_pref_ind | VARCHAR(2) | YES |  | Preferred drug indicator from formulary or plan design. |
| 27 | metric_quantity | NUMERIC(18, 3) | YES |  | Dispensed quantity in metric units submitted on the claim. |
| 28 | days_supply | BIGINT | YES |  | Intended number of therapy days covered by quantity dispensed. |
| 29 | ing_billed | NUMERIC(18, 2) | YES |  | Ingredient cost amount billed by the pharmacy. |
| 30 | ing_paid | NUMERIC(18, 2) | YES |  | Ingredient cost amount allowed/paid by the PBM. |
| 31 | disp_fee | NUMERIC(18, 2) | YES |  | Dispensing fee paid to the pharmacy. |
| 32 | copay | NUMERIC(18, 2) | YES |  | Member copay amount for the claim. |
| 33 | tax | NUMERIC(18, 2) | YES |  | Tax amount applied to the claim payment. |
| 34 | admin_fee | NUMERIC(18, 2) | YES |  | Administrative fee amount applied during claim pricing. |
| 35 | amount_paid | NUMERIC(18, 2) | YES |  | Total amount paid on the claim after adjudication. |
| 36 | ucr_amount | NUMERIC(18, 2) | YES |  | Usual and customary retail amount submitted by pharmacy. |
| 37 | awp_processed | NUMERIC(18, 5) | YES |  | Average Wholesale Price basis value used in pricing. |
| 38 | generic_savings | NUMERIC(18, 2) | YES |  | Estimated savings attributed to dispensing a generic product. |
| 39 | member_birth | DATE | YES |  | Member date of birth used for eligibility and clinical edits. |
| 40 | sex | VARCHAR(1) | YES |  | Member gender code used for clinical and reporting logic. |
| 41 | cardholder_key | VARCHAR(20) | YES |  | Warehouse key linking claim to the cardholder dimension. |
| 42 | physician_key | VARCHAR(14) | YES |  | Warehouse key linking claim to the prescriber/provider dimension. |
| 43 | diagnosis_code | VARCHAR(6) | YES |  | Diagnosis code submitted with claim (when available). |
| 44 | group_number | BIGINT | YES |  | Employer/client group number tied to member coverage. |
| 45 | drug_key | VARCHAR(15) | YES |  | Warehouse key linking claim to the drug/product dimension. |
| 46 | gpi | VARCHAR(14) | YES |  | Generic Product Identifier (GPI) for therapeutic classification. |
| 47 | ndc_type_code | BIGINT | YES |  | Code identifying the NDC format/type submitted. |
| 48 | ndc | NUMERIC(11, 0) | YES |  | National Drug Code (NDC) submitted for the dispensed product. |
| 49 | main_drug | VARCHAR(1) | YES |  | Indicator that this product is the primary drug on the claim. |
| 50 | benefit_key | VARCHAR(24) | YES |  | Warehouse key linking to benefit design used for adjudication. |
| 51 | copay_key | VARCHAR(12) | YES |  | Warehouse key linking to copay configuration applied. |
| 52 | copay_table | BIGINT | YES |  | Copay table identifier used to calculate member cost share. |
| 53 | dispense_table | BIGINT | YES |  | Dispensing rule table identifier used in adjudication. |
| 54 | plan_key | VARCHAR(16) | YES |  | Warehouse key linking claim to benefit plan dimension. |
| 55 | plan_number | VARCHAR(8) | YES |  | Plan identifier from source adjudication system. |
| 56 | mac_number | BIGINT | YES |  | Maximum Allowable Cost (MAC) schedule identifier applied. |
| 57 | daw_indicator | VARCHAR(1) | YES |  | Dispense As Written (DAW) code submitted by pharmacy. |
| 58 | compound_code | BIGINT | YES |  | NCPDP compound indicator/code for compounded prescription. |
| 59 | third_party_code | VARCHAR(1) | YES |  | Code identifying third-party payer/processor involvement. |
| 60 | rx_otc | VARCHAR(1) | YES |  | Indicator whether product is prescription legend or OTC. |
| 61 | adjustment_code_2 | BIGINT | YES |  | Secondary adjustment reason code for claim reprocessing. |
| 62 | generic_table | BIGINT | YES |  | Generic pricing/logic table identifier referenced in adjudication. |
| 63 | reimb_rate_table | BIGINT | YES |  | Reimbursement rate table identifier used to price the claim. |
| 64 | mail_order_flag | VARCHAR(1) | YES |  | Indicator that claim was dispensed through mail service channel. |
| 65 | line_number | BIGINT | YES |  | Claim detail line number within the transaction record. |
| 66 | claims_counter | BIGINT | YES |  | Counter value tracking claims sequence or accumulation context. |
| 67 | current_claim_indicator | VARCHAR(1) | YES |  | Indicator that row reflects the latest/current version of claim. |
| 68 | period_ending | DATE | YES |  | Period end date associated to reporting or accumulation window. |
| 69 | paid_date | DATE | YES |  | Date payment for the claim was issued/posted. |
| 70 | price_indicator | VARCHAR(1) | YES |  | Indicator describing pricing method used for adjudication. |
| 71 | adjustment_code | BIGINT | YES |  | Primary adjustment reason code for claim change/reversal. |
| 72 | network_number | BIGINT | YES |  | Numeric network identifier assigned to dispensing pharmacy network. |
| 73 | step_therapy_number | BIGINT | YES |  | Step therapy program/rule identifier applied to claim. |
| 74 | pcp_number | VARCHAR(14) | YES |  | Primary care provider reference number associated to member/claim. |
| 75 | date_key | VARCHAR(14) | YES |  | Warehouse date dimension key tied to claim event date. |
| 76 | exception_01 | BIGINT | YES |  | Adjudication exception code slot 1 captured on the claim. |
| 77 | override_1 | BIGINT | YES |  | Adjudication override code slot 1 used during processing. |
| 78 | rel_code | VARCHAR(2) | YES |  | Relationship code between member and cardholder/subscriber. |
| 79 | skip_limit_flag | BIGINT | YES |  | Indicator that standard quantity/day-supply limits were bypassed. |
| 80 | exception_02 | BIGINT | YES |  | Adjudication exception code slot 2 captured on the claim. |
| 81 | exception_03 | BIGINT | YES |  | Adjudication exception code slot 3 captured on the claim. |
| 82 | exception_04 | BIGINT | YES |  | Adjudication exception code slot 4 captured on the claim. |
| 83 | exception_05 | BIGINT | YES |  | Adjudication exception code slot 5 captured on the claim. |
| 84 | exception_06 | BIGINT | YES |  | Adjudication exception code slot 6 captured on the claim. |
| 85 | exception_07 | BIGINT | YES |  | Adjudication exception code slot 7 captured on the claim. |
| 86 | exception_08 | BIGINT | YES |  | Adjudication exception code slot 8 captured on the claim. |
| 87 | exception_09 | BIGINT | YES |  | Adjudication exception code slot 9 captured on the claim. |
| 88 | exception_10 | BIGINT | YES |  | Adjudication exception code slot 10 captured on the claim. |
| 89 | exception_11 | BIGINT | YES |  | Adjudication exception code slot 11 captured on the claim. |
| 90 | exception_12 | BIGINT | YES |  | Adjudication exception code slot 12 captured on the claim. |
| 91 | exception_13 | BIGINT | YES |  | Adjudication exception code slot 13 captured on the claim. |
| 92 | exception_14 | BIGINT | YES |  | Adjudication exception code slot 14 captured on the claim. |
| 93 | exception_15 | BIGINT | YES |  | Adjudication exception code slot 15 captured on the claim. |
| 94 | exception_16 | BIGINT | YES |  | Adjudication exception code slot 16 captured on the claim. |
| 95 | exception_17 | BIGINT | YES |  | Adjudication exception code slot 17 captured on the claim. |
| 96 | exception_18 | BIGINT | YES |  | Adjudication exception code slot 18 captured on the claim. |
| 97 | exception_19 | BIGINT | YES |  | Adjudication exception code slot 19 captured on the claim. |
| 98 | exception_20 | BIGINT | YES |  | Adjudication exception code slot 20 captured on the claim. |
| 99 | override_2 | BIGINT | YES |  | Adjudication override code slot 2 used during processing. |
| 100 | override_3 | BIGINT | YES |  | Adjudication override code slot 3 used during processing. |
| 101 | override_4 | BIGINT | YES |  | Adjudication override code slot 4 used during processing. |
| 102 | override_5 | BIGINT | YES |  | Adjudication override code slot 5 used during processing. |
| 103 | override_6 | BIGINT | YES |  | Adjudication override code slot 6 used during processing. |
| 104 | override_7 | BIGINT | YES |  | Adjudication override code slot 7 used during processing. |
| 105 | override_8 | BIGINT | YES |  | Adjudication override code slot 8 used during processing. |
| 106 | override_9 | BIGINT | YES |  | Adjudication override code slot 9 used during processing. |
| 107 | override_10 | BIGINT | YES |  | Adjudication override code slot 10 used during processing. |
| 108 | form_gt | BIGINT | YES |  | Formulary group table/rule indicator used during adjudication. |
| 109 | maint_gt | BIGINT | YES |  | Maintenance medication group table/rule indicator. |
| 110 | physician_key_2 | VARCHAR(18) | YES |  | Alternate warehouse key for associated prescriber/provider. |
| 111 | adj_code_1 | BIGINT | YES |  | Adjustment code slot 1 for claim update/reprocess reason. |
| 112 | adj_code_info | BIGINT | YES |  | Supplemental text/code information for adjustment processing. |
| 113 | coverage_type | VARCHAR(1) | YES |  | Coverage type code indicating benefit coverage category. |
| 114 | orig_rx_date | VARCHAR(8) | YES |  | Original prescription written date for refill or adjusted claim. |
| 115 | refills_auth | BIGINT | YES |  | Number of refills authorized by prescriber. |
| 116 | refill_count_num | BIGINT | YES |  | Refill sequence count for this dispensing event. |
| 117 | reversal_code | BIGINT | YES |  | Code indicating reversal type/reason for reversed claims. |
| 118 | sys_number | BIGINT | YES |  | Source system/internal adjudication platform identifier. |
| 119 | sponsor_number | BIGINT | YES |  | Plan sponsor/client identifier responsible for coverage. |
| 120 | upd_code | BIGINT | YES |  | Update code indicating maintenance action from source. |
| 121 | pho_number | VARCHAR(14) | YES |  | Prior history/authorization reference number (source-defined PHO value). |
| 122 | claim_cnty | VARCHAR(2) | YES |  | County code associated to the claim/member geography. |
| 123 | member_first_name | VARCHAR(15) | YES |  | Member first name from claim eligibility snapshot. |
| 124 | member_middle_initial | VARCHAR(1) | YES |  | Member middle initial from eligibility/claim feed. |
| 125 | member_last_name | VARCHAR(20) | YES |  | Member last name from claim eligibility snapshot. |
| 126 | version_number | VARCHAR(1) | YES |  | Version number of claim record after adjustments/reversals. |
| 127 | awp_100_percent | NUMERIC(18, 2) | YES |  | Calculated 100% AWP benchmark value for pricing comparison. |
| 128 | diff_ing_paid | NUMERIC(18, 2) | YES |  | Difference amount in ingredient paid between pricing scenarios. |
| 129 | diff_disp_fee | NUMERIC(18, 2) | YES |  | Difference amount in dispensing fee between pricing scenarios. |
| 130 | diff_table_number | BIGINT | YES |  | Differential pricing table identifier used for comparison logic. |
| 131 | mac_reference_price | NUMERIC(18, 2) | YES |  | Reference MAC price used to evaluate reimbursement. |
| 132 | contract_rate_price | NUMERIC(18, 2) | YES |  | Contracted reimbursement rate price applied to claim. |
| 133 | order_number | VARCHAR(20) | YES |  | Order or transaction sequence number from source workflow. |
| 134 | dispensing_status | VARCHAR(1) | YES |  | Dispensing status code for fill completion/partial fill state. |
| 135 | assoc_rx_date | DATE | YES |  | Associated prescription date for linked/original prescription. |
| 136 | assoc_rx_number | BIGINT | YES |  | Associated prescription number for linked transaction. |
| 137 | intended_days_supply | BIGINT | YES |  | Intended days supply documented for partial or special fills. |
| 138 | partial_ing_cost_paid | NUMERIC(18, 2) | YES |  | Ingredient cost paid for partial-fill portion. |
| 139 | intended_met_qty | NUMERIC(18, 3) | YES |  | Intended metric quantity for full therapy amount. |
| 140 | ta_amount | NUMERIC(18, 2) | YES |  | Transitional assistance or true-up adjustment amount (source-defined TA). |
| 141 | other_coverage_code | BIGINT | YES |  | NCPDP Other Coverage Code indicating other payer involvement. |
| 142 | other_payor_amount | NUMERIC(18, 2) | YES |  | Amount paid by other payer for COB adjudication. |
| 143 | date_of_injury | DATE | YES |  | Date of injury for workers compensation or injury-related claims. |
| 144 | indep_code | BIGINT | YES |  | Independent pharmacy classification/indicator code. |
| 145 | penalty_amount | NUMERIC(18, 2) | YES |  | Penalty amount assessed during pricing or contract reconciliation. |
| 146 | patient_last_name | VARCHAR(20) | YES |  | Patient last name as submitted on claim transaction. |
| 147 | patient_middle_initial | VARCHAR(1) | YES |  | Patient middle initial as submitted on claim transaction. |
| 148 | patient_first_name | VARCHAR(15) | YES |  | Patient first name as submitted on claim transaction. |
| 149 | sub_clarification_code_1 | BIGINT | YES |  | NCPDP submission clarification code slot 1. |
| 150 | sub_clarification_code_2 | BIGINT | YES |  | NCPDP submission clarification code slot 2. |
| 151 | sub_clarification_code_3 | BIGINT | YES |  | NCPDP submission clarification code slot 3. |
| 152 | pa_mc_code_and_number | NUMERIC(12, 0) | YES |  | Prior authorization/medical certification code and reference number. |
| 153 | level_of_service | BIGINT | YES |  | NCPDP level-of-service code describing service setting. |
| 154 | max_amt | NUMERIC(18, 2) | YES |  | Maximum allowed amount for pricing or benefit limit calculation. |
| 155 | deduct_amt | NUMERIC(18, 2) | YES |  | Deductible amount applied on this claim. |
| 156 | dmr_nabp | BIGINT | YES |  | NABP identifier tied to DMR reimbursement context. |
| 157 | other_payer_order | BIGINT | YES |  | COB other payer sequence/order value. |
| 158 | nonlics_deduct_amt | NUMERIC(18, 2) | YES |  | Non-LICS deductible amount applied for Medicare Part D claim. |
| 159 | standard_deduct_amt | NUMERIC(18, 2) | YES |  | Standard deductible amount component for the claim. |
| 160 | special_deduct_amt | NUMERIC(18, 2) | YES |  | Special deductible amount component per plan rules. |
| 161 | team_member | VARCHAR(4) | YES |  | Internal team/user identifier associated to claim handling. |
| 162 | npi_number | VARCHAR(10) | YES |  | National Provider Identifier (NPI) for prescriber/provider. |
| 163 | card_seq_number | BIGINT | YES |  | Cardholder card sequence number used for eligibility matching. |
| 164 | add_to_troop | NUMERIC(18, 2) | YES |  | Indicator whether member payment counts toward TrOOP. |
| 165 | pcn | VARCHAR(10) | YES |  | Processor Control Number (PCN) used for routing/adjudication. |
| 166 | bin_number | BIGINT | YES |  | Bank Identification Number (BIN) used for transaction routing. |
| 167 | eft_payment | VARCHAR(1) | YES |  | Electronic funds transfer payment amount/indicator for claim settlement. |
| 168 | medd_gap_discount | NUMERIC(18, 2) | YES |  | Medicare Part D coverage-gap discount amount applied. |
| 169 | medd_beg_phase | VARCHAR(1) | YES |  | Medicare Part D benefit phase at start of adjudication. |
| 170 | medd_end_phase | VARCHAR(1) | YES |  | Medicare Part D benefit phase after adjudication. |
| 171 | rxnumber_length | BIGINT | YES |  | Length of submitted prescription number for source normalization. |
| 172 | patient_paid_amount | NUMERIC(18, 2) | YES |  | Total amount paid by patient/member for the claim. |
| 173 | sub_clarification_count | BIGINT | YES |  | Count of submitted clarification codes on transaction. |
| 174 | other_payer_bin | BIGINT | YES |  | BIN for other payer in COB processing. |
| 175 | trans_ref_number | VARCHAR(10) | YES |  | Transaction reference number assigned during adjudication. |
| 176 | other_payer_pcn | VARCHAR(14) | YES |  | PCN for other payer in COB processing. |
| 177 | other_payer_group | VARCHAR(14) | YES |  | Group identifier for other payer in COB processing. |
| 178 | soj | VARCHAR(2) | YES |  | Source-of-judgment/source-of-claim indicator (SOJ) from adjudication feed. |
| 179 | other_payer_cardholder | VARCHAR(20) | YES |  | Cardholder/member ID used by other payer. |
| 180 | compound_dosage_description_code | VARCHAR(2) | YES |  | Compound dosage form description code. |
| 181 | compound_dispensing_id | VARCHAR(1) | YES |  | Identifier for compound dispensing event/components. |
| 182 | compound_count | BIGINT | YES |  | Number of ingredients/components in compounded claim. |
| 183 | amt_applied_period_deduct | NUMERIC(18, 2) | YES |  | Amount applied to period deductible accumulator. |
| 184 | amt_exceed_period_benefit | NUMERIC(18, 2) | YES |  | Amount exceeding period benefit maximum. |
| 185 | amt_copay | NUMERIC(18, 2) | YES |  | Member copay amount component on claim. |
| 186 | amt_coinsurance | NUMERIC(18, 2) | YES |  | Member coinsurance amount component on claim. |
| 187 | amt_attr_processor_fee | NUMERIC(18, 2) | YES |  | Attributed processor fee amount component. |
| 188 | amt_attr_sales_tax | NUMERIC(18, 2) | YES |  | Attributed sales tax amount component. |
| 189 | amt_attr_provider_net_select | NUMERIC(18, 2) | YES |  | Attributed provider network selection amount component. |
| 190 | amt_attr_prod_sel_brand | NUMERIC(18, 2) | YES |  | Attributed amount due to brand product selection. |
| 191 | amt_attr_prod_sel_non_pf | NUMERIC(18, 2) | YES |  | Attributed amount due to non-preferred product selection. |
| 192 | amt_attr_prod_sel_brd_non_pf | NUMERIC(18, 2) | YES |  | Attributed amount due to brand non-preferred product selection. |
| 193 | health_plan_funded_assist_amt | NUMERIC(18, 2) | YES |  | Health-plan funded assistance amount applied to member cost share. |
| 194 | gross_amount_due | NUMERIC(18, 2) | YES |  | Gross amount due before final payer/member allocation. |
| 195 | incentive_amount_sub | NUMERIC(18, 2) | YES |  | Submitted incentive amount component. |
| 196 | dispensing_fee_sub | NUMERIC(18, 2) | YES |  | Submitted dispensing fee amount component. |
| 197 | other_amount_claimed_sub | NUMERIC(18, 2) | YES |  | Submitted other amount claimed component. |
| 198 | flat_sales_tax_amount_sub | NUMERIC(18, 2) | YES |  | Submitted flat sales tax amount. |
| 199 | pct_sales_tax_amount_sub | NUMERIC(18, 2) | YES |  | Submitted percentage-based sales tax amount. |
| 200 | pct_sales_tax_rate_sub | NUMERIC(18, 4) | YES |  | Submitted percentage sales tax rate. |
| 201 | medicaid_subrogation | VARCHAR(20) | YES |  | Indicator/amount for Medicaid subrogation processing. |
| 202 | medicaid_paid_amt | NUMERIC(18, 2) | YES |  | Amount paid by Medicaid for COB/subrogation claims. |
| 203 | pharmacy_service_type | BIGINT | YES |  | NCPDP pharmacy service type code. |
| 204 | pharmacist_license | VARCHAR(50) | YES |  | Pharmacist license number associated with dispensing. |
| 205 | sequence_number | VARCHAR(20) | YES |  | Sequence number for claim event in source file/stream. |
| 206 | uid | VARCHAR(36) | YES |  | Unique source transaction identifier. |
| 207 | nabp_7 | VARCHAR(7) | YES |  | Seven-digit NABP pharmacy identifier. |
| 208 | preferred_status | VARCHAR(1) | YES |  | Preferred network/product status indicator. |
| 209 | rx_origin_code | BIGINT | YES |  | Prescription origin code (written, phone, electronic, etc.). |
| 210 | customer_location | BIGINT | YES |  | Patient/customer location code at point of service. |
| 211 | eligibility_clarification_code | BIGINT | YES |  | Eligibility clarification code submitted with claim. |
| 212 | primary_prescriber | VARCHAR(10) | YES |  | Primary prescriber identifier captured on claim. |
| 213 | basis_of_cost_determination | VARCHAR(2) | YES |  | NCPDP basis of cost determination code used for pricing. |
| 214 | document_number | BIGINT | YES |  | Source document/control number for claim record. |
| 215 | processor_control_flag | VARCHAR(1) | YES |  | Processor control indicator used in adjudication workflow. |
| 216 | dmr_reimbursement_payment_type | BIGINT | YES |  | DMR reimbursement payment type code. |
| 217 | pharmacy_option | VARCHAR(1) | YES |  | Pharmacy option code selected by plan/client setup. |
| 218 | pharmacy_name | VARCHAR(30) | YES |  | Dispensing pharmacy name from source transaction. |
| 219 | product_description_abbreviation | VARCHAR(25) | YES |  | Abbreviated product description text. |
| 220 | alt_cardholder_number | VARCHAR(13) | YES |  | Alternate cardholder identifier supplied on transaction. |
| 221 | alt_group_number | VARCHAR(12) | YES |  | Alternate group identifier supplied on transaction. |
| 222 | thera_class | BIGINT | YES |  | Therapeutic class code/category for dispensed drug. |
| 223 | rx_otc_class | VARCHAR(1) | YES |  | Prescription/OTC product class designation. |
| 224 | batch_date | DATE | YES |  | Date associated with source claim batch creation. |
| 225 | benefit_code | VARCHAR(16) | YES |  | Benefit code identifying benefit design applied. |
| 226 | claim_indicator | VARCHAR(1) | YES |  | General claim status/type indicator from source system. |
| 227 | rx_date_julian | BIGINT | YES |  | Prescription date represented in Julian format. |
| 228 | batch_date_julian | BIGINT | YES |  | Batch date represented in Julian format. |
| 229 | county | VARCHAR(2) | YES |  | County associated with member/patient address. |
| 230 | seq_number | VARCHAR(20) | YES |  | Alternate source sequence number for claim processing. |
| 231 | physician_number_x | VARCHAR(50) | YES |  | Alternate prescriber number from source feed. |
| 232 | cms_part_d_facility | VARCHAR(1) | YES |  | CMS Part D facility type/status indicator. |
| 233 | approved_msg_code | VARCHAR(3) | YES |  | Approved-message code returned at adjudication. |
| 234 | time_hhmm | VARCHAR(4) | YES |  | Claim time value in HHMM format. |
| 235 | restack_batch | VARCHAR(8) | YES |  | Current restack batch identifier for reloaded claim. |
| 236 | restack_claim | BIGINT | YES |  | Current restack claim identifier for reloaded claim. |
| 237 | variable_mac_factor_rate | NUMERIC(18, 5) | YES |  | Variable MAC factor/rate used in reimbursement calculation. |
| 238 | patient_residency | VARCHAR(2) | YES |  | Patient residency code used for plan/program rules. |
| 239 | special_packaging_ind | VARCHAR(1) | YES |  | Indicator for special packaging requirements/services. |
| 240 | prof_service_code_1 | VARCHAR(2) | YES |  | Professional service code slot 1 submitted on claim. |
| 241 | prof_service_code_2 | VARCHAR(2) | YES |  | Professional service code slot 2 submitted on claim. |
| 242 | prof_service_code_3 | VARCHAR(2) | YES |  | Professional service code slot 3 submitted on claim. |
| 243 | dur_pps_lvl_of_effort | VARCHAR(2) | YES |  | DUR prospective payment system level-of-effort value. |
| 244 | troop_amt | NUMERIC(18, 2) | YES |  | Amount credited to TrOOP (True Out-of-Pocket) accumulator. |
| 245 | redemption_count | BIGINT | YES |  | Count of redemption events tied to claim/program benefit. |
| 246 | date_of_reversal | DATE | YES |  | Date claim reversal was processed. |
| 247 | packaging_indicator | VARCHAR(1) | YES |  | Packaging type indicator for dispensed product. |
| 248 | no_financial_flag | VARCHAR(1) | YES |  | Indicator that transaction carries no financial impact. |
| 249 | claim_type_alpha | VARCHAR(2) | YES |  | Alphanumeric claim type code from source adjudication. |
| 250 | ltc_indicator | VARCHAR(1) | YES |  | Long-term care (LTC) claim indicator. |
| 251 | dur_lvl_of_effort_1 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) level-of-effort code slot 1. |
| 252 | dur_reason_service_1 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) reason-for-service code slot 1. |
| 253 | dur_prof_service_code_1 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) professional service code slot 1. |
| 254 | dur_result_of_serv_cd_1 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) result-of-service code slot 1. |
| 255 | dur_lvl_of_effort_2 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) level-of-effort code slot 2. |
| 256 | dur_reason_service_2 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) reason-for-service code slot 2. |
| 257 | dur_prof_service_code_2 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) professional service code slot 2. |
| 258 | dur_result_of_serv_cd_2 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) result-of-service code slot 2. |
| 259 | dur_lvl_of_effort_3 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) level-of-effort code slot 3. |
| 260 | dur_reason_service_3 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) reason-for-service code slot 3. |
| 261 | dur_prof_service_code_3 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) professional service code slot 3. |
| 262 | dur_result_of_serv_cd_3 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) result-of-service code slot 3. |
| 263 | dur_lvl_of_effort_4 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) level-of-effort code slot 4. |
| 264 | dur_reason_service_4 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) reason-for-service code slot 4. |
| 265 | dur_prof_service_code_4 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) professional service code slot 4. |
| 266 | dur_result_of_serv_cd_4 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) result-of-service code slot 4. |
| 267 | dur_lvl_of_effort_5 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) level-of-effort code slot 5. |
| 268 | dur_reason_service_5 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) reason-for-service code slot 5. |
| 269 | dur_prof_service_code_5 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) professional service code slot 5. |
| 270 | dur_result_of_serv_cd_5 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) result-of-service code slot 5. |
| 271 | dur_lvl_of_effort_6 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) level-of-effort code slot 6. |
| 272 | dur_reason_service_6 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) reason-for-service code slot 6. |
| 273 | dur_prof_service_code_6 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) professional service code slot 6. |
| 274 | dur_result_of_serv_cd_6 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) result-of-service code slot 6. |
| 275 | dur_lvl_of_effort_7 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) level-of-effort code slot 7. |
| 276 | dur_reason_service_7 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) reason-for-service code slot 7. |
| 277 | dur_prof_service_code_7 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) professional service code slot 7. |
| 278 | dur_result_of_serv_cd_7 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) result-of-service code slot 7. |
| 279 | dur_lvl_of_effort_8 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) level-of-effort code slot 8. |
| 280 | dur_reason_service_8 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) reason-for-service code slot 8. |
| 281 | dur_prof_service_code_8 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) professional service code slot 8. |
| 282 | dur_result_of_serv_cd_8 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) result-of-service code slot 8. |
| 283 | dur_lvl_of_effort_9 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) level-of-effort code slot 9. |
| 284 | dur_reason_service_9 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) reason-for-service code slot 9. |
| 285 | dur_prof_service_code_9 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) professional service code slot 9. |
| 286 | dur_result_of_serv_cd_9 | VARCHAR(2) | YES |  | Drug Utilization Review (DUR) result-of-service code slot 9. |
| 287 | scd_claim | VARCHAR(1) | YES |  | ScriptCare direct/adjudication claim indicator. |
| 288 | thresh_5100 | NUMERIC(18, 2) | YES |  | Threshold indicator/value related to 5100 edit or limit logic. |
| 289 | c_formulary_id_flag | VARCHAR(1) | YES |  | Indicator that formulary ID was applied/identified. |
| 290 | brand_config_occur | BIGINT | YES |  | Indicator that brand-configuration logic occurred on claim. |
| 291 | card_id_sent_from_pharm | VARCHAR(20) | YES |  | Card ID value transmitted by pharmacy at submission. |
| 292 | hms_physician_id | VARCHAR(10) | YES |  | HMS physician identifier from integrated source. |
| 293 | tier | VARCHAR(1) | YES |  | Formulary or benefit tier assigned to dispensed product. |
| 294 | claim_adjudication_time | VARCHAR(26) | YES |  | Elapsed adjudication time for claim processing. |
| 295 | age | BIGINT | YES |  | Member/patient age at time of claim. |
| 296 | quantity_dispensed | NUMERIC(18, 3) | YES |  | Quantity dispensed as submitted on claim. |
| 297 | previous_restack_batch | VARCHAR(8) | YES |  | Prior restack batch identifier before current restack. |
| 298 | previous_restack_claim | BIGINT | YES |  | Prior restack claim identifier before current restack. |
| 299 | wac_ref_price | NUMERIC(18, 2) | YES |  | Wholesale Acquisition Cost (WAC) reference price. |
| 300 | specialty_flag | VARCHAR(1) | YES |  | Indicator that claim is for specialty medication. |
| 301 | mail_order_indication | VARCHAR(4) | YES |  | Indicator that claim is mail-order/mail-service related. |
| 302 | spcl_patient_disp_fee | NUMERIC(18, 2) | YES |  | Special patient dispensing fee amount. |
| 303 | hms_poid | VARCHAR(10) | YES |  | HMS point-of-identifier/order identifier (POID). |
| 304 | orig_rev_batch | VARCHAR(8) | YES |  | Original reversal batch identifier for reversed claim. |
| 305 | orig_rev_claim | BIGINT | YES |  | Original reversal claim identifier for reversed claim. |
| 306 | grp_broker_nbr | VARCHAR(4) | YES |  | Group broker number associated to coverage account. |
| 307 | payment_center_id | VARCHAR(6) | YES |  | Payment center identifier used for settlement processing. |
| 308 | remit_reconciliation_id | VARCHAR(6) | YES |  | Remittance reconciliation identifier for payment matching. |
| 309 | pdmi_reject_code_1 | VARCHAR(4) | YES |  | PDMI reject code slot 1 returned during adjudication. |
| 310 | pdmi_reject_code_2 | VARCHAR(4) | YES |  | PDMI reject code slot 2 returned during adjudication. |
| 311 | pdmi_reject_code_3 | VARCHAR(4) | YES |  | PDMI reject code slot 3 returned during adjudication. |
| 312 | pdmi_reject_code_4 | VARCHAR(4) | YES |  | PDMI reject code slot 4 returned during adjudication. |
| 313 | pdmi_reject_code_5 | VARCHAR(4) | YES |  | PDMI reject code slot 5 returned during adjudication. |
| 314 | pdmi_reject_code_6 | VARCHAR(4) | YES |  | PDMI reject code slot 6 returned during adjudication. |
| 315 | pdmi_reject_code_7 | VARCHAR(4) | YES |  | PDMI reject code slot 7 returned during adjudication. |
| 316 | pdmi_reject_code_8 | VARCHAR(4) | YES |  | PDMI reject code slot 8 returned during adjudication. |
| 317 | pdmi_reject_code_9 | VARCHAR(4) | YES |  | PDMI reject code slot 9 returned during adjudication. |
| 318 | pdmi_reject_code_10 | VARCHAR(4) | YES |  | PDMI reject code slot 10 returned during adjudication. |
| 319 | pdmi_reject_code_11 | VARCHAR(4) | YES |  | PDMI reject code slot 11 returned during adjudication. |
| 320 | pdmi_reject_code_12 | VARCHAR(4) | YES |  | PDMI reject code slot 12 returned during adjudication. |
| 321 | pdmi_reject_code_13 | VARCHAR(4) | YES |  | PDMI reject code slot 13 returned during adjudication. |
| 322 | pdmi_reject_code_14 | VARCHAR(4) | YES |  | PDMI reject code slot 14 returned during adjudication. |
| 323 | pdmi_reject_code_15 | VARCHAR(4) | YES |  | PDMI reject code slot 15 returned during adjudication. |
| 324 | pdmi_reject_code_16 | VARCHAR(4) | YES |  | PDMI reject code slot 16 returned during adjudication. |
| 325 | pdmi_reject_code_17 | VARCHAR(4) | YES |  | PDMI reject code slot 17 returned during adjudication. |
| 326 | pdmi_reject_code_18 | VARCHAR(4) | YES |  | PDMI reject code slot 18 returned during adjudication. |
| 327 | pdmi_reject_code_19 | VARCHAR(4) | YES |  | PDMI reject code slot 19 returned during adjudication. |
| 328 | pdmi_reject_code_20 | VARCHAR(4) | YES |  | PDMI reject code slot 20 returned during adjudication. |
| 329 | amount_applied_to_oop | NUMERIC(18, 2) | YES |  | Amount applied to member out-of-pocket accumulator. |
| 330 | n1_claim_key | VARCHAR(14) | YES |  | Related N1 claim key used for linked claim reference. |
| 331 | n1_batch_number | VARCHAR(8) | YES |  | Related N1 batch number used for linked claim reference. |
| 332 | n1_claim_number | BIGINT | YES |  | Related N1 claim number used for linked claim reference. |
| 333 | user_id | VARCHAR(15) | YES |  | User or process ID that created/updated the claim transaction. |
| 334 | opioid_factor | NUMERIC(18, 2) | YES |  | Opioid risk/utilization factor used in opioid management edits. |
| 335 | contract_chain_number | BIGINT | YES |  | Contracted chain identifier used in reimbursement terms. |
| 336 | differential_claim_type | VARCHAR(6) | YES |  | Differential claim type code used in pricing comparisons. |
| 337 | carrier_id | VARCHAR(10) | YES |  | Carrier identifier associated with coverage and claim payment. |
| 338 | pharm_electronic_fee | NUMERIC(18, 2) | YES |  | Electronic transaction fee charged to/for pharmacy. |
| 339 | vaccine_admin_fee | NUMERIC(18, 2) | YES |  | Vaccine administration fee amount on claim. |
| 340 | prescriber_id_qualifier | VARCHAR(10) | YES |  | Qualifier indicating type of prescriber identifier submitted. |
| 341 | ctree_toggle | VARCHAR(1) | YES |  | Control toggle flag for c-tree/source platform behavior. |
| 342 | orig_med_gen_code | VARCHAR(1) | YES |  | Original medication generic/brand code from source transaction. |
| 343 | oth_pay_covg_type | VARCHAR(2) | YES |  | Other payer coverage type code for COB coordination. |
| 344 | script_care_claim | VARCHAR(1) | YES |  | ScriptCare claim indicator/identifier from ScriptCare feed. |
| 345 | script_care_net_pricing | VARCHAR(1) | YES |  | ScriptCare net pricing amount/value for claim. |
| 346 | quantity_prescribed | NUMERIC(18, 3) | YES |  | Prescribed quantity written by prescriber. |
| 347 | pdmi_admin_fee | NUMERIC(18, 2) | YES |  | PDMI administrative fee amount associated with adjudication. |
| 348 | client_sys_spo_admin_fee | NUMERIC(18, 2) | YES |  | Client system SPO administrative fee amount. |
| 349 | client_spo_grp_admin_fee | NUMERIC(18, 2) | YES |  | Client SPO group-level administrative fee amount. |
| 350 | claim_category | VARCHAR(12) | YES |  | Business category/classification of claim transaction. |
| 351 | client_basis_of_cost | VARCHAR(2) | YES |  | Client-calculated basis of cost determination value. |
| 352 | pharm_basis_of_cost | VARCHAR(2) | YES |  | Pharmacy-submitted basis of cost determination value. |
| 353 | group_from_pharm | VARCHAR(15) | YES |  | Group identifier value submitted by pharmacy. |
| 354 | tax_exempt_flag | CHAR(1) | YES |  | Indicator that claim/pharmacy transaction is tax exempt. |
| 355 | network_reimb_id | VARCHAR(10) | YES |  | Network reimbursement schedule identifier applied to claim. |
| 356 | copay_n1_amount | NUMERIC(18, 2) | YES |  | N1-related copay amount component. |
| 357 | calcamtpaid | NUMERIC(23, 2) | YES |  | Calculated amount paid after pricing and benefit logic. |
