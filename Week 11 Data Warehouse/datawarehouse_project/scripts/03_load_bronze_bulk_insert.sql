USE DataWarehouse;
GO

/* =========================================================
   STEP 4: LOAD CSV FILES INTO BRONZE TABLES
   Bronze = raw data loaded from CSV files
   ========================================================= */

TRUNCATE TABLE bronze.account;
TRUNCATE TABLE bronze.account_mapping;
TRUNCATE TABLE bronze.store;
TRUNCATE TABLE bronze.store_master;
TRUNCATE TABLE bronze.gl_transaction;
GO

/* Load account.csv */
BULK INSERT bronze.account
FROM 'C:\Users\ayoub\Desktop\datawarehouse_project\data\raw\account.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/* Load account_mapping.csv */
BULK INSERT bronze.account_mapping
FROM 'C:\Users\ayoub\Desktop\datawarehouse_project\data\raw\account_mapping.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/* Load store.csv */
BULK INSERT bronze.store
FROM 'C:\Users\ayoub\Desktop\datawarehouse_project\data\raw\store.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/* Load store_master.csv */
BULK INSERT bronze.store_master
FROM 'C:\Users\ayoub\Desktop\datawarehouse_project\data\raw\store_master.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/* Load transaction.csv */
BULK INSERT bronze.gl_transaction
FROM 'C:\Users\ayoub\Desktop\datawarehouse_project\data\raw\transaction.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/* Check row counts after loading */
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