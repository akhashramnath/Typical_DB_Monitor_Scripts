SELECT a.request_id, d.sid, d.serial# ,d.status,d.sql_id,d.osuser,d.process , c.SPID
FROM apps.fnd_concurrent_requests a,
apps.fnd_concurrent_processes b,
v$process c,v$session d
WHERE a.controlling_manager = b.concurrent_process_id
AND c.pid = b.oracle_process_id
AND b.session_id=d.audsid
AND a.request_id = &Request_ID
AND a.phase_code = 'R';
