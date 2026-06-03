-- =============================================
-- Table: cloud_data_warehouse.claimcompound
-- Columns: 31
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.claimcompound (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    batch_master VARCHAR(10) NOT NULL,
    claim_number INTEGER NOT NULL,
    ing_number INTEGER NOT NULL,
    ndc NUMERIC(11, 0),
    metric_quantity NUMERIC(18, 3),
    ing_cost_billed NUMERIC(18, 2),
    ing_bcd INTEGER,
    reject_code_1 INTEGER,
    reject_code_2 INTEGER,
    pdm_ing_cost NUMERIC(18, 2),
    awp_cost NUMERIC(18, 2),
    exception_code_1 INTEGER,
    exception_code_2 INTEGER,
    exception_code_3 INTEGER,
    exception_code_4 INTEGER,
    exception_code_5 INTEGER,
    generic_code VARCHAR(1),
    medd_drug_type VARCHAR(1),
    mac_reference_price NUMERIC(18, 2),
    contract_rate_price NUMERIC(18, 2),
    pde_ing_cost_paid NUMERIC(18, 2),
    ndc_type_code INTEGER,
    wac_reference_price NUMERIC(18, 2),
    claim_key VARCHAR(14)
);
