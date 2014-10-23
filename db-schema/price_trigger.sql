create or replace package store_price_pkg
    as
            type ridArray is table of rowid index by binary_integer;
  
            newRows ridArray; 
            empty   ridArray;
			
			type array is table of store_products%rowtype index by binary_integer;
  
			oldvals    array;
			empty_old    array;
    end;
/ 

 create or replace trigger store_price_bi
    before insert or update on developer.store_products
    begin
		if(inserting) then
            store_price_pkg.newRows := store_price_pkg.empty;
		end if;
		if(updating) then
			store_price_pkg.oldvals := store_price_pkg.empty_old;
		end if;
    end;
/

create or replace trigger store_price_aifer
    after insert or update of price on store_products 
	for each row
	declare
		i    number default store_price_pkg.oldvals.count+1;
		j    number default store_price_pkg.oldvals.count+1;
    begin
		if(inserting) then
            store_price_pkg.newRows( store_price_pkg.newRows.count+1 ) := :new.rowid;
		end if;
		if(updating) then
			store_price_pkg.oldvals(j).price:= :old.price;
			store_price_pkg.oldvals(j).store_product_id  := :old.store_product_id;
		end if;
    end;
/  

create or replace trigger store_price_ai
    after insert or update of price on store_products
	declare
	v_price NUMBER;
	v_product_id NUMBER;
	v_count NUMBER;
    begin
		if(inserting) then
		
            for i in 1 .. store_price_pkg.newRows.count 
			loop
				select price, store_product_id into v_price, v_product_id
				from store_products
				where rowid = store_price_pkg.newRows(i);
				INSERT INTO developer.price_list (price_list_id, store_product_id, price_old, price_new, datetime)
				VALUES(
					developer.price_list_id_seq.nextval, v_product_id, 0, v_price , sysdate);
            end loop;
		end if;
		if (updating) then
		DBMS_OUTPUT.PUT_LINE( 'UPDATING');
			for i in 1 .. store_price_pkg.oldvals.count 
			loop
			
		        select price, store_product_id into v_price, v_product_id
				from store_products
				where store_product_id = store_price_pkg.oldvals(i).store_product_id;
			
					INSERT INTO developer.price_list (price_list_id, store_product_id, price_old, price_new, datetime)
					VALUES(
						developer.price_list_id_seq.nextval, v_product_id, store_price_pkg.oldvals(i).price, v_price , sysdate);
				
			end loop;
		end if;
    end;
/ 

/* Created by Julia Osiak, PJWSTK 2014, Bachelor of Science Thesis */