USE master;
GO

IF DB_ID('DataWarehouse') IS NOT NULL
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

SELECT 
    name AS database_name,
    create_date
FROM sys.databases
WHERE name = 'DataWarehouse';