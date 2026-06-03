-- =============================================
-- Table: cloud_data_warehouse.onetmrb001
-- Columns: 24
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.onetmrb001 (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    claim_key VARCHAR(14),
    batch_nbr VARCHAR(8),
    claim_nbr INTEGER,
    sponsor_nbr INTEGER,
    last_name VARCHAR(14),
    first_name VARCHAR(12),
    birth_date TIMESTAMP,
    gender VARCHAR(1),
    zip VARCHAR(5),
    paid_flag VARCHAR(1),
    card_id VARCHAR(10),
    roll_date TIMESTAMP,
    orig_cardid VARCHAR(10),
    origmember_nbr VARCHAR(2),
    member_nbr VARCHAR(2),
    numberlessid_frompharm VARCHAR(18),
    date_modified TIMESTAMP
);
