-- =============================================
-- Table: cloud_data_warehouse.step_trigger_description
-- Columns: 31
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.step_trigger_description (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    step_trigger_table INTEGER,
    description VARCHAR(40),
    active_flag VARCHAR(1),
    associated_flag VARCHAR(1),
    associated_generic_table_1 INTEGER,
    associated_generic_table_2 INTEGER,
    associated_generic_table_3 INTEGER,
    associated_generic_table_4 INTEGER,
    associated_generic_table_5 INTEGER,
    associated_generic_table_6 INTEGER,
    associated_generic_table_7 INTEGER,
    associated_generic_table_8 INTEGER,
    associated_generic_table_9 INTEGER,
    associated_generic_table_10 INTEGER,
    associated_generic_table_11 INTEGER,
    associated_generic_table_12 INTEGER,
    associated_generic_table_13 INTEGER,
    associated_generic_table_14 INTEGER,
    associated_generic_table_15 INTEGER,
    associated_generic_table_16 INTEGER,
    associated_generic_table_17 INTEGER,
    associated_generic_table_18 INTEGER,
    associated_generic_table_19 INTEGER,
    associated_generic_table_20 INTEGER
);
