-- =============================================
-- Table: cloud_data_warehouse.state_comp_config
-- Columns: 21
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.state_comp_config (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt DATE,
    meta_eff_end_dt DATE,
    meta_curr_ind VARCHAR(2),
    system_link VARCHAR(5),
    system_number INTEGER,
    sponsor_number INTEGER,
    group_number INTEGER,
    state_id VARCHAR(2),
    rec_type VARCHAR(3),
    seq_nbr INTEGER,
    date_type VARCHAR(2),
    eff_date DATE,
    term_date DATE,
    add_id VARCHAR(15),
    change_id VARCHAR(15),
    add_date DATE,
    change_date DATE
);
