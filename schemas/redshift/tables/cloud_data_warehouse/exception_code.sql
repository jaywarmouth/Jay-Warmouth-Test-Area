-- =============================================
-- Table: cloud_data_warehouse.exception_code
-- Columns: 22
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.exception_code (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    exception_code INTEGER,
    desc_1 VARCHAR(40),
    desc_2 VARCHAR(40),
    desc_3 VARCHAR(40),
    desc_4 VARCHAR(40),
    desc_5 VARCHAR(40),
    desc_6 VARCHAR(40),
    system_specific VARCHAR(1),
    sponsor_specific VARCHAR(1),
    plan_specific VARCHAR(1),
    group_specific VARCHAR(1),
    pharm_specific VARCHAR(1),
    card_specific VARCHAR(1),
    drug_specific VARCHAR(1),
    active_code VARCHAR(1)
);
