set lines 170
column object_name format a30
column owner       format a15
column las_ddl_time format a10
select object_name,owner,status,object_type,to_char(last_ddl_time,'DD-MON-YYYY:HH24:MI:SS'),created from dba_objects
where object_name like upper('%'|| '&1' || '%') order by 5 desc
/
