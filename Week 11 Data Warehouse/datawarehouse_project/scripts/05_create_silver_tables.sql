USE DataWarehouse;
GO

/* =========================================================
   STEP 6: CREATE SILVER TABLES
   Silver = cleaned, standardized, typed data
   ========================================================= */

DROP TABLE IF EXISTS silver.gl_transaction;
DROP TABLE IF EXISTS silver.account_mapping;
DROP TABLE IF EXISTS silver.store_master;
DROP TABLE IF EXISTS silver.store;
DROP TABLE IF EXISTS silver.account;
GO

/* =========================
   silver.account
   Cleaned accounts
   ========================= */
CREATE TABLE silver.account (
    account_number INT,
    account_name NVARCHAR(255),
    account_type NVARCHAR(100),
    currency NVARCHAR(20)
);
GO

/* =========================
   silver.account_mapping
   Cleaned account mapping for P&L
   ========================= */
CREATE TABLE silver.account_mapping (
    account_number INT,
    account_name NVARCHAR(255),
    pl_line NVARCHAR(100),
    statement_type NVARCHAR(50),
    sort_order INT,
    notes NVARCHAR(1000)
);
GO

/* =========================
   silver.store
   Cleaned store geography
   ========================= */
CREATE TABLE silver.store (
    store_code NVARCHAR(50),
    country NVARCHAR(100),
    region NVARCHAR(100)
);
GO

/* =========================
   silver.store_master
   Cleaned store master data
   ========================= */
CREATE TABLE silver.store_master (
    store_code NVARCHAR(50),
    store_name NVARCHAR(255),
    store_type NVARCHAR(100)
);
GO

/* =========================
   silver.gl_transaction
   Cleaned transactions
   ========================= */
CREATE TABLE silver.gl_transaction (
    transaction_id INT,
    transaction_date DATE,
    store_code NVARCHAR(50),
    account_number INT,
    amount_local DECIMAL(18,2),
    currency NVARCHAR(20),
    document_number NVARCHAR(100),
    description NVARCHAR(1000)
);
GO

/* Check created Silver tables */
SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'silver'
ORDER BY TABLE_NAME;
GO