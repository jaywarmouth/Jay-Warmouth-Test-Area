-- =============================================
-- Table: cloud_data_warehouse.pharmacygeography
-- Columns: 6
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.pharmacygeography (
    nabp VARCHAR(7),
    source VARCHAR(20),
    date_of_last_update TIMESTAMP,
    force_update SMALLINT,
    latitude FLOAT8,
    longitude FLOAT8
);
