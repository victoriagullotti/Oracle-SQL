-- To enable output, we need to execute the following command
SET SERVEROUTPUT ON

-- The following procedure will print employee contacts
-- It accepts employee_id as a parameter
CREATE OR REPLACE PROCEDURE print_econtacts
    ( in_employee_id NUMBER 
    )
IS
  r_employee employees%ROWTYPE;
BEGIN
  SELECT *  INTO r_employee FROM employees  WHERE employee_id = in_employee_id;

  -- print out contact's information
  DBMS_OUTPUT.PUT_LINE( r_employee.last_name || ' ' ||
                        r_employee.email     || ' ' || 
                        r_employee.phone_number );

EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE( SQLERRM );
END;
/

-- Executing a PL/SQL procedure
EXECUTE print_econtacts(101);


-- The next procedure adds a new country to the COUNTRIES table
CREATE PROCEDURE add_country
    (    in_country_id countries.country_id%TYPE
        ,in_country_name countries.country_name%TYPE
        ,in_region_id countries.region_id%TYPE
    )
IS
BEGIN
    INSERT INTO countries(country_id,country_name,region_id)
    VALUES(in_country_id,in_country_name,in_region_id);
    DBMS_OUTPUT.PUT_LINE('Inserted ' || SQL%ROWCOUNT || ' country ');
    
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE( SQLERRM );    
END;
/

-- Executing a PL/SQL procedure
EXECUTE add_country('UA','Ukraine',1);
rollback;

-- List procedures
SELECT *  FROM user_procedures WHERE object_type='PROCEDURE';
SELECT *  FROM all_procedures  WHERE object_type='PROCEDURE';
SELECT *  FROM dba_procedures  WHERE object_type='PROCEDURE';

-- To display stored procedure code:
SELECT text FROM all_source WHERE name='PRINT_ECONTACTS' ORDER BY line;

-- To drop a procedure:
DROP PROCEDURE print_econtacts;
DROP PROCEDURE add_country;

-- The next function will get employees work address
CREATE OR REPLACE FUNCTION get_work_address(in_employee_id IN NUMBER)
RETURN VARCHAR2
IS employee_details VARCHAR2(130);
BEGIN
 SELECT
    'Street: '  || l.street_address || ', city: '    || l.city || 
    ', state: ' || l.state_province || ', country: ' || l.country_id as work_address
 INTO employee_details
 FROM
    employees e
 INNER JOIN
    departments d on e.department_id=d.department_id
 INNER JOIN
    locations l on d.location_id=l.location_id
 WHERE
    e.employee_id=in_employee_id;
    
 RETURN(employee_details);
END get_work_address;
/

-- Calling a function
SELECT get_work_address(101) AS "Employee Work Address" FROM DUAL;

-- Calling a function
SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line(get_work_address(101));

-- The following function will calculate a monthly tax for an employee
CREATE OR REPLACE FUNCTION calculate_tax(in_employee_id IN NUMBER)
   RETURN NUMBER
   IS tax NUMBER(10,2);
BEGIN 
   tax := 0;
   SELECT salary*30/100 INTO tax FROM employees WHERE employee_id = in_employee_id;         
   RETURN tax;      
END calculate_tax;
/

-- Calling a function
SELECT
    first_name,
    last_name,
    salary gross_income,
    calculate_tax(101) AS tax
FROM
    employees
WHERE
    employee_id=101;
    
-- List functions
SELECT *  FROM user_procedures WHERE object_type='FUNCTION';
SELECT *  FROM all_procedures  WHERE object_type='FUNCTION';
SELECT *  FROM dba_procedures  WHERE object_type='FUNCTION';

-- To display stored function code:
SELECT text FROM all_source WHERE name='CALCULATE_TAX' ORDER BY line;

-- To drop a function:
DROP FUNCTION get_work_address;
DROP FUNCTION calculate_tax;

-- HOME ASSIGNMENT
-- 1. Write a procedure that allows HR user to create new departments 
--    An example of execution: EXECUTE add_dept(280,'University',205,1700);

-- 2.  Create a function to check whether a given string is palindrome or not.
--     A palindrome is a word, phrase, number, or other sequence of characters 
--     which reads the same backward as forward, such as madam or racecar.
--     https://en.wikipedia.org/wiki/Palindrome

-- 3. Create a "check_sal" function to determine if the salary of the provided employee
--    is greater than or less than the average salary of all employees working
--    in the same department. The function should return TRUE if the employee salary > Average department salary
--    Write anonymous block to call the function and process the result. The output should be like this:
--    Example1: Employee salary < Average department salary
--    Example2: Employee salary > Average department salary

-- 1. Write a procedure that allows HR user to create new departments 
--    An example of execution: EXECUTE add_dept(280,'University',205,1700);

CREATE PROCEDURE add_dept
    (    in_department_id departments.department_id%TYPE
        ,in_department_name departments.department_name%TYPE
        ,in_manager_id departments.manager_id%TYPE
        ,in_location_id departments.location_id%TYPE
    )
IS
BEGIN
    INSERT INTO departments(department_id,department_name,manager_id,location_id)
    VALUES(in_department_id,in_department_name,in_manager_id,in_location_id);
    DBMS_OUTPUT.PUT_LINE('Inserted ' || SQL%ROWCOUNT || ' department ');
    
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE( SQLERRM );    
END;
/

-- 2.  Create a function to check whether a given string is palindrome or not.
--     A palindrome is a word, phrase, number, or other sequence of characters 
--     which reads the same backward as forward, such as madam or racecar.
--     https://en.wikipedia.org/wiki/Palindrome

CREATE OR REPLACE FUNCTION checkForPalindrome(inputString VARCHAR2)
   RETURN VARCHAR2 
   IS result VARCHAR2(75);
   
   reversedString VARCHAR2(50); 
   BEGIN 
      SELECT REVERSE(inputString) INTO reversedString FROM DUAL;
            
      -- Using UPPER to ignore case sensitivity.
      IF UPPER(inputString) = UPPER(reversedString)
      THEN
         RETURN(inputString||' IS a palindrome.');
      END IF;
         RETURN (inputString||' IS NOT a palindrome.');
      
    END checkForPalindrome;
/

SELECT checkForPalindrome('Oracle') FROM DUAL;
SELECT checkForPalindrome('MAdam')  FROM DUAL;
SELECT checkForPalindrome('noon')   FROM DUAL;


-- 3. Create a "check_sal" function to determine if the salary of the provided employee
--    is greater than or less than the average salary of all employees working
--    in the same department. The function should return TRUE if the employee salary > Average department salary
--    Write anonymous block to call the function and process the result. The output should be like this:
--    Example1: Employee salary < Average department salary
--    Example2: Employee salary > Average department salary

CREATE FUNCTION check_sal(in_emp_no employees.employee_id%TYPE)
    RETURN Boolean 
    IS
    v_dept_id employees.department_id%TYPE;
    v_sal     employees.salary%TYPE;
    v_avg_sal employees.salary%TYPE;
BEGIN
    SELECT salary,department_id INTO v_sal,v_dept_id FROM employees WHERE employee_id = in_emp_no;
    SELECT AVG(salary) INTO v_avg_sal FROM employees WHERE department_id=v_dept_id;
    IF v_sal > v_avg_sal THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;

EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE( SQLERRM );    
END;
/ 

-- To enable output, we need to execute the following command
SET SERVEROUTPUT ON

-- Anonumours block:
DECLARE
    v_emp_no NUMBER(3) NOT NULL := 100;
BEGIN
    IF (check_sal(v_emp_no) IS NULL) THEN
        DBMS_OUTPUT.PUT_LINE( 'The function returned NULL due to EXCEPTION' );
    ELSIF (check_sal(v_emp_no)) THEN
        DBMS_OUTPUT.PUT_LINE( 'Employee salary > Average department salary' );
    ELSE
        DBMS_OUTPUT.PUT_LINE( 'Employee salary < Average department salary' );
    END IF;
END;
/

