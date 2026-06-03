-- =============================================
-- Table: cloud_data_warehouse.erx_processor_plan_file
-- Columns: 12
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.erx_processor_plan_file (
    processor_plan_id BIGINT NOT NULL -- identity column,
    plan_name VARCHAR(256),
    plan_id VARCHAR(256),
    processor_number VARCHAR(256),
    bin VARCHAR(256),
    pcn VARCHAR(256),
    d0 VARCHAR(256),
    file_name VARCHAR(256),
    plan_type VARCHAR(256),
    help_desk_number VARCHAR(256),
    etl_load_date TIMESTAMP,
    etl_load_by VARCHAR(256)
);
