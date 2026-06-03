-- =============================================
-- Table: cloud_data_warehouse.ndc_form_override_master
-- Columns: 35
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.ndc_form_override_master (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    ndc_id VARCHAR(8),
    ndc NUMERIC(11, 0),
    sequence_nbr INTEGER,
    eff_date TIMESTAMP,
    term_date TIMESTAMP,
    status_code_c VARCHAR(1),
    status_code VARCHAR(1),
    copay_sched_type_c VARCHAR(1),
    copay_sched_type VARCHAR(6),
    copay_nbr_c VARCHAR(1),
    copay_nbr INTEGER,
    days_supply_c VARCHAR(1),
    days_supply INTEGER,
    reimb_number_c VARCHAR(1),
    reimb_number INTEGER,
    reimb_sched_c VARCHAR(1),
    reimb_sched VARCHAR(6),
    skip_limit_c VARCHAR(1),
    skip_limit VARCHAR(1),
    return_msg_c VARCHAR(1),
    return_msg VARCHAR(39),
    addition_msg_c VARCHAR(1),
    addition_msg VARCHAR(200),
    reject_code_c VARCHAR(1),
    reject_code VARCHAR(4),
    comments VARCHAR(100),
    add_date TIMESTAMP,
    change_date TIMESTAMP
);
