-- =============================================
-- Referential Integrity Validation
-- Purpose: Verify foreign key relationships and orphaned records
-- Author: Data Migration Validation Project
-- Date: 2026-01-31
-- =============================================

-- =============================================
-- Instructions:
-- 1. Run this script in SQL Server Management Studio
-- 2. Review the referential integrity violations
-- 3. Paste into Excel "Referential Integrity" sheet
-- =============================================

PRINT '========================================';
PRINT 'REFERENTIAL INTEGRITY VALIDATION';
PRINT '========================================';
PRINT '';

-- =============================================
-- Check Orphaned Orders in Source
-- =============================================
PRINT '--- Orphaned Orders in Source (No Matching Customer) ---';

SELECT 
    'Source' AS Database,
    O.OrderID,
    O.CustomerID AS OrphanedCustomerID,
    O.OrderDate,
    O.ProductName,
    O.TotalAmount,
    'Orphaned Order' AS IssueType,
    'CRITICAL' AS Severity
FROM SourceDB.dbo.Orders O
LEFT JOIN SourceDB.dbo.Customers C ON O.CustomerID = C.CustomerID
WHERE C.CustomerID IS NULL;

DECLARE @SourceOrphaned INT = (
    SELECT COUNT(*) 
    FROM SourceDB.dbo.Orders O
    LEFT JOIN SourceDB.dbo.Customers C ON O.CustomerID = C.CustomerID
    WHERE C.CustomerID IS NULL
);

PRINT CONCAT('Source Orphaned Orders: ', @SourceOrphaned);
PRINT '';

-- =============================================
-- Check Orphaned Orders in Target
-- =============================================
PRINT '--- Orphaned Orders in Target (No Matching Customer) ---';

SELECT 
    'Target' AS Database,
    O.OrderID,
    O.CustomerID AS OrphanedCustomerID,
    O.OrderDate,
    O.ProductName,
    O.TotalAmount,
    'Orphaned Order' AS IssueType,
    'CRITICAL' AS Severity
FROM TargetDB.dbo.Orders O
LEFT JOIN TargetDB.dbo.Customers C ON O.CustomerID = C.CustomerID
WHERE C.CustomerID IS NULL;

DECLARE @TargetOrphaned INT = (
    SELECT COUNT(*) 
    FROM TargetDB.dbo.Orders O
    LEFT JOIN TargetDB.dbo.Customers C ON O.CustomerID = C.CustomerID
    WHERE C.CustomerID IS NULL
);

PRINT CONCAT('Target Orphaned Orders: ', @TargetOrphaned);
PRINT '';

-- =============================================
-- Check Customers Without Orders (Source)
-- =============================================
PRINT '--- Customers Without Orders in Source ---';

SELECT 
    'Source' AS Database,
    C.CustomerID,
    C.FirstName,
    C.LastName,
    C.Email,
    COUNT(O.OrderID) AS OrderCount,
    'Customer Without Orders' AS IssueType,
    'LOW' AS Severity
FROM SourceDB.dbo.Customers C
LEFT JOIN SourceDB.dbo.Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.FirstName, C.LastName, C.Email
HAVING COUNT(O.OrderID) = 0;

PRINT '';

-- =============================================
-- Check Customers Without Orders (Target)
-- =============================================
PRINT '--- Customers Without Orders in Target ---';

SELECT 
    'Target' AS Database,
    C.CustomerID,
    C.FirstName,
    C.LastName,
    C.Email,
    COUNT(O.OrderID) AS OrderCount,
    'Customer Without Orders' AS IssueType,
    'LOW' AS Severity
FROM TargetDB.dbo.Customers C
LEFT JOIN TargetDB.dbo.Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.FirstName, C.LastName, C.Email
HAVING COUNT(O.OrderID) = 0;

PRINT '';

-- =============================================
-- Summary
-- =============================================
PRINT '========================================';
PRINT 'REFERENTIAL INTEGRITY SUMMARY';
PRINT '========================================';

SELECT 
    'Source Database' AS Database,
    @SourceOrphaned AS OrphanedOrders,
    CASE WHEN @SourceOrphaned = 0 THEN 'PASS' ELSE 'FAIL' END AS Status
UNION ALL
SELECT 
    'Target Database' AS Database,
    @TargetOrphaned AS OrphanedOrders,
    CASE WHEN @TargetOrphaned = 0 THEN 'PASS' ELSE 'FAIL' END AS Status;

GO
