-- =============================================
-- Table: cloud_data_warehouse.card_table
-- Columns: 16
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.card_table (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    ct_card_number_on_card VARCHAR(20),
    ct_system_number INTEGER,
    ct_sponsor_number INTEGER,
    ct_cardholder_number VARCHAR(14),
    ct_member_number VARCHAR(2),
    ct_card_seq_number INTEGER,
    ct_medical_id_number VARCHAR(20),
    ct_add_date DATE,
    ct_chg_date DATE
);
