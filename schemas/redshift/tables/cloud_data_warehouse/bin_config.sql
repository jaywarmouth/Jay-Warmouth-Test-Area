-- =============================================
-- Table: cloud_data_warehouse.bin_config
-- Columns: 26
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.bin_config (
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
    bin_number VARCHAR(10),
    other_cov_code INTEGER,
    ix CHAR(1),
    sequence_number INTEGER,
    eff_date TIMESTAMP,
    term_date TIMESTAMP,
    bin_config_type VARCHAR(12),
    value_type VARCHAR(20),
    except_code INTEGER,
    reject_code INTEGER,
    primary_msg VARCHAR(39),
    secondary_msg VARCHAR(200),
    add_id VARCHAR(15),
    change_id VARCHAR(15),
    add_date TIMESTAMP,
    change_date TIMESTAMP
);
