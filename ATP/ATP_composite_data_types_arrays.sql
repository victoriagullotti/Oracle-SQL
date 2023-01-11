-- To enable output, we need to execute the following command
SET SERVEROUTPUT ON

-- Associative Array ( INDEX BY Tables )
-- In this example we declare:
-- 1. A table data type "type_aa_table" by using INDEX BY option
-- 2. A "aa_fruits" associative array of that data type
DECLARE
    TYPE type_aa_table
    IS
        TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
    aa_fruits type_aa_table;
BEGIN
  -- This is how we access values in the Associative Array
  aa_fruits(0):='APPLE';
  aa_fruits(1):='BANANA';
  aa_fruits(2) :='MANGO';
  aa_fruits(3) :='KIWI';
  aa_fruits(4) :='LIME';
  DBMS_OUTPUT.PUT_LINE(aa_fruits(0));
  DBMS_OUTPUT.PUT_LINE(aa_fruits(1));
  DBMS_OUTPUT.PUT_LINE(aa_fruits(2));
  DBMS_OUTPUT.PUT_LINE(aa_fruits(3));
  DBMS_OUTPUT.PUT_LINE(aa_fruits(4));
END;
/

-- Let's enhance our example by using FOR loop ( not to repeat DBMS_OUTPUT commands )
-- We also use here FIRST and LAST INDEX BY Table Methods
DECLARE
    TYPE type_aa_table
    IS
        TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
    aa_fruits type_aa_table;
BEGIN
  aa_fruits(0):='APPLE';
  aa_fruits(1):='BANANA';
  aa_fruits(2) :='MANGO';
  aa_fruits(3) :='KIWI';
  aa_fruits(4) :='LIME';
  FOR loop_aa IN aa_fruits.FIRST..aa_fruits.LAST
  LOOP
    DBMS_OUTPUT.PUT_LINE(aa_fruits(loop_aa));
  END LOOP loop_aa;
END;
/

-- Array keys do not have to be sequential, and can be both positive and negative
-- Pay attention that because of the gaps in the index the bellow code fails
-- with the NO_DATA_FOUND error right at the index [-4] 
DECLARE
    TYPE type_aa_table
    IS
        TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
    aa_fruits type_aa_table;
BEGIN
  aa_fruits(-5):='APPLE';
  aa_fruits(-3):='BANANA';
  aa_fruits(0) :='MANGO';
  aa_fruits(3) :='KIWI';
  aa_fruits(4) :='LIME';

  FOR loop_aa IN aa_fruits.FIRST..aa_fruits.LAST
  LOOP
    DBMS_OUTPUT.PUT_LINE(aa_fruits(loop_aa));
  END LOOP loop_aa;
END;
/

-- Let's fix the above issue by using EXISTS INDEX BY Table Method
DECLARE
    TYPE type_aa_table
    IS
        TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
    aa_fruits type_aa_table;
BEGIN
  aa_fruits(-5):='APPLE';
  aa_fruits(-3):='BANANA';
  aa_fruits(0) :='MANGO';
  aa_fruits(3) :='KIWI';
  aa_fruits(4) :='LIME';
  FOR loop_aa IN aa_fruits.FIRST..aa_fruits.LAST
  LOOP
    IF aa_fruits.EXISTS(loop_aa) THEN
        DBMS_OUTPUT.PUT_LINE(aa_fruits(loop_aa));
    END IF;
    END LOOP loop_aa;
END;
/

SELECT * FROM job_history WHERE employee_id=203;

-- Creating and Accessing Associative Arrays
-- One more example with retiring employee_id=203
DECLARE
    TYPE type_aa_hiredate_table
    IS
        TABLE OF job_history.end_date%TYPE INDEX BY PLS_INTEGER;
    
    aa_end_date type_aa_hiredate_table;
    v_emp_id NUMBER;
    v_start_date job_history.start_date%TYPE;
    v_job_id job_history.job_id%TYPE;
    v_department_id job_history.department_id%TYPE;
BEGIN
    aa_end_date(1) := SYSDATE + 14;
    IF aa_end_date.EXISTS(1) THEN
        SELECT employee_id,hire_date,job_id,department_id INTO v_emp_id,v_start_date,v_job_id,v_department_id FROM employees WHERE employee_id=203;
        INSERT INTO job_history (employee_id,start_date,end_date,job_id,department_id) values(v_emp_id,v_start_date,aa_end_date(1),v_job_id,v_department_id);
    END IF;
END;
/

SELECT * FROM job_history WHERE employee_id=203;
rollback;

-- Declare an associative array to hold an entire row from a table
DECLARE
    TYPE type_aa_dept_table
    IS
        TABLE OF departments%ROWTYPE INDEX BY VARCHAR2(20);
    aa_dept type_aa_dept_table;
BEGIN
    SELECT * INTO aa_dept(1) FROM departments WHERE department_id=40;
    DBMS_OUTPUT.PUT_LINE(aa_dept(1).department_id);
    DBMS_OUTPUT.PUT_LINE(aa_dept(1).department_name);
    DBMS_OUTPUT.PUT_LINE(aa_dept(1).manager_id);
    DBMS_OUTPUT.PUT_LINE(aa_dept(1).location_id);
END;
/

-- Associative Array and FOR Loop
-- If you want to loop by an increment other than one (like in this example with departments table), 
-- you will have to do so programmatically as 
-- the FOR loop will only increment the index by one
DECLARE
    TYPE type_aa_dept_table
    IS
        TABLE OF departments%ROWTYPE INDEX BY PLS_INTEGER;
    aa_dept type_aa_dept_table;
BEGIN
    DBMS_OUTPUT.PUT_LINE('1st Loop');
    FOR d_id IN 10..100
    LOOP
        CONTINUE WHEN MOD(d_id,10) != 0;
        SELECT * INTO aa_dept(d_id) FROM departments WHERE department_id = d_id;
        DBMS_OUTPUT.PUT_LINE('department_id: '    || aa_dept(d_id).department_id ||
                             ' department_name: ' || aa_dept(d_id).department_name);  
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('2nd Loop');
    FOR i IN aa_dept.FIRST..aa_dept.LAST
    LOOP
        IF aa_dept.exists(i) THEN
        DBMS_OUTPUT.PUT_LINE('department_id: '    || aa_dept(i).department_id ||
                             ' department_name: ' || aa_dept(i).department_name);
        END IF;
    END LOOP;
END;
/

-- An example of the Associative Array with VARCHAR2 Key Column
DECLARE
    TYPE type_aa_country_tab 
    IS 
        TABLE OF VARCHAR2(50) INDEX BY VARCHAR2(5);
    aa_country type_aa_country_tab;
BEGIN
-- Populate lookup
aa_country('UK') := 'United Kingdom';
aa_country('US') := 'United States of America';
aa_country('FR') := 'France';
aa_country('DE') := 'Germany';

-- Find country name for ISO code
DBMS_OUTPUT.PUT_LINE('A country name for the provided ISO code : ' || aa_country(upper('&cc')));
END;
/

-- HOME ASSIGNMENT

-- Please review the next example. It introduces another Pl/SQL  built-in method under collection
-- NEXT(m)	Gives the index that succeeds mth index
DECLARE
    TYPE type_aa_age IS TABLE OF NUMBER INDEX BY VARCHAR(25); 
    aa_age_empl type_aa_age; 
    employee VARCHAR(25); 
BEGIN
 
    -- adding employee details to the table
    aa_age_empl('Oleksiy') := 20; 
    aa_age_empl('Olena') := 27; 
 
    -- printing the table contents in the console
    employee := aa_age_empl.FIRST; 
    WHILE employee IS NOT NULL LOOP 
         dbms_output.put_line 
         ('Employee name is ' || employee || ' and age is ' || TO_CHAR(aa_age_empl(employee))); 
         employee := aa_age_empl.NEXT(employee); 
     END LOOP; 
END; 
/

-- Please review another way of iteration through the departments table
DECLARE
    -- Here we declare an INDEX BY table and variables
    TYPE type_aa_dept_table IS TABLE OF departments%ROWTYPE INDEX BY PLS_INTEGER;
    aa_dept_table type_aa_dept_table;
    v_loop_count NUMBER(2) :=10;
    v_deptno NUMBER(4) :=0;
BEGIN
    -- Using a loop, we retrieve information of 10 departments 
    -- and store it in the associative array, and then retrieve it and print it
    FOR i IN 1..v_loop_count LOOP
        v_deptno:=v_deptno+10;
        SELECT * INTO aa_dept_table(i) FROM departments WHERE department_id = v_deptno;
        DBMS_OUTPUT.PUT_LINE('Department ID: '    || aa_dept_table(i).department_id ||
                             ' Department Name: ' || aa_dept_table(i).department_name);
    END LOOP;
END;
/