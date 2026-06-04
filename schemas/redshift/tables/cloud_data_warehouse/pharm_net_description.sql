-- =============================================
-- Table: cloud_data_warehouse.pharm_net_description
-- Columns: 25
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.pharm_net_description (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    system INTEGER,
    sponsor INTEGER,
    network_nbr INTEGER,
    primary_secondary VARCHAR(1),
    description VARCHAR(20),
    description_2 VARCHAR(20),
    patch_code VARCHAR(1),
    pdm_mac_flag VARCHAR(1),
    no_financial VARCHAR(1),
    spec_net_load VARCHAR(1),
    assoc_net_flag VARCHAR(1),
    abc_net_flag VARCHAR(1),
    ncpdp_term_flag VARCHAR(1),
    cust_abc_net_flag VARCHAR(1),
    loe_flag VARCHAR(1),
    sngl_src_gen_flag VARCHAR(1),
    pref_pharm_flag VARCHAR(1),
    sc_net_prc_applies VARCHAR(1)
);
