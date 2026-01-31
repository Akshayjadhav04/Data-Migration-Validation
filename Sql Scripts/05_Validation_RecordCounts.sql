-- =============================================
-- Record Count Comparison
-- Purpose: Compare record counts between source and target databases
-- Author: Data Migration Validation Project
-- Date: 2026-01-31
-- =============================================

-- =============================================
-- Instructions:
-- 1. Run this script in SQL Server Management Studio
-- 2. Copy the results grid
-- 3. Paste into Excel "Record Count Report" sheet
-- =============================================

PRINT '========================================';
PRINT 'RECORD COUNT COMPARISON';
PRINT '========================================';
PRINT '';

-- =============================================
-- Compare Customers Table
-- =============================================
SELECT 
    'Customers' AS TableName,
    (SELECT COUNT(*) FROM SourceDB.dbo.Customers) AS SourceCount,
    (SELECT COUNT(*) FROM TargetDB.dbo.Customers) AS TargetCount,
    (SELECT COUNT(*) FROM TargetDB.dbo.Customers) - 
    (SELECT COUNT(*) FROM SourceDB.dbo.Customers) AS Variance,
    CASE 
        WHEN (SELECT COUNT(*) FROM SourceDB.dbo.Customers) = 
             (SELECT COUNT(*) FROM TargetDB.dbo.Customers) 
        THEN 'PASS' 
        ELSE 'FAIL' 
    END AS Status
UNION ALL

-- =============================================
-- Compare Orders Table
-- =============================================
SELECT 
    'Orders' AS TableName,
    (SELECT COUNT(*) FROM SourceDB.dbo.Orders) AS SourceCount,
    (SELECT COUNT(*) FROM TargetDB.dbo.Orders) AS TargetCount,
    (SELECT COUNT(*) FROM TargetDB.dbo.Orders) - 
    (SELECT COUNT(*) FROM SourceDB.dbo.Orders) AS Variance,
    CASE 
        WHEN (SELECT COUNT(*) FROM SourceDB.dbo.Orders) = 
             (SELECT COUNT(*) FROM TargetDB.dbo.Orders) 
        THEN 'PASS' 
        ELSE 'FAIL' 
    END AS Status;

-- =============================================
-- Overall Summary
-- =============================================
PRINT '';
PRINT '========================================';
PRINT 'SUMMARY';
PRINT '========================================';

DECLARE @TotalTables INT = 2;
DECLARE @PassedTables INT = 0;

IF (SELECT COUNT(*) FROM SourceDB.dbo.Customers) = 
   (SELECT COUNT(*) FROM TargetDB.dbo.Customers)
    SET @PassedTables = @PassedTables + 1;

IF (SELECT COUNT(*) FROM SourceDB.dbo.Orders) = 
   (SELECT COUNT(*) FROM TargetDB.dbo.Orders)
    SET @PassedTables = @PassedTables + 1;

SELECT 
    @TotalTables AS TotalTables,
    @PassedTables AS PassedTables,
    @TotalTables - @PassedTables AS FailedTables,
    CASE 
        WHEN @PassedTables = @TotalTables THEN 'ALL PASSED' 
        ELSE 'DISCREPANCIES FOUND' 
    END AS OverallStatus;

GO
