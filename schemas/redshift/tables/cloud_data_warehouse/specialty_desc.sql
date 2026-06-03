-- =============================================
-- Table: cloud_data_warehouse.specialty_desc
-- Columns: 11
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.specialty_desc (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    table_id VARCHAR(8) NOT NULL,
    desc_1 VARCHAR(40),
    desc_2 VARCHAR(40),
    active_flag VARCHAR(1)
);
