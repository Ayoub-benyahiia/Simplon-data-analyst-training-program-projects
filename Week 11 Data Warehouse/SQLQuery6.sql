-- 🔍 CHECK 1 : عدد الصفوف في كل جدول
SELECT 'bronze.account'         AS table_name, COUNT(*) AS row_count 
FROM bronze.account
UNION ALL
SELECT 'bronze.account_mapping', COUNT(*) 
FROM bronze.account_mapping
UNION ALL
SELECT 'bronze.store',           COUNT(*) 
FROM bronze.store
UNION ALL
SELECT 'bronze.store_master',    COUNT(*) 
FROM bronze.store_master
UNION ALL
SELECT 'bronze.gltransaction',   COUNT(*) 
FROM bronze.gltransaction;