-- =============================================
-- Query: Extract Foreign Keys & Constraints
-- Database: Amazon Redshift
-- Description: Pulls all table constraints
--              including primary and foreign keys
-- =============================================

SELECT
    tc.constraint_name,
    tc.constraint_type,
    tc.table_schema,
    tc.table_name,
    kcu.column_name,
    ccu.table_name  AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
LEFT JOIN information_schema.constraint_column_usage ccu
    ON tc.constraint_name = ccu.constraint_name
WHERE tc.table_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY tc.table_schema, tc.table_name;
