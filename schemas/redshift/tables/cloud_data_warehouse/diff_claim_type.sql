-- =============================================
-- Table: cloud_data_warehouse.diff_claim_type
-- Columns: 11
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.diff_claim_type (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    claim_type VARCHAR(6),
    message_type_descr VARCHAR(50),
    add_date TIMESTAMP,
    change_date TIMESTAMP
);
