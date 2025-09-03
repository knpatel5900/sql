
--Size of all Database in RDS 
SELECT 
    d.name AS DatabaseName,
    CAST(SUM(mf.size) * 8.0 / 1024 / 1024 AS DECIMAL(10,2)) AS SizeInGB
FROM sys.master_files mf
INNER JOIN sys.databases d ON d.database_id = mf.database_id
GROUP BY d.name
ORDER BY SizeInGB DESC;


--Size of Specific Database
SELECT 
    DB_NAME() AS DatabaseName,
    CAST(SUM(size) * 8.0 / 1024 / 1024 AS DECIMAL(10,2)) AS SizeInGB
FROM sys.master_files
WHERE database_id = DB_ID();
