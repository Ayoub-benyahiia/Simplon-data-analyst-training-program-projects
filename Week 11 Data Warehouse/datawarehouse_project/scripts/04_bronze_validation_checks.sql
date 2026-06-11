USE DataWarehouse;
GO

/* =========================================================
   STEP 5: BRONZE VALIDATION CHECKS
   Goal: verify raw CSV data loaded correctly
   ========================================================= */

-- 1. Row counts for all Bronze tables
SELECT 'bronze.account' AS table_name, COUNT(*) AS row_count FROM bronze.account
UNION ALL
SELECT 'bronze.account_mapping', COUNT(*) FROM bronze.account_mapping
UNION ALL
SELECT 'bronze.store', COUNT(*) FROM bronze.store
UNION ALL
SELECT 'bronze.store_master', COUNT(*) FROM bronze.store_master
UNION ALL
SELECT 'bronze.gl_transaction', COUNT(*) FROM bronze.gl_transaction;
GO

-- 2. Preview sample data
SELECT TOP 10 * FROM bronze.account;
SELECT TOP 10 * FROM bronze.account_mapping;
SELECT TOP 10 * FROM bronze.store;
SELECT TOP 10 * FROM bronze.store_master;
SELECT TOP 10 * FROM bronze.gl_transaction;
GO

-- 3. Check duplicate account numbers
SELECT 
    account_number,
    COUNT(*) AS duplicate_count
FROM bronze.account
GROUP BY account_number
HAVING COUNT(*) > 1;
GO

-- 4. Check duplicate store codes in store table
SELECT 
    store_code,
    COUNT(*) AS duplicate_count
FROM bronze.store
GROUP BY store_code
HAVING COUNT(*) > 1;
GO

-- 5. Check duplicate store codes in store_master table
SELECT 
    store_code,
    COUNT(*) AS duplicate_count
FROM bronze.store_master
GROUP BY store_code
HAVING COUNT(*) > 1;
GO

-- 6. Check duplicate transaction IDs
SELECT 
    transaction_id,
    COUNT(*) AS duplicate_count
FROM bronze.gl_transaction
GROUP BY transaction_id
HAVING COUNT(*) > 1;
GO

-- 7. Check missing critical values in transactions
SELECT 
    SUM(CASE WHEN transaction_id IS NULL OR LTRIM(RTRIM(transaction_id)) = '' THEN 1 ELSE 0 END) AS missing_transaction_id,
    SUM(CASE WHEN transaction_date IS NULL OR LTRIM(RTRIM(transaction_date)) = '' THEN 1 ELSE 0 END) AS missing_transaction_date,
    SUM(CASE WHEN store_code IS NULL OR LTRIM(RTRIM(store_code)) = '' THEN 1 ELSE 0 END) AS missing_store_code,
    SUM(CASE WHEN account_number IS NULL OR LTRIM(RTRIM(account_number)) = '' THEN 1 ELSE 0 END) AS missing_account_number,
    SUM(CASE WHEN amount_local IS NULL OR LTRIM(RTRIM(amount_local)) = '' THEN 1 ELSE 0 END) AS missing_amount_local
FROM bronze.gl_transaction;
GO

-- 8. Check if transaction store codes exist in bronze.store
SELECT DISTINCT 
    t.store_code
FROM bronze.gl_transaction t
LEFT JOIN bronze.store s
    ON t.store_code = s.store_code
WHERE s.store_code IS NULL;
GO

-- 9. Check if transaction account numbers exist in bronze.account
SELECT DISTINCT 
    t.account_number
FROM bronze.gl_transaction t
LEFT JOIN bronze.account a
    ON t.account_number = a.account_number
WHERE a.account_number IS NULL;
GO