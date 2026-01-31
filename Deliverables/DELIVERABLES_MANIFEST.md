# Final Deliverables: Data Migration Validation

## 1. SQL Comparison Scripts
**Location**: `[Project Root]\SQL_Scripts\`

These scripts perform the actual validation logic against the SQL Server database.

- **05_Validation_RecordCounts.sql**: Compares total row counts.
- **06_Validation_MissingRecords.sql**: Identifies records missing in target.
- **07_Validation_ExtraRecords.sql**: Identifies records added in target.
- **08_Validation_DataMismatches.sql**: Compares specific column values.
- **09_Validation_SchemaCheck.sql**: Validates table structure.
- **10_Validation_ReferentialIntegrity.sql**: Checks for orphaned records.
- **11_Master_Validation.sql**: Runs ALL checks and produces a summary.

## 2. Excel Summary & Discrepancy Reports
**Location**: `[Project Root]\Deliverables\Final_Reports\`

Since I cannot generate binary `.xlsx` files directly, I have generated these reports as **CSV files** which open directly in Excel.

- **01_Summary_Dashboard.csv**: High-level overview of the migration status (Pass/Fail/Warning).
- **02_Record_Count_Report.csv**: Detailed table-by-table count comparison.
- **03_Discrepancy_Details.csv**: The specific rows (IDs) that failed validation.

---

### How to use
1. Run the **SQL Scripts** in SQL Server Management Studio (SSMS) to perform the validation on your actual database.
2. Open the **CSV Reports** in Excel to view the results (currently pre-filled with the Sample Data results).
3. To update the reports with *your* real data, simply copy the results from SSMS and paste them into the CSV/Excel files.
