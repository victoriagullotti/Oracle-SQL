-- To enable output, we need to execute the following command
SET SERVEROUTPUT ON

-- Variables are declared in the declarative section of the block and 
-- can be used for temporary storage of data, manipulation of stored values, etc
DECLARE
    v_location  VARCHAR2(15) NOT NULL := 'London';
    v_firstname VARCHAR(20);
    v_hiredate  DATE;
    v_empno     NUMBER(3) NOT NULL    := 100;
    c_salary    CONSTANT NUMBER       := 10000;
    v_valid     BOOLEAN NOT NULL      := TRUE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_firstname ||
                         ', Employee ID: ' || v_empno ||
                         ', Location: '    || v_location ||
                         ', Hire Date: '   || v_hiredate ||
                         ', Salary: '      || c_salary);

-- Assign new values to variables in the executable sction of the block
    v_firstname := 'Vargas';
    v_hiredate  := sysdate;
    v_empno     := 99;

    DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_firstname ||
                         ', Employee ID: ' || v_empno ||
                         ', Location: '    || v_location ||
                         ', Hire Date: '   || v_hiredate ||
                         ', Salary: '      || c_salary);             
END;
/

-- CONSTANT constrains variable so that its value cannot be changed
-- The following code will fail with the error:
-- PLS-00363: expression 'C_SALARY' cannot be used as an assignment target
DECLARE
    c_salary CONSTANT NUMBER := 10000;
BEGIN

c_salary     := 20000;
                    
END;
/

-- %TYPE Attribute is used to set variable's type according to 
-- a database column definition or another declared variable
DECLARE
    v_firstname employees.first_name%TYPE;
    v_lastname v_firstname%TYPE := 'Biden';
BEGIN
    DBMS_OUTPUT.PUT_LINE('Employee Name: '        || v_firstname ||
                         ', Employee Last Name: ' || v_lastname);
    SELECT first_name, last_name INTO v_firstname, v_lastname FROM employees WHERE employee_id=100;
    DBMS_OUTPUT.PUT_LINE('Employee Name: '        || v_firstname ||
                         ', Employee Last Name: ' || v_lastname);
END;
/

-- Composite Data Types: Records and Collections (List and Arrays)
-- We need to create an employee table copy for the Record variable demonstration
CREATE TABLE emp AS
SELECT   
  *
FROM
  employees;

-- Remember hire_date value for the employee_id=124;
SELECT * FROM emp WHERE employee_id = 124;
-- An example for Records

DECLARE
  emp_rec employees%ROWTYPE;
BEGIN
  SELECT * INTO emp_rec FROM employees WHERE employee_id = 124;
  emp_rec.hire_date := SYSDATE;
  UPDATE EMP SET ROW = emp_rec WHERE employee_id = 124;
END;
/

SELECT * FROM emp WHERE employee_id = 124;
drop table emp cascade constraints;

DECLARE
  TYPE Foursome IS VARRAY(4) OF VARCHAR2(15);  -- VARRAY type
 
  -- varray variable initialized with constructor:
 
  team Foursome := Foursome('John', 'Mary', 'Alberto', 'Juanita');
 
  PROCEDURE print_team (heading VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(heading);
 
    FOR i IN 1..4 LOOP
      DBMS_OUTPUT.PUT_LINE(i || '.' || team(i));
    END LOOP;
 
    DBMS_OUTPUT.PUT_LINE('---'); 
  END;
  
BEGIN 
  print_team('2001 Team:');
 
  team(3) := 'Pierre';  -- Change values of two elements
  team(4) := 'Yvonne';
  print_team('2005 Team:');
 
  -- Invoke constructor to assign new values to varray variable:
 
  team := Foursome('Arun', 'Amitha', 'Allan', 'Mae');
  print_team('2009 Team:');
END;
/
-- BIND or HOST variables
-- The next block should be run via CLOUD SHELL ( it doesn't work SQLDeveloper! )
-- Please use instructions from previous lesson to review your memory on how to connect to ATP via Cloud Shell

VARIABLE b_emp_salary NUMBER;

BEGIN
    SELECT salary INTO :b_emp_salary FROM employees WHERE employee_id=100;
END;
/

PRINT b_emp_salary;

SELECT
    first_name, last_name
FROM
    employees
WHERE
    salary=:b_emp_salary;
    


