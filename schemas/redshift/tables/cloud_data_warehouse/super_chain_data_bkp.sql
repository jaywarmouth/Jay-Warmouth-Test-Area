-- =============================================
-- Table: cloud_data_warehouse.super_chain_data_bkp
-- Columns: 10
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.super_chain_data_bkp (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    primary_chain_number VARCHAR(3),
    super_chain VARCHAR(255),
    super_chain_name VARCHAR(255)
);
