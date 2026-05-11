USE DataWarehouse;
Go

-- 1. Charger les transactions
BULK INSERT bronze.gltransaction
FROM 'C:\Users\ayoub\Desktop\DW_Project\transaction.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2            
);
select * from bronze.gltransaction
-- 2. Charger les comptes
BULK INSERT bronze.account
FROM 'C:\Users\ayoub\Desktop\DW_Project\account.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

-- 3. Charger les magasins (store)
BULK INSERT bronze.store
FROM 'C:\Users\ayoub\Desktop\DW_Project\store.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

-- 4. Charger le store master
BULK INSERT bronze.storemaster
FROM 'C:\Users\ayoub\Desktop\DW_Project\store_master.csv'  -- التأكد من اسم الملف واش storemaster.csv أو store_master.csv
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

-- 5. Charger le mapping des comptes
BULK INSERT bronze.account_mapping
FROM 'C:\Users\ayoub\Desktop\DW_Project\account_mapping.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
GO