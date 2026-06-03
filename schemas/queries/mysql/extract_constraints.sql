-- =============================================
-- Query: Extract Foreign Keys & Constraints
-- Database: MySQL
-- Description: Pulls all table constraints
--              including primary and foreign keys
-- =============================================

SELECT
    kcu.CONSTRAINT_NAME,
    tc.CONSTRAINT_TYPE,
    kcu.TABLE_SCHEMA,
    kcu.TABLE_NAME,
    kcu.COLUMN_NAME,
    kcu.REFERENCED_TABLE_NAME  AS FOREIGN_TABLE_NAME,
    kcu.REFERENCED_COLUMN_NAME AS FOREIGN_COLUMN_NAME
FROM information_schema.TABLE_CONSTRAINTS tc
JOIN information_schema.KEY_COLUMN_USAGE kcu
    ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
    AND tc.TABLE_SCHEMA   = kcu.TABLE_SCHEMA
    AND tc.TABLE_NAME     = kcu.TABLE_NAME
WHERE tc.TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'mysql', 'sys')
ORDER BY kcu.TABLE_SCHEMA, kcu.TABLE_NAME, tc.CONSTRAINT_TYPE;
