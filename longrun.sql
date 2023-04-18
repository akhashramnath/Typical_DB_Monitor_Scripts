set line 200
set pagesize 500
col PROGRAM_NAME format a30
col concreq format a8
col Username format a10
col opid format a4
col dbuser format a6
SELECT SUBSTR(LTRIM(req.request_id),1,15) concreq,
                   fcp.USER_CONCURRENT_PROGRAM_NAME "Program_Name",
                fu.user_name "Username",
               round((sysdate - actual_start_date) * 24 ,2) "Running_Hrs",
               SUBSTR(proc.os_process_id,1,15) clproc,
               SUBSTR(LTRIM(proc.oracle_process_id),1,15) opid,
        --       SUBSTR(look.meaning,1,10) reqph,
        --       SUBSTR(look1.meaning,1,10) reqst,
               SUBSTR(vsess.username,1,10) dbuser,
               SUBSTR(vproc.spid,1,10) svrproc,
               vsess.sid sid,
               vsess.serial# serial#
        FROM   fnd_concurrent_requests req,
               fnd_concurrent_processes proc,
               fnd_lookups look,
               fnd_lookups look1,
               v$process vproc,
               v$session vsess,
                   fnd_concurrent_programs_vl fcp,
                fnd_user fu
        WHERE  req.controlling_manager = proc.concurrent_process_id(+)
        AND    req.status_code = look.lookup_code
        AND    look.lookup_type = 'CP_STATUS_CODE'
        AND    req.phase_code = look1.lookup_code
        AND    look1.lookup_type = 'CP_PHASE_CODE'
        AND    look1.meaning = 'Running'
        and    req.CONCURRENT_PROGRAM_ID = fcp.CONCURRENT_PROGRAM_ID
        AND    proc.oracle_process_id = vproc.pid(+)
        AND    req.status_code='R'
        AND    vproc.addr = vsess.paddr(+)
        AND    fu.user_id = req.requested_by
        AND    round((sysdate - actual_start_date) * 24) > 1;
