-- =============================================
-- Table: cloud_data_warehouse.job_activity_audit
-- Columns: 41
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.job_activity_audit (
    jobactivityauditid INTEGER NOT NULL -- identity column,
    dateofrun TIMESTAMP,
    etl_findfiletime TIMESTAMP,
    etl_beginindextime TIMESTAMP,
    etl_endtime TIMESTAMP,
    recordsread INTEGER,
    recordsinserted INTEGER,
    recordsupdated INTEGER,
    recordserrored INTEGER,
    processname VARCHAR(256),
    databasefilename VARCHAR(256),
    databasefilerecordcount INTEGER,
    transactionfileorigination VARCHAR(150),
    transactionprocessdate TIMESTAMP,
    transactionsystemnumber INTEGER,
    transactionclaimcount INTEGER,
    transactionamountpaid NUMERIC(18, 2),
    transactionperiodending TIMESTAMP,
    transactioninputfilerecordcount INTEGER,
    transactioninputfilename VARCHAR(256),
    auditprocessdate TIMESTAMP,
    auditsystemnumber INTEGER,
    auditclaimcount INTEGER,
    auditamountpaid NUMERIC(18, 2),
    auditcopayamount NUMERIC(18, 2),
    auditperiodending TIMESTAMP,
    auditclaimcountdifference INTEGER,
    auditamountpaiddifference NUMERIC(18, 2),
    warehousename VARCHAR(150),
    recordrejected INTEGER,
    rejectfilename VARCHAR(256),
    scd_job_status VARCHAR(30),
    scd_job_start_time TIMESTAMP,
    copy_start_time TIMESTAMP,
    copy_end_time TIMESTAMP,
    hash_set_calculate_start_time TIMESTAMP,
    hash_set_calculate_end_time TIMESTAMP,
    scd_start_time TIMESTAMP,
    scd_end_time TIMESTAMP,
    filetotalrecords INTEGER,
    records_deleted INTEGER
);
