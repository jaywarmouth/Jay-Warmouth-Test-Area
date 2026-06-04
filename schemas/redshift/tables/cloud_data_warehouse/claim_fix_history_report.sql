-- =============================================
-- Table: cloud_data_warehouse.claim_fix_history_report
-- Columns: 16
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.claim_fix_history_report (
    record_type VARCHAR(6),
    claim_key VARCHAR(42),
    pde_batch_nbr VARCHAR(8),
    pde_claim_nbr INTEGER,
    pde_record_nbr VARCHAR(3),
    original_sponsor_nbr INTEGER,
    new_sponsor_nbr INTEGER,
    original_cardholder_nbr VARCHAR(30),
    new_cardholder_nbr VARCHAR(30),
    original_member_nbr VARCHAR(6),
    new_member_nbr VARCHAR(6),
    user_id VARCHAR(36),
    file_name VARCHAR(750),
    warehouse_change_date TIMESTAMP,
    original_cardholder_key VARCHAR(60),
    new_cardholder_key VARCHAR(60)
);
