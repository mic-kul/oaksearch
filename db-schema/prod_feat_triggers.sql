
create or replace package prod_feat_pkg
    as
            type ridArray is table of rowid index by binary_integer;
  
            newRows ridArray;
            empty   ridArray;
    end;
/ 

 create or replace trigger prod_feat_bi
    before insert or update on product_features
    begin
            prod_feat_pkg.newRows := prod_feat_pkg.empty;
    end;
/

create or replace trigger prod_feat_aifer
    after insert or update of product_id, feature_id on product_features for each row
    begin
            prod_feat_pkg.newRows( prod_feat_pkg.newRows.count+1 ) := :new.rowid;
    end;
/  

create or replace trigger prod_feat_ai
    after insert or update of product_id, feature_id on product_features
	declare
	a_prod_cursor sys_refcursor;
	json_return xmltype;
    begin
            for i in 1 .. prod_feat_pkg.newRows.count 
			loop
                    open a_prod_cursor for
                    select * from product_features 
					where rowid = prod_feat_pkg.newRows(i);
					
					json_return := ref_cursor_to_json(a_prod_cursor);
				if (updating) then
					INSERT INTO developer.worker_tasks
					VALUES (worker_task_id_seq.NEXTVAL, 'prod_feat_mod', json_return, current_timestamp );
				end if;
				if (inserting) then
					INSERT INTO developer.worker_tasks
					VALUES (worker_task_id_seq.NEXTVAL, 'prod_feat_add', json_return, current_timestamp );
				end if;
					
            end loop;
    end;
/ 

----------------------------------------------------------

create or replace package prod_feat_delete_pkg
    as
        type array is table of product_features%rowtype index by binary_integer;
  
       oldvals    array;
        empty    array;
    end;
/ 

create or replace trigger prod_feat_bd
    before delete on product_features
    begin
        prod_feat_delete_pkg.oldvals := prod_feat_delete_pkg.empty;
    end;
/ 

 create or replace trigger prod_feat_bdfer
    before delete on product_features
    for each row
    declare
       i    number default prod_feat_delete_pkg.oldvals.count+1;
	begin
        prod_feat_delete_pkg.oldvals(i).prod_feat_id:= :old.prod_feat_id;
        prod_feat_delete_pkg.oldvals(i).feature_id := :old.feature_id;
		prod_feat_delete_pkg.oldvals(i).product_id := :old.product_id;
		
		insert into delete_prod_feat ( prod_feat_id, product_id, feature_id )
				values
				( prod_feat_delete_pkg.oldvals(i).prod_feat_id, prod_feat_delete_pkg.oldvals(i).product_id,
				prod_feat_delete_pkg.oldvals(i).feature_id ); 
	
   end;
/ 

create or replace trigger prod_feat_ad
    after delete on product_features
  declare
  	a_prod_cursor sys_refcursor;
	json_return xmltype;
    begin
		for i in 1 .. prod_feat_delete_pkg.oldvals.count loop
		     open a_prod_cursor for
                select * from delete_prod_feat
				where prod_feat_id = prod_feat_delete_pkg.oldvals(i).prod_feat_id;
					
				json_return := ref_cursor_to_json(a_prod_cursor);
	
				INSERT INTO developer.worker_tasks
				VALUES (worker_task_id_seq.NEXTVAL, 'prod_feat_delete', json_return, current_timestamp );
       end loop;
  
  end;
/ 

/* Created by Julia Osiak, PJWSTK 2014, Bachelor of Science Thesis */	