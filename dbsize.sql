set serveroutput on
declare
  total_size_b number;
  free_size_b number;
  used_size_b number;
begin

  dbms_output.enable(100000);

  select Sum(bytes) into total_size_b
  from dba_data_files;

  select Sum(bytes) into free_size_b
  from dba_free_space;

  select Sum(bytes) into used_size_b
  from dba_segments;

  dbms_output.put_line('Total: ' || TO_CHAR(Round(total_size_b/1073741824, 2), '999,999,999.00') || ' GB');
  dbms_output.put_line('Free: ' || TO_CHAR(Round(free_size_b/1073741824, 2), '999,999.00') || ' GB');
  dbms_output.put_line('Used: ' || TO_CHAR(Round(used_size_b/1073741824, 2), '999,999,999.00') || ' GB');

end;

