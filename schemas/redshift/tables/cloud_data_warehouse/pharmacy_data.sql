-- =============================================
-- Table: cloud_data_warehouse.pharmacy_data
-- Columns: 12
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.pharmacy_data (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    pharmacy_number BIGINT NOT NULL,
    pharmacy_name VARCHAR(100),
    city VARCHAR(18),
    state VARCHAR(2),
    zip VARCHAR(5)
);
