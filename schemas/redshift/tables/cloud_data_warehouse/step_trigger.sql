-- =============================================
-- Table: cloud_data_warehouse.step_trigger
-- Columns: 19
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.step_trigger (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    step_table_no INTEGER,
    primary_gpi VARCHAR(14),
    eff_date TIMESTAMP,
    term_date TIMESTAMP,
    pharm_message_1 VARCHAR(60),
    pharm_message_2 VARCHAR(60),
    brand_gen_ind VARCHAR(1),
    nbr_look_back_drugs INTEGER,
    max_age INTEGER,
    min_age INTEGER,
    add_date TIMESTAMP,
    change_date TIMESTAMP
);
