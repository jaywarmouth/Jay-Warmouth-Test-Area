-- =============================================
-- Query: Extract Indexes
-- Database: Microsoft SQL Server
-- Description: Pulls all indexes, their types,
--              and associated columns
-- =============================================

SELECT
    s.name          AS schema_name,
    t.name          AS table_name,
    i.name          AS index_name,
    i.type_desc     AS index_type,
    i.is_primary_key,
    i.is_unique,
    c.name          AS column_name,
    ic.key_ordinal
FROM sys.indexes i
JOIN sys.tables t         ON i.object_id     = t.object_id
JOIN sys.schemas s        ON t.schema_id     = s.schema_id
JOIN sys.index_columns ic ON i.object_id     = ic.object_id
                          AND i.index_id      = ic.index_id
JOIN sys.columns c        ON ic.object_id    = c.object_id
                          AND ic.column_id    = c.column_id
WHERE t.is_ms_shipped = 0
ORDER BY s.name, t.name, i.name, ic.key_ordinal;
