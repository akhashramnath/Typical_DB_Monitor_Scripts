SET termout ON
SET heading ON
SET PAGESIZE 6000
SET LINESIZE 200

COLUMN pgm_notes FORMAT a80 HEADING 'Notes'
COLUMN rbs FORMAT a16 HEADING 'RBS' JUST center
COLUMN oracle_user FORMAT a12 HEADING 'Oracle|Username'
COLUMN sid_serial FORMAT a12 HEADING 'SID,Serial'
COLUMN unix_pid FORMAT a6 HEADING 'O/S|PID'
COLUMN Client_User FORMAT a14 HEADING 'Client|Username'
COLUMN Unix_user FORMAT a12 HEADING 'O/S|Username'
COLUMN login_time FORMAT a17 HEADING 'Login Time'
COLUMN last_txn FORMAT a17 HEADING 'Last Active'
COLUMN undo_kb FORMAT 999,999,999,999 HEADING 'Undo KB'
COLUMN sql_text FORMAT a140 HEADING 'Sql Text'


SELECT s.inst_id,
r.name rbs,
nvl(s.username, 'None') oracle_user,
s.osuser client_user,
p.username unix_user,
to_char(s.sid)||','||to_char(s.serial#) as sid_serial,
p.spid unix_pid,
TO_CHAR(s.logon_time, 'mm/dd/yy hh24:mi:ss') as login_time,
t.used_ublk * 8192 as undo_BYTES,
st.sql_text as sql_text
FROM gv$process p,
v$rollname r,
gv$session s,
gv$transaction t,
gv$sqlarea st
WHERE p.inst_id=s.inst_id
AND p.inst_id=t.inst_id
AND s.inst_id=st.inst_id
AND s.taddr = t.addr
AND s.paddr = p.addr(+)
AND r.usn = t.xidusn(+)
AND s.sql_address = st.address
-- AND t.used_ublk * 8192 > 10000
AND t.used_ublk * 8192 > 1073741824
ORDER
BY undo_BYTES desc
/
