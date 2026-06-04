-- =============================================
-- Table: cloud_data_warehouse.card_range
-- Columns: 36
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.card_range (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    group_number FLOAT8,
    occurrence INTEGER,
    record_type VARCHAR(1),
    start_id_range VARCHAR(20),
    stop_id_range VARCHAR(20),
    cdv VARCHAR(5),
    eff_date TIMESTAMP,
    term_date TIMESTAMP,
    pdmi_group_number FLOAT8,
    member_number VARCHAR(2),
    call_to_activate VARCHAR(1),
    call_to_act_phone VARCHAR(12),
    pa_flag VARCHAR(1),
    pa_phone_number VARCHAR(12),
    last_num_used_numless VARCHAR(20),
    numless_eff_flag VARCHAR(1),
    numless_eff_days INTEGER,
    numless_ter_flag VARCHAR(1),
    numless_ter_days INTEGER,
    numless_1000_remaining_flag VARCHAR(1),
    numless_500_remaining_flag VARCHAR(1),
    numless_1000_remaining_date TIMESTAMP,
    numless_500_remaining_date TIMESTAMP,
    numless_range_added_flag VARCHAR(1),
    help_desk_phone VARCHAR(12),
    add_date TIMESTAMP,
    change_date TIMESTAMP,
    add_id VARCHAR(15),
    change_id VARCHAR(15)
);
