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
--update dbo.OSSYS_USER set PASSWORD='$1$M1+DIUOd92AvbGMSZtO7AMo/cieghJjO8qz9p79c1IE=6264E9974A9A90223540C0D378E7B4BACC23053738539210B2DF0F568D13AB20A866D0C388C04BED18E8DE9248B36985062B5886821ECA1666B42DF3A77A4129' 
--where TENANT_ID= @tenantid and name IN (
--    'admin_' + @tenant + '_' + @prod,
--    'apiuser_' + @tenant + '_' + @prod,
--    'wfapiuser_' + @tenant + '_' + @prod
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