prompt
accept days prompt 'Enter no of days before:'
set verify off
set linesize 80
set pages 300
select to_char(first_time,'YYYY/MM/DD HH24') "Date - HOfDay",count(1) from V$LOG_HISTORY where  first_time > sysdate -&days 
group by to_char(first_time,'YYYY/MM/DD HH24') order by to_date(to_char(first_time,'YYYY/MM/DD HH24'),'YYYY/MM/DD HH24');

