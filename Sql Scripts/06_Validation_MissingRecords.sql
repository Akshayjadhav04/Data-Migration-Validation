-- =============================================
-- Missing Records Validation
-- Purpose: Find records that exist in source but missing in target
-- Author: Data Migration Validation Project
-- Date: 2026-01-31
-- =============================================

-- =============================================
-- Instructions:
-- 1. Run this script in SQL Server Management Studio
-- 2. Copy the results for each query
-- 3. Paste into Excel "Discrepancy Details" sheet
-- =============================================

PRINT '========================================';
PRINT 'MISSING RECORDS IN TARGET';
PRINT '========================================';
PRINT '';

-- =============================================
-- Missing Customers
-- =============================================
PRINT '--- Missing Customers ---';
SELECT 
    'Customer' AS RecordType,
    S.CustomerID,
    S.FirstName,
    S.LastName,
    S.Email,
    S.Country,
    'Missing in Target' AS IssueType,
    'HIGH' AS Severity
FROM SourceDB.dbo.Customers S
LEFT JOIN TargetDB.dbo.Customers T ON S.CustomerID = T.CustomerID
WHERE T.CustomerID IS NULL
ORDER BY S.CustomerID;

DECLARE @MissingCustomers INT = (
    SELECT COUNT(*) 
    FROM SourceDB.dbo.Customers S
    LEFT JOIN TargetDB.dbo.Customers T ON S.CustomerID = T.CustomerID
    WHERE T.CustomerID IS NULL
);

PRINT CONCAT('Total Missing Customers: ', @MissingCustomers);
PRINT '';

-- =============================================
-- Missing Orders
-- =============================================
PRINT '--- Missing Orders ---';
SELECT 
    'Order' AS RecordType,
    S.OrderID,
    S.CustomerID,
    S.OrderDate,
    S.ProductName,
    S.TotalAmount,
    S.Status,
    'Missing in Target' AS IssueType,
    'HIGH' AS Severity
FROM SourceDB.dbo.Orders S
LEFT JOIN TargetDB.dbo.Orders T ON S.OrderID = T.OrderID
WHERE T.OrderID IS NULL
ORDER BY S.OrderID;

DECLARE @MissingOrders INT = (
    SELECT COUNT(*) 
    FROM SourceDB.dbo.Orders S
    LEFT JOIN TargetDB.dbo.Orders T ON S.OrderID = T.OrderID
    WHERE T.OrderID IS NULL
);

PRINT CONCAT('Total Missing Orders: ', @MissingOrders);
PRINT '';

-- =============================================
-- Summary
-- =============================================
PRINT '========================================';
PRINT 'MISSING RECORDS SUMMARY';
PRINT '========================================';

SELECT 
    'Customers' AS TableName,
    @MissingCustomers AS MissingCount
UNION ALL
SELECT 
    'Orders' AS TableName,
    @MissingOrders AS MissingCount;

GO
