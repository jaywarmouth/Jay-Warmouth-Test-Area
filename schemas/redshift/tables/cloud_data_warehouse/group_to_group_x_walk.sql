-- =============================================
-- Table: cloud_data_warehouse.group_to_group_x_walk
-- Columns: 16
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.group_to_group_x_walk (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    meta_iud_flg VARCHAR(256),
    sponsor_nbr INTEGER,
    compu_group VARCHAR(16),
    sequence_nbr INTEGER,
    group_nbr FLOAT8,
    eff_date TIMESTAMP,
    term_date TIMESTAMP,
    add_id VARCHAR(15),
    change_id VARCHAR(15),
    add_date TIMESTAMP,
    change_date TIMESTAMP
);
