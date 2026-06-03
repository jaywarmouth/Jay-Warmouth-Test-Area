-- =============================================
-- Query: Extract Distribution & Sort Keys
-- Database: Amazon Redshift
-- Description: Pulls Redshift-specific distkey,
--              sortkey, and encoding per column
-- =============================================

SELECT
    schema_name,
    table_name,
    column_name,
    distkey,
    sortkey,
    encoding
FROM pg_table_def
WHERE schema_name NOT IN ('pg_catalog', 'information_schema')
ORDER BY schema_name, table_name, sortkey, column_name;
