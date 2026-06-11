USE DataWarehouse;
GO

/* =========================================================
   STEP 7: LOAD SILVER TABLES FROM BRONZE
   Silver = cleaned, standardized, typed data
   ========================================================= */

TRUNCATE TABLE silver.account;
TRUNCATE TABLE silver.account_mapping;
TRUNCATE TABLE silver.store;
TRUNCATE TABLE silver.store_master;
TRUNCATE TABLE silver.gl_transaction;
GO

/* =========================================================
   1. Load silver.account
   Cleaning:
   - account_number: text -> INT
   - account_name/type: trim spaces
   - currency: uppercase
   ========================================================= */
INSERT INTO silver.account (
    account_number,
    account_name,
    account_type,
    currency
)
SELECT DISTINCT
    TRY_CONVERT(INT, LTRIM(RTRIM(account_number))) AS account_number,
    NULLIF(LTRIM(RTRIM(account_name)), '') AS account_name,
    NULLIF(LTRIM(RTRIM(account_type)), '') AS account_type,
    UPPER(NULLIF(LTRIM(RTRIM(currency)), '')) AS currency
FROM bronze.account
WHERE TRY_CONVERT(INT, LTRIM(RTRIM(account_number))) IS NOT NULL;
GO

/* =========================================================
   2. Load silver.account_mapping
   Cleaning:
   - AccountNumber -> account_number INT
   - PLline -> pl_line
   - StatementType standardized: P L / PL / P&L -> P&L
   - SortOrder supports values like 10.0
   - empty values -> NULL or UNMAPPED
   ========================================================= */
INSERT INTO silver.account_mapping (
    account_number,
    account_name,
    pl_line,
    statement_type,
    sort_order,
    notes
)
SELECT DISTINCT
    TRY_CONVERT(INT, LTRIM(RTRIM(account_number))) AS account_number,
    NULLIF(LTRIM(RTRIM(account_name)), '') AS account_name,

    CASE 
        WHEN NULLIF(LTRIM(RTRIM(pl_line)), '') IS NULL THEN 'UNMAPPED'
        ELSE NULLIF(LTRIM(RTRIM(pl_line)), '')
    END AS pl_line,

    CASE 
        WHEN NULLIF(LTRIM(RTRIM(statement_type)), '') IS NULL THEN 'UNKNOWN'
        WHEN UPPER(REPLACE(LTRIM(RTRIM(statement_type)), ' ', '')) IN ('PL', 'P&L') THEN 'P&L'
        ELSE UPPER(LTRIM(RTRIM(statement_type)))
    END AS statement_type,

    TRY_CONVERT(INT, TRY_CONVERT(DECIMAL(10,2), LTRIM(RTRIM(sort_order)))) AS sort_order,
    NULLIF(LTRIM(RTRIM(notes)), '') AS notes
FROM bronze.account_mapping
WHERE TRY_CONVERT(INT, LTRIM(RTRIM(account_number))) IS NOT NULL;
GO

/* =========================================================
   3. Load silver.store
   Cleaning:
   - store_code uppercase
   - country/region trim
   ========================================================= */
INSERT INTO silver.store (
    store_code,
    country,
    region
)
SELECT DISTINCT
    UPPER(NULLIF(LTRIM(RTRIM(store_code)), '')) AS store_code,
    NULLIF(LTRIM(RTRIM(country)), '') AS country,
    NULLIF(LTRIM(RTRIM(region)), '') AS region
FROM bronze.store
WHERE NULLIF(LTRIM(RTRIM(store_code)), '') IS NOT NULL;
GO

/* =========================================================
   4. Load silver.store_master
   Cleaning:
   - store_code uppercase
   - store_name/type trim
   ========================================================= */
INSERT INTO silver.store_master (
    store_code,
    store_name,
    store_type
)
SELECT DISTINCT
    UPPER(NULLIF(LTRIM(RTRIM(store_code)), '')) AS store_code,
    NULLIF(LTRIM(RTRIM(store_name)), '') AS store_name,
    NULLIF(LTRIM(RTRIM(store_type)), '') AS store_type
FROM bronze.store_master
WHERE NULLIF(LTRIM(RTRIM(store_code)), '') IS NOT NULL;
GO

/* =========================================================
   5. Load silver.gl_transaction
   Cleaning:
   - transaction_id -> INT
   - transaction_date -> DATE
   - store_code -> uppercase
   - account_number -> INT
   - amount_local -> DECIMAL
   - currency -> uppercase
   ========================================================= */
INSERT INTO silver.gl_transaction (
    transaction_id,
    transaction_date,
    store_code,
    account_number,
    amount_local,
    currency,
    document_number,
    description
)
SELECT DISTINCT
    TRY_CONVERT(INT, LTRIM(RTRIM(transaction_id))) AS transaction_id,

    COALESCE(
        TRY_CONVERT(DATE, LTRIM(RTRIM(transaction_date)), 23),   -- yyyy-mm-dd
        TRY_CONVERT(DATE, LTRIM(RTRIM(transaction_date)), 101),  -- mm/dd/yyyy
        TRY_CONVERT(DATE, LTRIM(RTRIM(transaction_date)))
    ) AS transaction_date,

    UPPER(NULLIF(LTRIM(RTRIM(store_code)), '')) AS store_code,
    TRY_CONVERT(INT, LTRIM(RTRIM(account_number))) AS account_number,

    TRY_CONVERT(
        DECIMAL(18,2),
        REPLACE(LTRIM(RTRIM(amount_local)), ',', '.')
    ) AS amount_local,

    UPPER(NULLIF(LTRIM(RTRIM(currency)), '')) AS currency,
    NULLIF(LTRIM(RTRIM(document_number)), '') AS document_number,
    NULLIF(LTRIM(RTRIM(description)), '') AS description
FROM bronze.gl_transaction
WHERE TRY_CONVERT(INT, LTRIM(RTRIM(transaction_id))) IS NOT NULL;
GO

/* =========================================================
   6. Check Silver row counts
   ========================================================= */
SELECT 'silver.account' AS table_name, COUNT(*) AS row_count FROM silver.account
UNION ALL
SELECT 'silver.account_mapping', COUNT(*) FROM silver.account_mapping
UNION ALL
SELECT 'silver.store', COUNT(*) FROM silver.store
UNION ALL
SELECT 'silver.store_master', COUNT(*) FROM silver.store_master
UNION ALL
SELECT 'silver.gl_transaction', COUNT(*) FROM silver.gl_transaction;
GO

/* =========================================================
   7. Preview cleaned transaction data
   ========================================================= */
SELECT TOP 10 *
FROM silver.gl_transaction
ORDER BY transaction_id;
GO