	SELECT 
    r.session_id,
    r.command,
    r.status,
    r.percent_complete,
    r.start_time,
    r.estimated_completion_time / 1000 / 60 AS estimated_completion_time_minutes,
    r.total_elapsed_time / 1000 / 60 AS elapsed_time_minutes,
    r.logical_reads,
    r.writes
FROM 
    sys.dm_exec_requests r
WHERE 
    r.command IN ('BACKUP DATABASE', 'BACKUP LOG');



    SELECT 
    r.session_id,
    r.command,
    r.percent_complete,
    r.start_time,
    r.status,
    d.text AS query_text
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) d
WHERE r.command IN ('RESTORE DATABASE', 'RESTORE LOG');