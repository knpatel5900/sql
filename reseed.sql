USE Banking_DEV
SELECT
IST.TABLE_SCHEMA + '.' + IST.TABLE_NAME AS [Schema.Table],
ISC.COLUMN_NAME,
IDENT_SEED(IST.TABLE_SCHEMA + '.' + IST.TABLE_NAME) AS Seed,
IDENT_INCR(IST.TABLE_SCHEMA + '.' + IST.TABLE_NAME) AS Increment,
IDENT_CURRENT(IST.TABLE_SCHEMA + '.' + IST.TABLE_NAME)  AS Current_Identity,
TE.Increment_Number,
(IDENT_CURRENT(IST.TABLE_SCHEMA + '.' + IST.TABLE_NAME) + TE.Increment_Number)  AS New_Identity, 
'DBCC CHECKIDENT ( ''eidmadm.' + TE.TableName + ''', reseed,  ' + CONVERT(varchar(56),(IDENT_CURRENT(IST.TABLE_SCHEMA + '.' + IST.TABLE_NAME) + TE.Increment_Number))  + ' )' AS [SQL_To_IncreaseSeed]

FROM INFORMATION_SCHEMA.TABLES IST
JOIN
(
SELECT sc.name +'.'+ ta.name TableName ,SUM(pa.rows) RowCnt 
FROM sys.tables ta
INNER JOIN sys.partitions pa ON pa.OBJECT_ID = ta.OBJECT_ID
INNER JOIN sys.schemas sc ON ta.schema_id = sc.schema_id
WHERE ta.is_ms_shipped = 0 AND pa.index_id IN (1,0)
GROUP BY sc.name,ta.name 
) Counts ON Counts.TableName = IST.TABLE_SCHEMA + '.' + IST.TABLE_NAME
INNER JOIN INFORMATION_SCHEMA.COLUMNS ISC ON IST.TABLE_NAME = ISC.TABLE_NAME AND ISC.ORDINAL_POSITION = 1
INNER JOIN eidmadm.Banking_CRM_TableInventory TE ON TE.TableName = ISC.TABLE_NAME  AND reseedForHotfix = 'Yes'
WHERE OBJECTPROPERTY(OBJECT_ID(IST.TABLE_SCHEMA + '.' + IST.TABLE_NAME), 'TableHasIdentity') = 1
AND TE.Increment_Number <> 0
AND IST.TABLE_TYPE = 'BASE TABLE'

Order By IST.TABLE_NAME 