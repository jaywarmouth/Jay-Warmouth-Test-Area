-- =============================================
-- Table: cloud_data_warehouse.esi_rebatable_drug_list
-- Columns: 9
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.esi_rebatable_drug_list (
    cpc VARCHAR(100),
    manf VARCHAR(100),
    brand VARCHAR(100),
    drug_name VARCHAR(200),
    package_size_qty NUMERIC(18, 5),
    ndc VARCHAR(11),
    npf CHAR(1),
    basic CHAR(1),
    specialty CHAR(1)
);
