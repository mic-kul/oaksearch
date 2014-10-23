
CREATE OR REPLACE PACKAGE user_api AS
	PROCEDURE new_user(a_name VARCHAR2, a_last_name VARCHAR2, a_email varchar2,
					   a_nick varchar2, a_zipcode varchar2, a_pass_hash varchar2, a_pass_salt varchar2);
	PROCEDURE delete_user(a_nick varchar2);
	FUNCTION last_mod_prod(a_nick IN varchar2) return number;
END user_api;
/

CREATE OR REPLACE PACKAGE BODY user_api AS
	PROCEDURE new_user(a_name VARCHAR2, a_last_name VARCHAR2, a_email varchar2, a_nick varchar2, a_zipcode varchar2, a_pass_hash varchar2, a_pass_salt varchar2) IS
		user_count NUMBER;
		existing_user EXCEPTION;
		BEGIN
		
		SELECT COUNT(*) INTO user_count
		FROM developer.users
		WHERE email = a_email;
		
		IF (user_count = 0) THEN
			DBMS_OUTPUT.PUT_LINE('THIS USER ALREADY EXISTS');
			RAISE existing_user;
		ELSE
		
		INSERT INTO developer.users(user_id, first_name, last_name, nick, email, street_address, zip_code, password_hash, password_salt)
		VALUES(user_id_seq.nextval, a_name, a_last_name, a_nick, a_email, null, a_zipcode, a_pass_hash, a_pass_salt );
		
		END IF;
		
		EXCEPTION WHEN existing_user THEN
			DBMS_OUTPUT.PUT_LINE('THIS USER ALREADY EXISTS');
		
		COMMIT;
	END new_user;
	
	PROCEDURE delete_user(a_nick VARCHAR2) AS
		a_user_id NUMBER := 0;
		user_doesnt_exist EXCEPTION;
		BEGIN
			SELECT user_id INTO a_user_id
			FROM developer.users
			where UPPER(nick) = a_nick;
			
			IF (a_user_id =0) THEN
				RAISE user_doesnt_exist;
			ELSE
				DELETE FROM USERS WHERE user_id = a_user_id;
				DBMS_OUTPUT.PUT_LINE('USER HAS BEEN DELETED');
			END IF;
		COMMIT;
		
		EXCEPTION WHEN user_doesnt_exist THEN
			DBMS_OUTPUT.PUT_LINE('USER DOESNT EXIST');
	END delete_user;
	
	FUNCTION last_mod_prod(a_nick IN VARCHAR2) RETURN NUMBER IS
		a_user_id NUMBER := 0;
		user_doesnt_exist EXCEPTION;
		a_prod_id NUMBER :=0;
		BEGIN
			SELECT store_user_id INTO a_user_id
			FROM developer.store_users
			where UPPER(store_user_nick) = UPPER(a_nick);
			
			IF (a_user_id =0) THEN
				RAISE user_doesnt_exist;
				
			ELSE
				Select product_id into a_prod_id
				from products
				where modified_by = a_user_id 
				and rownum = 1
				order by modified_date desc;
				
			return a_prod_id;
			
			end if;
			
		EXCEPTION WHEN user_doesnt_exist THEN
			DBMS_OUTPUT.PUT_LINE('USER DOESNT EXIST');
	END last_mod_prod;
	
END user_api;
/