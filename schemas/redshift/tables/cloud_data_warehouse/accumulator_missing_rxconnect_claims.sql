-- =============================================
-- Table: cloud_data_warehouse.accumulator_missing_rxconnect_claims
-- Columns: 26
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.accumulator_missing_rxconnect_claims (
    claim_key VARCHAR(14),
    paid_or_reversal_flag VARCHAR(1),
    p_date BIGINT,
    etl_insert_date DATE,
    guid VARCHAR(256),
    batch_number VARCHAR(8),
    claim_number BIGINT,
    rx_number BIGINT,
    reject_code_1 BIGINT,
    reject_code_2 BIGINT,
    reversal_code BIGINT,
    create_date DATE,
    pharmacy_number VARCHAR(256),
    group_number VARCHAR(256),
    rx_date BIGINT,
    pdm_system_number INTEGER,
    pdm_sponsor_number INTEGER,
    claim_ind VARCHAR(256),
    accumcci VARCHAR(256),
    keypunch VARCHAR(256),
    line_number INTEGER,
    available_in_redshift VARCHAR(1),
    available_in_rds VARCHAR(1),
    date_of_reversal DATE,
    process_date DATE,
    adj_code_1 INTEGER
);
