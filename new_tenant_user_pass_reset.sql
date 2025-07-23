DECLARE @tenant VARCHAR(100), 
        @tenantid VARCHAR(100),
        @prod   VARCHAR(100);

-- Assign values to the variables
SET @tenant = 'optum';
SET @prod = 'dev';
SET @tenantid = (SELECT TENANT_ID FROM dbo.OSUSR_K0H_BANKTENANT_SERVICESCONFIG where BANKNAME = @tenant);


--New Tenant ::
select ESPACE_ID,* from  dbo.ossys_Tenant where name = @tenant
--update dbo.ossys_Tenant set ESPACE_ID=14 where name = @tenant

--Update Password
-- Update query with concatenation
--update dbo.OSSYS_USER set PASSWORD='$1$o2YSFVrB0qfIL8RvO2LNBAOGSdkwY9QrFqeALWoLyyw=9EDC1A3C293F1F30AB387D038572233F1375C121689B151D6C7E319818C57BA4302B7D3B1BE55B861E5921854616CB64EB0A3E26198FAE82660001DCBB82E05D' 
--where TENANT_ID= @tenantid and name IN (
--    'admin_' + @tenant + '_' + @prod,
--    'apiuser_' + @tenant + '_' + @prod,
--    'wfapiuser_' + @tenant + '_' + @prod
--);

-- Select query with concatenation
SELECT * 
FROM OSSYS_USER 
WHERE name IN (
    'admin_' + @tenant + '_' + @prod,
    'apiuser_' + @tenant + '_' + @prod,
    'wfapiuser_' + @tenant + '_' + @prod
);

select ESPACE_ID,* from  dbo.ossys_Tenant where name = @tenant