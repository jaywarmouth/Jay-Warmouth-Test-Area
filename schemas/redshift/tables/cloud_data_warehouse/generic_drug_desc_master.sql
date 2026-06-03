-- =============================================
-- Table: cloud_data_warehouse.generic_drug_desc_master
-- Columns: 21
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.generic_drug_desc_master (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    drug_status_code VARCHAR(1),
    drug_status_code_name VARCHAR(30),
    desc_1 VARCHAR(40),
    desc_2 VARCHAR(40),
    desc_3 VARCHAR(40),
    desc_4 VARCHAR(40),
    field_notes_1 VARCHAR(30),
    field_notes_2 VARCHAR(30),
    formulary_flag VARCHAR(1),
    maintenance_flag VARCHAR(1),
    drug_status_flag VARCHAR(1),
    ndc_exclusion_flag VARCHAR(1),
    add_date TIMESTAMP,
    change_date TIMESTAMP
);
