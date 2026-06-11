USE DataWarehouse;
GO

/* =========================================================
   STEP 10: LOAD GOLD STAR SCHEMA
   Gold = analytical model ready for SQL analysis / Power BI
   ========================================================= */

DELETE FROM gold.fact_gl;
DELETE FROM gold.dimaccount;
DELETE FROM gold.dimstore;
GO

DBCC CHECKIDENT ('gold.fact_gl', RESEED, 0);
DBCC CHECKIDENT ('gold.dimaccount', RESEED, 0);
DBCC CHECKIDENT ('gold.dimstore', RESEED, 0);
GO

/* =========================================================
   1. Load gold.dimstore
   Source:
   - silver.store
   - silver.store_master
   ========================================================= */
INSERT INTO gold.dimstore (
    store_code,
    store_name,
    store_type,
    country,
    region
)
SELECT
    s.store_code,
    sm.store_name,
    sm.store_type,
    s.country,
    s.region
FROM silver.store s
LEFT JOIN silver.store_master sm
    ON s.store_code = sm.store_code;
GO

/* =========================================================
   2. Load gold.dimaccount
   Source:
   - silver.account
   - silver.account_mapping

   Important:
   Some account mappings may be incomplete or duplicated.
   OUTER APPLY chooses the best mapping for each account.
   ========================================================= */
INSERT INTO gold.dimaccount (
    account_number,
    account_name,
    account_type,
    currency,
    pl_line,
    statement_type,
    sort_order
)
SELECT
    a.account_number,
    a.account_name,
    a.account_type,
    a.currency,
    COALESCE(m.pl_line, 'UNMAPPED') AS pl_line,
    COALESCE(m.statement_type, 'UNKNOWN') AS statement_type,
    m.sort_order
FROM silver.account a
OUTER APPLY (
    SELECT TOP 1
        am.pl_line,
        am.statement_type,
        am.sort_order,
        am.account_name
    FROM silver.account_mapping am
    WHERE am.account_number = a.account_number
    ORDER BY
        CASE 
            WHEN UPPER(LTRIM(RTRIM(am.account_name))) = UPPER(LTRIM(RTRIM(a.account_name))) THEN 0 
            ELSE 1 
        END,
        CASE WHEN am.sort_order IS NULL THEN 1 ELSE 0 END,
        am.sort_order
) m;
GO

/* =========================================================
   3. Load gold.fact_gl
   Source:
   - silver.gl_transaction
   - gold.dimstore
   - gold.dimaccount
   ========================================================= */
INSERT INTO gold.fact_gl (
    transaction_id,
    transaction_date,
    store_key,
    account_key,
    amount_local,
    currency,
    document_number,
    description
)
SELECT
    t.transaction_id,
    t.transaction_date,
    ds.store_key,
    da.account_key,
    t.amount_local,
    t.currency,
    t.document_number,
    t.description
FROM silver.gl_transaction t
INNER JOIN gold.dimstore ds
    ON t.store_code = ds.store_code
INNER JOIN gold.dimaccount da
    ON t.account_number = da.account_number;
GO

/* =========================================================
   4. Check Gold row counts
   ========================================================= */
SELECT 'gold.dimstore' AS table_name, COUNT(*) AS row_count FROM gold.dimstore
UNION ALL
SELECT 'gold.dimaccount', COUNT(*) FROM gold.dimaccount
UNION ALL
SELECT 'gold.fact_gl', COUNT(*) FROM gold.fact_gl;
GO

/* =========================================================
   5. Preview final analytical fact table
   ========================================================= */
SELECT TOP 10
    f.transaction_id,
    f.transaction_date,
    ds.store_code,
    ds.store_name,
    ds.country,
    ds.region,
    da.account_number,
    da.account_name,
    da.pl_line,
    da.statement_type,
    f.amount_local,
    f.currency,
    f.document_number,
    f.description
FROM gold.fact_gl f
INNER JOIN gold.dimstore ds
    ON f.store_key = ds.store_key
INNER JOIN gold.dimaccount da
    ON f.account_key = da.account_key
ORDER BY f.transaction_id;
GO