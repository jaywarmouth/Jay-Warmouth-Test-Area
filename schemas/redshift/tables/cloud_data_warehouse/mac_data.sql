-- =============================================
-- Table: cloud_data_warehouse.mac_data
-- Columns: 34
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.mac_data (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    mac_number BIGINT NOT NULL,
    gpi VARCHAR(14) NOT NULL,
    change_date_1 DATE,
    mac_unit_price_1 NUMERIC(18, 5),
    change_date_2 DATE,
    mac_unit_price_2 NUMERIC(18, 5),
    change_date_3 DATE,
    mac_unit_price_3 NUMERIC(18, 5),
    change_date_4 DATE,
    mac_unit_price_4 NUMERIC(18, 5),
    change_date_5 DATE,
    mac_unit_price_5 NUMERIC(18, 5),
    change_date_6 DATE,
    mac_unit_price_6 NUMERIC(18, 5),
    change_date_7 DATE,
    mac_unit_price_7 NUMERIC(18, 5),
    change_date_8 DATE,
    mac_unit_price_8 NUMERIC(18, 5),
    change_date_9 DATE,
    mac_unit_price_9 NUMERIC(18, 5),
    change_date_10 DATE,
    mac_unit_price_10 NUMERIC(18, 5),
    type_code VARCHAR(2),
    ndc VARCHAR(11),
    on_generic_only VARCHAR(1),
    prevails_flag VARCHAR(1),
    minimum_pack_size NUMERIC(18, 3)
);
