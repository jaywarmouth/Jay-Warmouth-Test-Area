-- =============================================
-- Table: cloud_data_warehouse.multi_config_master
-- Columns: 20
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.multi_config_master (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    t_link VARCHAR(5),
    system_nbr INTEGER,
    sponsor_nbr INTEGER,
    rec_type VARCHAR(3),
    data_type VARCHAR(3),
    amt_type VARCHAR(3),
    sequence_number INTEGER,
    eff_date TIMESTAMP,
    term_date TIMESTAMP,
    add_id VARCHAR(15),
    change_id VARCHAR(15),
    add_date TIMESTAMP,
    change_date TIMESTAMP
);
