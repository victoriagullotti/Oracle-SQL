/*
DROP TABLE schema_name.table_name
[CASCADE CONSTRAINTS | PURGE];
*/
--Tables
SELECT
    *
FROM
    all_tables
WHERE
    table_name = 'COUNTRIES';

--Constraints
SELECT
    *
FROM
    all_constraints;

--Drop tables
DROP TABLE countries CASCADE CONSTRAINTS;

DROP TABLE locations CASCADE CONSTRAINTS;

--See the recyclebin
SELECT
    *
FROM
    recyclebin;

show recyclebin;

--Restoring table 
FLASHBACK TABLE countries TO BEFORE DROP;

--Purging
PURGE TABLE locations;

PURGE TABLE BIN$7keLIJmlTmvgUxcQAAq2Dg==$0; --New name inside the recyclebin

PURGE recyclebin;