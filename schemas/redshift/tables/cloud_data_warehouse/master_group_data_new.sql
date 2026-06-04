-- =============================================
-- Table: cloud_data_warehouse.master_group_data_new
-- Columns: 9
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.master_group_data_new (
    group_number VARCHAR(20),
    group_name VARCHAR(90),
    sponsor_number INTEGER,
    sponsor_name VARCHAR(90),
    system_number INTEGER,
    system_name VARCHAR(90),
    system_link VARCHAR(30),
    sys_link_description VARCHAR(180),
    master_group INTEGER
);
