-- =============================================
-- Table: cloud_data_warehouse.nadac_data
-- Columns: 12
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.nadac_data (
    ndc_description VARCHAR(500),
    ndc VARCHAR(11),
    nadac_per_unit NUMERIC(18, 5),
    effective_date DATE,
    pricing_unit VARCHAR(20),
    pharmacy_type_indicator VARCHAR(20),
    otc VARCHAR(20),
    explanation_code VARCHAR(20),
    classification_for_rate_setting VARCHAR(20),
    corresponding_generic_drug_nadac_per_unit NUMERIC(18, 5),
    corresponding_generic_drug_effective_date DATE,
    as_of_date DATE
);
