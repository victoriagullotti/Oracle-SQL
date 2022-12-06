/**
CREATE SEQUENCE schema_name.sequence_name
[INCREMENT BY interval]
[START WITH first_number]
[MAXVALUE max_value | NOMAXVALUE]
[MINVALUE min_value | NOMINVALUE]
[CYCLE | NOCYCLE]
[CACHE cache_size | NOCACHE]
[ORDER | NOORDER];

https://www.oracletutorial.com/oracle-sequence/oracle-create-sequence/ 
**/

--10, 20, 30, ...100, 10
CREATE SEQUENCE tensequence MINVALUE 10 INCREMENT BY 10 MAXVALUE 100 START WITH 10 CYCLE CACHE 2;

SELECT
    tensequence.NEXTVAL
FROM
    dual;

SELECT
    tensequence.CURRVAL
FROM
    dual;

DROP SEQUENCE tensequence;

--Using sequences
CREATE TABLE suppliers (
    sup_id   NUMBER PRIMARY KEY,
    sup_name VARCHAR2(255) NOT NULL
);

COMMIT;

--Empty sequence
CREATE SEQUENCE sup_id;

INSERT INTO suppliers VALUES ( sup_id.NEXTVAL, 'Name One ');
INSERT INTO suppliers VALUES ( sup_id.NEXTVAL, 'Name Two');
INSERT INTO suppliers VALUES ( sup_id.NEXTVAL, 'Name Three');
INSERT INTO suppliers VALUES ( sup_id.NEXTVAL, 'Name Four');

SELECT
    *
FROM
    suppliers;

COMMIT;

--Using sequence via identity column
drop table suppliers;

CREATE TABLE suppliers (
    sup_id   NUMBER generated always as IDENTITY PRIMARY KEY,
    sup_name VARCHAR2(255) NOT NULL
);

INSERT INTO suppliers (sup_name) VALUES ( 'Name One ');
INSERT INTO suppliers (sup_name) VALUES ( 'Name Two');
INSERT INTO suppliers (sup_name) VALUES ( 'Name Three');
INSERT INTO suppliers (sup_name) VALUES ( 'Name Four');

commit;