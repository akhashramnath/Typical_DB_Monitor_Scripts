set colsep ""
col "SGA POOLS"			for A25
col "MEMORY"			for A11	head ""
col "AVG"			for A6	head ""
col "#"				for A4  head ""
col "OTHER POOLS"		for A20 head ""
select 'SHARED POOL' "SGA POOLS",'-->'||SH_SZ||' M' "MEMORY",'' "AVG",
'' "#",'OTHER POOLS' "OTHER POOLS",'-->'||OP_SZ||' M' "MEMORY" from  
( select round(sum(BYTES)/1024/1024) SH_SZ 
	from v$sgastat where POOL ='shared pool'),
( select round(sum(BYTES)/1024/1024) OP_SZ 
	from v$sgastat where POOL !='shared pool' or POOL IS NULL)
UNION ALL
select '_________________________','___________','______',
       '','____________________','_________'
from DUAL
UNION ALL
----------------------------------------------------------------------
-- --SHARED_POOL ... Pick the 6 top mem allocations up :
----------------------------------------------------------------------
select SP.POOL,SP.SZ_,PCT,'|  |',B.POOL,B.SZ_ from
(select ROWNUM ROW_,POOL,PCT,
decode(sign(length(SIZE_)-7),1,round(SIZE_/1024/1024)||' M',
                                      '   '||round(SIZE_/1024)||' K' ) SZ_
 from ( select NAME POOL ,BYTES SIZE_ ,round(BYTES/SUM_*100)||'%' PCT
        from v$sgastat,
       ( select sum(BYTES) SUM_ from v$sgastat where POOL ='shared pool')      
        where POOL = 'shared pool' 
        order by 2 desc )  
where rownum < 7 ) SP,
----------------------------------------------------------------------
-- --OTHER POOLS--
----------------------------------------------------------------------
(select ROWNUM ROW_,POOL, 
       decode(sign(length(SIZE_)-7),1,round(SIZE_/1024/1024)||' M',
       '   '||round(SIZE_/1024)||' K' )  SZ_
       from 
             (select POOL,sum(bytes) SIZE_ from v$sgastat
              where POOL is not null
              and POOL not like '%shared%'
              group by POOL              UNION ALL 
              select NAME POOL, bytes from v$sgastat
              where POOL is  null )) B
WHERE SP.ROW_=B.ROW_ (+)
UNION ALL
select '_________________________','___________','______',
       '|  |','____________________','_________'
from DUAL
UNION ALL
----------------------------------------------------------------------
-- -- END OF THE SGA 
--
----------------------------------------------------------------------
select '','','','','','' from dual
UNION ALL
select '=========================','===========','======',
       '====','====================','=========' from dual
UNION ALL
select 'ALL UGAs AND PGAs','','','','','' from dual
UNION ALL
select 'UGA / PGA ...','MEMORY','AVG','','ESTIMATED MAX SIZE','' from dual
UNION ALL
select 	substr(a.name,9,10)||' ('||count(*)||' sessions)' "ALL UGAs AND PGAs",
	      round(sum(b.value) /1024/1024,1)||' M' "MEMORY_MB",
	decode(sign(length(round(sum(b.value)/count(*)))-7), 
			1,round(sum(b.value)/count(*)/1024/1024,1)||' M',
       			round(sum(b.value)/count(*)/1024)||' K' ) "AVG/SESSION",
	'',
        MX||' sessions (HWM)= ',
round(sum((b.value)* MX )/count(*)/1024/1024)||' M' 
from v$statname a, v$sesstat b,
(select max_utilization  MX from v$resource_limit 
        where resource_name = 'sessions')
where a.statistic# = b.statistic#
and   a.name like '%ga memory' 
group by a.name,MX 
UNION ALL
select '_________________________','___________','______',
       '____','____________________','_________'
from DUAL
;
prompt
set colsep " " 
set feed on
