-- =============================================
-- Table: cloud_data_warehouse.hcpcs_ndc_crosswalk_tmp
-- Columns: 18
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.hcpcs_ndc_crosswalk_tmp (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    hcspcscode VARCHAR(10),
    short_description VARCHAR(250),
    labeler_name VARCHAR(250),
    ndc_2 NUMERIC(11, 0),
    drug_name VARCHAR(250),
    hcpcs_dosage VARCHAR(250),
    pkg_size VARCHAR(250),
    pkg_qty VARCHAR(250),
    bill_units VARCHAR(250),
    bill_units_pkg VARCHAR(250),
    file_name VARCHAR(250)
);
