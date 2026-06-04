-- =============================================
-- Table: cloud_data_warehouse.claims_updates
-- Columns: 3
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.claims_updates (
    claim_key VARCHAR(14) NOT NULL,
    ing_paid NUMERIC(18, 2),
    amount_paid NUMERIC(18, 2)
);
