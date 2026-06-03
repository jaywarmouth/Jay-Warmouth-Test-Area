-- =============================================
-- Table: cloud_data_warehouse.sponsor_list
-- Columns: 5
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.sponsor_list (
    id INTEGER,
    sponsor_number INTEGER,
    inserted_date TIMESTAMP,
    is_active BOOLEAN,
    sponsor_name VARCHAR(100)
);
