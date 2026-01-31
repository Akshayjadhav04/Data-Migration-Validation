-- =============================================
-- MASTER VALIDATION SCRIPT
-- Purpose: Execute all validation checks and provide comprehensive summary
-- Author: Data Migration Validation Project
-- Date: 2026-01-31
-- =============================================

-- =============================================
-- This script runs ALL validation checks:
-- 1. Record Count Comparison
-- 2. Missing Records Detection
-- 3. Extra Records Detection
-- 4. Data Value Mismatches
-- 5. Referential Integrity
-- =============================================

SET NOCOUNT ON;

PRINT '========================================';
PRINT 'DATA MIGRATION VALIDATION REPORT';
PRINT 'Execution Date: ' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '========================================';
PRINT '';

-- =============================================
-- 1. RECORD COUNT VALIDATION
-- =============================================
PRINT '========================================';
PRINT '1. RECORD COUNT VALIDATION';
PRINT '========================================';

DECLARE @SourceCustomers INT = (SELECT COUNT(*) FROM SourceDB.dbo.Customers);
DECLARE @TargetCustomers INT = (SELECT COUNT(*) FROM TargetDB.dbo.Customers);
DECLARE @SourceOrders INT = (SELECT COUNT(*) FROM SourceDB.dbo.Orders);
DECLARE @TargetOrders INT = (SELECT COUNT(*) FROM TargetDB.dbo.Orders);

SELECT 
    TableName,
    SourceCount,
    TargetCount,
    Variance,
    Status
FROM (
    SELECT 
        'Customers' AS TableName,
        @SourceCustomers AS SourceCount,
        @TargetCustomers AS TargetCount,
        @TargetCustomers - @SourceCustomers AS Variance,
        CASE WHEN @SourceCustomers = @TargetCustomers THEN 'PASS' ELSE 'FAIL' END AS Status
    UNION ALL
    SELECT 
        'Orders',
        @SourceOrders,
        @TargetOrders,
        @TargetOrders - @SourceOrders,
        CASE WHEN @SourceOrders = @TargetOrders THEN 'PASS' ELSE 'FAIL' END
) AS RecordCounts;

PRINT '';

-- =============================================
-- 2. MISSING RECORDS COUNT
-- =============================================
PRINT '========================================';
PRINT '2. MISSING RECORDS (Source → Target)';
PRINT '========================================';

DECLARE @MissingCustomers INT = (
    SELECT COUNT(*) 
    FROM SourceDB.dbo.Customers S
    LEFT JOIN TargetDB.dbo.Customers T ON S.CustomerID = T.CustomerID
    WHERE T.CustomerID IS NULL
);

DECLARE @MissingOrders INT = (
    SELECT COUNT(*) 
    FROM SourceDB.dbo.Orders S
    LEFT JOIN TargetDB.dbo.Orders T ON S.OrderID = T.OrderID
    WHERE T.OrderID IS NULL
);

SELECT 'Customers' AS TableName, @MissingCustomers AS MissingCount
UNION ALL
SELECT 'Orders', @MissingOrders;

PRINT CONCAT('Total Missing Customers: ', @MissingCustomers);
PRINT CONCAT('Total Missing Orders: ', @MissingOrders);
PRINT '';

-- =============================================
-- 3. EXTRA RECORDS COUNT
-- =============================================
PRINT '========================================';
PRINT '3. EXTRA RECORDS (Target only)';
PRINT '========================================';

DECLARE @ExtraCustomers INT = (
    SELECT COUNT(*) 
    FROM TargetDB.dbo.Customers T
    LEFT JOIN SourceDB.dbo.Customers S ON T.CustomerID = S.CustomerID
    WHERE S.CustomerID IS NULL
);

DECLARE @ExtraOrders INT = (
    SELECT COUNT(*) 
    FROM TargetDB.dbo.Orders T
    LEFT JOIN SourceDB.dbo.Orders S ON T.OrderID = S.OrderID
    WHERE S.OrderID IS NULL
);

SELECT 'Customers' AS TableName, @ExtraCustomers AS ExtraCount
UNION ALL
SELECT 'Orders', @ExtraOrders;

PRINT CONCAT('Total Extra Customers: ', @ExtraCustomers);
PRINT CONCAT('Total Extra Orders: ', @ExtraOrders);
PRINT '';

-- =============================================
-- 4. DATA MISMATCHES COUNT
-- =============================================
PRINT '========================================';
PRINT '4. DATA VALUE MISMATCHES';
PRINT '========================================';

DECLARE @CustomerMismatches INT;
DECLARE @OrderMismatches INT;

SELECT @CustomerMismatches = COUNT(DISTINCT S.CustomerID)
FROM SourceDB.dbo.Customers S
INNER JOIN TargetDB.dbo.Customers T ON S.CustomerID = T.CustomerID
WHERE S.FirstName <> T.FirstName
   OR S.LastName <> T.LastName
   OR S.Email <> T.Email
   OR S.TotalSpent <> T.TotalSpent;

SELECT @OrderMismatches = COUNT(DISTINCT S.OrderID)
FROM SourceDB.dbo.Orders S
INNER JOIN TargetDB.dbo.Orders T ON S.OrderID = T.OrderID
WHERE S.Status <> T.Status
   OR S.TotalAmount <> T.TotalAmount
   OR S.ProductName <> T.ProductName;

SELECT 'Customers' AS TableName, @CustomerMismatches AS MismatchCount
UNION ALL
SELECT 'Orders', @OrderMismatches;

PRINT CONCAT('Customer Records with Mismatches: ', @CustomerMismatches);
PRINT CONCAT('Order Records with Mismatches: ', @OrderMismatches);
PRINT '';

-- =============================================
-- 5. REFERENTIAL INTEGRITY CHECK
-- =============================================
PRINT '========================================';
PRINT '5. REFERENTIAL INTEGRITY';
PRINT '========================================';

DECLARE @SourceOrphaned INT = (
    SELECT COUNT(*) 
    FROM SourceDB.dbo.Orders O
    LEFT JOIN SourceDB.dbo.Customers C ON O.CustomerID = C.CustomerID
    WHERE C.CustomerID IS NULL
);

DECLARE @TargetOrphaned INT = (
    SELECT COUNT(*) 
    FROM TargetDB.dbo.Orders O
    LEFT JOIN TargetDB.dbo.Customers C ON O.CustomerID = C.CustomerID
    WHERE C.CustomerID IS NULL
);

SELECT 'Source Database' AS Database, @SourceOrphaned AS OrphanedOrders
UNION ALL
SELECT 'Target Database', @TargetOrphaned;

PRINT CONCAT('Source Orphaned Orders: ', @SourceOrphaned);
PRINT CONCAT('Target Orphaned Orders: ', @TargetOrphaned);
PRINT '';

-- =============================================
-- FINAL SUMMARY
-- =============================================
PRINT '========================================';
PRINT 'FINAL VALIDATION SUMMARY';
PRINT '========================================';

DECLARE @TotalIssues INT = @MissingCustomers + @MissingOrders + 
                           @ExtraCustomers + @ExtraOrders + 
                           @CustomerMismatches + @OrderMismatches + 
                           @TargetOrphaned;

DECLARE @MigrationStatus NVARCHAR(20) = CASE 
    WHEN @TotalIssues = 0 THEN 'SUCCESS'
    WHEN @TotalIssues <= 5 THEN 'WARNING'
    ELSE 'FAILED'
END;

SELECT 
    'Migration Validation' AS ValidationName,
    @TotalIssues AS TotalIssues,
    @MigrationStatus AS OverallStatus,
    GETDATE() AS ValidationDate;

PRINT '';
PRINT CONCAT('Total Issues Found: ', @TotalIssues);
PRINT CONCAT('Migration Status: ', @MigrationStatus);
PRINT '';

IF @TotalIssues = 0
    PRINT '✓ Data migration validation PASSED! No discrepancies found.';
ELSE IF @TotalIssues <= 5
    PRINT '⚠ Data migration validation completed with WARNINGS. Please review issues.';
ELSE
    PRINT '✗ Data migration validation FAILED! Critical issues found.';

PRINT '';
PRINT '========================================';
PRINT 'END OF VALIDATION REPORT';
PRINT '========================================';

SET NOCOUNT OFF;
GO
