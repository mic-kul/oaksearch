create or replace package worker_tasks_delete_pkg
    as
        type array is table of worker_tasks%rowtype index by binary_integer;
  
		oldvals    array;
        empty    array;
    end;
/ 

create or replace trigger worker_tasks_delete_bd
    before delete on worker_tasks
    begin
        worker_tasks_delete_pkg.oldvals := worker_tasks_delete_pkg.empty;
    end;
/ 

 create or replace trigger worker_tasks_bdfer
    before delete on worker_tasks
    for each row
    declare
        i    number default worker_tasks_delete_pkg.oldvals.count+1;
	begin
        worker_tasks_delete_pkg.oldvals(i).event_type := :old.event_type;
        worker_tasks_delete_pkg.oldvals(i).event_desc := :old.event_desc;
		worker_tasks_delete_pkg.oldvals(i).worker_task_id := :old.worker_task_id;
		worker_tasks_delete_pkg.oldvals(i).event_timestamp := :old.event_timestamp;
		
   end;
/ 

create or replace trigger worker_tasks_ad
    after delete on worker_tasks
    begin
		for i in 1 .. worker_tasks_delete_pkg.oldvals.count loop
				
				INSERT INTO developer.worker_tasks_hist (worker_task_hist_id, event_type, event_desc, event_timestamp, processed_timestamp)
				VALUES (worker_tasks_delete_pkg.oldvals(i).worker_task_id, 
						worker_tasks_delete_pkg.oldvals(i).event_type,
						worker_tasks_delete_pkg.oldvals(i).event_desc, 
						worker_tasks_delete_pkg.oldvals(i).event_timestamp,
						current_timestamp);
       end loop;
 
  end;
/ 