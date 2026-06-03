-- =============================================
-- Table: cloud_data_warehouse.generic_table
-- Columns: 10
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.generic_table (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    generic_table_number BIGINT NOT NULL,
    gpi VARCHAR(14) NOT NULL,
    drug_status VARCHAR(1)
);
