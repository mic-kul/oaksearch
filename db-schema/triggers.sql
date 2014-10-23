CREATE OR REPLACE TRIGGER developer.storeprod_price_update_trig 
AFTER UPDATE OR INSERT ON DEVELOPER.STORE_PRODUCTS
FOR EACH ROW
	BEGIN
	if (:old.price != :new.price AND :old.price IS NOT NULL) then
	INSERT INTO developer.price_list
	VALUES(
	developer.price_history_id_seq.nextval, :old.product_id, :new.price, sysdate);
	end if;
	END;
/
