--New Tenant ::

--select * from  dbo.ossys_Tenant
--update dbo.ossys_Tenant set ESPACE_ID=15 where name ='bankingmaster' 

--Update Password


DECLARE @tenant VARCHAR(100), 
        @tenantid VARCHAR(100),
        @prod   VARCHAR(100);

-- Assign values to the variables
SET @tenant = 'fiserv1';
SET @prod = 'dev';
SET @tenantid = (SELECT TENANT_ID FROM dbo.OSUSR_K0H_BANKTENANT_SERVICESCONFIG where BANKNAME = @tenant);

---- Update query with concatenation
--update dbo.OSSYS_USER set PASSWORD='$1$PGjEiAmUTna2ByFknTqP1JXoeFcVjBsJR8NoVKIvbgA=1355FFB0F279BF9EC6EB9EB61C13E30720D1FDBD11472FCA9F35791CE294F7DE0CDB03B273E39CF6206E1BAEAA55AB688A4324687E70FFC904D8AF389E7DB201' 
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