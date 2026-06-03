# cloud_data_warehouse.group_data

> **Schema:** cloud_data_warehouse | **Columns:** 351

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
| 8 | group_number | VARCHAR(20) | YES |  |  |
| 9 | group_name | VARCHAR(30) | YES |  |  |
| 10 | alt_group_number | VARCHAR(20) | YES |  |  |
| 11 | sponsor_number | BIGINT | YES |  |  |
| 12 | sponsor_name | VARCHAR(30) | YES |  |  |
| 13 | system_number | BIGINT | YES |  |  |
| 14 | system_name | VARCHAR(30) | YES |  |  |
| 15 | system_link | VARCHAR(10) | YES |  |  |
| 16 | group_street | VARCHAR(30) | YES |  |  |
| 17 | group_zip | VARCHAR(5) | YES |  |  |
| 18 | group_eff_date | DATE | YES |  |  |
| 19 | group_ter_date | DATE | YES |  |  |
| 20 | disp_fee_description | VARCHAR(30) | YES |  |  |
| 21 | copay_description | VARCHAR(30) | YES |  |  |
| 22 | master_group | BIGINT | YES |  |  |
| 23 | group_benefit_code | VARCHAR(16) | YES |  |  |
| 24 | group_master_flag | VARCHAR(1) | YES |  |  |
| 25 | group_benefit_description | VARCHAR(30) | YES |  |  |
| 26 | odaw_1_tc | BIGINT | YES |  |  |
| 27 | odaw_2_tc | BIGINT | YES |  |  |
| 28 | gen_tc | BIGINT | YES |  |  |
| 29 | np_tc | BIGINT | YES |  |  |
| 30 | single_tc | BIGINT | YES |  |  |
| 31 | brand_tc | BIGINT | YES |  |  |
| 32 | bc_tc | BIGINT | YES |  |  |
| 33 | copay_number | BIGINT | YES |  |  |
| 34 | plan_key | VARCHAR(16) | YES |  |  |
| 35 | sub_group | INTEGER | YES |  |  |
| 36 | formulary_structure | VARCHAR(1) | YES |  |  |
| 37 | active_system | VARCHAR(1) | YES |  |  |
| 38 | odaw_1_fixed_out | NUMERIC(18, 2) | YES |  |  |
| 39 | odaw_1_pct_out | NUMERIC(18, 4) | YES |  |  |
| 40 | odaw_2_fixed | NUMERIC(18, 2) | YES |  |  |
| 41 | odaw_2_pct | NUMERIC(18, 4) | YES |  |  |
| 42 | gen_fixed | NUMERIC(18, 2) | YES |  |  |
| 43 | gen_pct | NUMERIC(18, 4) | YES |  |  |
| 44 | np_fixed | NUMERIC(18, 2) | YES |  |  |
| 45 | np_pct | NUMERIC(18, 4) | YES |  |  |
| 46 | single_fixed | NUMERIC(18, 2) | YES |  |  |
| 47 | single_pct | NUMERIC(18, 4) | YES |  |  |
| 48 | brand_fixed | NUMERIC(18, 2) | YES |  |  |
| 49 | brand_pct | NUMERIC(18, 4) | YES |  |  |
| 50 | bc_fixed | NUMERIC(18, 2) | YES |  |  |
| 51 | bc_pct | NUMERIC(18, 4) | YES |  |  |
| 52 | depo_tc | BIGINT | YES |  |  |
| 53 | depo_fixed | NUMERIC(18, 2) | YES |  |  |
| 54 | inj_tc | BIGINT | YES |  |  |
| 55 | depo_pct | NUMERIC(18, 4) | YES |  |  |
| 56 | inj_fixed | NUMERIC(18, 2) | YES |  |  |
| 57 | inj_pct | NUMERIC(18, 4) | YES |  |  |
| 58 | split_tc | BIGINT | YES |  |  |
| 59 | split_fixed | NUMERIC(18, 2) | YES |  |  |
| 60 | split_pct | NUMERIC(18, 4) | YES |  |  |
| 61 | sys_link_description | VARCHAR(60) | YES |  |  |
| 62 | comp_tc | BIGINT | YES |  |  |
| 63 | comp_fixed | NUMERIC(18, 2) | YES |  |  |
| 64 | comp_pct | NUMERIC(18, 4) | YES |  |  |
| 65 | multi_tc | BIGINT | YES |  |  |
| 66 | multi_fixed | NUMERIC(18, 2) | YES |  |  |
| 67 | multi_pct | NUMERIC(18, 4) | YES |  |  |
| 68 | npbc_tc | BIGINT | YES |  |  |
| 69 | npbc_fixed | NUMERIC(18, 2) | YES |  |  |
| 70 | npbc_pct | NUMERIC(18, 4) | YES |  |  |
| 71 | np_daw_1_tc | BIGINT | YES |  |  |
| 72 | np_daw_1_fixed | NUMERIC(18, 2) | YES |  |  |
| 73 | np_daw_1_pct | NUMERIC(18, 4) | YES |  |  |
| 74 | np_daw_2_tc | BIGINT | YES |  |  |
| 75 | np_daw_2_fixed | NUMERIC(18, 2) | YES |  |  |
| 76 | np_daw_2_pct | NUMERIC(18, 4) | YES |  |  |
| 77 | npm_tc | BIGINT | YES |  |  |
| 78 | npm_fixed | NUMERIC(18, 2) | YES |  |  |
| 79 | npm_pct | NUMERIC(18, 4) | YES |  |  |
| 80 | npn_tc | BIGINT | YES |  |  |
| 81 | npn_fixed | NUMERIC(18, 2) | YES |  |  |
| 82 | npn_pct | NUMERIC(18, 4) | YES |  |  |
| 83 | odaw_3_tc | BIGINT | YES |  |  |
| 84 | odaw_3_fixed | NUMERIC(18, 2) | YES |  |  |
| 85 | odaw_3_pct | NUMERIC(18, 4) | YES |  |  |
| 86 | diff_flag | VARCHAR(1) | YES |  |  |
| 87 | diff_table_1 | BIGINT | YES |  |  |
| 88 | diff_eff_1 | DATE | YES |  |  |
| 89 | diff_ter_1 | DATE | YES |  |  |
| 90 | diff_table_2 | BIGINT | YES |  |  |
| 91 | diff_eff_2 | DATE | YES |  |  |
| 92 | diff_ter_2 | DATE | YES |  |  |
| 93 | diff_table_3 | BIGINT | YES |  |  |
| 94 | diff_eff_3 | DATE | YES |  |  |
| 95 | diff_ter_3 | DATE | YES |  |  |
| 96 | sys_street_1 | VARCHAR(30) | YES |  |  |
| 97 | sys_street_2 | VARCHAR(30) | YES |  |  |
| 98 | sys_city | VARCHAR(18) | YES |  |  |
| 99 | sys_state | VARCHAR(2) | YES |  |  |
| 100 | sys_zip | VARCHAR(5) | YES |  |  |
| 101 | sys_zip_4 | VARCHAR(4) | YES |  |  |
| 102 | spo_street_1 | VARCHAR(24) | YES |  |  |
| 103 | spo_street_2 | VARCHAR(24) | YES |  |  |
| 104 | spo_city | VARCHAR(18) | YES |  |  |
| 105 | spo_state | VARCHAR(2) | YES |  |  |
| 106 | spo_zip_4 | VARCHAR(4) | YES |  |  |
| 107 | spo_no_financial | VARCHAR(1) | YES |  |  |
| 108 | spo_mail_retail_flag | VARCHAR(1) | YES |  |  |
| 109 | group_city | VARCHAR(18) | YES |  |  |
| 110 | group_state | VARCHAR(2) | YES |  |  |
| 111 | spo_zip | VARCHAR(5) | YES |  |  |
| 112 | acct_type | VARCHAR(50) | YES |  |  |
| 113 | system_t_off_cycle | VARCHAR(1) | YES |  |  |
| 114 | physician_code_option | VARCHAR(1) | YES |  |  |
| 115 | dependent_elig_option | VARCHAR(1) | YES |  |  |
| 116 | valid_birth_option | VARCHAR(1) | YES |  |  |
| 117 | cardholder_number_flag | VARCHAR(1) | YES |  |  |
| 118 | accum_process | VARCHAR(1) | YES |  |  |
| 119 | broker | VARCHAR(12) | YES |  |  |
| 120 | system_client_type | VARCHAR(5) | YES |  |  |
| 121 | sponsor_account_type | VARCHAR(10) | YES |  |  |
| 122 | in_patch | VARCHAR(1) | YES |  |  |
| 123 | network_1 | BIGINT | YES |  |  |
| 124 | network_effective_1 | DATE | YES |  |  |
| 125 | network_term_1 | DATE | YES |  |  |
| 126 | network_2 | BIGINT | YES |  |  |
| 127 | network_effective_2 | DATE | YES |  |  |
| 128 | network_term_2 | DATE | YES |  |  |
| 129 | network_3 | BIGINT | YES |  |  |
| 130 | network_effective_3 | DATE | YES |  |  |
| 131 | network_term_3 | DATE | YES |  |  |
| 132 | network_4 | BIGINT | YES |  |  |
| 133 | network_effective_4 | DATE | YES |  |  |
| 134 | network_term_4 | DATE | YES |  |  |
| 135 | network_5 | BIGINT | YES |  |  |
| 136 | network_effective_5 | DATE | YES |  |  |
| 137 | network_term_5 | DATE | YES |  |  |
| 138 | network_6 | BIGINT | YES |  |  |
| 139 | network_effective_6 | DATE | YES |  |  |
| 140 | network_term_6 | DATE | YES |  |  |
| 141 | network_7 | BIGINT | YES |  |  |
| 142 | network_effective_7 | DATE | YES |  |  |
| 143 | network_term_7 | DATE | YES |  |  |
| 144 | network_8 | BIGINT | YES |  |  |
| 145 | network_effective_8 | DATE | YES |  |  |
| 146 | network_term_8 | DATE | YES |  |  |
| 147 | network_9 | BIGINT | YES |  |  |
| 148 | network_effective_9 | DATE | YES |  |  |
| 149 | network_term_9 | DATE | YES |  |  |
| 150 | network_10 | BIGINT | YES |  |  |
| 151 | network_effective_10 | DATE | YES |  |  |
| 152 | network_term_10 | DATE | YES |  |  |
| 153 | birth_month_flag | VARCHAR(2) | YES |  |  |
| 154 | mail_order_nabp_1 | BIGINT | YES |  |  |
| 155 | mail_order_eff_1 | DATE | YES |  |  |
| 156 | mail_order_nabp_2 | BIGINT | YES |  |  |
| 157 | mail_order_eff_2 | DATE | YES |  |  |
| 158 | mail_order_nabp_3 | BIGINT | YES |  |  |
| 159 | mail_order_eff_3 | DATE | YES |  |  |
| 160 | deduct_copay | BIGINT | YES |  |  |
| 161 | max_copay | BIGINT | YES |  |  |
| 162 | troop_copay | BIGINT | YES |  |  |
| 163 | rollover_date_2 | DATE | YES |  |  |
| 164 | rollover_date_3 | DATE | YES |  |  |
| 165 | rollover_date_4 | DATE | YES |  |  |
| 166 | rollover_date_5 | DATE | YES |  |  |
| 167 | rollover_date_6 | DATE | YES |  |  |
| 168 | rollover_date_7 | DATE | YES |  |  |
| 169 | rollover_date_8 | DATE | YES |  |  |
| 170 | rollover_date_9 | DATE | YES |  |  |
| 171 | rollover_date_10 | DATE | YES |  |  |
| 172 | rollover_date_1 | DATE | YES |  |  |
| 173 | disp_fee_eff_date_1 | DATE | YES |  |  |
| 174 | copay_eff_date_1 | DATE | YES |  |  |
| 175 | copay_number_1 | BIGINT | YES |  |  |
| 176 | copay_number_2 | BIGINT | YES |  |  |
| 177 | plan_eff_date_1 | DATE | YES |  |  |
| 178 | limit_kind_1 | VARCHAR(1) | YES |  |  |
| 179 | plan_number_2 | VARCHAR(8) | YES |  |  |
| 180 | limit_kind_2 | VARCHAR(1) | YES |  |  |
| 181 | plan_name | VARCHAR(30) | YES |  |  |
| 182 | limit_months | BIGINT | YES |  |  |
| 183 | limit_member | BIGINT | YES |  |  |
| 184 | group_street_2 | VARCHAR(40) | YES |  |  |
| 185 | dependent_eligibility | VARCHAR(1) | YES |  |  |
| 186 | deduct_copay_2 | BIGINT | YES |  |  |
| 187 | max_copay_2 | BIGINT | YES |  |  |
| 188 | limit_kind_3 | VARCHAR(1) | YES |  |  |
| 189 | deduct_copay_3 | BIGINT | YES |  |  |
| 190 | max_copay_3 | BIGINT | YES |  |  |
| 191 | limit_kind_4 | VARCHAR(1) | YES |  |  |
| 192 | deduct_copay_4 | BIGINT | YES |  |  |
| 193 | max_copay_4 | BIGINT | YES |  |  |
| 194 | limit_kind_5 | VARCHAR(1) | YES |  |  |
| 195 | deduct_copay_5 | BIGINT | YES |  |  |
| 196 | max_copay_5 | BIGINT | YES |  |  |
| 197 | limit_kind_6 | VARCHAR(1) | YES |  |  |
| 198 | deduct_copay_6 | BIGINT | YES |  |  |
| 199 | max_copay_6 | BIGINT | YES |  |  |
| 200 | limit_kind_7 | VARCHAR(1) | YES |  |  |
| 201 | deduct_copay_7 | BIGINT | YES |  |  |
| 202 | max_copay_7 | BIGINT | YES |  |  |
| 203 | limit_kind_8 | VARCHAR(1) | YES |  |  |
| 204 | deduct_copay_8 | BIGINT | YES |  |  |
| 205 | max_copay_8 | BIGINT | YES |  |  |
| 206 | limit_kind_9 | VARCHAR(1) | YES |  |  |
| 207 | deduct_copay_9 | BIGINT | YES |  |  |
| 208 | max_copay_9 | BIGINT | YES |  |  |
| 209 | limit_kind_10 | VARCHAR(1) | YES |  |  |
| 210 | deduct_copay_10 | BIGINT | YES |  |  |
| 211 | max_copay_10 | BIGINT | YES |  |  |
| 212 | dependent_age_limt_1 | BIGINT | YES |  |  |
| 213 | college_age_limit_1 | BIGINT | YES |  |  |
| 214 | disability_age_limit_1 | BIGINT | YES |  |  |
| 215 | special_age_limit_1 | BIGINT | YES |  |  |
| 216 | dependent_age_limit_2 | BIGINT | YES |  |  |
| 217 | college_age_limt_2 | BIGINT | YES |  |  |
| 218 | disability_age_limit_2 | BIGINT | YES |  |  |
| 219 | special_age_limit_2 | BIGINT | YES |  |  |
| 220 | dependent_age_limit_3 | BIGINT | YES |  |  |
| 221 | college_age_limit_3 | BIGINT | YES |  |  |
| 222 | disability_age_limit_3 | BIGINT | YES |  |  |
| 223 | special_age_limit_3 | BIGINT | YES |  |  |
| 224 | network_number_90_day | BIGINT | YES |  |  |
| 225 | option_flag_90_day | VARCHAR(1) | YES |  |  |
| 226 | sponsor_change | VARCHAR(15) | YES |  |  |
| 227 | age_date_cymd_1 | DATE | YES |  |  |
| 228 | age_date_cymd_2 | DATE | YES |  |  |
| 229 | age_date_cymd_3 | DATE | YES |  |  |
| 230 | ao_cymd_1 | DATE | YES |  |  |
| 231 | ao_number_1 | BIGINT | YES |  |  |
| 232 | ao_cymd_2 | DATE | YES |  |  |
| 233 | ao_number_2 | BIGINT | YES |  |  |
| 234 | ao_cymd_3 | DATE | YES |  |  |
| 235 | ao_number_3 | BIGINT | YES |  |  |
| 236 | ao_cymd_4 | DATE | YES |  |  |
| 237 | ao_number_4 | BIGINT | YES |  |  |
| 238 | ao_cymd_5 | DATE | YES |  |  |
| 239 | ao_number_5 | BIGINT | YES |  |  |
| 240 | back_bill_date | DATE | YES |  |  |
| 241 | back_bill_typ_code | VARCHAR(1) | YES |  |  |
| 242 | card_flag | VARCHAR(8) | YES |  |  |
| 243 | cards_single | BIGINT | YES |  |  |
| 244 | cards_family | BIGINT | YES |  |  |
| 245 | disp_fee_eff_date_2 | DATE | YES |  |  |
| 246 | disp_fee_eff_date_3 | DATE | YES |  |  |
| 247 | disp_schedule_number_1 | BIGINT | YES |  |  |
| 248 | disp_schedule_number_2 | BIGINT | YES |  |  |
| 249 | disp_schedule_number_3 | BIGINT | YES |  |  |
| 250 | drug_detail_flag | VARCHAR(1) | YES |  |  |
| 251 | pa_phone | VARCHAR(21) | YES |  |  |
| 252 | sub_flag | VARCHAR(1) | YES |  |  |
| 253 | troop_copay_2 | BIGINT | YES |  |  |
| 254 | troop_copay_3 | BIGINT | YES |  |  |
| 255 | troop_eff_date_1 | DATE | YES |  |  |
| 256 | troop_eff_date_2 | DATE | YES |  |  |
| 257 | troop_eff_date_3 | DATE | YES |  |  |
| 258 | year_roll_date_1 | DATE | YES |  |  |
| 259 | year_roll_date_2 | DATE | YES |  |  |
| 260 | year_roll_date_3 | DATE | YES |  |  |
| 261 | copay_eff_2 | DATE | YES |  |  |
| 262 | copay_eff_3 | DATE | YES |  |  |
| 263 | copay_eff_4 | DATE | YES |  |  |
| 264 | copay_eff_5 | DATE | YES |  |  |
| 265 | copay_eff_6 | DATE | YES |  |  |
| 266 | copay_eff_7 | DATE | YES |  |  |
| 267 | copay_eff_8 | DATE | YES |  |  |
| 268 | copay_eff_9 | DATE | YES |  |  |
| 269 | copay_eff_10 | DATE | YES |  |  |
| 270 | copay_num_3 | BIGINT | YES |  |  |
| 271 | copay_num_4 | BIGINT | YES |  |  |
| 272 | copay_num_5 | BIGINT | YES |  |  |
| 273 | copay_num_6 | BIGINT | YES |  |  |
| 274 | copay_num_7 | BIGINT | YES |  |  |
| 275 | copay_num_8 | BIGINT | YES |  |  |
| 276 | copay_num_9 | BIGINT | YES |  |  |
| 277 | copay_num_10 | BIGINT | YES |  |  |
| 278 | pos_tip | VARCHAR(1) | YES |  |  |
| 279 | ds_term_logic | VARCHAR(1) | YES |  |  |
| 280 | adm_eff_date_1 | DATE | YES |  |  |
| 281 | adm_schedule_number_1 | BIGINT | YES |  |  |
| 282 | adm_eff_date_2 | DATE | YES |  |  |
| 283 | adm_schedule_number_2 | BIGINT | YES |  |  |
| 284 | adm_eff_date_3 | DATE | YES |  |  |
| 285 | adm_schedule_number_3 | BIGINT | YES |  |  |
| 286 | adm_eff_date_4 | DATE | YES |  |  |
| 287 | adm_schedule_number_4 | BIGINT | YES |  |  |
| 288 | adm_eff_date_5 | DATE | YES |  |  |
| 289 | adm_schedule_number_5 | BIGINT | YES |  |  |
| 290 | tc_zip_flag | VARCHAR(1) | YES |  |  |
| 291 | broker_number_1 | VARCHAR(4) | YES |  |  |
| 292 | broker_eff_date_1 | DATE | YES |  |  |
| 293 | broker_number_2 | VARCHAR(4) | YES |  |  |
| 294 | broker_eff_date_2 | DATE | YES |  |  |
| 295 | broker_number_3 | VARCHAR(4) | YES |  |  |
| 296 | broker_eff_date_3 | DATE | YES |  |  |
| 297 | hospice_flag | VARCHAR(1) | YES |  |  |
| 298 | govt_reject | VARCHAR(1) | YES |  |  |
| 299 | medical_inb_accum_flag | VARCHAR(1) | YES |  |  |
| 300 | optimal_mac_flag | VARCHAR(1) | YES |  |  |
| 301 | sponsor_tpa | VARCHAR(4) | YES |  |  |
| 302 | ppap_nonguar_fund | VARCHAR(1) | YES |  |  |
| 303 | master_group_name | VARCHAR(30) | YES |  |  |
| 304 | sc_trans_date | DATE | YES |  |  |
| 305 | zip_4 | BIGINT | YES |  |  |
| 306 | plan_eff_date_2 | DATE | YES |  |  |
| 307 | plan_eff_date_3 | DATE | YES |  |  |
| 308 | plan_number_3 | VARCHAR(8) | YES |  |  |
| 309 | plan_eff_date_4 | DATE | YES |  |  |
| 310 | plan_number_4 | VARCHAR(8) | YES |  |  |
| 311 | plan_eff_date_5 | DATE | YES |  |  |
| 312 | plan_number_5 | VARCHAR(8) | YES |  |  |
| 313 | plan_eff_date_6 | DATE | YES |  |  |
| 314 | plan_number_6 | VARCHAR(8) | YES |  |  |
| 315 | plan_eff_date_7 | DATE | YES |  |  |
| 316 | plan_number_7 | VARCHAR(8) | YES |  |  |
| 317 | plan_eff_date_8 | DATE | YES |  |  |
| 318 | plan_number_8 | VARCHAR(8) | YES |  |  |
| 319 | plan_eff_date_9 | DATE | YES |  |  |
| 320 | plan_number_9 | VARCHAR(8) | YES |  |  |
| 321 | plan_eff_date_10 | DATE | YES |  |  |
| 322 | plan_number_10 | VARCHAR(8) | YES |  |  |
| 323 | rollover_date_11 | DATE | YES |  |  |
| 324 | rollover_date_12 | DATE | YES |  |  |
| 325 | rollover_date_13 | DATE | YES |  |  |
| 326 | rollover_date_14 | DATE | YES |  |  |
| 327 | rollover_date_15 | DATE | YES |  |  |
| 328 | rollover_date_16 | DATE | YES |  |  |
| 329 | rollover_date_17 | DATE | YES |  |  |
| 330 | rollover_date_18 | DATE | YES |  |  |
| 331 | benefit_code_2 | VARCHAR(16) | YES |  |  |
| 332 | benefit_code_3 | VARCHAR(16) | YES |  |  |
| 333 | benefit_code_4 | VARCHAR(16) | YES |  |  |
| 334 | benefit_code_5 | VARCHAR(16) | YES |  |  |
| 335 | cob_fee_flag | VARCHAR(1) | YES |  |  |
| 336 | flag_340b | VARCHAR(1) | YES |  |  |
| 337 | plan_number_1 | VARCHAR(8) | YES |  |  |
| 338 | entry_date | DATE | YES |  |  |
| 339 | change_date | DATE | YES |  |  |
| 340 | last_name_check | VARCHAR(1) | YES |  |  |
| 341 | add_id | VARCHAR(15) | YES |  |  |
| 342 | change_id | VARCHAR(15) | YES |  |  |
| 343 | max_single | NUMERIC(18, 2) | YES |  |  |
| 344 | max_family | NUMERIC(18, 2) | YES |  |  |
| 345 | deduct_single | NUMERIC(18, 2) | YES |  |  |
| 346 | deduct_family | NUMERIC(18, 2) | YES |  |  |
| 347 | formulary | BIGINT | YES |  |  |
| 348 | period_ending_date | DATE | YES |  |  |
| 349 | state_comp_source | VARCHAR(1) | YES |  |  |
| 350 | reject_260_flag | VARCHAR(1) | YES |  |  |
| 351 | grp_to_grp_x_walk | VARCHAR(1) | YES |  |  |
