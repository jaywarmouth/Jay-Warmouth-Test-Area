-- =============================================
-- Query: Extract Foreign Keys & Constraints
-- Database: Microsoft SQL Server
-- Description: Pulls all table constraints
--              including primary and foreign keys
-- =============================================

SELECT
    tc.CONSTRAINT_NAME,
    tc.CONSTRAINT_TYPE,
    tc.TABLE_SCHEMA,
    tc.TABLE_NAME,
    kcu.COLUMN_NAME,
    ccu.TABLE_NAME  AS FOREIGN_TABLE_NAME,
    ccu.COLUMN_NAME AS FOREIGN_COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu
    ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
    AND tc.TABLE_SCHEMA   = kcu.TABLE_SCHEMA
LEFT JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ccu
    ON tc.CONSTRAINT_NAME = ccu.CONSTRAINT_NAME
ORDER BY tc.TABLE_SCHEMA, tc.TABLE_NAME;
