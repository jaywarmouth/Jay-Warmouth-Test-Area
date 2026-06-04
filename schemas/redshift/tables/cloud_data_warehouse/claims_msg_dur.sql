-- =============================================
-- Table: cloud_data_warehouse.claims_msg_dur
-- Columns: 20
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.claims_msg_dur (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    batch_master VARCHAR(8),
    claim_number INTEGER,
    segment_id VARCHAR(4),
    seq_id INTEGER,
    conflict_code VARCHAR(2),
    severity INTEGER,
    other_pharmacy INTEGER,
    prev_fill_date TIMESTAMP,
    prev_met_quan NUMERIC(18, 3),
    database_ind VARCHAR(1),
    other_prescri INTEGER,
    free_text VARCHAR(30),
    add_text VARCHAR(100)
);
