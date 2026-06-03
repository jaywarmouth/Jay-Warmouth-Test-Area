-- =============================================
-- Table: cloud_data_warehouse.drug_340b
-- Columns: 16
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.drug_340b (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    group_nbr FLOAT8,
    pharmacy_nbr INTEGER,
    ndc NUMERIC(11, 0),
    eff_date TIMESTAMP,
    unit_cost NUMERIC(18, 5),
    add_date TIMESTAMP,
    change_date TIMESTAMP,
    term_date TIMESTAMP,
    version_nbr VARCHAR(256)
);
