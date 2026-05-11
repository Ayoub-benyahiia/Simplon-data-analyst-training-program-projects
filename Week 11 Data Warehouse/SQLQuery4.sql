USE DataWarehouse;
GO

-- 🔹 Table 1 : account
DROP TABLE IF EXISTS bronze.account;
CREATE TABLE bronze.account (
    account_number  VARCHAR(50),
    account_name    VARCHAR(255),
    account_type    VARCHAR(100),
    currency        VARCHAR(10)
);

-- 🔹 Table 2 : account_mapping
DROP TABLE IF EXISTS bronze.account_mapping;
CREATE TABLE bronze.account_mapping (
    AccountNumber   VARCHAR(50),
    AccountName     VARCHAR(255),
    PLLine          VARCHAR(100),
    StatementType   VARCHAR(50),
    SortOrder       VARCHAR(50),
    Notes           VARCHAR(500)
);

-- 🔹 Table 3 : store
DROP TABLE IF EXISTS bronze.store;
CREATE TABLE bronze.store (
    store_code  VARCHAR(50),
    country     VARCHAR(100),
    region      VARCHAR(100)
);

-- 🔹 Table 4 : store_master
DROP TABLE IF EXISTS bronze.store_master;
CREATE TABLE bronze.store_master (
    store_code  VARCHAR(50),
    store_name  VARCHAR(255),
    store_type  VARCHAR(50)
);

-- 🔹 Table 5 : gltransaction
DROP TABLE IF EXISTS bronze.gltransaction;
CREATE TABLE bronze.gltransaction (
    transaction_id      VARCHAR(50),
    transaction_date    VARCHAR(50),
    store_code          VARCHAR(50),
    account_number      VARCHAR(50),
    amount_local        VARCHAR(50),
    currency            VARCHAR(10),
    document_number     VARCHAR(100),
    description         VARCHAR(500)
);