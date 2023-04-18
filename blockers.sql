set lines 300;
set pages 300;
SELECT DECODE(request,0,'Holder: ','Waiter:') || sid sess,inst_id,id1, id2, lmode, request, type
FROM gv$lock
WHERE (id1, id2, type) IN (
  SELECT id1, id2, type FROM gv$lock WHERE request>0)
ORDER BY id1, request;

