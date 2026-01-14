SELECT * FROM eidmadm.notifyserviceconfig WHERE Name in ('Lob', 'Ims')
SELECT * FROM eidmadm.StatementConfigurations WHERE param in ('PrintVendorApiParam', 'PrintIntegrationType')
SELECT * FROM eidmadm.StatementConfigurations WHERE param in ('StatementPrintVendorAPI', 'StatementPrintVendorSecurity') and statementtype = 1
SELECT * FROM eidmadm.configurations WHERE PARAM IN ('IMSPrintReconsilationSFTP', 'IMSPrintReconsilationCallBackURL') 
SELECT extendedProperties,* FROM eidmadm.storageservers WHERE servername = 'SMPRINTAZE'