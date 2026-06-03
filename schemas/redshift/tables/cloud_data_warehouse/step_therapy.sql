-- =============================================
-- Table: cloud_data_warehouse.step_therapy
-- Columns: 21
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.step_therapy (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    step_number INTEGER,
    primary_gpi VARCHAR(14),
    step_gpi VARCHAR(14),
    number_of_days INTEGER,
    effective_date TIMESTAMP,
    termination_date TIMESTAMP,
    status CHAR(1),
    reject_number INTEGER,
    age INTEGER,
    age_g_l_flag VARCHAR(1),
    add_date TIMESTAMP,
    change_date TIMESTAMP,
    brand_generic_id VARCHAR(1),
    day_supply_duration INTEGER
);
