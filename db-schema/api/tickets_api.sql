
CREATE OR REPLACE PACKAGE ticket_api AS
	PROCEDURE new_user_ticket(a_user NUMBER, a_category NUMBER, a_topic VARCHAR2, a_content VARCHAR2);
	PROCEDURE delete_user_ticket(a_user_ticket_id NUMBER);
	PROCEDURE new_store_ticket(a_store INTEGER, a_category INTEGER, a_topic VARCHAR2, a_content VARCHAR2);
	PROCEDURE delete_store_ticket(a_store_ticket_id number);
	PROCEDURE change_user_ticket_status(a_ticket_id NUMBER, a_status NUMBER);
END ticket_api;
/

CREATE OR REPLACE PACKAGE BODY ticket_api AS
	
	PROCEDURE new_user_ticket(a_user NUMBER, a_category NUMBER, a_topic VARCHAR2, a_content VARCHAR2) AS
		existing_ticket EXCEPTION;
    ticket_count NUMBER;
    existing_ticket_exception EXCEPTION;
		BEGIN
			
		SELECT COUNT(*) INTO ticket_count
		FROM DEVELOPER.USER_TICKETS
		WHERE USER_ID = a_user
		AND TICKET_TOPIC= a_topic;
    
		IF (ticket_count > 0) THEN
			RAISE existing_ticket_exception;
		Else
		
		INSERT INTO developer.user_tickets (USER_TICKET_ID, TICKET_CATEGORY_ID, USER_ID, TICKET_TOPIC, TICKET_CONTENT, ticket_status, ticket_date) 
		VALUES(user_ticket_id_seq.nextval, a_category, a_user, a_topic, a_content, '1', current_timestamp );
    
		end if;
	COMMIT;
		EXCEPTION 
    WHEN existing_ticket_exception THEN
			DBMS_OUTPUT.PUT_LINE('THIS TICKET ALREADY EXISTS');

		
	END new_user_ticket;
	
	PROCEDURE delete_user_ticket(a_user_ticket_id NUMBER) AS
		a_id NUMBER;
		ticket_doesnt_exist_expt EXCEPTION;
		BEGIN
			SELECT COUNT(*) INTO a_id
			FROM products
			where  user_ticket_id = a_user_ticket_id;
			
			IF (a_id =0) THEN
				RAISE ticket_doesnt_exist_expt;
			ELSE
				DELETE FROM DEVELOPER.USER_TICKETS WHERE user_ticket_id = a_user_ticket_id;
				DBMS_OUTPUT.PUT_LINE('TICKET HAS BEEN DELETED');
			END IF;
			COMMIT;
			
		EXCEPTION 
      WHEN ticket_doesnt_exist_expt THEN
      	DBMS_OUTPUT.PUT_LINE('TICKET DOESNT EXIST');
      
	END delete_user_ticket;


	PROCEDURE new_store_ticket(a_store INTEGER, a_category INTEGER, a_topic VARCHAR2, a_content VARCHAR2) AS
		existing_ticket EXCEPTION;
		ticket_count NUMBER;
    
		BEGIN
		
		INSERT INTO developer.store_tickets (STORE_TICKET_ID, TICKET_CATEGORY_ID, STORE_ID, TICKET_TOPIC, TICKET_CONTENT) 
      VALUES(store_ticket_id_seq.next, a_category, a_store, a_topic, a_content);
		
		SELECT COUNT(*) INTO ticket_count
    FROM DEVELOPER.STORE_TICKETS
    WHERE TICKET_STATUS_ID = a_status
    AND STORE_ID = a_store
    AND TICKET_TOPIC= a_atopic;
    
    IF (ticket_count =>2)
    THEN
      RAISE existing_ticket_exception;
    END IF;
    
	COMMIT;
		EXCEPTION 
    WHEN existing_ticket_exception THEN
			DBMS_OUTPUT.PUT_LINE('THIS TICKET ALREADY EXISTS');
      ROLLBACK;
		
	END new_store_ticket;
  
  PROCEDURE delete_store_ticket(a_store_ticket_id NUMBER) AS
		a_id NUMBER;
		ticket_doesnt_exist_expt EXCEPTION;
		
		BEGIN
			SELECT COUNT(*) INTO a_id
			FROM products
			where  store_ticket_id = a_store_ticket_id;
			
			IF (a_id =0) THEN
				RAISE ticket_doesnt_exist_expt;
			ELSE
				DELETE FROM DEVELOPER.STORE_TICKETS WHERE store_ticket_id = a_store_ticket_id;
				DBMS_OUTPUT.PUT_LINE('TICKET HAS BEEN DELETED');
			END IF;
	 COMMIT;
		EXCEPTION 
      WHEN ticket_doesnt_exist_expt THEN
      	DBMS_OUTPUT.PUT_LINE('TICKET DOESNT EXIST');
      

	END delete_store_ticket;

	
	PROCEDURE change_user_ticket_status(a_ticket_id NUMBER, a_status NUMBER) IS
		a_count NUMBER := 0; 
		no_ticket EXCEPTION;
		BEGIN
			SELECT COUNT(*) into a_count
			FROM user_tickets
			where user_ticket_id = a_ticket_id;
			
			if (a_count = 0) then
				raise no_ticket;
			ELSE
				update user_tickets set ticket_status = a_status
				where user_ticket_id = a_ticket_id;
			end if;
			commit;
			
			exception
			when no_ticket then
					DBMS_OUTPUT.PUT_LINE('TICKET DOESNT EXIST');
					
		END change_user_ticket_status;
		
		
END ticket_api;
/

/* Created by Julia Osiak, PJWSTK 2014, Bachelor of Science Thesis */