DECLARE @tenant VARCHAR(100), 
        @tenantid VARCHAR(100),
        @prod   VARCHAR(100);

-- Assign values to the variables
SET @tenant = 'windward';
SET @prod = 'dev';
SET @tenantid = (SELECT TENANT_ID FROM dbo.OSUSR_K0H_BANKTENANT_SERVICESCONFIG where BANKNAME = @tenant);


--New Tenant ::
select ESPACE_ID,* from  dbo.ossys_Tenant where name = @tenant
--update dbo.ossys_Tenant set ESPACE_ID=14 where name = @tenant

--Update Password
-- Update query with concatenation
--update dbo.OSSYS_USER set PASSWORD='$1$lQZNVvq3vZp0P++kagzgf/ogJySGfSEySMCa2Bh2euY=34F32077D37162FBDB15AC41D07E6F0CA7C94C1929945F4907255B7875CB8189ECB8DAD76AA13D0C3BFF843ABF65B5DACE581D95D814AA32F8596D376F301DEB' 
--where TENANT_ID= @tenantid and name IN (
--    'admin_' + @tenant + '_' + @prod,
--    'apiuser_' + @tenant + '_' + @prod,
--    'wfapiuser_' + @tenant + '_' + @prod,
--    'statementuser_' + @tenant + '_' + @prod
--);

-- Select query with concatenation
SELECT * 
FROM OSSYS_USER 
WHERE name IN (
    'admin_' + @tenant + '_' + @prod,
    'apiuser_' + @tenant + '_' + @prod,
    'wfapiuser_' + @tenant + '_' + @prod,
    'statementuser_' + @tenant + '_' + @prod
);

select ESPACE_ID,* from  dbo.ossys_Tenant where name = @tenant