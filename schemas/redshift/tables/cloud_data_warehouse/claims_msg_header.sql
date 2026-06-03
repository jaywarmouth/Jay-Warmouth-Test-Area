-- =============================================
-- Table: cloud_data_warehouse.claims_msg_header
-- Columns: 21
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.claims_msg_header (
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
    ver_number VARCHAR(2),
    trans_code VARCHAR(2),
    transaction_count VARCHAR(1),
    resp_status VARCHAR(1),
    provider_qualifier VARCHAR(2),
    pharmacy_number INTEGER,
    pharm_digit_7 INTEGER,
    npi VARCHAR(10),
    rx_date TIMESTAMP,
    message VARCHAR(200)
);
