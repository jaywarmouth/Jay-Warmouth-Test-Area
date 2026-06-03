-- =============================================
-- Table: cloud_data_warehouse.reject_data
-- Columns: 26
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.reject_data (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    reject_number BIGINT NOT NULL,
    desc_1 VARCHAR(40),
    desc_2 VARCHAR(40),
    reject_description VARCHAR(256),
    cost_savings_group VARCHAR(8),
    compu_32_x VARCHAR(2),
    compu_message VARCHAR(39),
    pt_master_seq VARCHAR(4),
    pt_error VARCHAR(2),
    active_code VARCHAR(1),
    exception_override VARCHAR(1),
    override_override VARCHAR(1),
    priority_code BIGINT,
    group_priority_code BIGINT,
    canadian_err_code VARCHAR(2),
    override_type_code BIGINT,
    compu_d0 VARCHAR(4),
    medd_569_rej_flag VARCHAR(4),
    mcet_override VARCHAR(1)
);
