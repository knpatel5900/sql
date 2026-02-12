DECLARE @Tenantname varchar(50) = 'Metropolitan Capital Bank'
DECLARE @Tenantid int = 220

--UPDATE  OSUSR_K0H_BANKTENANT_SERVICESCONFIG 
--SET BankName = @Tenantname,
--DOCUMENTSSERVICECONFIGNAME='test',
--DOCUMENTSSERVICEENDPOINT='test'
--WHERE Tenant_ID = @tenantid

select * from OSUSR_K0H_BANKTENANT_SERVICESCONFIG WHERE Tenant_ID = @tenantid

update dbo.ossys_Tenant set NAME= @Tenantname
WHERE ID = @tenantid

select * from  dbo.ossys_Tenant
WHERE ID = @tenantid

--UPDATE  OSUSR_K0H_BANKTENANT_SERVICESCONFIG SET 
--CUSTOMERSERVICEENDPOINT='test',
--CUSTOMER_APIKEY='test',
--CUSTOMER_APISECRET='test',
--ACCOUNTSERVICEENDPOINT='test',
--ACCOUNT_APIKEY='test',
--ACCOUNT_APISECRET='test'
--WHERE Tenant_ID = @tenantid