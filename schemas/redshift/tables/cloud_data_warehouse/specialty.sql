-- =============================================
-- Table: cloud_data_warehouse.specialty
-- Columns: 15
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.specialty (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    table_id VARCHAR(8) NOT NULL,
    gpi VARCHAR(14) NOT NULL,
    eff_date DATE,
    term_date DATE,
    lim_dist_flag VARCHAR(1),
    brand_gen_id VARCHAR(1),
    add_id VARCHAR(15),
    change_id VARCHAR(15)
);
