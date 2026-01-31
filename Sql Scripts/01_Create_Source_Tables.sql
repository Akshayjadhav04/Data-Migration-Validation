-- =============================================
-- Create Source Database Tables
-- Purpose: Create tables in the source database for migration validation
-- Author: Data Migration Validation Project
-- Date: 2026-01-31
-- =============================================

USE SourceDB;
GO

-- Drop tables if they exist (for clean re-run)
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
GO

-- =============================================
-- Create Customers Table
-- =============================================
CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20),
    RegistrationDate DATE NOT NULL,
    Country NVARCHAR(50),
    TotalOrders INT DEFAULT 0,
    TotalSpent DECIMAL(10, 2) DEFAULT 0.00
);
GO

-- =============================================
-- Create Orders Table
-- =============================================
CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    ProductName NVARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    Status NVARCHAR(20) NOT NULL,
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) 
        REFERENCES dbo.Customers(CustomerID)
);
GO

-- =============================================
-- Verification: Display table structures
-- =============================================
PRINT 'Source tables created successfully!';
PRINT '';
PRINT 'Customers Table Structure:';
EXEC sp_help 'dbo.Customers';
PRINT '';
PRINT 'Orders Table Structure:';
EXEC sp_help 'dbo.Orders';
GO
