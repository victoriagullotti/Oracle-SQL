/*
CREATE [OR REPLACE] TRIGGER trigger_name
{BEFORE | AFTER } triggering_event ON table_name
[FOR EACH ROW]
[FOLLOWS | PRECEDES another_trigger]
[ENABLE / DISABLE ]
[WHEN condition]
DECLARE
    declaration statements
BEGIN
    executable statements
EXCEPTION
    exception_handling statements
END;
*/

--1. Create table
CREATE TABLE words (
    word_id   NUMBER
        GENERATED BY DEFAULT AS IDENTITY
    PRIMARY KEY,
    word_name VARCHAR(100) NOT NULL
);

--2. Fill with data
INSERT INTO words ( word_name ) VALUES ( 'Hello' );

INSERT INTO words ( word_name ) VALUES ( 'Hi' );

INSERT INTO words ( word_name ) VALUES ( 'Home' );

SELECT
    *
FROM
    words;

COMMIT;

--2. Creating audit table
CREATE TABLE word_audit (
    table_name VARCHAR2(100),
    tr_name    VARCHAR2(100),
    by_user    VARCHAR2(30),
    tr_date    DATE,
    word_id    NUMBER,
    old        VARCHAR2(100),
    new        VARCHAR2(100)
);


--3. New trigger
CREATE OR REPLACE TRIGGER mytrg AFTER
    insert or UPDATE OR DELETE ON words
    FOR EACH ROW
DECLARE
    l_transaction VARCHAR2(10);
BEGIN
--Determine tracsaction type
    
    l_transaction :=
        CASE
            WHEN UPDATING THEN
                'UPDATE'
            WHEN DELETING THEN
                'DELETE'
        END;
    INSERT INTO word_audit VALUES (
        'WORDS',
        l_transaction,
        user,
        sysdate,
        :old.word_id,
        :old.word_name,
        :new.word_name
    );

END;
/          --!!!! Dont forget / symbol

--4. Make changes in words table  and see new line in audit table
UPDATE words
SET
    word_name = 'New'
WHERE
    word_id = 1;

COMMIT;

SELECT
    *
FROM
    word_audit;

SELECT
    *
FROM
    words;