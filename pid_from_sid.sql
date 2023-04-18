Set lines 200
col sid format 99999
col username format a15
col osuser format a15
select a.sid, a.serial#,a.username, a.osuser, b.spid
from v$session a, v$process b
where a.paddr= b.addr
and a.sid='&sid'
order by a.sid;
