-- =============================================
-- Table: cloud_data_warehouse.reject_msg
-- Columns: 24
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.reject_msg (
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
    occ INTEGER,
    reject_code INTEGER,
    sequence_number INTEGER,
    eff_date TIMESTAMP,
    term_date TIMESTAMP,
    primary_resp_msg VARCHAR(200),
    sec_resp_msg VARCHAR(200),
    alt_pa_phone VARCHAR(10),
    unknown_column VARCHAR(10),
    add_id VARCHAR(15),
    change_id VARCHAR(15),
    add_date TIMESTAMP,
    change_date TIMESTAMP
);
