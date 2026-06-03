# cloud_data_warehouse.sponsor_tpa

> **Schema:** cloud_data_warehouse | **Columns:** 101

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
| 8 | system_number | INTEGER | YES |  |  |
| 9 | sponsor_number | INTEGER | YES |  |  |
| 10 | group_number | BIGINT | YES |  |  |
| 11 | type | INTEGER | YES |  |  |
| 12 | sequence_number | INTEGER | YES |  |  |
| 13 | eff_date | TIMESTAMP | YES |  |  |
| 14 | term_date | TIMESTAMP | YES |  |  |
| 15 | tpa | VARCHAR(4) | YES |  |  |
| 16 | client_id | VARCHAR(4) | YES |  |  |
| 17 | cycle | CHAR(1) | YES |  |  |
| 18 | data_file_name | VARCHAR(20) | YES |  |  |
| 19 | otd_index | INTEGER | YES |  |  |
| 20 | test_mode_path | VARCHAR(20) | YES |  |  |
| 21 | prod_mode_path | VARCHAR(20) | YES |  |  |
| 22 | id_card_mask01 | VARCHAR(20) | YES |  |  |
| 23 | id_card_mask01_len | INTEGER | YES |  |  |
| 24 | id_card_mask01_leno | INTEGER | YES |  |  |
| 25 | id_card_mask02 | VARCHAR(20) | YES |  |  |
| 26 | id_card_mask02_len | INTEGER | YES |  |  |
| 27 | id_card_mask02_leno | INTEGER | YES |  |  |
| 28 | id_card_mask03 | VARCHAR(20) | YES |  |  |
| 29 | id_card_mask03_len | INTEGER | YES |  |  |
| 30 | id_card_mask03_leno | INTEGER | YES |  |  |
| 31 | id_card_mask04 | VARCHAR(20) | YES |  |  |
| 32 | id_card_mask04_len | INTEGER | YES |  |  |
| 33 | id_card_mask04_leno | INTEGER | YES |  |  |
| 34 | id_card_mask05 | VARCHAR(20) | YES |  |  |
| 35 | id_card_mask05_len | INTEGER | YES |  |  |
| 36 | id_card_mask05_leno | INTEGER | YES |  |  |
| 37 | id_card_mask06 | VARCHAR(20) | YES |  |  |
| 38 | id_card_mask06_len | INTEGER | YES |  |  |
| 39 | id_card_mask06_leno | INTEGER | YES |  |  |
| 40 | id_card_mask07 | VARCHAR(20) | YES |  |  |
| 41 | id_card_mask07_len | INTEGER | YES |  |  |
| 42 | id_card_mask07_leno | INTEGER | YES |  |  |
| 43 | id_card_mask08 | VARCHAR(20) | YES |  |  |
| 44 | id_card_mask08_len | INTEGER | YES |  |  |
| 45 | id_card_mask08_leno | INTEGER | YES |  |  |
| 46 | id_card_mask09 | VARCHAR(20) | YES |  |  |
| 47 | id_card_mask09_len | INTEGER | YES |  |  |
| 48 | id_card_mask09_leno | INTEGER | YES |  |  |
| 49 | id_card_mask10 | VARCHAR(20) | YES |  |  |
| 50 | id_card_mask10_len | INTEGER | YES |  |  |
| 51 | id_card_mask10_leno | INTEGER | YES |  |  |
| 52 | id_card_mask11 | VARCHAR(20) | YES |  |  |
| 53 | id_card_mask11_len | INTEGER | YES |  |  |
| 54 | id_card_mask11_leno | INTEGER | YES |  |  |
| 55 | id_card_mask12 | VARCHAR(20) | YES |  |  |
| 56 | id_card_mask12_len | INTEGER | YES |  |  |
| 57 | id_card_mask12_leno | INTEGER | YES |  |  |
| 58 | id_card_mask13 | VARCHAR(20) | YES |  |  |
| 59 | id_card_mask13_len | INTEGER | YES |  |  |
| 60 | id_card_mask13_leno | INTEGER | YES |  |  |
| 61 | id_card_mask14 | VARCHAR(20) | YES |  |  |
| 62 | id_card_mask14_len | INTEGER | YES |  |  |
| 63 | id_card_mask14_leno | INTEGER | YES |  |  |
| 64 | id_card_mask15 | VARCHAR(20) | YES |  |  |
| 65 | id_card_mask15_len | INTEGER | YES |  |  |
| 66 | id_card_mask15_leno | INTEGER | YES |  |  |
| 67 | id_card_mask16 | VARCHAR(20) | YES |  |  |
| 68 | id_card_mask16_len | INTEGER | YES |  |  |
| 69 | id_card_mask16_leno | INTEGER | YES |  |  |
| 70 | id_card_mask17 | VARCHAR(20) | YES |  |  |
| 71 | id_card_mask17_len | INTEGER | YES |  |  |
| 72 | id_card_mask17_leno | INTEGER | YES |  |  |
| 73 | id_card_mask18 | VARCHAR(20) | YES |  |  |
| 74 | id_card_mask18_len | INTEGER | YES |  |  |
| 75 | id_card_mask18_leno | INTEGER | YES |  |  |
| 76 | id_card_mask19 | VARCHAR(20) | YES |  |  |
| 77 | id_card_mask19_len | INTEGER | YES |  |  |
| 78 | id_card_mask19_leno | INTEGER | YES |  |  |
| 79 | id_card_mask20 | VARCHAR(20) | YES |  |  |
| 80 | id_card_mask20_len | INTEGER | YES |  |  |
| 81 | id_card_mask20_leno | INTEGER | YES |  |  |
| 82 | id_card_mask21 | VARCHAR(20) | YES |  |  |
| 83 | id_card_mask21_len | INTEGER | YES |  |  |
| 84 | id_card_mask21_leno | INTEGER | YES |  |  |
| 85 | id_card_mask22 | VARCHAR(20) | YES |  |  |
| 86 | id_card_mask22_len | INTEGER | YES |  |  |
| 87 | id_card_mask22_leno | INTEGER | YES |  |  |
| 88 | id_card_mask23 | VARCHAR(20) | YES |  |  |
| 89 | id_card_mask23_len | INTEGER | YES |  |  |
| 90 | id_card_mask23_leno | INTEGER | YES |  |  |
| 91 | id_card_mask24 | VARCHAR(20) | YES |  |  |
| 92 | id_card_mask24_len | INTEGER | YES |  |  |
| 93 | id_card_mask24_leno | INTEGER | YES |  |  |
| 94 | id_card_mask25 | VARCHAR(20) | YES |  |  |
| 95 | id_card_mask25_len | INTEGER | YES |  |  |
| 96 | id_card_mask25_leno | INTEGER | YES |  |  |
| 97 | eof_ov_excep_flag | CHAR(1) | YES |  |  |
| 98 | add_id | VARCHAR(15) | YES |  |  |
| 99 | change_id | VARCHAR(15) | YES |  |  |
| 100 | add_date | TIMESTAMP | YES |  |  |
| 101 | change_date | TIMESTAMP | YES |  |  |
