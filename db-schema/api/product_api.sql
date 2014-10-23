
CREATE OR REPLACE PACKAGE product_api AS
	PROCEDURE new_product(a_name VARCHAR2, a_description VARCHAR2);
	PROCEDURE delete_product(a_name varchar2);
	FUNCTION get_newest_prod(a_prod_id out NUMBER) RETURN NUMBER;
END product_api;
/

CREATE OR REPLACE PACKAGE BODY product_api AS
	
	PROCEDURE new_product(a_name VARCHAR2, a_description VARCHAR2) IS
		product_count NUMBER;
		existing_product EXCEPTION;
		BEGIN
		
		SELECT COUNT(*) INTO product_count
		FROM developer.products
		WHERE name = a_name;
		
		IF (product_count != 0) THEN
			DBMS_OUTPUT.PUT_LINE('THIS PRODUCT ALREADY EXISTS');
			RAISE existing_product;
		ELSE
		
		INSERT INTO developer.products (product_id, name, description, created_by, created_date, modified_by, modified_date)
		VALUES(product_id_seq.nextval, a_name, a_description, user, current_timestamp, user, current_timestamp);
		
		END IF;
		COMMIT;
		
		EXCEPTION 
			WHEN existing_product THEN
			DBMS_OUTPUT.PUT_LINE('THIS PRODUCT ALREADY EXISTS');
				
	END new_product;
	
	PROCEDURE delete_product(a_name VARCHAR2) AS
		a_product_id NUMBER := 0;
		product_doesnt_exist EXCEPTION;
		BEGIN
			SELECT product_id INTO a_product_id
			FROM products
			where UPPER(name) = a_name;
			
			IF (a_product_id =0) THEN
				RAISE product_doesnt_exist;
			ELSE
				DELETE FROM PRODUCTS WHERE product_id = a_product_id;
				DBMS_OUTPUT.PUT_LINE('PRODUCT HAS BEEN DELETED');
			END IF;
	
		COMMIT;
		
		EXCEPTION 
      WHEN product_doesnt_exist THEN
      	DBMS_OUTPUT.PUT_LINE('PRODUCT DOESNT EXIST');
   
	END delete_product;

	FUNCTION get_newest_prod(a_prod_id out NUMBER) RETURN NUMBER
	IS
		a_product_refcurs SYS_REFCURSOR;
		a_product NUMBER;
		BEGIN
  
		  OPEN a_product_refcurs FOR 
			SELECT product_id FROM developer.products
			ORDER BY created_date DESC;
		  LOOP
			FETCH a_product_refcurs INTO a_product;
			EXIT WHEN (a_product_refcurs%ROWCOUNT >1);
		  CLOSE a_product_refcurs;
		  END LOOP;
		  RETURN a_product;
	END get_newest_prod;

END product_api;
/