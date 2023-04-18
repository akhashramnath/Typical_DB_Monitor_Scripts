-- The details of a session for a given system process id (sid)
alter session set nls_date_format='DD-MON-YY HH24:MI:SS';
DEFINE sid='&1'
set lines 170
col machine format a15
col username format a15
col event format a30
col action format a20
col module format a20
select sid,serial#,username,machine,type,status,to_char(logon_time,'DD-MON-YY HH24:MI:SS'),event,action,module,sql_id,SQL_HASH_VALUE,last_call_et
from v$session where sid = '&sid'
/
select a.sql_id, sql_text  from v$sqltext c,v$session a
where a.sid ='&sid'
        and hash_value = a.sql_hash_value
        and address = a.sql_address
order by piece
/
select a.sql_id, sql_text  from v$sqltext c,v$session a
where a.sid ='&sid'
        and hash_value = a.prev_hash_value
        and address = a.prev_sql_addr
order by piece
/


