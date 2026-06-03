-- =============================================
-- Table: cloud_data_warehouse.rxdccrosswalk
-- Columns: 9
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.rxdccrosswalk (
    ndc_11_digit VARCHAR(256),
    rxdc_drug_name VARCHAR(256),
    rxdc_drug_code VARCHAR(256),
    rxdc_therapeutic_class VARCHAR(256),
    rxdc_class_code VARCHAR(256),
    rxdc_brand_indicator INTEGER,
    ndc_data_source VARCHAR(256),
    therapeutic_class_data_source VARCHAR(256),
    exclude BOOLEAN NOT NULL DEFAULT false
);
