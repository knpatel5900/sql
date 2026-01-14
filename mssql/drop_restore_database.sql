--AWS
--Restoring live Database from Backup
--exec msdb.dbo.rds_restore_database
--        @restore_db_name='Banking_Dev2_HF',
--        @s3_arn_to_restore_from='arn:aws:s3:::savana-db-backups/deployment/Banking_Dev2_HF_20210121.bak';

--Droping Database
--exec msdb.dbo.rds_dro_database Banking_Dev2_HF (edited) 



--Azure
--DROP DATABASE [Database_name]

--RESTORE DATABASE [Database_Name] FROM  URL = N'', 
-- URL = N''s