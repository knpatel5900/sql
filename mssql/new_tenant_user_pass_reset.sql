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
--update dbo.OSSYS_USER set PASSWORD='$1$IGCxr8nST++Rqc9E0KpWu1y6KeHvNaDM08a4MoM+npY=F363B5546D3D0836D35B96ED9FBC92292F7AB80A996F00233037648491BB191A6AB2955BCEC8C8A439807E15A47745773ED231681EE6FAA1980F5D1FEFCBF6CA' 
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