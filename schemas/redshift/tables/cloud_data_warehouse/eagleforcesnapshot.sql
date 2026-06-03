-- =============================================
-- Table: cloud_data_warehouse.eagleforcesnapshot
-- Columns: 36
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.eagleforcesnapshot (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    claim_key VARCHAR(14),
    batch_master VARCHAR(8),
    claim_number INTEGER,
    claim_type VARCHAR(1),
    bin VARCHAR(8),
    pcn VARCHAR(10),
    group_number FLOAT8,
    medication VARCHAR(12),
    date_of_service DATE,
    member_id VARCHAR(12),
    f_name VARCHAR(12),
    l_name VARCHAR(15),
    gender VARCHAR(1),
    dob DATE,
    address VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(2),
    zip VARCHAR(15),
    token VARCHAR(50),
    result VARCHAR(10),
    excep_code VARCHAR(10),
    info VARCHAR(200),
    pdmi_result VARCHAR(10),
    post_status VARCHAR(3),
    post_message VARCHAR(50),
    send_date DATE,
    receive_date DATE,
    add_date DATE,
    user_id VARCHAR(20)
);
