-- To enable output, we need to execute the following command
SET SERVEROUTPUT ON

-- Varrays In PL/SQL
-- You can define a varray type at the schema level or within a PL/SQL declaration section.
DECLARE
   -- Varray Variables Declaration And Initialization
   type countrynames IS VARRAY(3) OF VARCHAR2(50); 
   type currency IS VARRAY(3) OF VARCHAR2(15);
   country countrynames; 
   cur currency; 
   addition integer; 
BEGIN
 
   -- adding country and its currency to the table
   country := countrynames('INDIA', 'USA', 'UK', 'FR'); 
   cur:= currency('INR', 'DOLLAR', 'POUND');
 
   -- returns count of number of countries in varray 
   addition := country.count;
 
   -- printing the content to the console 
   dbms_output.put_line('Total Number of countries : '|| addition); 
   FOR i in 1 .. addition LOOP 
       dbms_output.put_line('Country: ' || country(i) || 
' ,Currency : ' || cur(i)); 
   END LOOP; 
END; 
/

 
-- This one is created at the schema level and can have no more than 10 elements.
CREATE OR REPLACE TYPE list_of_names_t IS VARRAY(10) OF VARCHAR2 (100);
/
-- You can use EXTEND collection method to make room in the varray for new elements,
DECLARE
   happyfamily   list_of_names_t := list_of_names_t (); 
BEGIN  
   happyfamily.EXTEND(4);  
   happyfamily (1) := 'Ostap';  
   happyfamily (2) := 'Oleksiy';  
   happyfamily (3) := 'Volodymir';  
   happyfamily (4) := 'Olena';  
     
   FOR l_row IN 1 .. happyfamily.COUNT  
   LOOP  
      DBMS_OUTPUT.put_line (happyfamily (l_row));  
   END LOOP;  
END; 
/

-- Varrays always have consecutive subscripts, 
-- so you cannot delete individual elements except from the end by using the TRIM method. 
-- You can use DELETE without parameters to delete all elements. So this block fails.
DECLARE  
   happyfamily   list_of_names_t := list_of_names_t ();  
BEGIN  
   happyfamily.EXTEND(4);  
   happyfamily (1) := 'Ostap';  
   happyfamily (2) := 'Oleksiy';  
   happyfamily (3) := 'Volodymir';  
   happyfamily (4) := 'Olena';  
     
   happyfamily.delete(2);  
END; 
/

-- You can apply SQL query logic to the contents a varray using the TABLE operator.
DECLARE  
   happyfamily   list_of_names_t := list_of_names_t ();  
 BEGIN  
   happyfamily.EXTEND (4);  
   happyfamily (1) := 'Ostap';  
   happyfamily (2) := 'Oleksiy';  
   happyfamily (3) := 'Volodymir';  
   happyfamily (4) := 'Olena';
    
   /* Use TABLE operator to apply SQL operations to  
      a PL/SQL VARRAY */  
  
   FOR rec IN (  SELECT COLUMN_VALUE family_name FROM TABLE(happyfamily) ORDER BY family_name )  
   LOOP  
      DBMS_OUTPUT.put_line(rec.family_name);  
   END LOOP;  
END; 
/


-- You can define a column of varray type in a relational table. 
-- The next several steps demonstrate this.
CREATE OR REPLACE TYPE parent_names_t IS VARRAY (2) OF VARCHAR2 (100);
/
CREATE OR REPLACE TYPE child_names_t IS VARRAY (1) OF VARCHAR2 (100); 
/

CREATE TABLE family 
( 
   surname          VARCHAR2 (1000) 
 , parent_names     parent_names_t 
 , children_names   child_names_t 
);

-- Insert Varrays into Table
DECLARE  
   parents    parent_names_t := parent_names_t ();  
   children   child_names_t := child_names_t ();  
BEGIN  
   DBMS_OUTPUT.put_line (parents.LIMIT);  
     
   parents.EXTEND (2);  
   parents(1) := 'Samuel';  
   parents(2) := 'Charina';  
   --  
   children.EXTEND;  
   children (1) := 'Feather';  
  
   --  
   INSERT INTO family (surname, parent_names, children_names)  
        VALUES ('Assurty', parents, children);  
  
   COMMIT;  
END; 
/

SELECT * FROM family;

-- You can modify the limit of a varray, as demonstratex in this script.
CREATE OR REPLACE TYPE names_vat AS VARRAY (10) OF VARCHAR2 (80); 
/

DECLARE 
   l_list   names_vat := names_vat (); 
BEGIN 
   DBMS_OUTPUT.put_line ('Limit of names_vat = ' || l_list.LIMIT); 
END; 
/

ALTER TYPE names_vat MODIFY LIMIT 100 INVALIDATE;
/

DECLARE 
   l_list   names_vat := names_vat (); 
BEGIN 
   DBMS_OUTPUT.put_line ('Limit of names_vat = ' || l_list.LIMIT); 
END; 
/

--Modify Limit on Existing Varray with Dynamic SQL
BEGIN 
   EXECUTE IMMEDIATE 'ALTER TYPE names_vat MODIFY LIMIT 200 INVALIDATE'; 
END; 
/

DECLARE 
   l_list   names_vat := names_vat (); 
BEGIN 
   DBMS_OUTPUT.put_line ('Limit of names_vat = ' || l_list.LIMIT); 
END;
/











drop table family cascade constraints;
drop type names_vat;