USE DataWarehouse;
GO

/* =========================================================
   STEP 13: FINAL SQL ANALYSIS QUERIES
   Source: Gold views
   Goal: business analysis for demo and Power BI
   ========================================================= */


/* =========================================================
   1. Global KPIs: Revenue, Expenses, Profit
   ========================================================= */
SELECT
    SUM(CASE WHEN amount_local > 0 THEN amount_local ELSE 0 END) AS total_revenue,
    SUM(CASE WHEN amount_local < 0 THEN amount_local ELSE 0 END) AS total_expenses_negative,
    ABS(SUM(CASE WHEN amount_local < 0 THEN amount_local ELSE 0 END)) AS total_expenses_positive,
    SUM(amount_local) AS profit,
    COUNT(*) AS transaction_count
FROM gold.v_gl_enriched;
GO


/* =========================================================
   2. Revenue vs Expenses by year
   ========================================================= */
SELECT
    transaction_year,
    SUM(CASE WHEN amount_local > 0 THEN amount_local ELSE 0 END) AS total_revenue,
    ABS(SUM(CASE WHEN amount_local < 0 THEN amount_local ELSE 0 END)) AS total_expenses,
    SUM(amount_local) AS profit,
    COUNT(*) AS transaction_count
FROM gold.v_gl_enriched
GROUP BY transaction_year
ORDER BY transaction_year;
GO


/* =========================================================
   3. Profit trend by month
   ========================================================= */
SELECT
    transaction_year,
    transaction_month,
    transaction_month_name,
    total_revenue,
    ABS(total_expenses) AS total_expenses,
    profit,
    transaction_count
FROM gold.v_pnl_by_month
ORDER BY transaction_year, transaction_month;
GO


/* =========================================================
   4. Store performance
   ========================================================= */
SELECT
    store_code,
    store_name,
    store_type,
    country,
    region,
    total_revenue,
    ABS(total_expenses) AS total_expenses,
    profit,
    transaction_count
FROM gold.v_store_performance
ORDER BY profit DESC;
GO


/* =========================================================
   5. Account / P&L performance
   ========================================================= */
SELECT
    account_number,
    account_name,
    account_type,
    pl_line,
    statement_type,
    total_revenue,
    ABS(total_expenses) AS total_expenses,
    total_amount,
    transaction_count
FROM gold.v_account_performance
ORDER BY sort_order;
GO


/* =========================================================
   6. P&L line analysis
   ========================================================= */
SELECT
    pl_line,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN amount_local > 0 THEN amount_local ELSE 0 END) AS total_revenue,
    ABS(SUM(CASE WHEN amount_local < 0 THEN amount_local ELSE 0 END)) AS total_expenses,
    SUM(amount_local) AS net_amount
FROM gold.v_gl_enriched
GROUP BY pl_line
ORDER BY net_amount DESC;
GO


/* =========================================================
   7. Top 3 biggest revenues
   ========================================================= */
SELECT TOP 3
    transaction_id,
    transaction_date,
    store_code,
    store_name,
    account_number,
    account_name,
    amount_local,
    document_number,
    description
FROM gold.v_gl_enriched
WHERE amount_local > 0
ORDER BY amount_local DESC;
GO


/* =========================================================
   8. Top 3 biggest expenses
   ========================================================= */
SELECT TOP 3
    transaction_id,
    transaction_date,
    store_code,
    store_name,
    account_number,
    account_name,
    amount_local,
    document_number,
    description
FROM gold.v_gl_enriched
WHERE amount_local < 0
ORDER BY amount_local ASC;
GO


/* =========================================================
   9. Most profitable store
   ========================================================= */
SELECT TOP 1
    store_code,
    store_name,
    country,
    region,
    profit,
    transaction_count
FROM gold.v_store_performance
ORDER BY profit DESC;
GO


/* =========================================================
   10. Store with highest expenses
   ========================================================= */
SELECT TOP 1
    store_code,
    store_name,
    country,
    region,
    ABS(total_expenses) AS total_expenses,
    transaction_count
FROM gold.v_store_performance
ORDER BY ABS(total_expenses) DESC;
GO


/* =========================================================
   11. Most profitable year
   ========================================================= */
SELECT TOP 1
    transaction_year,
    SUM(amount_local) AS profit
FROM gold.v_gl_enriched
GROUP BY transaction_year
ORDER BY profit DESC;
GO


/* =========================================================
   12. Check problematic categories
   Categories with negative net amount
   ========================================================= */
SELECT
    pl_line,
    COUNT(*) AS transaction_count,
    SUM(amount_local) AS net_amount
FROM gold.v_gl_enriched
GROUP BY pl_line
HAVING SUM(amount_local) < 0
ORDER BY net_amount ASC;
GO


/* =========================================================
   13. Unmapped business accounts
   ========================================================= */
SELECT
    account_number,
    account_name,
    account_type,
    pl_line,
    statement_type,
    sort_order
FROM gold.dimaccount
WHERE 
    pl_line = 'UNMAPPED'
    OR statement_type = 'UNKNOWN'
    OR sort_order IS NULL;
GO