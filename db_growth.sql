set pagesize 50000
tti "Database growth per month for last year"

select to_char(creation_time, 'RRRR Month') "Month",
       sum(bytes)/1024/1024 "Growth in Meg"
  from sys.v_$datafile
 where creation_time > SYSDATE-365
 group by to_char(creation_time, 'RRRR Month')
/

tti off
