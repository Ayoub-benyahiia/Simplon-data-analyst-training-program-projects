# Data Warehouse Project — Bronze / Silver / Gold Architecture

## 1. Project Context

This project is a Data Warehouse implementation using SQL Server.

The goal is to centralize raw CSV data, clean and standardize it, then transform it into an analytical model ready for reporting and decision-making.

The project follows a layered Data Warehouse architecture:

```text
CSV Files → Bronze Layer → Silver Layer → Gold Layer → SQL Analysis / Power BI
```

---

## 2. Project Objective

The objective of this project is to build a complete SQL-based Data Warehouse pipeline that:

- Loads raw CSV files into SQL Server
- Stores raw data in the Bronze layer
- Cleans and standardizes data in the Silver layer
- Builds a Gold analytical model using a Star Schema
- Performs data quality checks at each step
- Prepares data for SQL analysis and Power BI reporting

---

## 3. Tools Used

| Tool | Role |
|---|---|
| SQL Server | Database engine used to store the Data Warehouse |
| SSMS | Used to write, execute, and test SQL scripts |
| T-SQL | Used for table creation, transformations, joins, views, and analysis |
| BULK INSERT | Used to load CSV files into Bronze tables |
| Power BI | Used to create the final dashboard |
| GitHub | Used to store and submit the project |

---

## 4. Data Sources

The source data comes from CSV files:

```text
account.csv
account_mapping.csv
store.csv
store_master.csv
transaction.csv
```

These files are loaded into the Bronze layer without transformation.

---

## 5. Data Warehouse Architecture

```text
CSV Files
   ↓
Bronze Layer
Raw data loaded from CSV files
   ↓
Silver Layer
Cleaned, standardized, typed data
   ↓
Gold Layer
Star Schema for analysis
   ↓
SQL Analysis / Power BI Dashboard
```

---

## 6. Layer Explanation

### Bronze Layer

The Bronze layer contains raw data copied directly from the CSV files.

No transformation is applied in this layer.

Bronze tables:

```text
bronze.account
bronze.account_mapping
bronze.store
bronze.store_master
bronze.gl_transaction
```

Purpose:

- Keep a faithful copy of source data
- Allow traceability
- Make debugging easier

---

### Silver Layer

The Silver layer contains cleaned and standardized data.

Main transformations:

- Trim spaces
- Standardize text values
- Convert data types
- Convert dates
- Convert amounts to decimal
- Standardize store codes
- Handle empty values
- Detect data quality issues

Silver tables:

```text
silver.account
silver.account_mapping
silver.store
silver.store_master
silver.gl_transaction
```

Examples of transformations:

```text
transaction_date: NVARCHAR → DATE
amount_local: NVARCHAR → DECIMAL(18,2)
account_number: NVARCHAR → INT
store_code: TRIM + UPPER
statement_type: P L / PL → P&L
```

---

### Gold Layer

The Gold layer contains the final analytical model.

It uses a Star Schema composed of dimensions and a fact table.

Gold tables:

```text
gold.dimstore
gold.dimaccount
gold.fact_gl
```

Star Schema:

```text
gold.dimstore
      ↓
gold.fact_gl
      ↑
gold.dimaccount
```

The fact table contains financial transactions, and the dimensions contain descriptive business information.

---

## 7. Gold Data Model

### Dimension: gold.dimstore

Contains store information:

```text
store_key
store_code
store_name
store_type
country
region
```

### Dimension: gold.dimaccount

Contains account and P&L information:

```text
account_key
account_number
account_name
account_type
currency
pl_line
statement_type
sort_order
```

### Fact Table: gold.fact_gl

Contains financial transactions:

```text
fact_gl_key
transaction_id
transaction_date
store_key
account_key
amount_local
currency
document_number
description
```

---

## 8. Project Structure

```text
datawarehouse_project/
│
├── data/
│   └── raw/
│       ├── account.csv
│       ├── account_mapping.csv
│       ├── store.csv
│       ├── store_master.csv
│       └── transaction.csv
│
├── scripts/
│   ├── 00_create_database.sql
│   ├── 01_create_schemas.sql
│   ├── 02_create_bronze_tables.sql
│   ├── 03_load_bronze_bulk_insert.sql
│   ├── 04_bronze_validation_checks.sql
│   ├── 05_create_silver_tables.sql
│   ├── 06_load_silver_transform.sql
│   ├── 07_silver_data_quality_checks.sql
│   ├── 08_create_gold_tables.sql
│   ├── 09_load_gold_star_schema.sql
│   ├── 10_gold_data_quality_checks.sql
│   ├── 11_create_gold_analysis_views.sql
│   └── 12_analysis_queries.sql
│
├── powerbi/
│   └── dashboard.pbix
│
├── docs/
│   └── screenshots/
│
├── presentation/
│
└── README.md
```

---

## 9. How to Run the Project

### Step 1: Open SQL Server Management Studio

Connect to SQL Server using:

```text
.\SQLEXPRESS
```

or your local SQL Server instance.

---

### Step 2: Prepare CSV Files

For BULK INSERT, CSV files were placed in:

```text
C:\DataWarehouse\raw\
```

Example:

```text
C:\DataWarehouse\raw\account.csv
C:\DataWarehouse\raw\account_mapping.csv
C:\DataWarehouse\raw\store.csv
C:\DataWarehouse\raw\store_master.csv
C:\DataWarehouse\raw\transaction.csv
```

Important:

If BULK INSERT cannot read files from Desktop, copy the CSV files to `C:\DataWarehouse\raw`.

Also close Excel before running BULK INSERT because opened CSV files can block SQL Server from reading them.

---

### Step 3: Execute SQL Scripts in Order

Run the scripts in this exact order:

```text
00_create_database.sql
01_create_schemas.sql
02_create_bronze_tables.sql
03_load_bronze_bulk_insert.sql
04_bronze_validation_checks.sql
05_create_silver_tables.sql
06_load_silver_transform.sql
07_silver_data_quality_checks.sql
08_create_gold_tables.sql
09_load_gold_star_schema.sql
10_gold_data_quality_checks.sql
11_create_gold_analysis_views.sql
12_analysis_queries.sql
```

---

## 10. Data Quality Checks

Data quality checks were performed at different stages.

### Bronze Checks

- Row counts
- Sample data preview
- Missing critical values
- Duplicate detection
- Store/account key validation

Bronze row counts:

```text
bronze.account          6
bronze.account_mapping  9
bronze.store            7
bronze.store_master     7
bronze.gl_transaction   20000
```

---

### Silver Checks

Silver checks confirmed that cleaned data matched Bronze data.

```text
silver.account          6
silver.account_mapping  9
silver.store            7
silver.store_master     7
silver.gl_transaction   20000
```

Critical missing values in Silver transactions:

```text
missing_transaction_id      0
missing_transaction_date    0
missing_store_code          0
missing_account_number      0
missing_amount_local        0
```

---

### Gold Checks

Gold checks confirmed that the Star Schema was loaded correctly.

```text
gold.dimstore     7
gold.dimaccount   6
gold.fact_gl      20000
```

Validation results:

```text
Silver transaction count = Gold fact count
Silver total amount = Gold total amount
Missing store keys = 0
Missing account keys = 0
```

---

## 11. Gold Views

The following views were created to simplify SQL analysis and Power BI reporting:

```text
gold.v_gl_enriched
gold.v_pnl_by_month
gold.v_store_performance
gold.v_account_performance
```

### Main View

`gold.v_gl_enriched` combines:

- transactions
- stores
- accounts
- P&L information

This view is the main source for analysis and reporting.

---

## 12. SQL Analysis

The final SQL analysis includes:

- Total revenue
- Total expenses
- Profit
- Revenue vs expenses by year
- Profit trend by month
- Store performance
- Account performance
- P&L line analysis
- Top 3 revenues
- Top 3 expenses
- Most profitable store
- Most profitable year
- Unmapped business accounts

These queries are available in:

```text
scripts/12_analysis_queries.sql
```

---

## 13. Power BI Dashboard

The Power BI dashboard is connected to the Gold layer.

Main dashboard KPIs:

```text
Total Revenue
Total Expenses
Profit
Transaction Count
```

Main visuals:

```text
Profit by Month
Revenue vs Expenses
Profit by Store
P&L Line Analysis
Store / Region Analysis
Account Performance
```

Power BI file:

```text
powerbi/dashboard.pbix
```

---

## 14. Business Finding / Data Issue

During the data quality checks, one business mapping issue was identified:

```text
Account 7000 - Interest Expense
Mapping status: UNMAPPED / UNKNOWN
```

This is not a technical error.

It means that the account needs business validation before being fully classified in the P&L mapping.

The issue was kept visible in the Gold layer instead of being hidden, because transparent data quality is important in Data Engineering.

---

## 15. Challenges

Main challenges in this project:

- Loading CSV files using BULK INSERT
- Handling file permission issues
- Cleaning and converting raw text values
- Standardizing account mappings
- Building a Star Schema
- Validating data quality across Bronze, Silver, and Gold
- Preparing data for Power BI reporting

---

## 16. Key Learnings

Through this project, I learned how to:

- Design a layered Data Warehouse architecture
- Use Bronze, Silver, and Gold layers correctly
- Load CSV data into SQL Server
- Clean and standardize data using T-SQL
- Create a Star Schema
- Build dimensions and fact tables
- Perform data quality checks
- Prepare SQL views for reporting
- Connect Power BI to a SQL Server Data Warehouse

---

## 17. Final Pipeline Summary

```text
CSV Files
   ↓
BULK INSERT
   ↓
Bronze Layer
   ↓
Cleaning and Standardization
   ↓
Silver Layer
   ↓
Star Schema Modeling
   ↓
Gold Layer
   ↓
SQL Analysis + Power BI Dashboard
```

---

## 18. Author

Project developed as part of a Data Engineering / Data Analytics learning project.

Role:

```text
Data Engineer / Data Analyst