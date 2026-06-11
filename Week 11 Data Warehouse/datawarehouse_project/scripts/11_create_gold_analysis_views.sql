USE DataWarehouse;
GO

/* =========================================================
   STEP 12: CREATE GOLD ANALYSIS VIEWS
   Goal: prepare Gold data for SQL analysis and Power BI
   ========================================================= */

DROP VIEW IF EXISTS gold.v_account_performance;
DROP VIEW IF EXISTS gold.v_store_performance;
DROP VIEW IF EXISTS gold.v_pnl_by_month;
DROP VIEW IF EXISTS gold.v_gl_enriched;
GO

/* =========================================================
   1. Enriched transaction view
   This is the main view for analysis and Power BI
   ========================================================= */
CREATE VIEW gold.v_gl_enriched AS
SELECT
    f.transaction_id,
    f.transaction_date,
    YEAR(f.transaction_date) AS transaction_year,
    MONTH(f.transaction_date) AS transaction_month,
    DATENAME(MONTH, f.transaction_date) AS transaction_month_name,

    ds.store_code,
    ds.store_name,
    ds.store_type,
    ds.country,
    ds.region,

    da.account_number,
    da.account_name,
    da.account_type,
    da.pl_line,
    da.statement_type,
    da.sort_order,

    f.amount_local,
    CASE 
        WHEN f.amount_local > 0 THEN 'Revenue'
        WHEN f.amount_local < 0 THEN 'Expense'
        ELSE 'Zero'
    END AS amount_type,

    f.currency,
    f.document_number,
    f.description
FROM gold.fact_gl f
INNER JOIN gold.dimstore ds
    ON f.store_key = ds.store_key
INNER JOIN gold.dimaccount da
    ON f.account_key = da.account_key;
GO

/* =========================================================
   2. P&L by month
   Useful for trend analysis
   ========================================================= */
CREATE VIEW gold.v_pnl_by_month AS
SELECT
    transaction_year,
    transaction_month,
    MIN(transaction_month_name) AS transaction_month_name,

    SUM(CASE WHEN amount_local > 0 THEN amount_local ELSE 0 END) AS total_revenue,
    SUM(CASE WHEN amount_local < 0 THEN amount_local ELSE 0 END) AS total_expenses,
    SUM(amount_local) AS profit,

    COUNT(*) AS transaction_count
FROM gold.v_gl_enriched
GROUP BY
    transaction_year,
    transaction_month;
GO

/* =========================================================
   3. Store performance
   Useful for Power BI store dashboard
   ========================================================= */
CREATE VIEW gold.v_store_performance AS
SELECT
    store_code,
    store_name,
    store_type,
    country,
    region,

    SUM(CASE WHEN amount_local > 0 THEN amount_local ELSE 0 END) AS total_revenue,
    SUM(CASE WHEN amount_local < 0 THEN amount_local ELSE 0 END) AS total_expenses,
    SUM(amount_local) AS profit,

    COUNT(*) AS transaction_count
FROM gold.v_gl_enriched
GROUP BY
    store_code,
    store_name,
    store_type,
    country,
    region;
GO

/* =========================================================
   4. Account / P&L performance
   Useful for financial analysis
   ========================================================= */
CREATE VIEW gold.v_account_performance AS
SELECT
    account_number,
    account_name,
    account_type,
    pl_line,
    statement_type,
    sort_order,

    SUM(CASE WHEN amount_local > 0 THEN amount_local ELSE 0 END) AS total_revenue,
    SUM(CASE WHEN amount_local < 0 THEN amount_local ELSE 0 END) AS total_expenses,
    SUM(amount_local) AS total_amount,

    COUNT(*) AS transaction_count
FROM gold.v_gl_enriched
GROUP BY
    account_number,
    account_name,
    account_type,
    pl_line,
    statement_type,
    sort_order;
GO

/* Check created views */
SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'gold'
ORDER BY TABLE_NAME;
GO

/* Preview views */
SELECT TOP 10 * FROM gold.v_gl_enriched ORDER BY transaction_id;
SELECT TOP 10 * FROM gold.v_pnl_by_month ORDER BY transaction_year, transaction_month;
SELECT TOP 10 * FROM gold.v_store_performance ORDER BY profit DESC;
SELECT TOP 10 * FROM gold.v_account_performance ORDER BY sort_order;
GO