create or replace package feature_pkg
    as
            type ridArray is table of rowid index by binary_integer;
  
            newRows ridArray;
            empty   ridArray;
    end;
/ 

 create or replace trigger feature_bi
    before insert or update on features
    begin
            feature_pkg.newRows := feature_pkg.empty;
    end;
/

create or replace trigger feature_aifer
    after insert or update of feature_type, feature_name on features for each row
    begin
            feature_pkg.newRows( feature_pkg.newRows.count+1 ) := :new.rowid;
    end;
/  

create or replace trigger feature_ai
    after insert or update of feature_type, feature_name on features
	declare
	a_prod_cursor sys_refcursor;
	json_return xmltype;
    begin
            for i in 1 .. feature_pkg.newRows.count 
			loop
                    open a_prod_cursor for
                    select * from features 
					where rowid = feature_pkg.newRows(i);
					
					json_return := ref_cursor_to_json(a_prod_cursor);
			if( updating ) then
					INSERT INTO developer.worker_tasks
					VALUES (worker_task_id_seq.NEXTVAL, 'feature_mod', json_return, current_timestamp );
			end if;
			if ( inserting) then
					INSERT INTO developer.worker_tasks
					VALUES (worker_task_id_seq.NEXTVAL, 'feature_add', json_return, current_timestamp );
			end if;
            end loop;
    end;
/ 

------------------------
create or replace package feature_delete_pkg
    as
        type array is table of features%rowtype index by binary_integer;
  
       oldvals    array;
        empty    array;
    end;
/ 

create or replace trigger feature_bd
    before delete on features
    begin
        feature_delete_pkg.oldvals := feature_delete_pkg.empty;
    end;
/ 

 create or replace trigger feature_bdfer
    before delete on features
    for each row
    declare
        i    number default feature_delete_pkg.oldvals.count+1;
		a_prod_cursor sys_refcursor;
	json_return xmltype;
    begin
        feature_delete_pkg.oldvals(i).feature_name := :old.feature_name;
        feature_delete_pkg.oldvals(i).feature_type := :old.feature_type;
		feature_delete_pkg.oldvals(i).feature_id := :old.feature_id;
		insert into delete_feat ( feature_name, feature_type, feature_id )
				values
				( feature_delete_pkg.oldvals(i).feature_name, feature_delete_pkg.oldvals(i).feature_type,
				feature_delete_pkg.oldvals(i).feature_id ); 
	
   end;
/ 

create or replace trigger feature_ad
    after delete on features
  declare
  	a_prod_cursor sys_refcursor;
	json_return xmltype;
    begin
		for i in 1 .. feature_delete_pkg.oldvals.count loop
		     open a_prod_cursor for
                select * from delete_feat 
				where feature_id = feature_delete_pkg.oldvals(i).feature_id;
					
				json_return := ref_cursor_to_json(a_prod_cursor);
	
				INSERT INTO developer.worker_tasks
				VALUES (worker_task_id_seq.NEXTVAL, 'feature_delete', json_return, current_timestamp );
       end loop;
 
  end;
/ 

/* Created by Julia Osiak, PJWSTK 2014, Bachelor of Science Thesis */