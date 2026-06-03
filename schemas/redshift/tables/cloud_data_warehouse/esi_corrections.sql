-- =============================================
-- Table: cloud_data_warehouse.esi_corrections
-- Columns: 27
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.esi_corrections (
    carrier_operational_id VARCHAR(50),
    load_batch_nbr VARCHAR(50),
    mail_retail_cde VARCHAR(50),
    pass_through_txt VARCHAR(14),
    fill_drug_formulary_id VARCHAR(50),
    contract_operational_id VARCHAR(50),
    elig_group_operational_id VARCHAR(50),
    insurance_cde VARCHAR(50),
    locator_id VARCHAR(50),
    brand_generic_cde VARCHAR(50),
    serviced_dte TIMESTAMP,
    total_claims VARCHAR(50),
    brand_claims VARCHAR(50),
    service_qtr VARCHAR(50),
    orig_guarantee_rate NUMERIC(18, 2),
    orig_admin_fee NUMERIC(18, 2),
    orig_admin_fee_amount NUMERIC(18, 2),
    orig_net_guarantee NUMERIC(18, 2),
    corrected_guarantee_rate NUMERIC(18, 2),
    corrected_admin_fee NUMERIC(18, 2),
    corrected_admin_fee_amount NUMERIC(18, 2),
    corrected_net_guarantee NUMERIC(18, 2),
    diff_guarantee_rate NUMERIC(18, 2),
    diff_admin_fee NUMERIC(18, 2),
    diff_admin_fee_amount NUMERIC(18, 2),
    diff_net_guarantee NUMERIC(18, 2),
    pdmi_load_date TIMESTAMP
);
