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
--update dbo.OSSYS_USER set PASSWORD='$1$eOW/xgnXwww1U2Gav2NLOyqIFPRdm4ODeK9Nqp1R23s=3DAB94C59435C82FEC4B30795574A3A7961CEABA9736136CC1474C219CEB6257B781A5C6809A1F25B83C8282648844C0F3A8ED1066314493A1BFB3A3FA1FA055' 
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