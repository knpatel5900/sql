-- =============================================
-- SET BATCH NUMBER HERE
-- =============================================
SET session vars.b = 'fc73e0ce-05df-4e37-a25e-66abdfbd31d6';
-- =============================================


-- Batch overview
SELECT st.description AS "statementtype"
	,sc.code AS "statementcore"
	,sb.statementperiod AS "statementperiod"
	,sb.batchnumber AS "intake-id"
	,sb.createddate AS "initiateddate"
	,stg.description AS "batchstage"
	,sta.description AS "batchstate"
	,(SELECT count(id) FROM public.statementdata sd WHERE sd.batchnumber = ss.batchnumber) AS "datacount"
	,(SELECT count(id) FROM public.statement_x_document doc WHERE doc.batchnumber = ss.batchnumber) AS "documentcount"
	,(SELECT count(id) FROM public.statement_x_notifications sn WHERE sn.batchnumber = ss.batchnumber) AS "notificationcount"
	,(SELECT count(id) FROM public.statementerror se WHERE se.batchnumber = ss.batchnumber) AS "errorcount"
	,sb.filesprocessed
FROM public.statementbatch sb
INNER JOIN public.statement_type st ON st.id = sb.statementtype
INNER JOIN public.statementsummary ss ON ss.batchnumber = sb.batchnumber
INNER JOIN public.stage stg ON stg.id = ss.stage
INNER JOIN public.status sta ON sta.id = ss.state
INNER JOIN public.statement_core sc ON sc.id = sb.statementcore
WHERE ss.id = (SELECT max(id) FROM public.statementsummary WHERE batchnumber = sb.batchnumber)
	AND sb.batchnumber = current_setting('vars.b')::uuid
ORDER BY sb.id DESC;


-- Statement summary stages/states
SELECT s.id, s.batchnumber, g.description, t.description,
	s.customersuccesscount, s.accountsuccesscount, s.notificationsuccesscount, s.duration, *
FROM statementsummary s
JOIN stage g ON s.stage = g.id
JOIN processstate t ON s.state = t.id
WHERE s.batchnumber = current_setting('vars.b')::uuid
ORDER BY stage, state;


-- Errors
SELECT * FROM statementerror
WHERE batchnumber = current_setting('vars.b')::uuid
ORDER BY id DESC LIMIT 100;


-- Statement data count
SELECT count(id) FROM statementdata
WHERE batchnumber = current_setting('vars.b')::uuid;


-- Document count
SELECT count(id) FROM public.statement_x_document
WHERE batchnumber = current_setting('vars.b')::uuid;


-- Recent batches (date filter, no batch variable needed)
SELECT id, batchnumber, parentbatchnumber, createddate, *
FROM statementbatch
WHERE createddate > '2/1/2026'
ORDER BY id DESC;


-- Recent errors (date filter, no batch variable needed)
SELECT createddate, * FROM statementerror
WHERE createddate > '2/1/2026' AND createddate < '2/2/2026'
ORDER BY id DESC LIMIT 100;