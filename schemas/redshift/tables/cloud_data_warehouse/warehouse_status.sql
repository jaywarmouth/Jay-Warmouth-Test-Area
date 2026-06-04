-- =============================================
-- Table: cloud_data_warehouse.warehouse_status
-- Columns: 23
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.warehouse_status (
    warehouse_status VARCHAR(225) NOT NULL,
    warehouse_status_time TIMESTAMP,
    drug_status VARCHAR(225),
    drug_status_time TIMESTAMP,
    cardholder_status VARCHAR(225),
    cardholder_status_time TIMESTAMP,
    plan_status VARCHAR(225),
    plan_status_time TIMESTAMP,
    group_status VARCHAR(225),
    group_status_time TIMESTAMP,
    phdem_status VARCHAR(225),
    phdem_status_time TIMESTAMP,
    phnet_status VARCHAR(225),
    phnet_status_time TIMESTAMP,
    rv601_status VARCHAR(150),
    rv601_status_time TIMESTAMP,
    reversal_status VARCHAR(150),
    reversal_status_time TIMESTAMP,
    gpi_status VARCHAR(150),
    gpi_status_time TIMESTAMP,
    claims_msg_status VARCHAR(150),
    rxconnect_status VARCHAR(150),
    rxconnect_status_time TIMESTAMP
);
