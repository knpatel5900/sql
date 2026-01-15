select *
from eidmadm.storageservers

----------------------------------------------- AWS Cloud platform Print Server -----------------------------------------------
IF (SELECT physical_name
FROM sys.master_files with (nolock)
WHERE name = 'master') = 'D:\rdsdbdata\DATA\master.mdf'
BEGIN
    Print 'Cloud Platform is AWS'
    /*SQL Code to Update Storage servers*/
    IF (select servername
    from eidmadm.storageservers
    where servername ='SMPRINTAWS') IS NULL
    BEGIN
        Print '( i ) No Storageserver Found for IMS Print, Adding One'
        SET IDENTITY_INSERT [eidmadm].[storageservers] ON
        INSERT [eidmadm].[storageservers]
            ([serverid], [servername], [physicalserver], [port], [protocol], [serviceaddress], [type], [status], [replicationlastpurge], [replicationpollinginterval], [localdbconn], [license], [activecachepathid], [activereplicationengineid], [replicationlastactivity], [owneruserid], [createddate], [lastmodifieduserid], [lastmodifieddate], [isEncrypted], [securityCertificateId], [extendedProperties])
        VALUES
            (1000003, N'SMPRINTAWS', N'', NULL, N'', N'', 2, NULL, NULL, NULL, N'', N'', NULL, NULL, NULL, 1, CAST(GETDATE() AS DateTime), 1, CAST(GETDATE() AS DateTime), 0, NULL, N'{"bucketNamePrefix":""", "bucket":""",   "region":"us-east-1", "accessKey":"", "secretKey":"", "role":"", "signedUrlExpireSeconds":"120" }')
        SET IDENTITY_INSERT [eidmadm].[storageservers] OFF
    END
    update eidmadm.storageservers set type=2
END

----------------------------------------------- AWS Cloud platform Statement v2 -----------------------------------------------
IF (SELECT physical_name
FROM sys.master_files with (nolock)
WHERE name = 'master') = 'D:\rdsdbdata\DATA\master.mdf'
BEGIN
    Print 'Cloud Platform is AWS'
    /*SQL Code to Update  Statemnt V2 Storage servers*/
    IF (select servername
    from eidmadm.storageservers
    where servername ='SMSTMNTAWS') IS NULL
    BEGIN
        Print '( i ) No Storageserver Found for Statement v2, Adding One'
        SET IDENTITY_INSERT [eidmadm].[storageservers] ON
        INSERT [eidmadm].[storageservers]
            ([serverid], [servername], [physicalserver], [port], [protocol], [serviceaddress], [type], [status], [replicationlastpurge], [replicationpollinginterval], [localdbconn], [license], [activecachepathid], [activereplicationengineid], [replicationlastactivity], [owneruserid], [createddate], [lastmodifieduserid], [lastmodifieddate], [isEncrypted], [securityCertificateId], [extendedProperties])
        VALUES
            (1000002, N'SMSTMNTAWS', N'', NULL, N'', N'', 2, NULL, NULL, NULL, N'', N'', NULL, NULL, NULL, 1, CAST(GETDATE() AS DateTime), 1, CAST(GETDATE() AS DateTime), 0, NULL, N'{"bucketNamePrefix":""", "bucket":""",   "region":"us-east-1", "accessKey":"", "secretKey":"", "role":"", "signedUrlExpireSeconds":"120" }')
        SET IDENTITY_INSERT [eidmadm].[storageservers] OFF
        
    END

    /*If Needs to Change ID for Statement V2*/
    SET IDENTITY_INSERT [eidmadm].[storageservers] ON
    --update eidmadm.storageservers set serverid='1000002' where servername='SMSTMNTAWS'
    update eidmadm.docclasses set storageserverid = '1000002' WHERE docclassid = '800377'
    SET IDENTITY_INSERT [eidmadm].[storageservers] OFF
    select *
    from eidmadm.storageservers
    select *
    from eidmadm.docclasses
    WHERE docclassid = '800377'
    update eidmadm.storageservers set type=2

END


----------------------------------------------- Azure Cloud platform Print Server-----------------------------------------------

IF (SELECT LEFT(physical_name,5)
FROM sys.master_files with (nolock)
WHERE database_id = 1 AND file_id = 1) = 'https'           
BEGIN
    Print 'Cloud Platform is Azure'
    /*SQL Code to Update Storage servers*/
    IF (select servername
    from eidmadm.storageservers
    where servername ='SMPRINTAWS' or servername ='SMPRINTAZE') IS NULL
    BEGIN
        Print '( i ) No Storageserver Found for IMS Print, Adding One'
        SET IDENTITY_INSERT [eidmadm].[storageservers] ON
        INSERT [eidmadm].[storageservers]
            ([serverid], [servername], [physicalserver], [port], [protocol], [serviceaddress], [type], [status], [replicationlastpurge], [replicationpollinginterval], [localdbconn], [license], [activecachepathid], [activereplicationengineid], [replicationlastactivity], [owneruserid], [createddate], [lastmodifieduserid], [lastmodifieddate], [isEncrypted], [securityCertificateId], [extendedProperties])
        VALUES
            (1000003, N'SMPRINTAZE', N'', NULL, N'', N'', 2, NULL, NULL, NULL, N'', N'', NULL, NULL, NULL, 1, CAST(GETDATE() AS DateTime), 1, CAST(GETDATE() AS DateTime), 0, NULL, N'{"containerNamePrefix":"","container":""},"endpointUri":"","accountKey":"","connectionString":"","sasUriExpireSeconds":600,"resourceGroupName":"","accountName":"","subscriptionId":"","managementCredsType":"ManagedIdentity"')
        SET IDENTITY_INSERT [eidmadm].[storageservers] OFF
    END
     update eidmadm.storageservers set type=3
END

----------------------------------------------- Azure Cloud platform Statement V2-----------------------------------------------

IF (SELECT LEFT(physical_name,5)
FROM sys.master_files with (nolock)
WHERE database_id = 1 AND file_id = 1) = 'https'           
BEGIN
    Print 'Cloud Platform is Azure'
    IF (select servername
    from eidmadm.storageservers
    where servername ='SMSTAZBLOB' or servername ='SMSTMNTAZE') IS NULL
    BEGIN
        Print '( i ) No Storageserver Found for Statement v2, Adding One'
        SET IDENTITY_INSERT [eidmadm].[storageservers] ON
        INSERT [eidmadm].[storageservers]
            ([serverid], [servername], [physicalserver], [port], [protocol], [serviceaddress], [type], [status], [replicationlastpurge], [replicationpollinginterval], [localdbconn], [license], [activecachepathid], [activereplicationengineid], [replicationlastactivity], [owneruserid], [createddate], [lastmodifieduserid], [lastmodifieddate], [isEncrypted], [securityCertificateId], [extendedProperties])
        VALUES
            (1000002, N'SMSTMNTAZE', N'', NULL, N'', N'', 2, NULL, NULL, NULL, N'', N'', NULL, NULL, NULL, 1, CAST(GETDATE() AS DateTime), 1, CAST(GETDATE() AS DateTime), 0, NULL, N'{"containerNamePrefix":"","container":""},"endpointUri":"","accountKey":"","connectionString":"","sasUriExpireSeconds":600,"resourceGroupName":"","accountName":"","subscriptionId":"","managementCredsType":"ManagedIdentity"')
        SET IDENTITY_INSERT [eidmadm].[storageservers] OFF
    END
    SET IDENTITY_INSERT [eidmadm].[storageservers] ON
    Print '( i ) Updating Storageserver Found for Statement v2'
    update eidmadm.storageservers set servername='SMPRINTAZE' where servername = 'SMPRINTAWS'
    update eidmadm.storageservers set servername='SMSTMNTAZE' where servername = 'SMSTAZBLOB'
    /*If Needs to Change ID for Statement V2*/
    update eidmadm.docclasses set storageserverid = '1000002' WHERE docclassid = '800377'
    SET IDENTITY_INSERT [eidmadm].[storageservers] OFF
    select *
    from eidmadm.storageservers
    select *
    from eidmadm.docclasses
    WHERE docclassid = '800377'
    update eidmadm.storageservers set type=3
END



--Adding and Reinserting storage servers if with old id
----------------------------------------------- Azure Cloud -----------------------------------------------

IF (SELECT LEFT(physical_name,5)
FROM sys.master_files with (nolock)
WHERE database_id = 1 AND file_id = 1) = 'https'           
BEGIN
    Print 'Cloud Platform is Azure'
    DECLARE @Print VARCHAR(max);
    DECLARE @v2 VARCHAR(max);
    -- Assign values to variables
    SET @print= (select extendedProperties
    from eidmadm.storageservers
    where servername = 'SMPRINTAZE');
    SET @v2 = (select extendedProperties
    from eidmadm.storageservers
    where servername = 'SMSTMNTAZE');
    --print @print
    --print @v2
    IF (select servername
    from eidmadm.storageservers
    where servername = 'SMPRINTAZE' and serverid=9000001) IS NOT NULL
	Begin
        Print '( i ) Found Server with old id for Print, Deleting and Reinserting One'
        DELETE from eidmadm.storageservers where servername = 'SMPRINTAZE'
        SET IDENTITY_INSERT [eidmadm].[storageservers] ON
        INSERT [eidmadm].[storageservers]
            ([serverid], [servername], [physicalserver], [port], [protocol], [serviceaddress], [type], [status], [replicationlastpurge], [replicationpollinginterval], [localdbconn], [license], [activecachepathid], [activereplicationengineid], [replicationlastactivity], [owneruserid], [createddate], [lastmodifieduserid], [lastmodifieddate], [isEncrypted], [securityCertificateId], [extendedProperties])
        VALUES
            (1000003, N'SMPRINTAZE', N'', NULL, N'', N'', 2, NULL, NULL, NULL, N'', N'', NULL, NULL, NULL, 1, CAST(GETDATE() AS DateTime), 1, CAST(GETDATE() AS DateTime), 0, NULL, @print)
        SET IDENTITY_INSERT [eidmadm].[storageservers] OFF
    end

    IF (select servername
    from eidmadm.storageservers
    where servername = 'SMSTMNTAZE' and serverid=9000005) IS NOT NULL
	Begin
        Print '( i ) Found Server with old id for v2, Deleting and Reinserting One'
        DELETE from eidmadm.storageservers where servername = 'SMSTMNTAZE'
        SET IDENTITY_INSERT [eidmadm].[storageservers] ON
        INSERT [eidmadm].[storageservers]
            ([serverid], [servername], [physicalserver], [port], [protocol], [serviceaddress], [type], [status], [replicationlastpurge], [replicationpollinginterval], [localdbconn], [license], [activecachepathid], [activereplicationengineid], [replicationlastactivity], [owneruserid], [createddate], [lastmodifieduserid], [lastmodifieddate], [isEncrypted], [securityCertificateId], [extendedProperties])
        VALUES
            (1000002, N'SMSTMNTAZE', N'', NULL, N'', N'', 2, NULL, NULL, NULL, N'', N'', NULL, NULL, NULL, 1, CAST(GETDATE() AS DateTime), 1, CAST(GETDATE() AS DateTime), 0, NULL, @v2)
        SET IDENTITY_INSERT [eidmadm].[storageservers] OFF
    end
    update eidmadm.storageservers set type=3
END

----------------------------------------------- AWS Cloud -----------------------------------------------
IF (SELECT physical_name
FROM sys.master_files with (nolock)
WHERE name = 'master') = 'D:\rdsdbdata\DATA\master.mdf'
BEGIN
    Print 'Cloud Platform is AWS'
    DECLARE @Print1 VARCHAR(max);
    DECLARE @v21 VARCHAR(max);
    -- Assign values to variables
    SET @print1= (select extendedProperties
    from eidmadm.storageservers
    where servername = 'SMPRINTAWS');
    SET @v21 = (select extendedProperties
    from eidmadm.storageservers
    where servername = 'SMSTMNTAWS');
    --print @print
    --print @v2
    IF (select servername
    from eidmadm.storageservers
    where servername = 'SMPRINTAWS' and serverid=9000001) IS NOT NULL
	Begin
        Print '( i ) Found Server with old id for Print, Deleting and Reinserting One'
        DELETE from eidmadm.storageservers where servername = 'SMPRINTAWS'
        SET IDENTITY_INSERT [eidmadm].[storageservers] ON
        INSERT [eidmadm].[storageservers]
            ([serverid], [servername], [physicalserver], [port], [protocol], [serviceaddress], [type], [status], [replicationlastpurge], [replicationpollinginterval], [localdbconn], [license], [activecachepathid], [activereplicationengineid], [replicationlastactivity], [owneruserid], [createddate], [lastmodifieduserid], [lastmodifieddate], [isEncrypted], [securityCertificateId], [extendedProperties])
        VALUES
            (1000003, N'SMPRINTAWS', N'', NULL, N'', N'', 2, NULL, NULL, NULL, N'', N'', NULL, NULL, NULL, 1, CAST(GETDATE() AS DateTime), 1, CAST(GETDATE() AS DateTime), 0, NULL, @print1)
        SET IDENTITY_INSERT [eidmadm].[storageservers] OFF
    end

    IF (select servername
    from eidmadm.storageservers
    where servername = 'SMSTMNTAWS' and serverid=9000005) IS NOT NULL
	Begin
        Print '( i ) Found Server with old id for v2, Deleting and Reinserting One'
        DELETE from eidmadm.storageservers where servername = 'SMSTMNTAWS'
        SET IDENTITY_INSERT [eidmadm].[storageservers] ON
        INSERT [eidmadm].[storageservers]
            ([serverid], [servername], [physicalserver], [port], [protocol], [serviceaddress], [type], [status], [replicationlastpurge], [replicationpollinginterval], [localdbconn], [license], [activecachepathid], [activereplicationengineid], [replicationlastactivity], [owneruserid], [createddate], [lastmodifieduserid], [lastmodifieddate], [isEncrypted], [securityCertificateId], [extendedProperties])
        VALUES
            (1000002, N'SMSTMNTAWS', N'', NULL, N'', N'', 2, NULL, NULL, NULL, N'', N'', NULL, NULL, NULL, 1, CAST(GETDATE() AS DateTime), 1, CAST(GETDATE() AS DateTime), 0, NULL, @v21)
        SET IDENTITY_INSERT [eidmadm].[storageservers] OFF
    end
    update eidmadm.storageservers set type=2

END



select *
from eidmadm.storageservers