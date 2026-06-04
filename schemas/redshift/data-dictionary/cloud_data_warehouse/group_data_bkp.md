# cloud_data_warehouse.group_data_bkp

> **Schema:** cloud_data_warehouse | **Columns:** 344

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
| 34 | formulary | INTEGER | YES |  |  |
| 35 | plan_key | VARCHAR(12) | YES |  |  |
| 36 | sub_group | INTEGER | YES |  |  |
| 37 | formulary_structure | VARCHAR(1) | YES |  |  |
| 38 | active_system | VARCHAR(1) | YES |  |  |
| 39 | odaw_1_fixed_out | NUMERIC(18, 2) | YES |  |  |
| 40 | odaw_1_pct_out | NUMERIC(18, 4) | YES |  |  |
| 41 | odaw_2_fixed | NUMERIC(18, 2) | YES |  |  |
| 42 | odaw_2_pct | NUMERIC(18, 4) | YES |  |  |
| 43 | gen_fixed | NUMERIC(18, 2) | YES |  |  |
| 44 | gen_pct | NUMERIC(18, 4) | YES |  |  |
| 45 | np_fixed | NUMERIC(18, 2) | YES |  |  |
| 46 | np_pct | NUMERIC(18, 4) | YES |  |  |
| 47 | single_fixed | NUMERIC(18, 2) | YES |  |  |
| 48 | single_pct | NUMERIC(18, 4) | YES |  |  |
| 49 | brand_fixed | NUMERIC(18, 2) | YES |  |  |
| 50 | brand_pct | NUMERIC(18, 4) | YES |  |  |
| 51 | bc_fixed | NUMERIC(18, 2) | YES |  |  |
| 52 | bc_pct | NUMERIC(18, 4) | YES |  |  |
| 53 | depo_tc | BIGINT | YES |  |  |
| 54 | depo_fixed | NUMERIC(18, 2) | YES |  |  |
| 55 | inj_tc | BIGINT | YES |  |  |
| 56 | depo_pct | NUMERIC(18, 4) | YES |  |  |
| 57 | inj_fixed | NUMERIC(18, 2) | YES |  |  |
| 58 | inj_pct | NUMERIC(18, 4) | YES |  |  |
| 59 | split_tc | BIGINT | YES |  |  |
| 60 | split_fixed | NUMERIC(18, 2) | YES |  |  |
| 61 | split_pct | NUMERIC(18, 4) | YES |  |  |
| 62 | sys_link_description | VARCHAR(60) | YES |  |  |
| 63 | comp_tc | BIGINT | YES |  |  |
| 64 | comp_fixed | NUMERIC(18, 2) | YES |  |  |
| 65 | comp_pct | NUMERIC(18, 4) | YES |  |  |
| 66 | multi_tc | BIGINT | YES |  |  |
| 67 | multi_fixed | NUMERIC(18, 2) | YES |  |  |
| 68 | multi_pct | NUMERIC(18, 4) | YES |  |  |
| 69 | npbc_tc | BIGINT | YES |  |  |
| 70 | npbc_fixed | NUMERIC(18, 2) | YES |  |  |
| 71 | npbc_pct | NUMERIC(18, 4) | YES |  |  |
| 72 | np_daw_1_tc | BIGINT | YES |  |  |
| 73 | np_daw_1_fixed | NUMERIC(18, 2) | YES |  |  |
| 74 | np_daw_1_pct | NUMERIC(18, 4) | YES |  |  |
| 75 | np_daw_2_tc | BIGINT | YES |  |  |
| 76 | np_daw_2_fixed | NUMERIC(18, 2) | YES |  |  |
| 77 | np_daw_2_pct | NUMERIC(18, 4) | YES |  |  |
| 78 | npm_tc | BIGINT | YES |  |  |
| 79 | npm_fixed | NUMERIC(18, 2) | YES |  |  |
| 80 | npm_pct | NUMERIC(18, 4) | YES |  |  |
| 81 | npn_tc | BIGINT | YES |  |  |
| 82 | npn_fixed | NUMERIC(18, 2) | YES |  |  |
| 83 | npn_pct | NUMERIC(18, 4) | YES |  |  |
| 84 | odaw_3_tc | BIGINT | YES |  |  |
| 85 | odaw_3_fixed | NUMERIC(18, 2) | YES |  |  |
| 86 | odaw_3_pct | NUMERIC(18, 4) | YES |  |  |
| 87 | diff_flag | VARCHAR(1) | YES |  |  |
| 88 | diff_table_1 | BIGINT | YES |  |  |
| 89 | diff_eff_1 | DATE | YES |  |  |
| 90 | diff_ter_1 | DATE | YES |  |  |
| 91 | diff_table_2 | BIGINT | YES |  |  |
| 92 | diff_eff_2 | DATE | YES |  |  |
| 93 | diff_ter_2 | DATE | YES |  |  |
| 94 | diff_table_3 | BIGINT | YES |  |  |
| 95 | diff_eff_3 | DATE | YES |  |  |
| 96 | diff_ter_3 | DATE | YES |  |  |
| 97 | sys_street_1 | VARCHAR(30) | YES |  |  |
| 98 | sys_street_2 | VARCHAR(30) | YES |  |  |
| 99 | sys_city | VARCHAR(18) | YES |  |  |
| 100 | sys_state | VARCHAR(2) | YES |  |  |
| 101 | sys_zip | VARCHAR(5) | YES |  |  |
| 102 | sys_zip_4 | VARCHAR(4) | YES |  |  |
| 103 | spo_street_1 | VARCHAR(24) | YES |  |  |
| 104 | spo_street_2 | VARCHAR(24) | YES |  |  |
| 105 | spo_city | VARCHAR(18) | YES |  |  |
| 106 | spo_state | VARCHAR(2) | YES |  |  |
| 107 | spo_zip_4 | VARCHAR(4) | YES |  |  |
| 108 | spo_no_financial | VARCHAR(1) | YES |  |  |
| 109 | spo_mail_retail_flag | VARCHAR(1) | YES |  |  |
| 110 | group_city | VARCHAR(18) | YES |  |  |
| 111 | group_state | VARCHAR(2) | YES |  |  |
| 112 | spo_zip | VARCHAR(5) | YES |  |  |
| 113 | acct_type | VARCHAR(50) | YES |  |  |
| 114 | system_t_off_cycle | VARCHAR(1) | YES |  |  |
| 115 | physician_code_option | VARCHAR(1) | YES |  |  |
| 116 | dependent_elig_option | VARCHAR(1) | YES |  |  |
| 117 | valid_birth_option | VARCHAR(1) | YES |  |  |
| 118 | cardholder_number_flag | VARCHAR(1) | YES |  |  |
| 119 | accum_process | VARCHAR(1) | YES |  |  |
| 120 | broker | VARCHAR(12) | YES |  |  |
| 121 | system_client_type | VARCHAR(5) | YES |  |  |
| 122 | sponsor_account_type | VARCHAR(10) | YES |  |  |
| 123 | in_patch | VARCHAR(1) | YES |  |  |
| 124 | network_1 | BIGINT | YES |  |  |
| 125 | network_effective_1 | DATE | YES |  |  |
| 126 | network_term_1 | DATE | YES |  |  |
| 127 | network_2 | BIGINT | YES |  |  |
| 128 | network_effective_2 | DATE | YES |  |  |
| 129 | network_term_2 | DATE | YES |  |  |
| 130 | network_3 | BIGINT | YES |  |  |
| 131 | network_effective_3 | DATE | YES |  |  |
| 132 | network_term_3 | DATE | YES |  |  |
| 133 | network_4 | BIGINT | YES |  |  |
| 134 | network_effective_4 | DATE | YES |  |  |
| 135 | network_term_4 | DATE | YES |  |  |
| 136 | network_5 | BIGINT | YES |  |  |
| 137 | network_effective_5 | DATE | YES |  |  |
| 138 | network_term_5 | DATE | YES |  |  |
| 139 | network_6 | BIGINT | YES |  |  |
| 140 | network_effective_6 | DATE | YES |  |  |
| 141 | network_term_6 | DATE | YES |  |  |
| 142 | network_7 | BIGINT | YES |  |  |
| 143 | network_effective_7 | DATE | YES |  |  |
| 144 | network_term_7 | DATE | YES |  |  |
| 145 | network_8 | BIGINT | YES |  |  |
| 146 | network_effective_8 | DATE | YES |  |  |
| 147 | network_term_8 | DATE | YES |  |  |
| 148 | network_9 | BIGINT | YES |  |  |
| 149 | network_effective_9 | DATE | YES |  |  |
| 150 | network_term_9 | DATE | YES |  |  |
| 151 | network_10 | BIGINT | YES |  |  |
| 152 | network_effective_10 | DATE | YES |  |  |
| 153 | network_term_10 | DATE | YES |  |  |
| 154 | birth_month_flag | VARCHAR(2) | YES |  |  |
| 155 | mail_order_nabp_1 | BIGINT | YES |  |  |
| 156 | mail_order_eff_1 | DATE | YES |  |  |
| 157 | mail_order_nabp_2 | BIGINT | YES |  |  |
| 158 | mail_order_eff_2 | DATE | YES |  |  |
| 159 | mail_order_nabp_3 | BIGINT | YES |  |  |
| 160 | mail_order_eff_3 | DATE | YES |  |  |
| 161 | deduct_copay | BIGINT | YES |  |  |
| 162 | max_copay | BIGINT | YES |  |  |
| 163 | troop_copay | BIGINT | YES |  |  |
| 164 | rollover_date_2 | DATE | YES |  |  |
| 165 | rollover_date_3 | DATE | YES |  |  |
| 166 | rollover_date_4 | DATE | YES |  |  |
| 167 | rollover_date_5 | DATE | YES |  |  |
| 168 | rollover_date_6 | DATE | YES |  |  |
| 169 | rollover_date_7 | DATE | YES |  |  |
| 170 | rollover_date_8 | DATE | YES |  |  |
| 171 | rollover_date_9 | DATE | YES |  |  |
| 172 | rollover_date_10 | DATE | YES |  |  |
| 173 | rollover_date_1 | DATE | YES |  |  |
| 174 | disp_fee_eff_date_1 | DATE | YES |  |  |
| 175 | copay_eff_date_1 | DATE | YES |  |  |
| 176 | copay_number_1 | BIGINT | YES |  |  |
| 177 | copay_number_2 | BIGINT | YES |  |  |
| 178 | plan_eff_date_1 | DATE | YES |  |  |
| 179 | limit_kind_1 | VARCHAR(1) | YES |  |  |
| 180 | plan_number_2 | VARCHAR(4) | YES |  |  |
| 181 | limit_kind_2 | VARCHAR(1) | YES |  |  |
| 182 | plan_name | VARCHAR(30) | YES |  |  |
| 183 | max_single | BIGINT | YES |  |  |
| 184 | max_family | BIGINT | YES |  |  |
| 185 | deduct_single | BIGINT | YES |  |  |
| 186 | deduct_family | BIGINT | YES |  |  |
| 187 | limit_months | BIGINT | YES |  |  |
| 188 | limit_member | BIGINT | YES |  |  |
| 189 | group_street_2 | VARCHAR(40) | YES |  |  |
| 190 | dependent_eligibility | VARCHAR(1) | YES |  |  |
| 191 | deduct_copay_2 | BIGINT | YES |  |  |
| 192 | max_copay_2 | BIGINT | YES |  |  |
| 193 | limit_kind_3 | VARCHAR(1) | YES |  |  |
| 194 | deduct_copay_3 | BIGINT | YES |  |  |
| 195 | max_copay_3 | BIGINT | YES |  |  |
| 196 | limit_kind_4 | VARCHAR(1) | YES |  |  |
| 197 | deduct_copay_4 | BIGINT | YES |  |  |
| 198 | max_copay_4 | BIGINT | YES |  |  |
| 199 | limit_kind_5 | VARCHAR(1) | YES |  |  |
| 200 | deduct_copay_5 | BIGINT | YES |  |  |
| 201 | max_copay_5 | BIGINT | YES |  |  |
| 202 | limit_kind_6 | VARCHAR(1) | YES |  |  |
| 203 | deduct_copay_6 | BIGINT | YES |  |  |
| 204 | max_copay_6 | BIGINT | YES |  |  |
| 205 | limit_kind_7 | VARCHAR(1) | YES |  |  |
| 206 | deduct_copay_7 | BIGINT | YES |  |  |
| 207 | max_copay_7 | BIGINT | YES |  |  |
| 208 | limit_kind_8 | VARCHAR(1) | YES |  |  |
| 209 | deduct_copay_8 | BIGINT | YES |  |  |
| 210 | max_copay_8 | BIGINT | YES |  |  |
| 211 | limit_kind_9 | VARCHAR(1) | YES |  |  |
| 212 | deduct_copay_9 | BIGINT | YES |  |  |
| 213 | max_copay_9 | BIGINT | YES |  |  |
| 214 | limit_kind_10 | VARCHAR(1) | YES |  |  |
| 215 | deduct_copay_10 | BIGINT | YES |  |  |
| 216 | max_copay_10 | BIGINT | YES |  |  |
| 217 | dependent_age_limt_1 | BIGINT | YES |  |  |
| 218 | college_age_limit_1 | BIGINT | YES |  |  |
| 219 | disability_age_limit_1 | BIGINT | YES |  |  |
| 220 | special_age_limit_1 | BIGINT | YES |  |  |
| 221 | dependent_age_limit_2 | BIGINT | YES |  |  |
| 222 | college_age_limt_2 | BIGINT | YES |  |  |
| 223 | disability_age_limit_2 | BIGINT | YES |  |  |
| 224 | special_age_limit_2 | BIGINT | YES |  |  |
| 225 | dependent_age_limit_3 | BIGINT | YES |  |  |
| 226 | college_age_limit_3 | BIGINT | YES |  |  |
| 227 | disability_age_limit_3 | BIGINT | YES |  |  |
| 228 | special_age_limit_3 | BIGINT | YES |  |  |
| 229 | network_number_90_day | BIGINT | YES |  |  |
| 230 | option_flag_90_day | VARCHAR(1) | YES |  |  |
| 231 | sponsor_change | VARCHAR(15) | YES |  |  |
| 232 | age_date_cymd_1 | DATE | YES |  |  |
| 233 | age_date_cymd_2 | DATE | YES |  |  |
| 234 | age_date_cymd_3 | DATE | YES |  |  |
| 235 | ao_cymd_1 | DATE | YES |  |  |
| 236 | ao_number_1 | BIGINT | YES |  |  |
| 237 | ao_cymd_2 | DATE | YES |  |  |
| 238 | ao_number_2 | BIGINT | YES |  |  |
| 239 | ao_cymd_3 | DATE | YES |  |  |
| 240 | ao_number_3 | BIGINT | YES |  |  |
| 241 | ao_cymd_4 | DATE | YES |  |  |
| 242 | ao_number_4 | BIGINT | YES |  |  |
| 243 | ao_cymd_5 | DATE | YES |  |  |
| 244 | ao_number_5 | BIGINT | YES |  |  |
| 245 | back_bill_date | DATE | YES |  |  |
| 246 | back_bill_typ_code | VARCHAR(1) | YES |  |  |
| 247 | card_flag | VARCHAR(8) | YES |  |  |
| 248 | cards_single | BIGINT | YES |  |  |
| 249 | cards_family | BIGINT | YES |  |  |
| 250 | disp_fee_eff_date_2 | DATE | YES |  |  |
| 251 | disp_fee_eff_date_3 | DATE | YES |  |  |
| 252 | disp_schedule_number_1 | BIGINT | YES |  |  |
| 253 | disp_schedule_number_2 | BIGINT | YES |  |  |
| 254 | disp_schedule_number_3 | BIGINT | YES |  |  |
| 255 | drug_detail_flag | VARCHAR(1) | YES |  |  |
| 256 | pa_phone | VARCHAR(21) | YES |  |  |
| 257 | sub_flag | VARCHAR(1) | YES |  |  |
| 258 | troop_copay_2 | BIGINT | YES |  |  |
| 259 | troop_copay_3 | BIGINT | YES |  |  |
| 260 | troop_eff_date_1 | DATE | YES |  |  |
| 261 | troop_eff_date_2 | DATE | YES |  |  |
| 262 | troop_eff_date_3 | DATE | YES |  |  |
| 263 | year_roll_date_1 | DATE | YES |  |  |
| 264 | year_roll_date_2 | DATE | YES |  |  |
| 265 | year_roll_date_3 | DATE | YES |  |  |
| 266 | copay_eff_2 | DATE | YES |  |  |
| 267 | copay_eff_3 | DATE | YES |  |  |
| 268 | copay_eff_4 | DATE | YES |  |  |
| 269 | copay_eff_5 | DATE | YES |  |  |
| 270 | copay_eff_6 | DATE | YES |  |  |
| 271 | copay_eff_7 | DATE | YES |  |  |
| 272 | copay_eff_8 | DATE | YES |  |  |
| 273 | copay_eff_9 | DATE | YES |  |  |
| 274 | copay_eff_10 | DATE | YES |  |  |
| 275 | copay_num_3 | BIGINT | YES |  |  |
| 276 | copay_num_4 | BIGINT | YES |  |  |
| 277 | copay_num_5 | BIGINT | YES |  |  |
| 278 | copay_num_6 | BIGINT | YES |  |  |
| 279 | copay_num_7 | BIGINT | YES |  |  |
| 280 | copay_num_8 | BIGINT | YES |  |  |
| 281 | copay_num_9 | BIGINT | YES |  |  |
| 282 | copay_num_10 | BIGINT | YES |  |  |
| 283 | pos_tip | VARCHAR(1) | YES |  |  |
| 284 | ds_term_logic | VARCHAR(1) | YES |  |  |
| 285 | adm_eff_date_1 | DATE | YES |  |  |
| 286 | adm_schedule_number_1 | BIGINT | YES |  |  |
| 287 | adm_eff_date_2 | DATE | YES |  |  |
| 288 | adm_schedule_number_2 | BIGINT | YES |  |  |
| 289 | adm_eff_date_3 | DATE | YES |  |  |
| 290 | adm_schedule_number_3 | BIGINT | YES |  |  |
| 291 | adm_eff_date_4 | DATE | YES |  |  |
| 292 | adm_schedule_number_4 | BIGINT | YES |  |  |
| 293 | adm_eff_date_5 | DATE | YES |  |  |
| 294 | adm_schedule_number_5 | BIGINT | YES |  |  |
| 295 | tc_zip_flag | VARCHAR(1) | YES |  |  |
| 296 | broker_number_1 | VARCHAR(4) | YES |  |  |
| 297 | broker_eff_date_1 | DATE | YES |  |  |
| 298 | broker_number_2 | VARCHAR(4) | YES |  |  |
| 299 | broker_eff_date_2 | DATE | YES |  |  |
| 300 | broker_number_3 | VARCHAR(4) | YES |  |  |
| 301 | broker_eff_date_3 | DATE | YES |  |  |
| 302 | hospice_flag | VARCHAR(1) | YES |  |  |
| 303 | govt_reject | VARCHAR(1) | YES |  |  |
| 304 | medical_inb_accum_flag | VARCHAR(1) | YES |  |  |
| 305 | optimal_mac_flag | VARCHAR(1) | YES |  |  |
| 306 | sponsor_tpa | VARCHAR(4) | YES |  |  |
| 307 | ppap_nonguar_fund | VARCHAR(1) | YES |  |  |
| 308 | master_group_name | VARCHAR(30) | YES |  |  |
| 309 | sc_trans_date | DATE | YES |  |  |
| 310 | zip_4 | BIGINT | YES |  |  |
| 311 | plan_eff_date_2 | DATE | YES |  |  |
| 312 | plan_eff_date_3 | DATE | YES |  |  |
| 313 | plan_number_3 | VARCHAR(4) | YES |  |  |
| 314 | plan_eff_date_4 | DATE | YES |  |  |
| 315 | plan_number_4 | VARCHAR(4) | YES |  |  |
| 316 | plan_eff_date_5 | DATE | YES |  |  |
| 317 | plan_number_5 | VARCHAR(4) | YES |  |  |
| 318 | plan_eff_date_6 | DATE | YES |  |  |
| 319 | plan_number_6 | VARCHAR(4) | YES |  |  |
| 320 | plan_eff_date_7 | DATE | YES |  |  |
| 321 | plan_number_7 | VARCHAR(4) | YES |  |  |
| 322 | plan_eff_date_8 | DATE | YES |  |  |
| 323 | plan_number_8 | VARCHAR(4) | YES |  |  |
| 324 | plan_eff_date_9 | DATE | YES |  |  |
| 325 | plan_number_9 | VARCHAR(4) | YES |  |  |
| 326 | plan_eff_date_10 | DATE | YES |  |  |
| 327 | plan_number_10 | VARCHAR(4) | YES |  |  |
| 328 | rollover_date_11 | DATE | YES |  |  |
| 329 | rollover_date_12 | DATE | YES |  |  |
| 330 | rollover_date_13 | DATE | YES |  |  |
| 331 | rollover_date_14 | DATE | YES |  |  |
| 332 | rollover_date_15 | DATE | YES |  |  |
| 333 | rollover_date_16 | DATE | YES |  |  |
| 334 | rollover_date_17 | DATE | YES |  |  |
| 335 | rollover_date_18 | DATE | YES |  |  |
| 336 | benefit_code_2 | VARCHAR(16) | YES |  |  |
| 337 | benefit_code_3 | VARCHAR(16) | YES |  |  |
| 338 | benefit_code_4 | VARCHAR(16) | YES |  |  |
| 339 | benefit_code_5 | VARCHAR(16) | YES |  |  |
| 340 | cob_fee_flag | VARCHAR(1) | YES |  |  |
| 341 | flag_340b | VARCHAR(1) | YES |  |  |
| 342 | plan_number_1 | VARCHAR(4) | YES |  |  |
| 343 | entry_date | DATE | YES |  |  |
| 344 | change_date | DATE | YES |  |  |
