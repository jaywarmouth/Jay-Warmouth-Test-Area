-- =============================================
-- Table: cloud_data_warehouse.esi_formulary_table_to_group_crosswalk_by_client
-- Columns: 10
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.esi_formulary_table_to_group_crosswalk_by_client (
    system_number INTEGER,
    formulary_table INTEGER,
    group_type VARCHAR(50),
    carrier INTEGER,
    contract VARCHAR(50),
    group VARCHAR(100),
    effective_date DATE,
    term_date DATE,
    notes VARCHAR(255),
    code_flag VARCHAR(255)
);
