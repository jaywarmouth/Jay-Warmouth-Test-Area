-- =============================================
-- Table: cloud_data_warehouse.warehouse_status_audit
-- Columns: 24
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.warehouse_status_audit (
    warehouse_status_audit_id BIGINT NOT NULL -- identity column,
    warehouse_status VARCHAR(228),
    warehouse_status_time TIMESTAMP,
    warehouse_status_notes VARCHAR(256),
    drug_status VARCHAR(228),
    drug_status_time TIMESTAMP,
    cardholder_status VARCHAR(228),
    cardholder_status_time TIMESTAMP,
    plan_status VARCHAR(228),
    plan_status_time TIMESTAMP,
    group_status VARCHAR(228),
    group_status_time TIMESTAMP,
    phdem_status VARCHAR(228),
    phdem_status_time TIMESTAMP,
    phnet_status VARCHAR(228),
    phnet_status_time TIMESTAMP,
    rv601_status VARCHAR(150),
    rv601_status_time TIMESTAMP,
    reversal_status VARCHAR(150),
    reversal_status_time TIMESTAMP,
    gpi_status VARCHAR(150),
    gpi_status_time TIMESTAMP,
    claims_msg_status VARCHAR(150),
    claims_msg_status_time TIMESTAMP
);
