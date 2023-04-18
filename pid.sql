col module for a30;
set lines 300;
col event for a38;
col program for a30;
col status for a8;
select sid,serial#,module,event,status,sql_id from V$session where paddr=(select addr from v$process where spid=&pid);
