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
--update dbo.OSSYS_USER set PASSWORD='$1$MQ8s3cclX4Y9AeZa/kklwBthbPcHd0B5UpRhM6H/yZM=C61BCE8FA0981835DC0F8BF7D7B1D0989D3831BCEA77859F033C2CD74B3FFB30ACB194C43B0DB6693120DB38A76047492F6CC258A533DA7411E2B1E7BB07A889' 
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