-- =============================================
-- Table: cloud_data_warehouse.gpi_data
-- Columns: 40
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.gpi_data (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    gpi VARCHAR(14),
    type_code VARCHAR(1),
    third_party VARCHAR(1),
    main_drug VARCHAR(1),
    generic_code VARCHAR(1),
    product_name VARCHAR(60),
    trade_ndc VARCHAR(11),
    trade_type_code BIGINT,
    otc_code VARCHAR(1),
    route_of_admin VARCHAR(2),
    dea_class VARCHAR(5),
    previous_gpi VARCHAR(14),
    gpi_14_place VARCHAR(1),
    pdm_gpi_switch VARCHAR(1),
    compu04_patch VARCHAR(1),
    type_code_pull VARCHAR(1),
    five_thou_one_six_thou_one_flag BIGINT,
    new_gpi VARCHAR(14),
    add_subtract VARCHAR(1),
    second_previous_gpi VARCHAR(14),
    gpi_add_date DATE,
    o_with_y_for_mac VARCHAR(1),
    gpi_description VARCHAR(60),
    gpi_description_10 VARCHAR(60),
    gpi_description_2 VARCHAR(60),
    gpi_2 VARCHAR(2),
    gpi_10 VARCHAR(10),
    gpi_11_to_14 VARCHAR(4),
    gpi_trade_descr VARCHAR(25),
    prod_descr_abbr VARCHAR(25),
    name_1 VARCHAR(60),
    name_2 VARCHAR(60),
    ss_gen_term_date DATE
);
