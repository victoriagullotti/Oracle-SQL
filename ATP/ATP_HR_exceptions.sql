-- To enable output, we need to execute the following command
SET SERVEROUTPUT ON


-- Sometimes the code may cause unexpected errors at runtime.
-- PL/SQL treats all errors that occur in an anonymous block, procedure, or
-- function as exceptions. The exceptions can have different causes such as 
-- coding mistakes, bugs, even hardware failures.

-- An example of exception:
SELECT * FROM employees WHERE last_name='King';
SELECT * FROM employees WHERE last_name='Bardem';
DECLARE
    v_first_name VARCHAR2(30);
    v_last_name employees.last_name%TYPE := '&last_name';
BEGIN
    SELECT first_name INTO v_first_name FROM employees WHERE last_name=v_last_name;
    DBMS_OUTPUT.PUT_LINE('Employee first name: ' || v_first_name);
END;
/

-- The code that you write to handle exceptions is called an exception handler
DECLARE
    v_first_name VARCHAR2(30);
    v_last_name employees.last_name%TYPE := '&last_name';
BEGIN
    SELECT first_name INTO v_first_name FROM employees WHERE last_name=v_last_name;
    DBMS_OUTPUT.PUT_LINE('Employee first name: ' || v_first_name);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Employee with last name ' || v_last_name || ' does not exist');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('The table has more than one employee with last name ' || v_last_name);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unknown Error');
        
END;
/

-- Non-predefined exceptions are similar to predefined exceptions. However,
-- they are not defined as PL/SQL exceptions in the Oracle Server. They are
-- standard Oracle errors. To create an exception with standard Oracle error
-- you use a PRAGMA EXCEPTION_INIT function
-- 1. Let's determine error number for the operation by creating incorrect
-- INSERT statement ( department_name can't be NULL)
INSERT INTO departments(department_id, department_name) VALUES (280, NULL);
-- 2. Non-predefined error trapping example:
DECLARE
    e_insert_err EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_insert_err, -01400);
BEGIN
    INSERT INTO departments(department_id, department_name) VALUES (280, NULL);
EXCEPTION
    WHEN e_insert_err THEN
        DBMS_OUTPUT.PUT_LINE('INSERT operation has failed: ' || SQLERRM);
END;
/
    

-- In the above examples an exception is raised automatically by Oracle 
-- when an error occurs(ORA-01403, ORA-01422, etc...) These errors 
-- are converted into predefined exceptions. But sometimes, depending on the
-- business functionality of your application, you may want to explicitly
-- rise an exception. Let's do it
DECLARE
   x NUMBER:=&x; 
   y NUMBER:=&y;
   div_r FLOAT;
   exp1 EXCEPTION;
   exp2 EXCEPTION;
  
BEGIN
   IF y=0 THEN 
        RAISE exp1;
   ELSIF y > x THEN 
        RAISE exp2;
   ELSE
      div_r:= x / y;
      DBMS_OUTPUT.PUT_LINE('The result of ' || x || ' divided by ' || y || ' is '||div_r);
   END IF;
  
EXCEPTION
   WHEN exp1 THEN
      dbms_output.put_line('Error');
      dbms_output.put_line('division by zero not allowed');
  
   WHEN exp2 THEN
      dbms_output.put_line('Error');
      dbms_output.put_line('y is greater than x please check the input');
  
END;
/

-- Let's create a table where we will keep application errors 
CREATE TABLE myapp_errors
    ( e_user VARCHAR2(40) NOT NULL,
      e_date DATE DEFAULT SYSDATE,
      error_code NUMBER,
      error_message VARCHAR2(255) NOT NULL
    );
    
-- You can use SQLCODE and SQLERRM function to trap exception error code and message:
DECLARE
    r_employee employees%rowtype;
    error_code NUMBER;
    error_message VARCHAR(255);
BEGIN
--    SELECT * INTO r_employee FROM employees;
    SELECT * INTO r_employee FROM employees WHERE last_name='Bardem';
EXCEPTION
    WHEN OTHERS THEN
        error_code    := SQLCODE;
        error_message := SQLERRM;
        INSERT INTO myapp_errors (e_user, e_date,  error_code, error_message)
                          VALUES (USER,   SYSDATE, error_code, error_message);
        COMMIT;
END;
/
-- Let's check that failed execution has been stored in our table:
SELECT * FROM myapp_errors;


-- With RAISE_APPLICATION_ERROR procedure you can report errors to your application
-- RAISE_APPLICATION_ERROR(error_number,message);
-- error_number - Is a user-specified number for the exception between -20000 and -20999
-- message      - Is the user-specified message for the exception 
DECLARE
    v_employee_id job_history.employee_id%TYPE := '&employee_id';
    e_employee_id EXCEPTION;
BEGIN
    DELETE FROM job_history WHERE employee_id = v_employee_id;
    IF SQL%NOTFOUND THEN RAISE e_employee_id;
    END IF;

EXCEPTION
    WHEN e_employee_id THEN
        RAISE_APPLICATION_ERROR(-20001, 'No record in JOB_HISTORY table with such employee_id: ' || v_employee_id);
END;
/

-- HOME ASSIGNMENT


-- 1. The bellow provided code returns street_adrress from the LOCATIONS table for the provided country_code
-- It should be improved to include exception. If there is no location for the provided country code, 
-- handle the exception with an appropriate exception handler. 
-- If there are multiple locations for the provided country code, handle the 
-- exception with an appropriate exception handler. Handle any other not specified exception ( Use SQLERRM ).
-- Use the following country codes to test your program: BR, US, PL

SET SERVEROUTPUT ON
DECLARE
    v_street_address locations.street_address%TYPE;
    v_country_id locations.country_id%TYPE := '&last_name';
BEGIN
    SELECT street_address INTO v_street_address FROM locations WHERE country_id=v_country_id;
    DBMS_OUTPUT.PUT_LINE('Location street address is: ' || v_street_address);
END;
/

-- 2. Determine the error code you get on the DELETE attempt from the locations table
-- Write PL/SQL block that will handle this error and prints meaningfull message
DELETE FROM locations WHERE country_id='US';

-- SOLUTION:

-- 1. The bellow provided code returns street_adrress from the LOCATIONS table for the provided country_code
-- It should be improved to include exception. If there is no location for the provided country code, 
-- handle the exception with an appropriate exception handler. 
-- If there are multiple locations for the provided country code, handle the 
-- exception with an appropriate exception handler. Handle any other not specified exception ( Use SQLERRM ).
-- Use the following country codes to test your program: BR, US, PL

SET SERVEROUTPUT ON
DECLARE
    v_street_address locations.street_address%TYPE;
    v_country_id locations.country_id%TYPE := '&last_name';
BEGIN
    SELECT street_address INTO v_street_address FROM locations WHERE country_id=v_country_id;
    DBMS_OUTPUT.PUT_LINE('Location street address is: ' || v_street_address);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('There is no location for the: ' || v_country_id || ' country code');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('The LOCATIONS table has more than one location for the provided country code: ' || v_country_id);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unknown Error: ' || SQLERRM);
        
END;
/

-- 2. Determine the error code you get on the DELETE attempt from the locations table
-- Write PL/SQL block that will handle this error and prints meaningfull message

DECLARE
    e_child_record EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_child_record, -02292);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Deleting the locations...');
    DELETE FROM locations WHERE country_id='US';
    
    EXCEPTION
        WHEN e_child_record THEN
           DBMS_OUTPUT.PUT_LINE('Delete operation failed. There are child records in another table, that are referencing this location');
END;
/

