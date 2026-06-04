-- =============================================
-- Table: cloud_data_warehouse.roll_up_code_parm_master
-- Columns: 16
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.roll_up_code_parm_master (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    roll_up_code VARCHAR(20),
    sequence_number INTEGER,
    eff_date TIMESTAMP,
    term_date TIMESTAMP,
    plan_code VARCHAR(8),
    add_id VARCHAR(15),
    change_id VARCHAR(15),
    add_date TIMESTAMP,
    change_date TIMESTAMP
);
