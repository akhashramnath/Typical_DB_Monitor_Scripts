-- -----------------------------------------------------------------------------------
-- Program	: sess_sql.sql
-- Description	: Display SQL Sessions
-- -----------------------------------------------------------------------------------
-- Modification History
-- ----------	-----------------	----------------------------------------------
-- -----------------------------------------------------------------------------------
set lines 180

def aps_prog    = 'sessinfo.sql'
def aps_title   = 'Session information'
start apstitle

col "Session Info" form A80
set verify off
set pages 45
accept sid      prompt 'Please enter the value for Sid if known            : '
accept spid     prompt 'Please enter the value for Server Process if known : '
select ' Sid, Serial#, Aud sid : '|| s.sid||' , '||s.serial#||' , '||
       s.audsid||chr(10)|| '     DB User / OS User : '||s.username||
       '   /   '||s.osuser||chr(10)|| '    Machine - Terminal : '||
       s.machine||'  -  '|| s.terminal||chr(10)||
       '        OS Process Ids : '||
       s.process||' (Client)  '||p.spid||' (Server)'|| chr(10)||
       '   Client Program Name : '||s.program||chr(10)||
       '                Status : '||s.status||chr(10)||
       '           Last Call ET: '||s.last_call_et||chr(10)||
       '                 Module: '||s.module||chr(10)||
       '                 Action: '||s.action  "Session Info"
  from v$process p,v$session s
 where p.addr = s.paddr
   and s.sid = nvl('&SID',s.sid)
   and p.spid = nvl('&spid',p.spid)
/

-- col hv          noprint
col ln          heading 'Line'                  format        9,999
col ss          heading 'SQL Statement'         format          A65

select  b.hash_value            hv,
        b.piece                 ln,
        b.sql_text              ss
from    v$sqltext b, v$session c,
        v$process d
where   b.address = c.sql_address
  and   b.hash_value = c.sql_hash_value
  and   d.addr = c.paddr
   and c.sid = nvl('&SID',c.sid)
   and d.spid = nvl('&spid',d.spid)
order by 1,2
/
start apsclear

col name          heading 'Statistic/Description'         format          A40
col value         heading 'Value'         format   999,999,999,990

select  s.statistic#, name, value
from  v$sesstat s, v$statname n,
      v$session m, v$process p
where s.statistic# = n.statistic#
  and m.sid = nvl('&SID',m.sid)
  and s.sid = m.sid
  and p.spid = nvl('&spid',p.spid)
  and m.paddr = p.addr
  and value > 0
  and s.statistic# in (2,3,4,6,7,8,9,11,12,15,16,20,21,38,39,40,41,64,100,101,147,158,163,164,165,166,188,190,208,209)
order by 1
/



