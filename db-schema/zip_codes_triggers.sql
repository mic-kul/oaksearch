CREATE OR REPLACE TRIGGER NEW_USER_ZIP_CODE_BI
BEFORE INSERT OR UPDATE ON USERS
FOR EACH ROW
declare
	a_count NUMBER;
	a_zip_code VARCHAR2(10);
begin
	a_count := 0;
	a_zip_code := :new.zip_code;
	
	select count(*) into a_count
	from zip_codes
	where zip_code = a_zip_code;
	
	if (a_count = 0) then
	
		if(inserting) then
			INSERT INTO ZIP_CODES(zip_code, city, country) 
			VALUES (:new.zip_code, 'UNKNOWN', 'UNKNOWN');
		end if;
		
		if(updating) then
			if(:old.zip_code != :new.zip_code) then
				INSERT INTO ZIP_CODES(zip_code, city, country) 
				VALUES (:new.zip_code, 'UNKNOWN', 'UNKNOWN');
			end if;
		end if;
		
		INSERT INTO ADMIN_ALERTS(ADMIN_ALERT_ID, MESSAGE, alert_time)
		VALUES (admin_alert_id_seq.nextval, 'new zip_code '||a_zip_code , current_timestamp);
		
	end if;

end new_user_zip_code_bi;
/

CREATE OR REPLACE TRIGGER NEW_STORE_ZIP_CODE_BI
BEFORE INSERT OR UPDATE ON STORES
FOR EACH ROW
declare
	a_count NUMBER;
	a_zip_code VARCHAR2(10);
begin
	a_count := 0;
	a_zip_code := :new.zip_code;
	
	select count(*) into a_count
	from zip_codes
	where zip_code = a_zip_code;
	
	if (a_count = 0) then
	
		if(inserting) then
			INSERT INTO ZIP_CODES(zip_code, city, country) 
			VALUES (:new.zip_code, 'UNKNOWN', 'UNKNOWN');
		end if;
		
		if(updating) then
			if(:old.zip_code != :new.zip_code) then
				INSERT INTO ZIP_CODES(zip_code, city, country) 
				VALUES (:new.zip_code, 'UNKNOWN', 'UNKNOWN');
			end if;
		end if;
		
		INSERT INTO ADMIN_ALERTS(ADMIN_ALERT_ID, MESSAGE, alert_time)
		VALUES (admin_alert_id_seq.nextval, 'new zip_code '||a_zip_code , current_timestamp);
		
	end if;

end new_store_zip_code_bi;
/

/* Created by Julia Osiak, PJWSTK 2014, Bachelor of Science Thesis */