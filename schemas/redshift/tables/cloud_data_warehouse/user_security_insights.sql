-- =============================================
-- Table: cloud_data_warehouse.user_security_insights
-- Columns: 8
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.user_security_insights (
    userguid VARCHAR(100) NOT NULL,
    user_email VARCHAR(100),
    system_number INTEGER,
    sponsor_number INTEGER,
    group_number BIGINT,
    system_name VARCHAR(50),
    sponsor_name VARCHAR(50),
    group_name VARCHAR(50)
);
