-- =============================================
-- Table: cloud_data_warehouse.activity_audit
-- Columns: 14
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.activity_audit (
    rec_id INTEGER NOT NULL -- identity column,
    rec_source VARCHAR(250),
    dateofrun TIMESTAMP,
    insert_date TIMESTAMP,
    etl_begin_index_time TIMESTAMP,
    etl_end_time TIMESTAMP,
    records_read INTEGER,
    records_inserted INTEGER,
    records_updated INTEGER,
    process_name VARCHAR(256),
    database_file_name VARCHAR(256),
    scd_job_status VARCHAR(30),
    recordserrored INTEGER,
    rejectfilename VARCHAR(256)
);
