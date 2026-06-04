-- =============================================
-- Table: cloud_data_warehouse.cycle_status
-- Columns: 4
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.cycle_status (
    cycle VARCHAR(150),
    inlog_period_ending TIMESTAMP,
    refresh_period_ending TIMESTAMP,
    claim_55_period_ending TIMESTAMP
);
