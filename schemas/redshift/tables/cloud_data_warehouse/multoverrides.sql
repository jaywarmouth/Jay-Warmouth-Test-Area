-- =============================================
-- Table: cloud_data_warehouse.multoverrides
-- Columns: 23
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.multoverrides (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    cardholder_number VARCHAR(10),
    member_number VARCHAR(2),
    sponsor_number INTEGER,
    gpi VARCHAR(14),
    type_code INTEGER,
    eff_date TIMESTAMP,
    sequence_number INTEGER,
    term_date TIMESTAMP,
    prior_auth INTEGER,
    one_use VARCHAR(1),
    notes VARCHAR(50),
    time_hh_mm_ss VARCHAR(20),
    add_id VARCHAR(15),
    change_id VARCHAR(15),
    add_date TIMESTAMP,
    change_date TIMESTAMP
);
