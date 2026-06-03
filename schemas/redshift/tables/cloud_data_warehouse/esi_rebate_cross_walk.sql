-- =============================================
-- Table: cloud_data_warehouse.esi_rebate_cross_walk
-- Columns: 12
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.esi_rebate_cross_walk (
    id INTEGER NOT NULL,
    formulary_gt INTEGER,
    system_number INTEGER,
    sponsor_number INTEGER,
    sponsor_account_type VARCHAR(10),
    plan_formulary_gt1 INTEGER,
    plan_formulary_gt2 INTEGER,
    rebate_contract_id VARCHAR(20),
    rebate_carrier_id VARCHAR(20),
    rebate_flag CHAR(1),
    effective_date DATE,
    term_date DATE
);
