-- =============================================
-- Table: cloud_data_warehouse.cms_hospice
-- Columns: 16
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.cms_hospice (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    pdm_group FLOAT8,
    layout VARCHAR(20),
    agency_id VARCHAR(20),
    vendor_id VARCHAR(20),
    eff_date TIMESTAMP,
    term_date TIMESTAMP,
    notes VARCHAR(40),
    add_date TIMESTAMP,
    change_date TIMESTAMP
);
