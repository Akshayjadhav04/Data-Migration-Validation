-- =============================================
-- Extra Records Validation
-- Purpose: Find records that exist in target but not in source
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
PRINT 'EXTRA RECORDS IN TARGET';
PRINT '========================================';
PRINT '';

-- =============================================
-- Extra Customers (not in source)
-- =============================================
PRINT '--- Extra Customers ---';
SELECT 
    'Customer' AS RecordType,
    T.CustomerID,
    T.FirstName,
    T.LastName,
    T.Email,
    T.Country,
    'Extra in Target (Not in Source)' AS IssueType,
    'MEDIUM' AS Severity
FROM TargetDB.dbo.Customers T
LEFT JOIN SourceDB.dbo.Customers S ON T.CustomerID = S.CustomerID
WHERE S.CustomerID IS NULL
ORDER BY T.CustomerID;

DECLARE @ExtraCustomers INT = (
    SELECT COUNT(*) 
    FROM TargetDB.dbo.Customers T
    LEFT JOIN SourceDB.dbo.Customers S ON T.CustomerID = S.CustomerID
    WHERE S.CustomerID IS NULL
);

PRINT CONCAT('Total Extra Customers: ', @ExtraCustomers);
PRINT '';

-- =============================================
-- Extra Orders (not in source)
-- =============================================
PRINT '--- Extra Orders ---';
SELECT 
    'Order' AS RecordType,
    T.OrderID,
    T.CustomerID,
    T.OrderDate,
    T.ProductName,
    T.TotalAmount,
    T.Status,
    'Extra in Target (Not in Source)' AS IssueType,
    'MEDIUM' AS Severity
FROM TargetDB.dbo.Orders T
LEFT JOIN SourceDB.dbo.Orders S ON T.OrderID = S.OrderID
WHERE S.OrderID IS NULL
ORDER BY T.OrderID;

DECLARE @ExtraOrders INT = (
    SELECT COUNT(*) 
    FROM TargetDB.dbo.Orders T
    LEFT JOIN SourceDB.dbo.Orders S ON T.OrderID = S.OrderID
    WHERE S.OrderID IS NULL
);

PRINT CONCAT('Total Extra Orders: ', @ExtraOrders);
PRINT '';

-- =============================================
-- Summary
-- =============================================
PRINT '========================================';
PRINT 'EXTRA RECORDS SUMMARY';
PRINT '========================================';

SELECT 
    'Customers' AS TableName,
    @ExtraCustomers AS ExtraCount
UNION ALL
SELECT 
    'Orders' AS TableName,
    @ExtraOrders AS ExtraCount;

GO
