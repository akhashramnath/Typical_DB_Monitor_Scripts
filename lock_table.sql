SELECT c.owner
      ,c.object_name
      ,c.object_type
      ,vs.module
      ,vs.machine
      ,vs.osuser
      ,vlocked.oracle_username
      ,vs.sid
      ,vp.pid
      ,vp.spid AS os_process
      ,vs.serial#
      ,vs.status
      ,vs.saddr
      ,vs.audsid
      ,vs.process
FROM 
    v$locked_object vlocked
    ,v$process       vp
    ,v$session       vs
    ,dba_objects     c
WHERE vs.sid = vlocked.session_id
AND vlocked.object_id = c.object_id
AND vs.paddr = vp.addr
AND c.object_name LIKE '%' || upper('&tab_name') || '%'
AND nvl(vs.status
      ,'XX') != 'KILLED';
