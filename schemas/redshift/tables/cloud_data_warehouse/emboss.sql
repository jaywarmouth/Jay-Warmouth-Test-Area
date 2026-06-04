-- =============================================
-- Table: cloud_data_warehouse.emboss
-- Columns: 31
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.emboss (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    cardholder_number VARCHAR(10),
    member_number VARCHAR(2),
    spon_number INTEGER,
    quant_billed_1 INTEGER,
    emboss_date_1 TIMESTAMP,
    quant_billed_2 INTEGER,
    emboss_date_2 TIMESTAMP,
    quant_billed_3 INTEGER,
    emboss_date_3 TIMESTAMP,
    quant_billed_4 INTEGER,
    emboss_date_4 TIMESTAMP,
    quant_billed_5 INTEGER,
    emboss_date_5 TIMESTAMP,
    quant_billed_6 INTEGER,
    emboss_date_6 TIMESTAMP,
    quant_billed_7 INTEGER,
    emboss_date_7 TIMESTAMP,
    quant_billed_8 INTEGER,
    emboss_date_8 TIMESTAMP,
    quant_billed_9 INTEGER,
    emboss_date_9 TIMESTAMP,
    quant_billed_10 INTEGER,
    emboss_date_10 TIMESTAMP,
    cardholder_key VARCHAR(20)
);
