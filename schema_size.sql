set lines 120
col owner format a40
col bytes 999999999
select owner,sum(bytes)/1024/1024 "Size in MB" from dba_segments where owner = '&owner' group by owner;
