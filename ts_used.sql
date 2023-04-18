REM
REM Script: ts_used.sql
REM
REM Function: Display tablespace usage with graph
REM
REM
column tablespace format a20
column total_mb format 999,999,999,999.99
column used_mb format 999,999,999,999.99
column free_mb format 999,999,999.99
column pct_used format 999.99
column graph format a25 heading "GRAPH (X=5%)"
compute sum of total_mb on report
compute sum of used_mb on report
compute sum of free_mb on report
break on report
set lines 132 pages 50
select a.tablespace_name,
round(a.bytes_alloc / 1024 / 1024) total_mb,
round((a.bytes_alloc - nvl(b.bytes_free, 0)) / 1024 / 1024) used_mb,
round(nvl(b.bytes_free, 0) / 1024 / 1024) free_mb,
100 - round((nvl(b.bytes_free, 0) / a.bytes_alloc) * 100) Pct_used
from ( select f.tablespace_name,
sum(f.bytes) bytes_alloc,
sum(decode(f.autoextensible, 'YES',f.maxbytes,'NO', f.bytes)) maxbytes
from dba_data_files f
group by tablespace_name) a,
(
select ts.name tablespace_name, sum(fs.blocks) * ts.blocksize bytes_free
from DBA_LMT_FREE_SPACE fs, sys.ts$ ts
where ts.ts# = fs.tablespace_id
group by ts.name, ts.blocksize ) b,
dba_tablespaces c
where a.tablespace_name = b.tablespace_name (+)
and a.tablespace_name = c.tablespace_name
union all
select h.tablespace_name,
round(sum(h.bytes_free + h.bytes_used) / 1048576) total_mb,
round(sum(nvl(p.bytes_used, 0))/ 1048576) used_mb,
round(sum((h.bytes_free + h.bytes_used) - nvl(p.bytes_used, 0)) / 1048576) free_mb,
100 - round((sum((h.bytes_free + h.bytes_used) - nvl(p.bytes_used, 0)) / sum(h.bytes_used + h.bytes_free)) * 100) pct_used
from (SELECT DISTINCT * FROM SYS.V_$TEMP_SPACE_HEADER) h,
(select tablespace_name, file_id, sum(bytes_used) bytes_used
from (SELECT DISTINCT * FROM SYS.GV_$TEMP_EXTENT_POOL)
group by tablespace_name, file_id) p,
dba_temp_files f,
dba_tablespaces c
where p.file_id(+) = h.file_id
and p.tablespace_name(+) = h.tablespace_name
and f.file_id = h.file_id
and f.tablespace_name = h.tablespace_name
and f.tablespace_name = c.tablespace_name
group by h.tablespace_name
ORDER BY 5 desc
/
ttitle off
