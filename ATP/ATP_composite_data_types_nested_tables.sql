-- To enable output, we need to execute the following command
SET SERVEROUTPUT ON

-- An example of Nested Table
-- We also use here COUNT collection method, which
-- returns the number of elements present in the collection
DECLARE
    TYPE subject IS TABLE OF VARCHAR(15); 
    TYPE teacher IS TABLE OF VARCHAR2(20);
    subjectnames subject; 
    subjectteacher teacher; 
    summ integer; 
BEGIN
 
    -- adding subject and its teachers to the table by using a constructor
    subjectnames := subject('Oracle', 'MySQL', 'REDIS'); 
    subjectteacher:= teacher('Larry', 'Oleksiy', 'Salvatore');
 
    -- returns count of number of elements in nested table
    summ:= subjectteacher.count;
 
    -- printing the content to the console
    dbms_output.put_line('Total Number of Teachers: '|| summ); 
    FOR i IN 1 .. summ LOOP 
         dbms_output.put_line('Subject: '||subjectnames(i)||', Teacher: ' || subjectteacher(i)); 
    end loop; 
END;
/


-- HOME ASSIGNMENT
-- Create a nested table that holds department names. Create elements in it, with departments as values
-- Run a loop to print out the content of the nested table
DECLARE
    -- declare nested table
    TYPE department_type IS TABLE OF departments.department_name%TYPE;
    deps department_type;
BEGIN
    -- initialize nested table
    deps := department_type('Administration','Marketing','IT','Construction','Operation');
    FOR i in 1..deps.count() LOOP
        DBMS_OUTPUT.PUT_LINE(deps(i));
    END LOOP;
END;
/