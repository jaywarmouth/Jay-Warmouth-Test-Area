-- =============================================
-- Table: cloud_data_warehouse.temp_out
-- Columns: 5
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.temp_out (
    tmp_prescriberid VARCHAR(256),
    tmp_hms_piid VARCHAR(100),
    tmp_physicianeligible VARCHAR(150),
    tmp_pdmirejectcode VARCHAR(100),
    tmp_apimessage VARCHAR(100)
);
