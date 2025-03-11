--AWS
--Restoring live Database from Backup
--exec msdb.dbo.rds_restore_database
--        @restore_db_name='Banking_Dev2_HF',
--        @s3_arn_to_restore_from='arn:aws:s3:::savana-db-backups/deployment/Banking_Dev2_HF_20210121.bak';

--Droping Database
--exec msdb.dbo.rds_dro_database Banking_Dev2_HF (edited) 



--Azure

--DROP DATABASE [ngage_glo_Test]

--RESTORE DATABASE [ngage_glo_Test2] FROM  URL = N'https://mainuatsqlstorage.blob.core.windows.net/savsm-db-azebackups/ngage_glo_uat_backup_2021_11_18_000551.bak'