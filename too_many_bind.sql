select * from (
select distinct sql_id, bind_count from (
select sql_id, child_number, count(*) bind_count from v$sql_bind_capture
group by sql_id, child_number
)
order by bind_count desc
)
where rownum < 50
/
