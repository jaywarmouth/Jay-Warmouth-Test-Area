-- =============================================
-- Table: cloud_data_warehouse.urxs_headers_chain_code
-- Columns: 4
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.urxs_headers_chain_code (
    chain_key FLOAT8,
    eft NUMERIC(8, 2),
    chain_code FLOAT8,
    header_on_invoice VARCHAR(255)
);
