-- =============================================
-- Query: Extract All Tables & Columns
-- Database: MySQL
-- Description: Pulls all schemas, tables, and
--              column definitions from information_schema
-- =============================================

SELECT
    t.TABLE_SCHEMA,
    t.TABLE_NAME,
    c.COLUMN_NAME,
    c.ORDINAL_POSITION,
    c.DATA_TYPE,
    c.COLUMN_TYPE,
    c.CHARACTER_MAXIMUM_LENGTH,
    c.NUMERIC_PRECISION,
    c.NUMERIC_SCALE,
    c.IS_NULLABLE,
    c.COLUMN_DEFAULT,
    c.EXTRA,
    c.COLUMN_COMMENT
FROM information_schema.TABLES t
JOIN information_schema.COLUMNS c
    ON t.TABLE_SCHEMA = c.TABLE_SCHEMA
    AND t.TABLE_NAME  = c.TABLE_NAME
WHERE t.TABLE_TYPE   = 'BASE TABLE'
  AND t.TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'mysql', 'sys')
ORDER BY
    t.TABLE_SCHEMA,
    t.TABLE_NAME,
    c.ORDINAL_POSITION;
