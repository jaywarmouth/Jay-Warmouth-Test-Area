-- =============================================
-- Table: cloud_data_warehouse.rebate_admin
-- Columns: 18
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.rebate_admin (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    contract_id VARCHAR(20) NOT NULL,
    admin_fee_type VARCHAR(6) NOT NULL,
    eff_date DATE NOT NULL,
    term_date DATE NOT NULL,
    admin_fee NUMERIC(18, 2),
    notes VARCHAR(60),
    mfg_admin_fee NUMERIC(18, 2),
    client_id VARCHAR(30),
    formulary_name VARCHAR(10),
    add_id VARCHAR(15),
    change_id VARCHAR(15)
);
