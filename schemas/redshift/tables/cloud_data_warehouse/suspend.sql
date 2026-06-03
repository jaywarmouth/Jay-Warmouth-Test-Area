-- =============================================
-- Table: cloud_data_warehouse.suspend
-- Columns: 25
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.suspend (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    system_number INTEGER,
    sponsor_number INTEGER,
    group_number FLOAT8,
    period_ending DATE,
    alt_group_number VARCHAR(20),
    invoice_amount FLOAT8,
    claim_count INTEGER,
    grp_invoice_number INTEGER,
    spo_invoice_number INTEGER,
    sys_invoice_number INTEGER,
    release_flag VARCHAR(1),
    paid_date DATE,
    differential_amount NUMERIC(12, 2),
    admin_fee FLOAT8,
    manual_date DATE,
    file_date DATE,
    release_date DATE,
    deposit_date DATE
);
