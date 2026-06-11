USE DataWarehouse;
GO

/* =========================================================
   STEP 3: CREATE BRONZE TABLES
   Bronze = raw copy from CSV files, no transformation
   ========================================================= */

DROP TABLE IF EXISTS bronze.gl_transaction;
DROP TABLE IF EXISTS bronze.account_mapping;
DROP TABLE IF EXISTS bronze.store_master;
DROP TABLE IF EXISTS bronze.store;
DROP TABLE IF EXISTS bronze.account;
GO

/* =========================
   bronze.account
   Source file: account.csv
   Columns:
   account_number, account_name, account_type, currency
   ========================= */
CREATE TABLE bronze.account (
    account_number NVARCHAR(50),
    account_name NVARCHAR(255),
    account_type NVARCHAR(100),
    currency NVARCHAR(20)
);
GO

/* =========================
   bronze.account_mapping
   Source file: account_mapping.csv
   Columns:
   AccountNumber, AccountName, PLline, StatementType, SortOrder, Notes
   ========================= */
CREATE TABLE bronze.account_mapping (
    account_number NVARCHAR(50),
    account_name NVARCHAR(255),
    pl_line NVARCHAR(100),
    statement_type NVARCHAR(50),
    sort_order NVARCHAR(50),
    notes NVARCHAR(1000)
);
GO

/* =========================
   bronze.store
   Source file: store.csv
   Columns:
   store_code, country, region
   ========================= */
CREATE TABLE bronze.store (
    store_code NVARCHAR(50),
    country NVARCHAR(100),
    region NVARCHAR(100)
);
GO

/* =========================
   bronze.store_master
   Source file: store_master.csv
   Columns:
   store_code, store_name, store_type
   ========================= */
CREATE TABLE bronze.store_master (
    store_code NVARCHAR(50),
    store_name NVARCHAR(255),
    store_type NVARCHAR(100)
);
GO

/* =========================
   bronze.gl_transaction
   Source file: transaction.csv
   Columns:
   transaction_id, transaction_date, store_code, account_number,
   amount_local, currency, document_number, description
   ========================= */
CREATE TABLE bronze.gl_transaction (
    transaction_id NVARCHAR(50),
    transaction_date NVARCHAR(50),
    store_code NVARCHAR(50),
    account_number NVARCHAR(50),
    amount_local NVARCHAR(50),
    currency NVARCHAR(20),
    document_number NVARCHAR(100),
    description NVARCHAR(1000)
);
GO

/* Check created Bronze tables */
SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'bronze'
ORDER BY TABLE_NAME;
GO