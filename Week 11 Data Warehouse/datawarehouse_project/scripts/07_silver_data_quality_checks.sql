USE DataWarehouse;
GO

/* =========================================================
   STEP 8: SILVER DATA QUALITY CHECKS
   Goal: validate cleaned and standardized Silver layer
   ========================================================= */

-- 1. Compare Bronze vs Silver row counts
SELECT 
    'account' AS table_name,
    (SELECT COUNT(*) FROM bronze.account) AS bronze_count,
    (SELECT COUNT(*) FROM silver.account) AS silver_count
UNION ALL
SELECT 
    'account_mapping',
    (SELECT COUNT(*) FROM bronze.account_mapping),
    (SELECT COUNT(*) FROM silver.account_mapping)
UNION ALL
SELECT 
    'store',
    (SELECT COUNT(*) FROM bronze.store),
    (SELECT COUNT(*) FROM silver.store)
UNION ALL
SELECT 
    'store_master',
    (SELECT COUNT(*) FROM bronze.store_master),
    (SELECT COUNT(*) FROM silver.store_master)
UNION ALL
SELECT 
    'gl_transaction',
    (SELECT COUNT(*) FROM bronze.gl_transaction),
    (SELECT COUNT(*) FROM silver.gl_transaction);
GO

-- 2. Check missing critical values in silver.gl_transaction
SELECT
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS missing_transaction_id,
    SUM(CASE WHEN transaction_date IS NULL THEN 1 ELSE 0 END) AS missing_transaction_date,
    SUM(CASE WHEN store_code IS NULL OR LTRIM(RTRIM(store_code)) = '' THEN 1 ELSE 0 END) AS missing_store_code,
    SUM(CASE WHEN account_number IS NULL THEN 1 ELSE 0 END) AS missing_account_number,
    SUM(CASE WHEN amount_local IS NULL THEN 1 ELSE 0 END) AS missing_amount_local
FROM silver.gl_transaction;
GO

-- 3. Check duplicate transaction IDs
SELECT 
    transaction_id,
    COUNT(*) AS duplicate_count
FROM silver.gl_transaction
GROUP BY transaction_id
HAVING COUNT(*) > 1;
GO

-- 4. Check duplicate accounts
SELECT 
    account_number,
    COUNT(*) AS duplicate_count
FROM silver.account
GROUP BY account_number
HAVING COUNT(*) > 1;
GO

-- 5. Check duplicate stores
SELECT 
    store_code,
    COUNT(*) AS duplicate_count
FROM silver.store
GROUP BY store_code
HAVING COUNT(*) > 1;
GO

-- 6. Check if transaction account numbers exist in silver.account
SELECT DISTINCT
    t.account_number
FROM silver.gl_transaction t
LEFT JOIN silver.account a
    ON t.account_number = a.account_number
WHERE a.account_number IS NULL;
GO

-- 7. Check if transaction store codes exist in silver.store
SELECT DISTINCT
    t.store_code
FROM silver.gl_transaction t
LEFT JOIN silver.store s
    ON t.store_code = s.store_code
WHERE s.store_code IS NULL;
GO

-- 8. Check account mapping quality
SELECT *
FROM silver.account_mapping
WHERE 
    pl_line IS NULL
    OR statement_type IS NULL
    OR sort_order IS NULL;
GO

-- 9. Business quick check: revenue, expenses, profit
SELECT
    SUM(CASE WHEN amount_local > 0 THEN amount_local ELSE 0 END) AS total_revenue,
    SUM(CASE WHEN amount_local < 0 THEN amount_local ELSE 0 END) AS total_expenses,
    SUM(amount_local) AS total_profit
FROM silver.gl_transaction;
GO

-- 10. Transactions by year
SELECT
    YEAR(transaction_date) AS transaction_year,
    COUNT(*) AS transaction_count,
    SUM(amount_local) AS total_amount
FROM silver.gl_transaction
GROUP BY YEAR(transaction_date)
ORDER BY transaction_year;
GO