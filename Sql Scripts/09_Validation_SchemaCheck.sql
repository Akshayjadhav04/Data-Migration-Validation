-- =============================================
-- Schema Validation
-- Purpose: Compare table schemas between source and target databases
-- Author: Data Migration Validation Project
-- Date: 2026-01-31
-- =============================================

-- =============================================
-- Instructions:
-- 1. Run this script in SQL Server Management Studio
-- 2. Review the schema comparison results
-- 3. Paste into Excel "Schema Validation" sheet
-- =============================================

PRINT '========================================';
PRINT 'SCHEMA VALIDATION';
PRINT '========================================';
PRINT '';

-- =============================================
-- Compare Column Definitions
-- =============================================
PRINT '--- Column Schema Comparison ---';

WITH SourceSchema AS (
    SELECT 
        t.name AS TableName,
        c.name AS ColumnName,
        ty.name AS DataType,
        c.max_length AS MaxLength,
        c.precision AS Precision,
        c.scale AS Scale,
        c.is_nullable AS IsNullable
    FROM SourceDB.sys.tables t
    INNER JOIN SourceDB.sys.columns c ON t.object_id = c.object_id
    INNER JOIN SourceDB.sys.types ty ON c.user_type_id = ty.user_type_id
    WHERE t.name IN ('Customers', 'Orders')
),
TargetSchema AS (
    SELECT 
        t.name AS TableName,
        c.name AS ColumnName,
        ty.name AS DataType,
        c.max_length AS MaxLength,
        c.precision AS Precision,
        c.scale AS Scale,
        c.is_nullable AS IsNullable
    FROM TargetDB.sys.tables t
    INNER JOIN TargetDB.sys.columns c ON t.object_id = c.object_id
    INNER JOIN TargetDB.sys.types ty ON c.user_type_id = ty.user_type_id
    WHERE t.name IN ('Customers', 'Orders')
)
SELECT 
    COALESCE(S.TableName, T.TableName) AS TableName,
    COALESCE(S.ColumnName, T.ColumnName) AS ColumnName,
    S.DataType AS SourceDataType,
    T.DataType AS TargetDataType,
    S.MaxLength AS SourceMaxLength,
    T.MaxLength AS TargetMaxLength,
    S.IsNullable AS SourceNullable,
    T.IsNullable AS TargetNullable,
    CASE 
        WHEN S.ColumnName IS NULL THEN 'Missing in Source'
        WHEN T.ColumnName IS NULL THEN 'Missing in Target'
        WHEN S.DataType <> T.DataType THEN 'Data Type Mismatch'
        WHEN S.MaxLength <> T.MaxLength THEN 'Length Mismatch'
        WHEN S.IsNullable <> T.IsNullable THEN 'Nullability Mismatch'
        ELSE 'Match'
    END AS SchemaStatus
FROM SourceSchema S
FULL OUTER JOIN TargetSchema T 
    ON S.TableName = T.TableName 
    AND S.ColumnName = T.ColumnName
ORDER BY TableName, ColumnName;

PRINT '';

-- =============================================
-- Compare Primary Keys
-- =============================================
PRINT '--- Primary Key Comparison ---';

WITH SourcePK AS (
    SELECT 
        t.name AS TableName,
        i.name AS ConstraintName,
        c.name AS ColumnName
    FROM SourceDB.sys.tables t
    INNER JOIN SourceDB.sys.indexes i ON t.object_id = i.object_id
    INNER JOIN SourceDB.sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
    INNER JOIN SourceDB.sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
    WHERE i.is_primary_key = 1
    AND t.name IN ('Customers', 'Orders')
),
TargetPK AS (
    SELECT 
        t.name AS TableName,
        i.name AS ConstraintName,
        c.name AS ColumnName
    FROM TargetDB.sys.tables t
    INNER JOIN TargetDB.sys.indexes i ON t.object_id = i.object_id
    INNER JOIN TargetDB.sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
    INNER JOIN TargetDB.sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
    WHERE i.is_primary_key = 1
    AND t.name IN ('Customers', 'Orders')
)
SELECT 
    COALESCE(S.TableName, T.TableName) AS TableName,
    S.ColumnName AS SourcePKColumn,
    T.ColumnName AS TargetPKColumn,
    CASE 
        WHEN S.ColumnName = T.ColumnName THEN 'Match'
        ELSE 'Mismatch'
    END AS PKStatus
FROM SourcePK S
FULL OUTER JOIN TargetPK T ON S.TableName = T.TableName
ORDER BY TableName;

PRINT '';

-- =============================================
-- Compare Foreign Keys
-- =============================================
PRINT '--- Foreign Key Comparison ---';

WITH SourceFK AS (
    SELECT 
        OBJECT_NAME(fk.parent_object_id) AS TableName,
        fk.name AS FKName,
        OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable,
        COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS FKColumn
    FROM SourceDB.sys.foreign_keys fk
    INNER JOIN SourceDB.sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
),
TargetFK AS (
    SELECT 
        OBJECT_NAME(fk.parent_object_id) AS TableName,
        fk.name AS FKName,
        OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable,
        COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS FKColumn
    FROM TargetDB.sys.foreign_keys fk
    INNER JOIN TargetDB.sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
)
SELECT 
    COALESCE(S.TableName, T.TableName) AS TableName,
    S.FKColumn AS SourceFKColumn,
    T.FKColumn AS TargetFKColumn,
    S.ReferencedTable AS SourceReferencedTable,
    T.ReferencedTable AS TargetReferencedTable,
    CASE 
        WHEN S.FKColumn IS NULL THEN 'Missing in Source'
        WHEN T.FKColumn IS NULL THEN 'Missing in Target'
        WHEN S.FKColumn = T.FKColumn AND S.ReferencedTable = T.ReferencedTable THEN 'Match'
        ELSE 'Mismatch'
    END AS FKStatus
FROM SourceFK S
FULL OUTER JOIN TargetFK T 
    ON S.TableName = T.TableName 
    AND S.FKColumn = T.FKColumn
ORDER BY TableName;

GO
