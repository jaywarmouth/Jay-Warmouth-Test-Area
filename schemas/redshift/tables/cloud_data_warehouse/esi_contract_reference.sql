-- =============================================
-- Table: cloud_data_warehouse.esi_contract_reference
-- Columns: 3
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.esi_contract_reference (
    contract_code VARCHAR(50) NOT NULL,
    form_code INTEGER NOT NULL,
    contract_name VARCHAR(250) NOT NULL
);
