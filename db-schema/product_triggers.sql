
create or replace package product_pkg
    as
            type ridArray is table of rowid index by binary_integer;
  
            newRows ridArray;
            empty   ridArray;
    end;
/ 

 create or replace trigger product_bi
    before insert or update on products
    begin
            product_pkg.newRows := product_pkg.empty;
    end;
/

create or replace trigger product_aifer
    after insert or update of name, description on products for each row
    begin
            product_pkg.newRows( product_pkg.newRows.count+1 ) := :new.rowid;
    end;
/  

create or replace trigger product_ai
    after insert or update of name, description on products
	declare
	a_prod_cursor sys_refcursor;
	json_return xmltype;
    begin
            for i in 1 .. product_pkg.newRows.count 
			loop
                    open a_prod_cursor for
                    select * from products 
					where rowid = product_pkg.newRows(i);
					
					json_return := ref_cursor_to_json(a_prod_cursor);
				if (updating) then
					INSERT INTO developer.worker_tasks
					VALUES (worker_task_id_seq.NEXTVAL, 'product_mod', json_return, current_timestamp );
					
				end if;
				if (inserting) then
					INSERT INTO developer.worker_tasks
					VALUES (worker_task_id_seq.NEXTVAL, 'product_add', json_return, current_timestamp );
				end if;
            end loop;
    end;
/ 
------------------------------------------------------------
create or replace package product_delete_pkg
    as
        type array is table of products%rowtype index by binary_integer;
  
       oldvals    array;
        empty    array;
    end;
/ 

create or replace trigger product_bd
    before delete on products
    begin
        product_delete_pkg.oldvals := product_delete_pkg.empty;
    end;
/ 

 create or replace trigger product_bdfer
    before delete on products
    for each row
    declare
        i    number default product_delete_pkg.oldvals.count+1;
		a_prod_cursor sys_refcursor;
	json_return xmltype;
    begin
        product_delete_pkg.oldvals(i).name := :old.name;
        product_delete_pkg.oldvals(i).description := :old.description;
		product_delete_pkg.oldvals(i).product_id := :old.product_id;
	
   end;
/ 

create or replace trigger product_ad
    after delete on products
  declare
  	a_prod_cursor sys_refcursor;
	json_return xmltype;
    begin
		for i in 1 .. product_delete_pkg.oldvals.count loop
			insert into delete_prod ( name, description, product_id )
			values
			( product_delete_pkg.oldvals(i).name, product_delete_pkg.oldvals(i).description,
			product_delete_pkg.oldvals(i).product_id ); 
		end loop;
		for i in 1 .. product_delete_pkg.oldvals.count loop
		     open a_prod_cursor for
                select * from delete_prod 
				where product_id = product_delete_pkg.oldvals(i).product_id;
					
				json_return := ref_cursor_to_json(a_prod_cursor);
	
				INSERT INTO developer.worker_tasks
				VALUES (worker_task_id_seq.NEXTVAL, 'product_delete', json_return, current_timestamp );
       end loop;
  end;
/ 
*/
----------------
create or replace trigger product_new_features
	after insert or update on products
	for each row
	declare
	a_count NUMBER;
	a_feat_id NUMBER;
	begin
		a_count := 0;
		
		select count(*) into a_count
		from features
		where upper(feature_name) = upper(:new.name);
		
		if (a_count = 0) then
			if(inserting) then
			
				a_feat_id := feature_id_seq.nextval;
				
				insert into features(feature_id, feature_type, feature_name, created_date)
				values (a_feat_id, '_name', :new.name, current_timestamp);
				
				insert into product_features(prod_feat_id, product_id, feature_id)
				values (product_feature_id_seq.nextval, :new.product_id, a_feat_id);
				
			end if;
			
			if(updating) then
				if(:new.name != :old.name) then
					insert into features(feature_id, feature_type, feature_name, created_date)
					values (feature_id_seq.nextval, '_name', :new.name, current_timestamp);
				end if;
			end if;
		end if;
	end product_new_features;
/

/* Created by Julia Osiak, PJWSTK 2014, Bachelor of Science Thesis */