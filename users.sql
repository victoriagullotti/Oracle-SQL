/*Creating a new user, granting him access operations and table space*/

SELECT
    *
FROM
    all_users
WHERE
    username = 'HR';

CREATE USER hr IDENTIFIED BY "1Q2w3e4r_2022"; --Password

--Check avalable tablespace in the database
SELECT
    *
FROM
    dba_tablespaces;

SELECT
    *
FROM
    v$tablespace;

--Set up tablespace and unlimited quota
ALTER USER hr
    DEFAULT TABLESPACE data
    QUOTA UNLIMITED ON data;

ALTER USER hr
    TEMPORARY TABLESPACE temp;

--Grant the following permissions
GRANT
    CREATE SESSION,
    CREATE VIEW,
    ALTER SESSION,
    CREATE SEQUENCE
TO hr;

GRANT
    CREATE SYNONYM,
    CREATE DATABASE LINK, resource,
    UNLIMITED TABLESPACE
TO hr;

GRANT EXECUTE ON sys.dbms_stats TO hr;

--Test user
show user; --USER is "ADMIN" or USER is "HR"