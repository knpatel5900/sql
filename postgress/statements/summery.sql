
select st.description as "statementtype"
	,sc.code as "statementcore"
	,sb.statementperiod as "statementperiod"
	,sb.batchnumber as "intake-id"
	,sb.createddate as "initiateddate"
	,stg.description as "batchstage"
	,sta.description as "batchstate"
	,(select count(id) 
		from public.statementdata sd
		where sd.batchnumber = ss.batchnumber) as "datacount"
	,(select count(id) 
		from public.statement_x_document doc
		where doc.batchnumber = ss.batchnumber) as "documentcount"
	,(select count(id)
	from public.statement_x_notifications sn
		where sn.batchnumber = ss.batchnumber) as "notificationcount"
    ,(select count(id)
	from public.statementerror se
		where se.batchnumber = ss.batchnumber) as "errorcount"
    ,sb.filesprocessed
from public.statementbatch sb
inner join public.statement_type st 
	on st.id = sb.statementtype
inner join public.statementsummary ss
	on ss.batchnumber = sb.batchnumber
inner join public.stage stg
	on stg.id = ss.stage
inner join public.status sta
	on sta.id = ss.state
inner join public.statement_core sc
	on sc.id = sb.statementcore
where ss.id = (select max(id) from public.statementsummary where batchnumber = sb.batchnumber)
	and sb.batchnumber = 'batchnumber'
order by sb.id desc 


select s.id, s.batchnumber, g.description, t.description, s.customersuccesscount, s.accountsuccesscount, s.notificationsuccesscount, s.duration, * 
from statementsummary s
join stage g on s.stage = g.id
join processstate t on s.state = t.id
where s.batchnumber = 'batchnumber'
order by stage, state;


select createddate, * from statementerror where createddate > '2/1/2026' and createddate < '2/2/2026'  order by ID desc limit 100