select store_product_id, datetime, (price_new - price_old) "price_rise"
from price_list
where price_new - price_old > 0
order by store_product_id, datetime;

select store_product_id, datetime, (price_new - price_old) "price_drop"
from price_list
where price_new - price_old < 0
order by store_product_id, datetime;
/