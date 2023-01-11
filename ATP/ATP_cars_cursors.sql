-- To enable output, we need to execute the following command
SET SERVEROUTPUT ON

DECLARE
    CURSOR c_cars_cursor IS
    SELECT id,descr FROM car_names WHERE model='ford';
    v_id car_names.id%TYPE;
    v_descr car_names.descr%TYPE;
BEGIN
    OPEN c_cars_cursor;
    LOOP
        FETCH c_cars_cursor INTO v_id, v_descr;
        EXIT WHEN c_cars_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_id ||' : '||v_descr);
    END LOOP;
    CLOSE c_cars_cursor;
END;
/

SELECT id,descr FROM car_names WHERE model='ford';

-- Cursors and Records
DECLARE
    CURSOR c_cars_cursor IS
    SELECT id,model,descr FROM car_names WHERE model='ford';
    v_car_record c_cars_cursor%ROWTYPE;
BEGIN
    OPEN c_cars_cursor;
    LOOP
        FETCH c_cars_cursor INTO v_car_record;
        EXIT WHEN c_cars_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_car_record.id ||' : '||v_car_record.descr);
    END LOOP;
    CLOSE c_cars_cursor;
END;
/

-- Cursor FOR Loops
DECLARE
    CURSOR c_cars_cursor IS
    SELECT id,model,descr FROM car_names WHERE model='ford';
BEGIN
    FOR car_record IN c_cars_cursor
    LOOP
        DBMS_OUTPUT.PUT_LINE(car_record.id ||' : '||car_record.descr);
    END LOOP;
END;
/

-- Cursor FOR Loops Using Subqueries
BEGIN
    FOR car_record IN ( SELECT id,model,descr FROM car_names WHERE model='ford')
    LOOP
         DBMS_OUTPUT.PUT_LINE(car_record.id ||' : '||car_record.descr);
    END LOOP;
END;
/

-- %ROWCOUNT and %NOTFOUND Cursor Attributes
DECLARE
    CURSOR c_cars_cursor IS
    SELECT id,model,descr FROM car_names;
    v_car_record c_cars_cursor%ROWTYPE;
BEGIN
    OPEN c_cars_cursor;
    LOOP
        FETCH c_cars_cursor INTO v_car_record;
        EXIT WHEN c_cars_cursor%ROWCOUNT > 5 OR c_cars_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_car_record.id ||' : '||v_car_record.descr);
    END LOOP;
    CLOSE c_cars_cursor;
END;
/

-- Cursors with Parameters
-- You can define a cursor once, and use it in multiple places.
DECLARE 
   CURSOR c_cars_cursor (filter_model IN VARCHAR2) 
   IS 
        SELECT id,model,descr FROM car_names WHERE model = filter_model; 
   v_car_record c_cars_cursor%ROWTYPE; 
BEGIN 
   OPEN c_cars_cursor ('ford');
    LOOP
        FETCH c_cars_cursor INTO v_car_record;
        EXIT WHEN c_cars_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_car_record.id ||' : '||v_car_record.descr);
    END LOOP;
    CLOSE c_cars_cursor;
   DBMS_OUTPUT.PUT_LINE('Use same cursor a second time, avoiding copy-paste of SQL '); 
   OPEN c_cars_cursor ('subaru');
    LOOP
        FETCH c_cars_cursor INTO v_car_record;
        EXIT WHEN c_cars_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_car_record.id ||' : '||v_car_record.descr);
    END LOOP;
    CLOSE c_cars_cursor;
 
   DBMS_OUTPUT.PUT_LINE('Use the same cursor for the 3rd time. In the FOR loop'); 
   FOR rec IN c_cars_cursor ('volkswagen') 
   LOOP 
      DBMS_OUTPUT.PUT_LINE (rec.id ||' : '||rec.descr); 
   END LOOP; 
END;
/




-- HOME ASSIGNMENT
-- Please perform the following preparation steps:
-- To enable output, we need to execute the following command
SET SERVEROUTPUT ON

-- We need to create a table to hold on enangered species
CREATE TABLE endangered_species 
( 
   common_name    VARCHAR2 (100), 
   species_name   VARCHAR2 (100) 
);

-- Fill table with data
BEGIN
   /* https://www.worldwildlife.org/species/directory?direction=desc&sort=extinction_status */
   INSERT INTO endangered_species
        VALUES ('Amur Leopard', 'Panthera pardus orientalis');

   INSERT INTO endangered_species
        VALUES ('Hawksbill Turtle', 'Eretmochelys imbricata');

   INSERT INTO endangered_species
        VALUES ('Javan Rhino', 'Rhinoceros sondaicus');

   COMMIT;
END;
/

-- An example of the Implicit Cursors with SELECT INTO statement
DECLARE 
   l_common_name   endangered_species.common_name%TYPE; 
BEGIN 
   SELECT common_name INTO l_common_name FROM endangered_species WHERE species_name = 'Rhinoceros sondaicus'; 
   DBMS_OUTPUT.put_line (l_common_name); 
END;
/

-- 1. Create an Explicit Cursor "species_cur" and associate it with following SELECT statement:
-- "SELECT * FROM endangered_species WHERE species_name = 'Rhinoceros sondaicus'"
-- Then use open, fetch, and close commands to work with cursor and print common_name of the selected row. 
DECLARE 
   CURSOR species_cur IS SELECT * FROM endangered_species WHERE species_name = 'Rhinoceros sondaicus'; 
   l_species   species_cur%ROWTYPE; 
BEGIN 
   OPEN species_cur; 
   FETCH species_cur INTO l_species; 
   DBMS_OUTPUT.PUT_LINE(l_species.common_name);
   CLOSE species_cur; 
END;
/
-- FYI: Generally do not use explicit cursors for single row lookups; implicits are simpler and faster.


-- 2. Please review and understand how works the following example of cursor with parameters
--    You can define a cursor once, and use it in multiple places.
DECLARE 
   CURSOR species_cur (filter_in IN VARCHAR2) 
   IS 
        SELECT * FROM endangered_species WHERE species_name LIKE filter_in ORDER BY common_name; 
   l_species   species_cur%ROWTYPE; 
BEGIN
   DBMS_OUTPUT.PUT_LINE('### species_name like %u% ###');
   OPEN species_cur ('%u%');
   LOOP
        FETCH species_cur INTO l_species;
        EXIT WHEN species_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(l_species.species_name);
   END LOOP;
   CLOSE species_cur;
 
   /* Use same cursor a second time, avoiding copy-paste of SQL */ 
   DBMS_OUTPUT.PUT_LINE('### species_name like %e% ###');
   OPEN species_cur ('%e%');
   LOOP
        FETCH species_cur INTO l_species;
        EXIT WHEN species_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(l_species.species_name);
   END LOOP;
   CLOSE species_cur;
   /* I can even use it in a cursor FOR loop */ 
   DBMS_OUTPUT.PUT_LINE('### species_name like %o% ###');
   FOR rec IN species_cur ('%o%') 
   LOOP 
      DBMS_OUTPUT.PUT_LINE (rec.species_name); 
   END LOOP; 
END;
/