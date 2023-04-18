set lin 132
set pages 66
column "SID"          format 999
column "SER"          format 99999
column "Table"        format A10
column "SPID"         format A5 
column "CPID"         format A5 
column "OS User"      format A7 
column "Table"        format A10
column "SQL Text"     format A40 wor
column "Mode"         format A20
column "Node"      format A10
column "Terminal"     format A8

spool /tmp/locks.lst

select
  s.sid "SID",
  s.serial# "SER",
  o.object_name "Table",
  s.osuser "OS User",
  s.machine "Node",
  s.terminal "Terminal",
  --p.spid "SPID",
  --s.process "CPID",
  decode (s.lockwait, null, 'Have Lock(s)', 'Waiting for <' || b.sid || '>') "Mode",
  substr (c.sql_text, 1, 150) "SQL Text"
from v$lock l,
  v$lock d,
  v$session s,
  v$session b,
  v$process p,
  v$transaction t,
  sys.dba_objects o,
  v$open_cursor c
where l.sid = s.sid
  and o.object_id (+) = l.id1
  and c.hash_value (+) = s.sql_hash_value
  and c.address (+) = s.sql_address
  and s.paddr = p.addr
  and d.kaddr (+) = s.lockwait
  and d.id2 = t.xidsqn (+)
  and b.taddr (+) = t.addr
  and l.type = 'TM'
group by
  o.object_name,
  s.osuser,
  s.machine,
  s.terminal,
  p.spid,
  s.process,
  s.sid,
  s.serial#,
  decode (s.lockwait, null, 'Have Lock(s)', 'Waiting for <' || b.sid || '>'),
  substr (c.sql_text, 1, 150)
order by 
  decode (s.lockwait, null, 'Have Lock(s)', 'Waiting for <' || b.sid || '>') desc,
  o.object_name asc,
  s.sid asc;
spool off;


