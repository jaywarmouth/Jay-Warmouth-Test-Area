-- =============================================
-- Table: cloud_data_warehouse.rebate_admin_master
-- Columns: 25
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.rebate_admin_master (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    system_number BIGINT NOT NULL,
    sponsor_number BIGINT NOT NULL,
    group_number VARCHAR(20) NOT NULL,
    esi_contract VARCHAR(20) NOT NULL,
    fee_type VARCHAR(6) NOT NULL,
    rec_type VARCHAR(10) NOT NULL,
    seq_no BIGINT NOT NULL,
    eff_date DATE,
    term_date DATE,
    pay_out_level VARCHAR(1),
    adm_fee_pay_rate NUMERIC(18, 2),
    percent_fee NUMERIC(18, 4),
    true_up VARCHAR(1),
    true_up_share VARCHAR(1),
    client_id VARCHAR(30),
    formulary_name VARCHAR(10),
    add_id VARCHAR(15),
    change_id VARCHAR(15)
);
