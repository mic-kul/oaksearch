CREATE user developer IDENTIFIED BY OmletteDuFromage
DEFAULT TABLESPACE DEV_TS
TEMPORARY TABLESPACE TEMP;

ALTER USER DEVELOPER QUOTA UNLIMITED ON DEV_TS;

GRANT connect, resource to developer;

CREATE ROLE developer_role;

grant create any index, 
	execute any procedure,
	insert any table,
	update any table,
	select any table to developer_role;