select 'exec DBMS_SHARED_POOL.PURGE ('''||address||','||hash_value||''', ''C'');' "Run the following" from v$sqlarea where sql_id='&a';
