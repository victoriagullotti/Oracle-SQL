--grant create table to admin;
delete catalogl;
drop TABLE catalogl;
COMMIT;

--CREATE TABLES
create table catalog1 (id number(3), name varchar2(20), price number(6));
create table catalog2 (id number(3), name varchar2(20), price number(6));

insert into catalog1 VALUES (1, 'IPhone', 1986.00);
insert into catalog1 VALUES (2, 'HP Laptop', 1590.00);
insert into catalog1 VALUES (3, 'Apple Mac', 3200.00);
insert into catalog2 VALUES (1, 'IPhone', 2090.00);
insert into catalog2 VALUES (2, 'HP Laptop', 1690.00);
insert into catalog2 VALUES (5, 'Apple IPad', 790.00);

commit;

SELECT * from catalog1;
SELECT * from catalog2;


--MERGE TWO TABLES
--RESULT TABLE - TABLE 1
--Updating prices in catalog 1. If item does not exist, then inserting new item. 
merge into catalog1 c1
using catalog2 c2
on (c1.id = c2.id)
when matched then 
update set c1.price = c2.price
when not matched then
insert VALUES (c2.id, c2.name, c2.price);

SELECT * from catalog1;
SELECT * from catalog2;


ROLLBACK;

COMMIT;