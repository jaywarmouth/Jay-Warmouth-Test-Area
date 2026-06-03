-- =============================================
-- Table: cloud_data_warehouse.physician_sponsor
-- Columns: 41
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.physician_sponsor (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    physician_sponsor INTEGER,
    physician_number VARCHAR(14),
    physician_last_name VARCHAR(30),
    physician_first_name VARCHAR(30),
    physician_mi VARCHAR(1),
    physician_address_1 VARCHAR(40),
    physician_address_2 VARCHAR(40),
    physician_city VARCHAR(30),
    physician_state VARCHAR(2),
    phys_zip VARCHAR(10),
    physician_zip_code VARCHAR(10),
    phys_zip4 VARCHAR(10),
    physician_specialty VARCHAR(10),
    phys_secondary_specialty_1 VARCHAR(10),
    phys_secondary_specialty_2 VARCHAR(10),
    phys_secondary_specialty_3 VARCHAR(10),
    phys_secondary_specialty_4 VARCHAR(10),
    phys_state_id VARCHAR(14),
    phys_oh_med_id VARCHAR(14),
    phys_dea_number VARCHAR(14),
    phys_eff_date TIMESTAMP,
    phys_ter_date TIMESTAMP,
    phys_status VARCHAR(1),
    phys_print_flag VARCHAR(1),
    phys_system_phy_id_num VARCHAR(14),
    phys_pho_nbr_1 VARCHAR(14),
    phys_eff_1 TIMESTAMP,
    phys_pho_nbr_2 VARCHAR(14),
    phys_eff_2 TIMESTAMP,
    phys_pho_nbr_3 VARCHAR(14),
    phys_eff_3 TIMESTAMP,
    phys_ind_grp VARCHAR(3),
    phys_manual_date TIMESTAMP,
    phys_file_date TIMESTAMP
);
