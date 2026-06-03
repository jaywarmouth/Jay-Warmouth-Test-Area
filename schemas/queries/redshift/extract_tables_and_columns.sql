-- =============================================
-- Query: Extract All Tables & Columns
-- Database: Amazon Redshift
-- Description: Pulls all schemas, tables, and
--              column definitions from information_schema
-- =============================================

SELECT
    t.table_schema,
    t.table_name,
    c.column_name,
    c.ordinal_position,
    c.data_type,
    c.character_maximum_length,
    c.numeric_precision,
    c.numeric_scale,
    c.is_nullable,
    c.column_default
FROM information_schema.tables t
JOIN information_schema.columns c
    ON t.table_schema = c.table_schema
    AND t.table_name  = c.table_name
WHERE t.table_type   = 'BASE TABLE'
  AND t.table_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY
    t.table_schema,
    t.table_name,
    c.ordinal_position;
