-- =============================================
-- Table: cloud_data_warehouse.titration_track
-- Columns: 29
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.titration_track (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    cardholder_number VARCHAR(10),
    member_number VARCHAR(2),
    sponsor_number INTEGER,
    ndc_gpi VARCHAR(14),
    sequence_nbr INTEGER,
    fill_number INTEGER,
    start_date TIMESTAMP,
    claim_key VARCHAR(14),
    paid_flag VARCHAR(1),
    rx_date TIMESTAMP,
    met_quantity NUMERIC(18, 3),
    claim_days_supply BIGINT,
    claim_ndc NUMERIC(11, 0),
    rules_breached VARCHAR(1),
    titration_type VARCHAR(1),
    days_between_min INTEGER,
    days_between_max INTEGER,
    add_id VARCHAR(15),
    change_id VARCHAR(15),
    add_date TIMESTAMP,
    change_date TIMESTAMP,
    cardholder_key VARCHAR(20)
);
