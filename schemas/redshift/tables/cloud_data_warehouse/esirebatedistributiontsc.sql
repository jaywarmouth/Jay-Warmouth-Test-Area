-- =============================================
-- Table: cloud_data_warehouse.esirebatedistributiontsc
-- Columns: 32
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.esirebatedistributiontsc (
    original_id VARCHAR(50),
    carrier_id VARCHAR(50),
    contract_id VARCHAR(50),
    group_id VARCHAR(50),
    locator_id VARCHAR(50),
    insurance_code VARCHAR(50),
    user_defined VARCHAR(50),
    new_pass_through VARCHAR(50),
    pass_through_text VARCHAR(50),
    claim_type VARCHAR(50),
    formulary_id VARCHAR(50),
    load_batch_number VARCHAR(50),
    retail_mail VARCHAR(50),
    specialty VARCHAR(50),
    filled_month VARCHAR(50),
    brand_generic VARCHAR(50),
    fill_days_supply INTEGER,
    payment_amount NUMERIC(18, 2),
    claim_count INTEGER,
    per_rx_rate NUMERIC(18, 2),
    per_rx_calc_amount NUMERIC(18, 2),
    maf_rate NUMERIC(18, 2),
    maf_calc_amount NUMERIC(18, 2),
    percent_share_base_rate NUMERIC(18, 2),
    rebates_calc_amount NUMERIC(18, 2),
    percent_share_admin_fee_rate NUMERIC(18, 2),
    admin_fee_calc_amount NUMERIC(18, 2),
    pdmi_load_date TIMESTAMP,
    pdmi_batch_claim VARCHAR(25),
    exclusion_reason VARCHAR(150),
    file_name_loaded VARCHAR(150),
    load_date TIMESTAMP
);
