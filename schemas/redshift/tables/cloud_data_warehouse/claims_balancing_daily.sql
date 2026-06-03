-- =============================================
-- Table: cloud_data_warehouse.claims_balancing_daily
-- Columns: 8
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.claims_balancing_daily (
    process_date TIMESTAMP NOT NULL,
    claim_count INTEGER,
    audit_date TIMESTAMP,
    audit_claim_count INTEGER,
    audit_claim_count_difference INTEGER,
    written_claim_count INTEGER,
    total_error_count INTEGER,
    paid_error_count INTEGER
);
