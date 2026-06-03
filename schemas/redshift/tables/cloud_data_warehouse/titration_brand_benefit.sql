-- =============================================
-- Table: cloud_data_warehouse.titration_brand_benefit
-- Columns: 27
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.titration_brand_benefit (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    titration_brand_id VARCHAR(20),
    ndcgpi VARCHAR(14),
    redemp_count_min INTEGER,
    redemp_count_max INTEGER,
    claim_cob CHAR(1),
    sequence_nbr INTEGER,
    days_between_flag CHAR(1),
    month_ben CHAR(1),
    days_between_min INTEGER,
    days_between_max INTEGER,
    copay NUMERIC(18, 2),
    max_claim_amt NUMERIC(18, 2),
    reject_code INTEGER,
    eff_date TIMESTAMP,
    term_date TIMESTAMP,
    titration_type CHAR(1),
    add_id VARCHAR(15),
    change_id VARCHAR(15),
    add_date TIMESTAMP,
    change_date TIMESTAMP
);
