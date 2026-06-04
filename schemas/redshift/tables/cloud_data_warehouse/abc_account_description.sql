-- =============================================
-- Table: cloud_data_warehouse.abc_account_description
-- Columns: 5
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.abc_account_description (
    category_number FLOAT8,
    category_description VARCHAR(255),
    system_number FLOAT8,
    sponsor_number FLOAT8,
    group_number VARCHAR(255)
);
