-- =============================================
-- Table: cloud_data_warehouse.specialty_config
-- Columns: 25
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.specialty_config (
    meta_surr_key VARCHAR(1000),
    meta_hash_key VARCHAR(1000),
    meta_src_sys_nm VARCHAR(80),
    meta_iud_flg VARCHAR(1),
    meta_eff_strt_dt TIMESTAMP,
    meta_eff_end_dt TIMESTAMP,
    meta_curr_ind VARCHAR(3),
    table_id VARCHAR(8) NOT NULL,
    gpi VARCHAR(14) NOT NULL,
    eff_date DATE NOT NULL,
    status_code VARCHAR(1),
    copay_schedule_type VARCHAR(6),
    copay_number BIGINT,
    max_day_supply BIGINT,
    skip_limit_flag VARCHAR(1),
    term_date DATE,
    pref_message VARCHAR(30),
    injec_cov_stat_code VARCHAR(1),
    script_per_member BIGINT,
    unit_per_day NUMERIC(18, 2),
    reimb_sched_type VARCHAR(6),
    reimb_sched_number BIGINT,
    add_id VARCHAR(15),
    change_id VARCHAR(15),
    copay_per_month_flag VARCHAR(1)
);
