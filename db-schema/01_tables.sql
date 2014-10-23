PROMPT Creating Table 'USERS'
CREATE TABLE developer.USERS
(user_id NUMBER(8,0)
,first_name VARCHAR2(50)
,last_name VARCHAR2(50)
,nick VARCHAR2(20)
,email VARCHAR2(50)
,street_address VARCHAR2(50)
,zip_code VARCHAR2(5)
,password_hash VARCHAR2(140)
,password_salt VARCHAR2(8)
)
/

PROMPT Creating Table 'Stores'
CREATE TABLE developer.STORES
(store_id NUMBER(3,0)
,name VARCHAR2(25)
,website VARCHAR2(50)
,street_address VARCHAR2(50)
,zip_code VARCHAR2(5)
,created_by NUMBER(8,0)
,created_date TIMESTAMP(6)
,modified_by NUMBER(8,0)
,modified_date TIMESTAMP(6)
)
/

PROMPT Creating Table 'Zip_Codes'
CREATE TABLE developer.ZIP_CODES
(zip_code VARCHAR2(5)
,city VARCHAR2(25)
,country VARCHAR2(20)
)
/

PROMPT Creating Table 'Products'
CREATE TABLE developer.PRODUCTS
(product_id NUMBER(8,0)
,name VARCHAR2(50)
,description VARCHAR2(2000)
,created_by NUMBER(8,0)
,created_date TIMESTAMP(6)
,modified_by NUMBER(8,0)
,modified_date TIMESTAMP(6)
)
/

PROMPT Creating Table 'Features'
CREATE TABLE developer.FEATURES
(feature_id NUMBER(8,0)
,feature_type VARCHAR(25)
,feature_name VARCHAR2(25)
,created_by NUMBER(8,0)
,created_date TIMESTAMP(6)
,modified_by NUMBER(8,0)
,modified_date TIMESTAMP(6)
)
/

PROMPT Creating Table 'Reviews'
CREATE TABLE developer.REVIEWS
(review_id NUMBER(6,0)
,product_id NUMBER
,user_id NUMBER
,review_txt VARCHAR2(2000)
,rating NUMBER(2,0)
,created_date TIMESTAMP(6)
)
/

PROMPT Creating Table 'Product_Features'
CREATE TABLE developer.PRODUCT_FEATURES
(prod_feat_id NUMBER
,product_id NUMBER
,feature_id NUMBER
)
/

PROMPT Creatig Table 'Offers'
CREATE TABLE developer.OFFERS
(offer_id NUMBER(9,0)
,store_id NUMBER(3,0)
,auction_id NUMBER(7,0)
,offer_date TIMESTAMP(6)
,offer VARCHAR2(2000)
,price NUMBER(10,2)
)
/

PROMPT Creating Table 'Auctions'
CREATE TABLE developer.AUCTIONS
(auction_id NUMBER(7,0)
,user_id NUMBER(8,0)
,product_id NUMBER(8,0)
,message VARCHAR2(2000)
,start_date TIMESTAMP
,end_date TIMESTAMP
,auction_status VARCHAR2(10)
)
/

PROMPT Creating Table 'Store_Products'
CREATE TABLE developer.STORE_PRODUCTS
(store_product_id NUMBER(7,0)
,product_id NUMBER
,store_id NUMBER
,price NUMBER(10,2)
)
/

PROMPT Creating Table 'User_Watched_Products'
CREATE TABLE developer.USER_WATCHED_PRODUCTS
(user_id NUMBER
,store_product_id NUMBER
,watched_id NUMBER(10,0)
,user_watch_prod_date TIMESTAMP
,product_id NUMBER(8,0)
)
/

PROMPT Creating Table 'Black_Lists'
CREATE TABLE developer.BLACK_LISTS
(black_list_id NUMBER(8,0)
,user_id NUMBER(8,0)
,created_date TIMESTAMP
)
/

PROMPT Creating Table 'Black_List_Stores'
CREATE TABLE developer.BLACK_LIST_STORES
(black_list_store_id NUMBER(9,0)
,black_list_id NUMBER(8,0)
,store_id NUMBER
)
/

PROMPT Creating Table 'Price_List'
CREATE TABLE developer.PRICE_LIST
(price_list_id NUMBER(10,0)
,store_product_id NUMBER
,price_old NUMBER(10,2)
,price_new NUMBER(10,2)
,datetime TIMESTAMP(6)
)
/

PROMPT Creating Table 'Worker_Tasks'
CREATE TABLE developer.WORKER_TASKS
(worker_task_id NUMBER
,event_type VARCHAR2(40)
,event_desc xmltype
,event_timestamp TIMESTAMP(6)
)
/

Create Table developer.WORKER_TASKS_HIST
(worker_task_hist_id NUMBER
,event_type VARCHAR2(40)
,event_desc xmltype
,event_timestamp TIMESTAMP(6)
,processed_timestamp TIMESTAMP(6)
)
/

PROMPT Creating Table 'Product_Photos'
CREATE TABLE developer.PRODUCT_PHOTOS
(product_photo_id NUMBER(10,0)
,product_id NUMBER(8,0)
,photo_id NUMBER(10,0)
)
/

PROMPT Creating Table 'Photos'
CREATE TABLE developer.PHOTOS
(photo_id NUMBER(10,0)
,photo_type VARCHAR2(3)
,photo_path VARCHAR2(200)
)
/

PROMPT Creating Table 'Store_Produtc_Photos'
CREATE TABLE developer.STORE_PRODUCT_PHOTOS
(store_prod_photo_id NUMBER(10,0)
,store_id NUMBER(3,0)
,photo_id NUMBER(10,0)
)
/
 
PROMPT CREATING TABLE 'ADMINS'
CREATE TABLE developer.ADMINS
(admin_id NUMBER(3,0)
,nick VARCHAR2(50)
,first_name VARCHAR2(50)
,last_name VARCHAR2(50)
,email VARCHAR2(50)
,password_hash VARCHAR2(140)
,password_salt VARCHAR2(40)
)
/

PROMPT CREATING TABLE 'STORE_USERS'
CREATE TABLE developer.STORE_USERS
(store_user_id NUMBER(3,0)
,nick VARCHAR2(50)
,first_name VARCHAR2(50)
,last_name VARCHAR2(50)
,email VARCHAR2(50)
,store_id NUMBER(3,0)
,password_hash VARCHAR2(140)
,password_salt VARCHAR2(40)
)
/

PROMPT CREATING TABLE 'ADMIN_ALERTS'
CREATE TABLE developer.ADMIN_ALERTS
(admin_alert_id NUMBER(10,0)
,message VARCHAR2(250)
,alert_time TIMESTAMP(6)
);
/

PROMPT CREATING TABLE 'DELETE_PROD'
CREATE GLOBAL TEMPORARY TABLE delete_prod
(product_id NUMBER(8,0)
,name VARCHAR2(50)
,description VARCHAR2(2000))
ON COMMIT DELETE ROWS;
/

PROMPT CREATING TABLE 'DELETE_FEAT'
CREATE GLOBAL TEMPORARY TABLE delete_feat
(feature_id NUMBER(8,0)
,feature_type VARCHAR(25)
,feature_name VARCHAR2(25))
ON COMMIT DELETE ROWS;
/

PROMPT CREATING TABLE 'DELETE_PROD_FEAT'
CREATE GLOBAL TEMPORARY TABLE delete_prod_feat
(prod_feat_id NUMBER
,product_id NUMBER
,feature_id NUMBER)
ON COMMIT DELETE ROWS;
/

CREATE TABLE MESSAGES
(message_id NUMBER(10,0)
,from_user NUMBER(8,0)
,message VARCHAR2(4000)
)
/

CREATE TABLE USER_MESSAGE
(message_id NUMBER(10,0)
,to_user NUMBER(8,0)
,sent_date TIMESTAMP
)
/

*/
CREATE TABLE TICKET_U_A
(ticket_ua_id NUMBER(10,0)
,user_id NUMBER(8,0)
,admin_id NUMBER(3,0)
,datetime TIMESTAMP(6)
,message VARCHAR2(4000)
)
/

CREATE TABLE TICKET_U_A_REPLY
(ticket_ua_id NUMBER(10,0)
,reply_id NUMBER(10,0)
)
/

CREATE TABLE REPLIES
(reply_id NUMBER(10,0)
,message VARCHAR2(4000)
,datetime TIMESTAMP(6)
,is_creator NUMBER(1)
)
/

CREATE TABLE TICKET_U_S_REPLY
(ticket_us_id NUMBER(10,0)
,reply_id NUMBER(10,0)
)
/

CREATE TABLE TICKET_U_S
(ticket_us_id NUMBER(10,0)
,user_id NUMBER(8,0)
,store_id NUMBER(3,0)
,datetime TIMESTAMP(6)
,message VARCHAR2(4000)
)
/

CREATE TABLE TICKET_S_A_REPLY
(ticket_sa_id NUMBER(10,0)
,reply_id NUMBER(10,0)
)
/

CREATE TABLE TICKET_S_A
(ticket_sa_id NUMBER(10,0)
,admin_id NUMBER(3,0)
,store_id NUMBER(3,0)
,datetime TIMESTAMP(6)
,message VARCHAR2(4000)
)
/

/* Created by Julia Osiak, PJWSTK 2014, Bachelor of Science Thesis */