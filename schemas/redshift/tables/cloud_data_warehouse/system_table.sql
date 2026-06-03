-- =============================================
-- Table: cloud_data_warehouse.system_table
-- Columns: 29
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.system_table (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    system_nbr INTEGER NOT NULL,
    system_name VARCHAR(30),
    address_1 VARCHAR(30),
    address_2 VARCHAR(30),
    city VARCHAR(18),
    state VARCHAR(2),
    zip VARCHAR(5),
    pa_phone VARCHAR(21),
    help_desk_phone VARCHAR(14),
    help_desk_fax VARCHAR(14),
    system_in VARCHAR(4),
    report_title VARCHAR(30),
    zip4 VARCHAR(4),
    system_link VARCHAR(5),
    active_code VARCHAR(1),
    state_code VARCHAR(2),
    benefit_code VARCHAR(1),
    rebate_flag VARCHAR(1),
    client_type VARCHAR(5),
    claim_bin_nbr INTEGER,
    entry_date DATE,
    change_date DATE
);
