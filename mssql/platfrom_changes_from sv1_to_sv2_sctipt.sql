
--1. globalvariable  set to v2 for  StatementVersion
update eidmadm.globalvariables set variablevalue='v2' where  variablename='StatementVersion'
select * from eidmadm.globalvariables where  variablename ='StatementVersion'
--2. set pinstancestate = 99 or 98 
update eidmadm.wf_pinstances set pinstancestate = 99 where pinstancename in ('ImportData', 'LoanStatementImportData', 'bill / loan payment statement')
select * from eidmadm.wf_pinstances where pinstancename in ('ImportData', 'LoanStatementImportData', 'bill / loan payment statement')
--3. set nextrundate to a far future date
update eidmadm.wf_processactivity set nextrundate = '2075-01-01 00:00:00.000' where pinstanceid in ( select pinstanceid from eidmadm.wf_pinstances where pinstancename in ('ImportData', 'LoanStatementImportData', 'bill / loan payment statement'))
select * from eidmadm.wf_processactivity  where pinstanceid in ( select pinstanceid from eidmadm.wf_pinstances where pinstancename in ('ImportData', 'LoanStatementImportData', 'bill / loan payment statement'))
--4 chk storage servers	
select * from eidmadm.storageservers where servername='SMSTMNTAWS'