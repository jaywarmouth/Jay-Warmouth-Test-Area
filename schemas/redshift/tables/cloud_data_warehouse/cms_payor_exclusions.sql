-- =============================================
-- Table: cloud_data_warehouse.cms_payor_exclusions
-- Columns: 12
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.cms_payor_exclusions (
    cms_payor_exclusion_id BIGINT NOT NULL -- identity column,
    contract_id VARCHAR(256),
    plan_id VARCHAR(256),
    contract_year VARCHAR(256),
    effective_start_date DATE,
    effective_end_date DATE,
    bin VARCHAR(256),
    pcn VARCHAR(256),
    created_date TIMESTAMP,
    created_by VARCHAR(256),
    etl_load_date TIMESTAMP,
    etl_load_by VARCHAR(256)
);
