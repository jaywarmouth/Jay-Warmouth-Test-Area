-- =============================================
-- Table: cloud_data_warehouse.titration_group
-- Columns: 21
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.titration_group (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    system_link VARCHAR(5),
    system_number INTEGER,
    sponsor_number INTEGER,
    group_number FLOAT8,
    sequence_number INTEGER,
    eff_date TIMESTAMP,
    term_date TIMESTAMP,
    data_type VARCHAR(3),
    titration_group_data VARCHAR(20),
    group_code VARCHAR(20),
    add_id VARCHAR(15),
    change_id VARCHAR(15),
    add_date TIMESTAMP,
    change_date TIMESTAMP
);
