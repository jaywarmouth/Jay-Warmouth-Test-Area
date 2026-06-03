-- =============================================
-- Table: cloud_data_warehouse.npi
-- Columns: 30
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.npi (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    npi VARCHAR(10) NOT NULL,
    entity_code VARCHAR(1),
    business_name VARCHAR(45),
    last_name VARCHAR(35),
    first_name VARCHAR(20),
    middle_initial VARCHAR(1),
    location_address_1 VARCHAR(25),
    location_address_2 VARCHAR(25),
    location_city VARCHAR(25),
    location_state VARCHAR(2),
    location_zip VARCHAR(5),
    location_zip_5 INTEGER,
    location_country VARCHAR(2),
    location_phone VARCHAR(10),
    enumeration_date TIMESTAMP,
    update_date TIMESTAMP,
    add_date TIMESTAMP,
    chg_date TIMESTAMP,
    business_fax VARCHAR(20),
    practice_fax VARCHAR(20),
    deactivation_reason_cd VARCHAR(2),
    deactivation_date TIMESTAMP,
    reactivation_date TIMESTAMP
);
