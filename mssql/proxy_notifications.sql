

-- Step 1: Create the SmsProxyServicer
IF NOT EXISTS (SELECT * FROM [eidmadm].[NotifyServicers] WHERE [Name] = 'ProxySmsServicer')
BEGIN
   INSERT INTO [eidmadm].[NotifyServicers] ([ChannelTypeId],[Name]) VALUES (1,'ProxySmsServicer')
END

DECLARE @ServicerIdSMS INT = (SELECT Id FROM [eidmadm].[NotifyServicers] WHERE [Name] = 'ProxySmsServicer')

IF NOT EXISTS (SELECT * FROM [eidmadm].[NotifyServiceConfig] WHERE [Name] = 'ProxySmsServicer')
BEGIN
   INSERT INTO [eidmadm].[NotifyServiceConfig] (ServicerId, Name, SerializedProperties, IsDefault, CreatedUserId, CreatedDate, ModifiedUserId, ModifiedDate) VALUES (@ServicerIdSMS,'ProxySmsServicer', '{}',1,1,GETDATE(),1,GETDATE())
END

-- Step 2: Create the EmailProxyServicer
IF NOT EXISTS (SELECT * FROM [eidmadm].[NotifyServicers] WHERE [Name] = 'ProxyEMailServicer')
BEGIN
   INSERT INTO [eidmadm].[NotifyServicers] ([ChannelTypeId],[Name]) VALUES (2,'ProxyEMailServicer')
END

DECLARE @ServicerIdEmail INT = (SELECT Id FROM [eidmadm].[NotifyServicers] WHERE [Name] = 'ProxyEMailServicer')

IF NOT EXISTS (SELECT * FROM [eidmadm].[NotifyServiceConfig] WHERE [Name] = 'ProxyEMailServicer')
BEGIN
   INSERT INTO [eidmadm].[NotifyServiceConfig] (ServicerId, Name, SerializedProperties, IsDefault, CreatedUserId, CreatedDate, ModifiedUserId, ModifiedDate) VALUES (@ServicerIdEmail,'ProxyEMailServicer', '{}',1,1,GETDATE(),1,GETDATE())
END

-- Step 3: Make the Proxy Servicers active.
UPDATE eidmadm.NotifyServiceConfig SET IsDefault = 1 WHERE Name IN ('ProxySmsServicer', 'ProxyEMailServicer')
UPDATE eidmadm.NotifyServiceConfig SET IsDefault = 0 WHERE Name IN ('Twilio SMS', 'Sendgrid')

-- Step 4: Set SerializedProperties for these two Proxy items (sms and email)
IF EXISTS (SELECT VariableValue FROM eidmadm.globalvariables WHERE VariableName = 'nGage_EndPoint') BEGIN
	DECLARE @EndPoint AS varchar(100) = (SELECT VariableValue FROM eidmadm.globalvariables WHERE VariableName = 'nGage_EndPoint')
	DECLARE @JsonProxySmsServicer   AS NVARCHAR(MAX) = ( '{"CallbackUrl":"' +  @EndPoint + 'ngageservices/notifications/ngage.notifications.callbackapi/api/notification/callback/twilio","ProxyDelay":1000}' )
	DECLARE @JsonProxyEMailServicer AS NVARCHAR(MAX) = ( '{"CallbackUrl":"' +  @EndPoint + 'ngageservices/notifications/ngage.notifications.callbackapi/api/notification/callback/sendgrid","ProxyDelay":1000}' )

	UPDATE [eidmadm].[NotifyServiceConfig] SET [SerializedProperties] = @JsonProxySmsServicer   WHERE NAME = 'ProxySmsServicer'
	UPDATE [eidmadm].[NotifyServiceConfig] SET [SerializedProperties] = @JsonProxyEMailServicer WHERE NAME = 'ProxyEMailServicer'
END


----------------------------------------------ALWAYS LAST - LOG TO DBSCRIPT TABLE------------------------------------------------------
DECLARE @ScriptName nVarchar(500)
      SET @ScriptName = 'Config_Proxy_Notifications.sql_' +  CAST(CURRENT_TIMESTAMP AS VARCHAR(250)) 

INSERT INTO eidmadm.DBScriptsLog (ScriptName,ScriptRunDate) VALUES (@ScriptName,getdate())
