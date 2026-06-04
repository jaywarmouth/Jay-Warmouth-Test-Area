-- =============================================
-- Table: cloud_data_warehouse.esi_340b_pharmacy_excluded_listing
-- Columns: 12
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.esi_340b_pharmacy_excluded_listing (
    nabp INTEGER,
    nabp_7 VARCHAR(7),
    pharmacy_name VARCHAR(255),
    esi_340b_id VARCHAR(255),
    shipping_address_1 VARCHAR(255),
    shipping_address_2 VARCHAR(255),
    shipping_address_3 VARCHAR(255),
    shipping_city VARCHAR(255),
    shipping_state VARCHAR(255),
    shipping_zip FLOAT8,
    esi_340b_effective_date TIMESTAMP,
    esi_340b_term_date TIMESTAMP
);
