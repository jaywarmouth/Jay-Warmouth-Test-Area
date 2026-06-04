-- =============================================
-- Table: cloud_data_warehouse.step_therapy_description
-- Columns: 31
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.step_therapy_description (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    table_number INTEGER,
    table_name VARCHAR(40),
    active_code VARCHAR(1),
    generic_table_association_1 INTEGER,
    generic_table_association_2 INTEGER,
    generic_table_association_3 INTEGER,
    generic_table_association_4 INTEGER,
    generic_table_association_5 INTEGER,
    generic_table_association_6 INTEGER,
    generic_table_association_7 INTEGER,
    generic_table_association_8 INTEGER,
    generic_table_association_9 INTEGER,
    generic_table_association_10 INTEGER,
    generic_table_association_11 INTEGER,
    generic_table_association_12 INTEGER,
    generic_table_association_13 INTEGER,
    generic_table_association_14 INTEGER,
    generic_table_association_15 INTEGER,
    generic_table_association_16 INTEGER,
    generic_table_association_17 INTEGER,
    generic_table_association_18 INTEGER,
    generic_table_association_19 INTEGER,
    generic_table_association_20 INTEGER,
    association_flag VARCHAR(1)
);
