-- =============================================
-- Table: cloud_data_warehouse.esi_mfg_rejections
-- Columns: 22
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.esi_mfg_rejections (
    brand_nme VARCHAR(255),
    carrier_operational_id VARCHAR(255),
    carrier_nme VARCHAR(255),
    contract_operational_id VARCHAR(255),
    excl_dsc VARCHAR(255),
    serviced_dte TIMESTAMP,
    fill_drug_formulary_id VARCHAR(255),
    mfr_nme VARCHAR(255),
    nabp_nbr VARCHAR(255),
    fill_ndc_nbr VARCHAR(255),
    npi_nbr VARCHAR(255),
    rx_nbr VARCHAR(255),
    locator_id VARCHAR(255),
    insurance_cde VARCHAR(255),
    new_pass_through VARCHAR(255),
    user_defined VARCHAR(255),
    invoice_year FLOAT8,
    invoice_month FLOAT8,
    sum_fill_days_supply_qty FLOAT8,
    sum_inferred_fill_qty FLOAT8,
    sum_claim_count_nbr FLOAT8,
    claim_key VARCHAR(255)
);
