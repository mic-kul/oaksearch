
declare

a_count number := 0;
cursor c1 IS
	select name from products;

begin
	for pname in c1
	LOOP
		
		SELECT COUNT(*) into a_count FROM FEATURES
		WHERE feature_type = '_name'
		AND feature_name = pname.name;
		 
		if (a_count = 0) then
			insert into features(feature_id, feature_type, feature_name, created_date)
			values (feature_id_seq.nextval, '_name', pname.name, current_timestamp);
		end if;
		
		
	END LOOP;
END;
/
