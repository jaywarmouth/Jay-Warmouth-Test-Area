-- =============================================
-- Table: cloud_data_warehouse.overrides_type_code_descriptions
-- Columns: 11
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.overrides_type_code_descriptions (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    type_code BIGINT NOT NULL,
    type_code_description VARCHAR(100),
    type_code_descr_ovr VARCHAR(100),
    override_disp VARCHAR(1)
);
