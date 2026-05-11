select * from bronze.account
select * from bronze.stor
select * from bronze.account
select * from bronze.account

CREATE TABLE silver.account (
    account_number VARCHAR(50),
    account_name VARCHAR(255),
    account_type VARCHAR(100),
    currency VARCHAR(10)
);
CREATE TABLE silver.store (
    store_code VARCHAR(50),
    country VARCHAR(100),
    region VARCHAR(100)
);
CREATE TABLE silver.account_mapping (
    account_number VARCHAR(50),
    account_name VARCHAR(255),
    plline VARCHAR(100),
    statement_type VARCHAR(100),
    sort_order INT,
    notes VARCHAR(255)
);

CREATE TABLE silver.store_master (
    store_code VARCHAR(50),
    store_name VARCHAR(255),
    store_type VARCHAR(100)
);

CREATE TABLE silver.gltransaction (
    transaction_id VARCHAR(50),
    transaction_date DATE,
    store_code VARCHAR(50),
    account_number VARCHAR(50),
    amount_local DECIMAL(18,2),
    currency VARCHAR(10),
    document_number VARCHAR(100),
    description VARCHAR(255)
);


INSERT INTO silver.account
SELECT DISTINCT
    TRIM(account_number) AS account_number,

    UPPER(TRIM(ISNULL(account_name, 'UNKNOWN'))) AS account_name,

    TRIM(account_type) AS account_type,

    UPPER(TRIM(currency)) AS currency

FROM bronze.account
WHERE account_number IS NOT NULL;
---------------------------------
INSERT INTO silver.store
SELECT DISTINCT
    TRIM(store_code) AS store_code,

    UPPER(TRIM(ISNULL(country, 'UNKNOWN'))) AS country,

    UPPER(TRIM(ISNULL(region, 'UNKNOWN'))) AS region

FROM bronze.store
WHERE TRIM(store_code) <> '';
------------------------------
INSERT INTO silver.account_mapping
SELECT DISTINCT
    TRIM(AccountNumber) AS account_number,

    UPPER(TRIM(ISNULL(AccountName, 'UNKNOWN'))) AS account_name,

    UPPER(
        CASE 
            WHEN TRIM(PLLine) IN ('P L', 'PL') THEN 'P&L'
            ELSE TRIM(PLLine)
        END
    ) AS plline,

    UPPER(TRIM(ISNULL(StatementType, 'UNKNOWN'))) AS statement_type,

    CAST(CAST(ISNULL(SortOrder, '0') AS DECIMAL(10,1)) AS INT) AS sort_order,

    TRIM(ISNULL(Notes, 'NO NOTES')) AS notes

FROM bronze.account_mapping
WHERE TRIM(AccountNumber) <> '';
-----------------------------------------------
INSERT INTO silver.store_master
SELECT DISTINCT
    TRIM(store_code) AS store_code,

    UPPER(TRIM(ISNULL(store_name, 'UNKNOWN'))) AS store_name,

    UPPER(TRIM(ISNULL(store_type, 'UNKNOWN'))) AS store_type

FROM bronze.store_master
WHERE TRIM(store_code) <> '';
-----------------------------------------
INSERT INTO silver.gltransaction
SELECT DISTINCT
    TRIM(transaction_id) AS transaction_id,

    CAST(transaction_date AS DATE) AS transaction_date,

    TRIM(store_code) AS store_code,

    TRIM(account_number) AS account_number,

    CAST(amount_local AS DECIMAL(18,2)) AS amount_local,

    UPPER(TRIM(ISNULL(currency, 'UNKNOWN'))) AS currency,

    TRIM(ISNULL(document_number, 'NO_DOC')) AS document_number,

    TRIM(ISNULL(description, 'NO DESCRIPTION')) AS description

FROM bronze.gltransaction
WHERE TRIM(transaction_id) <> '';
----------------------------------------

SELECT TOP 10 * FROM silver.gltransaction;
---------------------------------------------------------------
CREATE VIEW gold.dimaccount AS
SELECT
    a.account_number,
    a.account_name,
    a.account_type,
    a.currency,

    am.plline,
    am.statement_type,
    am.sort_order,
    am.notes

FROM silver.account a

LEFT JOIN silver.account_mapping am
ON a.account_number = am.account_number;

--------------------------------------------------
CREATE VIEW gold.dimstore  AS
SELECT
    s.store_code,
    s.country,
    s.region,

    sm.store_name,
    sm.store_type

FROM silver.store s

LEFT JOIN silver.store_master sm
ON s.store_code = sm.store_code;

select * from gold.dimstore

--------------------------------------------
CREATE VIEW gold.fact_gl AS

SELECT
    g.transaction_id,
    g.transaction_date,
    g.amount_local,
    g.currency,
    g.document_number,
    g.description,

    -- Account Details
    a.account_number,
    a.account_name,
    a.account_type,
    a.plline,
    a.statement_type,
    a.sort_order,
    a.notes,

    -- Store Details
    s.store_code,
    s.store_name,
    s.store_type,
    s.country,
    s.region

FROM silver.gltransaction g

LEFT JOIN gold.dimaccount a
ON g.account_number = a.account_number

LEFT JOIN gold.dimstore  s
ON g.store_code = s.store_code;