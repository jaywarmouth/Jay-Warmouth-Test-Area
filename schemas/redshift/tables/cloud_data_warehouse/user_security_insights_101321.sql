-- =============================================
-- Table: cloud_data_warehouse.user_security_insights_101321
-- Columns: 5
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.user_security_insights_101321 (
    userguid VARCHAR(100),
    user_email VARCHAR(100),
    system_number INTEGER,
    sponsor_number INTEGER,
    group_number BIGINT
);
