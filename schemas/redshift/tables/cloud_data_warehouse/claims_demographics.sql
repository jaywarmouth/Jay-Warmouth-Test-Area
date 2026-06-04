-- =============================================
-- Table: cloud_data_warehouse.claims_demographics
-- Columns: 16
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.claims_demographics (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    batch_number VARCHAR(8),
    claim_number INTEGER,
    patient_street VARCHAR(30),
    patient_city VARCHAR(20),
    patient_state VARCHAR(2),
    patient_zip_code VARCHAR(15),
    patient_phone_number VARCHAR(10),
    patient_card_id VARCHAR(20),
    claims_demographics_key VARCHAR(14)
);
