-- =============================================
-- Table: cloud_data_warehouse.subscriptions_payment_address
-- Columns: 3
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.subscriptions_payment_address (
    id INTEGER,
    address VARCHAR(1000),
    aprx_address VARCHAR(200)
);
