/*Creating table supliers with automatically generated key*/
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

/*
1	Name One 
2	Name Two
3	Name Three
4	Name Four
*/