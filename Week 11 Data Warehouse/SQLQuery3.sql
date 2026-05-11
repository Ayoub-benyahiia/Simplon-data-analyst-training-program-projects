USE DataWarehouse;
GO

-- 1. Table Account
CREATE TABLE bronze.account (
    account_id VARCHAR(50),
    account_name VARCHAR(255),
    account_type VARCHAR(50)
);
GO

-- 2. Table Store
CREATE TABLE bronze.store (
    store_id VARCHAR(50),
    store_name VARCHAR(255),
    city VARCHAR(100)
);
GO

-- 3. Table GLTransaction
CREATE TABLE bronze.gltransaction (
    transaction_id VARCHAR(50),
    account_id VARCHAR(50),
    store_id VARCHAR(50),
    amount VARCHAR(50),
    transaction_date VARCHAR(50)
);
GO

-- 4. Table Store Master
CREATE TABLE bronze.storemaster (
    store_id VARCHAR(50),
    region VARCHAR(100),
    manager VARCHAR(100)
);
GO

-- 5. Table Account Mapping
CREATE TABLE bronze.account_mapping (
    account_id VARCHAR(50),
    category VARCHAR(100),
    subcategory VARCHAR(100)
);
GO