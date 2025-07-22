DECLARE @tenant VARCHAR(100), 
        @tenantid VARCHAR(100),
        @prod   VARCHAR(100);

-- Assign values to the variables
SET @tenant = 'fbb2';
SET @prod = 'uat';
SET @tenantid = (SELECT TENANT_ID FROM dbo.OSUSR_K0H_BANKTENANT_SERVICESCONFIG where BANKNAME = @tenant);


--New Tenant ::
select ESPACE_ID,* from  dbo.ossys_Tenant where name = @tenant
update dbo.ossys_Tenant set ESPACE_ID=14 where name = @tenant

--Update Password
-- Update query with concatenation
update dbo.OSSYS_USER set PASSWORD='$1$Skeja4Z0l53DpenwSfWX1NUtwsPdoGLj2dGd4mGxETw=D6E826DF5A9626DAD108E06AFC1EFA463F6E13B0FC201902C31C82479E1C585AADD34EFBF448D8E95057FCDDF7C7B4CE8EDE7F0B75C7E5DD63E8EFEC2E976CBB' 
where TENANT_ID= @tenantid and name IN (
    'admin_' + @tenant + '_' + @prod,
    'apiuser_' + @tenant + '_' + @prod,
    'wfapiuser_' + @tenant + '_' + @prod
);

-- Select query with concatenation
SELECT * 
FROM OSSYS_USER 
WHERE name IN (
    'admin_' + @tenant + '_' + @prod,
    'apiuser_' + @tenant + '_' + @prod,
    'wfapiuser_' + @tenant + '_' + @prod
);

select ESPACE_ID,* from  dbo.ossys_Tenant where name = @tenant