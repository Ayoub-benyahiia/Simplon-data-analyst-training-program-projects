USE DataWarehouse;
GO

/* =========================================================
   STEP 9: CREATE GOLD TABLES
   Gold = analytical model for reporting
   Star Schema:
   - gold.dimaccount
   - gold.dimstore
   - gold.fact_gl
   ========================================================= */

DROP TABLE IF EXISTS gold.fact_gl;
DROP TABLE IF EXISTS gold.dimaccount;
DROP TABLE IF EXISTS gold.dimstore;
GO

/* =========================
   Dimension: Store
   ========================= */
CREATE TABLE gold.dimstore (
    store_key INT IDENTITY(1,1) PRIMARY KEY,
    store_code NVARCHAR(50) NOT NULL,
    store_name NVARCHAR(255),
    store_type NVARCHAR(100),
    country NVARCHAR(100),
    region NVARCHAR(100)
);
GO

/* =========================
   Dimension: Account
   ========================= */
CREATE TABLE gold.dimaccount (
    account_key INT IDENTITY(1,1) PRIMARY KEY,
    account_number INT NOT NULL,
    account_name NVARCHAR(255),
    account_type NVARCHAR(100),
    currency NVARCHAR(20),
    pl_line NVARCHAR(100),
    statement_type NVARCHAR(50),
    sort_order INT
);
GO

/* =========================
   Fact table: GL Transactions
   ========================= */
CREATE TABLE gold.fact_gl (
    fact_gl_key INT IDENTITY(1,1) PRIMARY KEY,
    transaction_id INT NOT NULL,
    transaction_date DATE NOT NULL,
    store_key INT NOT NULL,
    account_key INT NOT NULL,
    amount_local DECIMAL(18,2) NOT NULL,
    currency NVARCHAR(20),
    document_number NVARCHAR(100),
    description NVARCHAR(1000),

    CONSTRAINT FK_fact_gl_dimstore
        FOREIGN KEY (store_key) REFERENCES gold.dimstore(store_key),

    CONSTRAINT FK_fact_gl_dimaccount
        FOREIGN KEY (account_key) REFERENCES gold.dimaccount(account_key)
);
GO

/* Check created Gold tables */
SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gold'
ORDER BY TABLE_NAME;
GO