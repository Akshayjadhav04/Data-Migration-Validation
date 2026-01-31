# 🚀 Data Migration Validation Project

## Complete Solution for SQL-Based Data Migration Validation

---

## 📖 Project Overview

This project provides a complete, professional-grade solution for validating data integrity after database migration. It includes SQL scripts for comprehensive validation checks and Excel templates for clear reporting.

**Perfect for**: Database administrators, data engineers, QA teams, and anyone responsible for ensuring data migration accuracy.

---
<img width="1151" height="933" alt="Screenshot 2026-02-01 015717" src="https://github.com/user-attachments/assets/d1234057-6f51-4dce-85da-053798c4f527" />

## 🎯 What's Included

### 📁 Folder Structure

```
Data Migration Validation2/
│
├── 📊 Sample Data
│   ├── source_customers.csv          (20 customer records - original data)
│   ├── source_orders.csv             (15 order records - original data)
│   ├── target_customers.csv          (19 customer records - with issues)
│   └── target_orders.csv             (15 order records - with issues)
│
├── 💾 SQL_Scripts/
│   ├── 01_Create_Source_Tables.sql   (Source database setup)
│   ├── 02_Create_Target_Tables.sql   (Target database setup)
│   ├── 03_Import_Source_Data.sql     (Import source CSV data)
│   ├── 04_Import_Target_Data.sql     (Import target CSV data)
│   ├── 05_Validation_RecordCounts.sql (Count comparison)
│   ├── 06_Validation_MissingRecords.sql (Missing records check)
│   ├── 07_Validation_ExtraRecords.sql (Extra records check)
│   ├── 08_Validation_DataMismatches.sql (Field-level comparison)
│   ├── 09_Validation_SchemaCheck.sql (Schema validation)
│   ├── 10_Validation_ReferentialIntegrity.sql (FK validation)
│   └── 11_Master_Validation.sql      (Complete validation report)
│
├── 🛠️ Tools/
│   └── Run_Excel_Validator.ps1       (AUTOMATED Excel Report Generator)
│
├── 📋 Deliverables/
│   └── Final_Excel_Validation_Report.xlsx (The Final Dashboard Output)
│
├── 📚 Documentation/
│   ├── SQL_Scripts_Guide.md          (How to use SQL scripts)
│   ├── Excel_Template_Guide.md       (Excel reporting guide)
│   └── Complete_Workflow.md          (Step-by-step process)
│
└── README.md                         (This file)
```

---

## ✨ Key Features

### 🔍 Comprehensive Validation Checks

- ✅ **Record Count Comparison** - Verify total records match
- ✅ **Missing Records Detection** - Find records lost during migration
- ✅ **Extra Records Detection** - Identify unexpected new records
- ✅ **Data Value Comparison** - Field-by-field value matching
- ✅ **Schema Validation** - Ensure table structures match
- ✅ **Referential Integrity** - Check foreign key relationships
- ✅ **Master Validation** - All-in-one comprehensive report

### 📊 Professional Reporting

- Excel templates with pre-configured formulas
- Color-coded status indicators (Pass/Fail/Warning)
- Executive summary dashboard
- Detailed discrepancy tracking
- Severity classification (Critical/High/Medium/Low)

### 🎓 Learning Resources

- Sample datasets with intentional discrepancies
- Detailed inline code comments
- Step-by-step documentation
- Troubleshooting guides
- Best practices included

---

## 🚀 Quick Start (30 minutes)

### Prerequisites

- SQL Server (any edition)
- SQL Server Management Studio (SSMS)
- Microsoft Excel
- Basic SQL knowledge

### Step 1: Create Databases

```sql
CREATE DATABASE SourceDB;
CREATE DATABASE TargetDB;
```

### Step 2: Run Setup Scripts

1. Execute `01_Create_Source_Tables.sql`
2. Execute `02_Create_Target_Tables.sql`
3. Update paths and run `03_Import_Source_Data.sql`
4. Update paths and run `04_Import_Target_Data.sql`

### Step 3: Run Validation

```sql
-- Quick validation (recommended first)
Execute: 11_Master_Validation.sql

-- Detailed validation (for Excel reporting)
Execute: Scripts 05-10 individually
```

### Step 4: Generate Excel Report (AUTOMATED)

1. Navigate to the `Tools` folder.
2. Run the `Run_Excel_Validator.ps1` script (Right-click -> Run with PowerShell).
3. The script will automatically:
   - Import all CSV data
   - Apply validation formulas
   - Generate the **Summary Dashboard**
   - Save the file as `Deliverables/Final_Excel_Validation_Report.xlsx`

**For complete instructions**, see: `Documentation/Complete_Workflow.md`

---

## 📊 Sample Data Details

### Intentional Discrepancies Included

The sample data contains realistic migration issues for testing:

| Issue Type | Details | Severity |
|------------|---------|----------|
| Missing Customer | Customer ID 1014 (Patricia Wilson) | HIGH |
| Missing Order | Order ID 5015 | HIGH |
| Extra Customer | Customer ID 1021 (Amanda White) | MEDIUM |
| Extra Order | Order ID 5016 | MEDIUM |
| Data Mismatch | Order 5013 status change | MEDIUM |

**Total Issues**: 6 (which triggers "WARNING" status)

---

## 🎯 Use Cases

### 1️⃣ Practice & Learning
- Learn data validation techniques
- Understand SQL comparison queries
- Practice Excel reporting skills

### 2️⃣ Real Migration Projects
- Adapt scripts for production databases
- Customize validation rules
- Generate compliance reports

### 3️⃣ Quality Assurance
- Automated validation testing
- Regression testing for migrations
- Data integrity auditing

---

## 📖 Documentation Guides

### For SQL Scripts
📄 **File**: `Documentation/SQL_Scripts_Guide.md`

**Contents**:
- Detailed explanation of each script
- Execution order and dependencies
- Parameter customization
- Troubleshooting common errors
- Expected outputs for each script

### For Excel Reporting
📄 **File**: `Documentation/Excel_Template_Guide.md`

**Contents**:
- Sheet structure and purpose
- Formula reference
- Conditional formatting rules
- Chart recommendations
- Color coding guidelines

### For Complete Workflow
📄 **File**: `Documentation/Complete_Workflow.md`

**Contents**:
- End-to-end process (5 phases)
- Detailed step-by-step instructions
- Screenshots and examples
- Analysis guidelines
- Decision framework

---

## 🔧 Customization Guide

### Adapting for Your Migration

#### 1. Update Table Names
Search and replace in all SQL scripts:
- `Customers` → `YourTableName1`
- `Orders` → `YourTableName2`

#### 2. Update Column Names
Modify validation queries to match your schema:
```sql
-- Example: Change email validation
WHERE S.Email <> T.Email
-- To your column:
WHERE S.CustomerEmail <> T.CustomerEmail
```

#### 3. Add Custom Validations
Add business-specific validation rules:
```sql
-- Example: Validate date ranges
WHERE S.OrderDate > '2024-01-01'
  AND T.OrderDate > '2024-01-01'
```

#### 4. Adjust Severity Levels
Customize severity based on your requirements:
- `CRITICAL`: Data loss, corruption
- `HIGH`: Missing records, key mismatches
- `MEDIUM`: Data changes, extra records
- `LOW`: Minor inconsistencies

---

## 🎓 Learning Outcomes

After completing this project, you'll understand:

- ✅ How to compare databases using SQL
- ✅ Techniques for finding missing and extra records
- ✅ Methods for field-level data comparison
- ✅ Schema validation approaches
- ✅ Referential integrity checking
- ✅ Professional report generation in Excel
- ✅ Data migration quality assurance process

---

## 📊 Validation Results Interpretation

### ✅ SUCCESS (0 issues)
- All records migrated correctly
- No data mismatches
- Schema matches perfectly
- Referential integrity intact
- **Action**: Approve migration ✓

### ⚠️ WARNING (1-5 issues)
- Minor discrepancies found
- Non-critical issues
- Explainable variances
- **Action**: Review and approve with conditions

### ❌ FAILED (6+ issues)
- Significant data loss or corruption
- Critical mismatches
- Schema incompatibilities
- **Action**: Investigate and re-run migration

---

## 🛠️ Technologies Used

- **Database**: SQL Server (T-SQL)
- **Reporting**: Microsoft Excel
- **Languages**: SQL, Excel Formulas
- **Tools**: SQL Server Management Studio (SSMS)

---

## 📝 Project Deliverables

✅ **11 SQL Scripts** - Complete validation suite  
✅ **Automation Tool** - `Run_Excel_Validator.ps1` for one-click reports  
✅ **Final Excel Dashboard** - `Final_Excel_Validation_Report.xlsx` with Visual Summaries  
✅ **4 Sample CSV Files** - Realistic test data  
✅ **3 Documentation Files** - Comprehensive guides  
✅ **This README** - Project overview and quick start  

---

## 🔍 Troubleshooting

### Common Issues

**Problem**: "Database does not exist"  
**Solution**: Create databases using `CREATE DATABASE` command

**Problem**: "Cannot bulk load. File not found"  
**Solution**: Update file paths in import scripts (03 & 04)

**Problem**: "Permission denied"  
**Solution**: Grant SQL Server service account file read permissions

**Problem**: "No discrepancies found"  
**Solution**: Ensure you're using target CSV files (not source)

For detailed troubleshooting, see: `Documentation/SQL_Scripts_Guide.md`

---


## 🎯 Next Steps

1. **Read the Complete Workflow** → `Documentation/Complete_Workflow.md`
2. **Follow Step-by-Step Instructions** → Create databases, run scripts
3. **Review SQL Scripts Guide** → Understand each validation
4. **Generate Excel Report** → Create professional deliverables
5. **Customize for Your Needs** → Adapt to real projects

---

## 🏆 Project Highlights

- 🎓 **Production-Ready**: Scripts can be used in real migration projects
- 📚 **Well-Documented**: Extensive guides and inline comments
- 🔍 **Comprehensive**: Covers all aspects of data validation
- 🎯 **Practical**: Includes sample data with realistic issues
- 📊 **Professional**: Excel reporting framework included
- 🛠️ **Customizable**: Easy to adapt for different schemas

----           Akshay Jadhav        ---------


