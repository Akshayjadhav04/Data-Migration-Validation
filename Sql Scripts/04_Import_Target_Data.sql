-- =============================================
-- Import Target Data from CSV Files
-- Purpose: Load data from CSV files into target database tables
-- Author: Data Migration Validation Project
-- Date: 2026-01-31
-- =============================================

USE TargetDB;
GO

-- =============================================
-- IMPORTANT: Update file paths before running!
-- Replace 'C:\Users\aksha\OneDrive\Desktop\Data Migration Validation2\'
-- with your actual file path if different
-- =============================================

DECLARE @TargetPath NVARCHAR(500) = 'C:\Users\aksha\OneDrive\Desktop\Data Migration Validation2\';

-- =============================================
-- Import Customers Data
-- =============================================
PRINT 'Importing Customers data...';

BULK INSERT dbo.Customers
FROM 'C:\Users\aksha\OneDrive\Desktop\Data Migration Validation2\target_customers.csv'
WITH (
    FIRSTROW = 2,              -- Skip header row
    FIELDTERMINATOR = ',',     -- CSV delimiter
    ROWTERMINATOR = '\n',      -- New line delimiter
    TABLOCK,
    FORMAT = 'CSV'
);

PRINT 'Customers imported successfully!';
PRINT CONCAT('Total Customers: ', (SELECT COUNT(*) FROM dbo.Customers));
GO

-- =============================================
-- Import Orders Data
-- =============================================
PRINT '';
PRINT 'Importing Orders data...';

BULK INSERT dbo.Orders
FROM 'C:\Users\aksha\OneDrive\Desktop\Data Migration Validation2\target_orders.csv'
WITH (
    FIRSTROW = 2,              -- Skip header row
    FIELDTERMINATOR = ',',     -- CSV delimiter
    ROWTERMINATOR = '\n',      -- New line delimiter
    TABLOCK,
    FORMAT = 'CSV'
);

PRINT 'Orders imported successfully!';
PRINT CONCAT('Total Orders: ', (SELECT COUNT(*) FROM dbo.Orders));
GO

-- =============================================
-- Verification: Display sample data
-- =============================================
PRINT '';
PRINT '=== Sample Customers Data ===';
SELECT TOP 5 * FROM dbo.Customers ORDER BY CustomerID;

PRINT '';
PRINT '=== Sample Orders Data ===';
SELECT TOP 5 * FROM dbo.Orders ORDER BY OrderID;
GO

-- =============================================
-- Alternative Method: Using OPENROWSET
-- Uncomment if BULK INSERT doesn't work
-- =============================================
/*
-- Enable Ad Hoc Distributed Queries first:
-- EXEC sp_configure 'show advanced options', 1;
-- RECONFIGURE;
-- EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
-- RECONFIGURE;

INSERT INTO dbo.Customers
SELECT * FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'Text;Database=C:\Users\aksha\OneDrive\Desktop\Data Migration Validation2\;HDR=YES',
    'SELECT * FROM target_customers.csv'
);

INSERT INTO dbo.Orders
SELECT * FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'Text;Database=C:\Users\aksha\OneDrive\Desktop\Data Migration Validation2\;HDR=YES',
    'SELECT * FROM target_orders.csv'
);
*/
