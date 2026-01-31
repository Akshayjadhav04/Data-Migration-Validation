-- =============================================
-- Data Value Mismatches Validation
-- Purpose: Find records where field values differ between source and target
-- Author: Data Migration Validation Project
-- Date: 2026-01-31
-- =============================================

-- =============================================
-- Instructions:
-- 1. Run this script in SQL Server Management Studio
-- 2. Review the mismatched records
-- 3. Paste into Excel "Discrepancy Details" sheet
-- =============================================

PRINT '========================================';
PRINT 'DATA VALUE MISMATCHES';
PRINT '========================================';
PRINT '';

-- =============================================
-- Customer Data Mismatches
-- =============================================
PRINT '--- Customer Data Mismatches ---';
SELECT 
    'Customer' AS RecordType,
    S.CustomerID,
    'FirstName' AS FieldName,
    S.FirstName AS SourceValue,
    T.FirstName AS TargetValue,
    'Data Mismatch' AS IssueType,
    'MEDIUM' AS Severity
FROM SourceDB.dbo.Customers S
INNER JOIN TargetDB.dbo.Customers T ON S.CustomerID = T.CustomerID
WHERE S.FirstName <> T.FirstName

UNION ALL

SELECT 
    'Customer' AS RecordType,
    S.CustomerID,
    'LastName' AS FieldName,
    S.LastName AS SourceValue,
    T.LastName AS TargetValue,
    'Data Mismatch' AS IssueType,
    'MEDIUM' AS Severity
FROM SourceDB.dbo.Customers S
INNER JOIN TargetDB.dbo.Customers T ON S.CustomerID = T.CustomerID
WHERE S.LastName <> T.LastName

UNION ALL

SELECT 
    'Customer' AS RecordType,
    S.CustomerID,
    'Email' AS FieldName,
    S.Email AS SourceValue,
    T.Email AS TargetValue,
    'Data Mismatch' AS IssueType,
    'HIGH' AS Severity
FROM SourceDB.dbo.Customers S
INNER JOIN TargetDB.dbo.Customers T ON S.CustomerID = T.CustomerID
WHERE S.Email <> T.Email

UNION ALL

SELECT 
    'Customer' AS RecordType,
    S.CustomerID,
    'TotalSpent' AS FieldName,
    CAST(S.TotalSpent AS NVARCHAR) AS SourceValue,
    CAST(T.TotalSpent AS NVARCHAR) AS TargetValue,
    'Data Mismatch' AS IssueType,
    'HIGH' AS Severity
FROM SourceDB.dbo.Customers S
INNER JOIN TargetDB.dbo.Customers T ON S.CustomerID = T.CustomerID
WHERE S.TotalSpent <> T.TotalSpent

ORDER BY CustomerID, FieldName;

PRINT '';

-- =============================================
-- Order Data Mismatches
-- =============================================
PRINT '--- Order Data Mismatches ---';
SELECT 
    'Order' AS RecordType,
    S.OrderID,
    'Status' AS FieldName,
    S.Status AS SourceValue,
    T.Status AS TargetValue,
    'Data Mismatch' AS IssueType,
    'MEDIUM' AS Severity
FROM SourceDB.dbo.Orders S
INNER JOIN TargetDB.dbo.Orders T ON S.OrderID = T.OrderID
WHERE S.Status <> T.Status

UNION ALL

SELECT 
    'Order' AS RecordType,
    S.OrderID,
    'TotalAmount' AS FieldName,
    CAST(S.TotalAmount AS NVARCHAR) AS SourceValue,
    CAST(T.TotalAmount AS NVARCHAR) AS TargetValue,
    'Data Mismatch' AS IssueType,
    'HIGH' AS Severity
FROM SourceDB.dbo.Orders S
INNER JOIN TargetDB.dbo.Orders T ON S.OrderID = T.OrderID
WHERE S.TotalAmount <> T.TotalAmount

UNION ALL

SELECT 
    'Order' AS RecordType,
    S.OrderID,
    'ProductName' AS FieldName,
    S.ProductName AS SourceValue,
    T.ProductName AS TargetValue,
    'Data Mismatch' AS IssueType,
    'MEDIUM' AS Severity
FROM SourceDB.dbo.Orders S
INNER JOIN TargetDB.dbo.Orders T ON S.OrderID = T.OrderID
WHERE S.ProductName <> T.ProductName

ORDER BY OrderID, FieldName;

PRINT '';

-- =============================================
-- Summary
-- =============================================
PRINT '========================================';
PRINT 'DATA MISMATCH SUMMARY';
PRINT '========================================';

DECLARE @CustomerMismatches INT;
DECLARE @OrderMismatches INT;

-- Count customer mismatches
SELECT @CustomerMismatches = COUNT(DISTINCT S.CustomerID)
FROM SourceDB.dbo.Customers S
INNER JOIN TargetDB.dbo.Customers T ON S.CustomerID = T.CustomerID
WHERE S.FirstName <> T.FirstName
   OR S.LastName <> T.LastName
   OR S.Email <> T.Email
   OR S.TotalSpent <> T.TotalSpent;

-- Count order mismatches
SELECT @OrderMismatches = COUNT(DISTINCT S.OrderID)
FROM SourceDB.dbo.Orders S
INNER JOIN TargetDB.dbo.Orders T ON S.OrderID = T.OrderID
WHERE S.Status <> T.Status
   OR S.TotalAmount <> T.TotalAmount
   OR S.ProductName <> T.ProductName;

SELECT 
    'Customers' AS TableName,
    @CustomerMismatches AS RecordsWithMismatches
UNION ALL
SELECT 
    'Orders' AS TableName,
    @OrderMismatches AS RecordsWithMismatches;

GO
