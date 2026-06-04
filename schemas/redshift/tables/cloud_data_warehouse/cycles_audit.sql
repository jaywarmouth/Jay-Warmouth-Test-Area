-- =============================================
-- Table: cloud_data_warehouse.cycles_audit
-- Columns: 18
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.cycles_audit (
    date_of_run DATE,
    transaction_system_number INTEGER NOT NULL,
    transaction_sponsor_number INTEGER NOT NULL,
    transaction_group_number BIGINT NOT NULL,
    transaction_claim_type_indicator VARCHAR(6) NOT NULL,
    transaction_claim_count INTEGER,
    transaction_amount_paid NUMERIC(18, 2),
    transaction_period_ending DATE,
    transaction_input_file_name VARCHAR(765) NOT NULL,
    audit_system_number INTEGER,
    audit_sponsor_number INTEGER,
    audit_group_number BIGINT,
    audit_claim_count INTEGER,
    audit_amount_paid NUMERIC(18, 2),
    audit_copay_amount NUMERIC(18, 2),
    audit_period_ending DATE,
    audit_claim_count_difference INTEGER,
    audit_amount_paid_difference NUMERIC(18, 2)
);
