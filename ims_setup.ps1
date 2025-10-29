$choices = $env:choices -split ","
foreach ($choice in $choices) {
    if ($choice -eq "imsblob") {
        $dict_filename = "D:\Deployments\dataset\Dataset.csv"
        $csvdatas = Import-CSV -Path $dict_filename
        $Database = $env:Database
  
        foreach ($csvdata in $csvdatas) {
            if ($Database -eq $csvdata.database) {
                $RDSInstance = $csvdata.DBInstance
                $env = $csvdata.Environment
                $client = $csvdata.client.ToLower()
                if ($env -eq "int" ) {
                    $env = "inte"
                }
                $env = $env.ToLower()
                if ($env:mainclient -eq $NULL) { 
                    $client = $csvdata.client 
                    $client = $client.ToLower()
                    $env:mainclient = $client.ToLower()
                }
                write-host "RDS RDSInstance is  :: $RDSInstance and Database is :: $Database"
                if ($env -eq "prod") {
                    start-sleep -s 15
                }
                $query = "SELECT  JSON_VALUE(extendedProperties,'$.containerNamePrefix') AS Bucketname  FROM eidmadm.storageservers where servername = 'SMPRINTAWS' or servername = 'SMPRINTAZE' "
                $old = "SELECT  extendedProperties FROM eidmadm.storageservers where servername = 'SMPRINTAWS' or servername = 'SMPRINTAZE'"
                # Declaring placeholder variables
                $vault_url = "https://vault.savanainc.com:8200/v1/"
                # Setting Vault Url with Resp to Cloud
                if ($RDSInstance -match "aze" -or $RDSInstance -match "savprod01" -or $RDSInstance -match "database.windows.net") {
                    Write-Host "( i ) Seems to be Azure SQL Instance"
                    $vault_auth_endpoint = ${vault_url} + "database/data/azure"   
                }
                else {
                    Write-Host "( i ) Seems to be AWS RDS Instance"
                    $vault_auth_endpoint = ${vault_url} + "database/data/aws" 
                }
                # Getting Secrets form AWS SM 
                $SMCreds = (Get-SECSecretValue -SecretId "arn:aws:secretsmanager:us-east-1:313346835816:secret:savana-automation-vault-SN7cW0" -Region "us-east-1").SecretString | ConvertFrom-Json
                $APIToken = $SMCreds.'vault-jenkins-key'
                $Headers = @{'X-Vault-Token' = $APIToken }
                $DatabaseCreds = ((Invoke-WebRequest -Uri $vault_auth_endpoint -Method GET -Headers $Headers -ContentType "application/json").content | ConvertFrom-Json).data.data
                $DBServerPrefix = $RDSInstance.Split(".")[0]
                $SQLUser = $DatabaseCreds."$DBServerPrefix-sauser"
                $SQLPass = $DatabaseCreds."$DBServerPrefix-sapass"
                if (!$SQLPass) {
                    Write-Host "[ ! ] Unable to retrieve database credentials from Secrets Manager! Please check logs!"
                    throw
                }
      
      
                Function CallVaultAPI($Url) {
                    # Getting Secrets form AWS SM 
                    $SMCreds = (Get-SECSecretValue -SecretId "arn:aws:secretsmanager:us-east-1:313346835816:secret:savana-automation-vault-SN7cW0" -Region "us-east-1").SecretString | ConvertFrom-Json
                    $APIToken = $SMCreds.'vault-jenkins-key'
                    $Headers = @{'X-Vault-Token' = $APIToken }
                    try { Invoke-RestMethod -Method GET -Uri $Url -Headers $Headers -ContentType $ContentType }
                    catch { Write-Host "[ ! ] Error reported! Error body: $Url "; $_ }
                    $apidata = Invoke-RestMethod -Method GET -Uri $Url -Headers $Headers -ContentType $ContentType 
                    $data = $apidata.data.data
                    if ($data -eq $Null) {
                        write-host "[ ! ] No data Found in Vault $Url"
                        exit 1
                    }
                    return  $data
                }
    
                $vault_auth_endpoint = ${vault_url} + $Env + "/data/" + $env:mainclient + "/" + $client + "/infra/east-us2/storage/default" 
                $sav_statement_storage_name = (CallVaultAPI  -Url $vault_auth_endpoint).statements_container_name | out-file sav_statement_storage_name.txt
                $statement_processing_container_name = (CallVaultAPI  -Url $vault_auth_endpoint).statement_processing_container_name | out-file statement_processing_container_name.txt
                $sav_storage_account_name = (CallVaultAPI  -Url $vault_auth_endpoint).storage_account_name | out-file sav_storage_account_name.txt
                $sav_storage_account_strings = (CallVaultAPI  -Url $vault_auth_endpoint).storage_account_primary_blob_connection_string -split ";"
                $sav_storage_account_strings = $sav_storage_account_strings -split ";"
                foreach ($sav_storage_account_string in $sav_storage_account_strings) { 
                    if ($sav_storage_account_string -like "*BlobEndpoint*") {
                        $blobendpoint = $sav_storage_account_string -replace "BlobEndpoint="
                    }
                    if ($sav_storage_account_string -like "*AccountKey*") {
                        $AccountKey = $sav_storage_account_string -replace "AccountKey="
                    }            
                }      
                $vault_auth_endpoint = ${vault_url} + $Env + "/data/" + $env:mainclient + "/general/infra/east-us2/resourcegroup" 
                $sav_subscription_id = (CallVaultAPI  -Url $vault_auth_endpoint).subscription_id | out-file sav_subscription_id.txt
                $sav_resource_group = (CallVaultAPI  -Url $vault_auth_endpoint).name | out-file sav_resource_group.txt
                  
                #IMS SFTP  
                $vault_auth_endpoint = ${vault_url} + $Env + "/data/" + $env:mainclient + "/" + $client + "/infra/east-us2/ims/sftp" 
                $sftp_host = (CallVaultAPI  -Url $vault_auth_endpoint).sftp_host      | out-File sftp_host.txt  
                $sftp_username = (CallVaultAPI  -Url $vault_auth_endpoint).sftp_username   | out-File sftp_username.txt 
                $sftp_password = (CallVaultAPI  -Url $vault_auth_endpoint).sftp_password   | out-File sftp_password.txt 
                $sftp_port = (CallVaultAPI  -Url $vault_auth_endpoint).sftp_port   | out-File sftp_port.txt 
                $sftp_host = (Get-Content sftp_host.txt).trim() 
                $sftp_username = (Get-Content sftp_username.txt).trim() 
                $sftp_password = (Get-Content sftp_password.txt).trim() 
                $sftp_port = (Get-Content sftp_port.txt).trim()

                #nGageapi
                $vault_auth_endpoint = ${vault_url} + $Env + "/data/" + $env:mainclient + "/" + $client + "/general" 
                $ngageapi = (CallVaultAPI  -Url $vault_auth_endpoint).url_platform_api      | out-File ngageapi.txt 
                $ngageapi_url = (Get-Content ngageapi.txt).trim() -replace "/swagger"


                #IMS Notification  
                $vault_auth_endpoint = ${vault_url} + $Env + "/data/" + $env:mainclient + "/" + $client + "/integrations/ims"
                $notification_callback_string = (CallVaultAPI  -Url $vault_auth_endpoint).notification_callback_string  | out-File notification_callback_string.txt
                $serviceapikey = (CallVaultAPI  -Url $vault_auth_endpoint).serviceapikey  | out-File serviceapikey.txt
                $notification_callback_string = (Get-Content notification_callback_string.txt).trim() 
                $serviceapikey = (Get-Content serviceapikey.txt).trim()   
                $statement_processing_container_name = (Get-Content statement_processing_container_name.txt).trim()
                $sav_statement_storage_name = (Get-Content sav_statement_storage_name.txt).trim()
                $sav_storage_account_name = (Get-Content sav_storage_account_name.txt).trim()
                $sav_subscription_id = (Get-Content sav_subscription_id.txt).trim()
                $sav_resource_group = (Get-Content sav_resource_group.txt).trim()
        
                #IMS URL  
                $vault_auth_endpoint = ${vault_url} + $Env + "/data/" + $env:mainclient + "/" + $client + "/infra/east-us2/ims/apigw/ims-service-apigateway"
                $ims_url = (CallVaultAPI  -Url $vault_auth_endpoint).gateway_url  | out-File ims_url.txt
                $apikey = (CallVaultAPI  -Url $vault_auth_endpoint).serviceapikey  | out-File apikey.txt
                $ims_url = (Get-Content ims_url.txt).trim()
                $apikey = (Get-Content apikey.txt).trim()


                $ims_sql_query = @"
USE ${Database}
BEGIN TRANSACTION;
BEGIN TRY

DECLARE @ScriptName nVarchar(500)
SET @ScriptName = '20250923_set_prod_dash_SD_19550_IMS.sql' 
PRINT @ScriptName + 'begin'

IF NOT EXISTS (SELECT Scriptname FROM eidmadm.DBScriptsLog WHERE ScriptName = @ScriptName )
BEGIN

SET NUMERIC_ROUNDABORT OFF
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS, NOCOUNT ON
SET DATEFORMAT YMD
SET XACT_ABORT ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRANSACTION
--==================================================================================================================================================
--SELECT * FROM eidmadm.notifyserviceconfig WHERE Name in ('Lob', 'Ims')
--SELECT * FROM eidmadm.StatementConfigurations WHERE param in ('PrintVendorApiParam', 'PrintIntegrationType')
--SELECT * FROM eidmadm.StatementConfigurations WHERE param in ('StatementPrintVendorAPI', 'StatementPrintVendorSecurity') and statementtype = 1
--SELECT * FROM eidmadm.configurations WHERE PARAM IN ('IMSPrintReconsilationSFTP', 'IMSPrintReconsilationCallBackURL') 
--SELECT extendedProperties,* FROM eidmadm.storageservers WHERE servername = 'SMPRINTAZE'

DECLARE 
@URL         AS VARCHAR(100) = '${ims_url}/api/printstage/print',
@apiKey      AS VARCHAR(100) = '${apikey}',
@ngageApi    AS VARCHAR(100) = '$ngageapi_url',
@pringApi    AS VARCHAR(max),
@callBackURL AS VARCHAR(max) = '${notification_callback_string}',
@sftp_host AS VARCHAR(max)='${sftp_host}'
@sftp_port AS VARCHAR(100)='${sftp_port}'
@sftp_username AS VARCHAR(max)='${sftp_username}'
@sftp_password AS VARCHAR(max)='${sftp_password}'

SET @pringApi = ('{"baseEndPoint":"'+ @ngageApi + '","accountDocument":"api/app/toolbox/accountDocuments","customerDocument":"api/app/toolbox/customerDocuments"}')


--------------------------------------------------------------------------------------------------------------------------
-------------------------------1. NotifyServiceConfig Table---------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
UPDATE eidmadm.notifyserviceconfig SET IsDefault = 0 WHERE Name = 'Lob'
UPDATE eidmadm.notifyserviceconfig SET IsDefault = 1 WHERE Name = 'Ims'
UPDATE eidmadm.notifyserviceconfig SET SerializedProperties = '{"Url":"' + @URL + '","AuthorizationToken":"' + @apiKey + '"}' WHERE Name = 'Ims'

--------------------------------------------------------------------------------------------------------------------------
-------------------------------2. StatementConfigurations Table-----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
UPDATE eidmadm.StatementConfigurations SET ParamValue = 'Ims'     WHERE Param = 'PrintIntegrationType'
UPDATE eidmadm.StatementConfigurations SET ParamValue = @pringApi WHERE Param = 'PrintVendorApiParam'

UPDATE eidmadm.StatementConfigurations SET ParamValue = @URL    WHERE Param = 'StatementPrintVendorAPI'
UPDATE eidmadm.StatementConfigurations SET ParamValue = @apiKey WHERE Param = 'StatementPrintVendorSecurity'

--------------------------------------------------------------------------------------------------------------------------
-------------------------------3. configurations Table--------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
UPDATE eidmadm.configurations SET paramvalue = @callBackURL WHERE PARAM = 'IMSPrintReconsilationCallBackURL'
UPDATE eidmadm.configurations SET paramvalue = '{"host":@sftp_host,"port":@sftp_port ,"user":@sftp_username,"password":@sftp_password,"fromDir":"FromIMS" }' WHERE PARAM = 'IMSPrintReconsilationSFTP'

--==================================================================================================================================================
	BEGIN
		INSERT INTO eidmadm.DBScriptsLog (ScriptName,ScriptRunDate) VALUES (@ScriptName,GETDATE())
	END
	COMMIT TRANSACTION
END
ELSE
BEGIN
	PRINT 'ERROR ! '+ @ScriptName + ' Script has already been run once in the database!'
END
PRINT @ScriptName + ' end'
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_SEVERITY()  AS ErrorSeverity
          ,ERROR_STATE()  AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure
          ,ERROR_LINE()   AS ErrorLine,  ERROR_MESSAGE()   AS ErrorMessage;
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
END CATCH
IF @@TRANCOUNT > 0
    COMMIT TRANSACTION;	
--==================================================================================================================================================
"@

                $updates = @"
{
    "containerNamePrefix": "$statement_processing_container_name",
    "endpointUri": "$blobendpoint",
    "accountKey": "$AccountKey",
    "connectionString": "",
    "sasUriExpireSeconds": 600,
    "resourceGroupName": "$sav_resource_group",
    "accountName": "$sav_storage_account_name",
    "subscriptionId": "$sav_subscription_id",
    "managementCredsType": "ManagedIdentity"
}
"@
                # $updatebucketquery = "update eidmadm.storageservers set extendedProperties = '${updates}' where servername = 'SMPRINTAZE'"
                # Write-Host "[ i ] Updating $Database with BUcket Name: $statement_processing_container_name"
                # Invoke-Sqlcmd -ServerInstance $RDSInstance -Username $SQLUser -Password $SQLPass -Database $Database  -Query $updatebucketquery -trustservercertificate
                # Write-Host ""
                # $newconfigquery = Invoke-Sqlcmd -ServerInstance $RDSInstance -Username $SQLUser -Password $SQLPass -Database $Database -Query $old
                # $newconfig = $newconfigquery.extendedProperties
                # write-host "[ i ] New Config is:"
                # $newconfig
                # Write-Host ""
                # Write-Host "[ i ] Update Complete for $Database...."
                # Write-Host ""
                # Write-Host "#======================================================Complete===============================================================#"
                # Write-Host ""
                #IMS Storage Update
                start-sleep -s 10
                #Invoke-Sqlcmd -ServerInstance $RDSInstance -Username $SQLUser -Password $SQLPass -Database $Database  -Query $ims_sql_query -trustservercertificate
                Write-Host "" 
                Write-Host ""
                Write-Host "[ i ] Update Complete for $Database...."
                Write-Host ""
                $updates
                $ims_sql_query 
            }
        }
    }
}