select * from dba_objects;

--TYPES OF OBJECTS
select DISTINCT object_type FROM dba_objects;

--OBJECTS IN SPEC SCHEMA
select * from dba_objects o WHERE o.owner = 'SH';

--ALL TABLES
SELECT * FROM all_tables o WHERE o.owner = 'SH';

--ALL VIEWS
SELECT * FROM all_views;

--ALL USERS
SELECT * FROM all_users;

--ALL INDEXES
SELECT * FROM all_indexes o WHERE o.owner = 'SH';

--DESCRIBE - structure
describe all_tables;

--DDA - Generates the code to reconstruct the object
ddl sh.countrie;
