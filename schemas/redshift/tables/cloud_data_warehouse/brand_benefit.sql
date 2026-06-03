-- =============================================
-- Table: cloud_data_warehouse.brand_benefit
-- Columns: 28
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.brand_benefit (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    brand_benefit_id VARCHAR(20),
    ndc_gpi VARCHAR(14),
    territory_id VARCHAR(8),
    oth_pay_rej_found VARCHAR(4),
    eff_date TIMESTAMP,
    redemp_count_min INTEGER,
    redemp_count_max INTEGER,
    cob VARCHAR(1),
    days_supply_min INTEGER,
    days_supply_max INTEGER,
    met_qty_min NUMERIC(18, 3),
    met_qty_max NUMERIC(18, 3),
    occurence INTEGER,
    copay NUMERIC(18, 2),
    max_claim_amt NUMERIC(18, 2),
    term_date TIMESTAMP,
    add_date TIMESTAMP,
    change_date TIMESTAMP,
    max_awp_wac_pct NUMERIC(18, 4),
    alt_reimb_gen_type VARCHAR(6),
    benefit_msg_flag VARCHAR(1)
);
