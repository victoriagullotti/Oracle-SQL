-- To enable output, we need to execute the following command
SET SERVEROUTPUT ON

DECLARE
    v_today DATE :=SYSDATE;
    v_tomorrow v_today%TYPE;
    v_my_monthly_sal NUMBER (9,2) := 9000;
    v_my_annual_sal v_my_monthly_sal%TYPE;
    v_my_annual_sel_size INTEGER(5);
    v_my_total_sal v_my_monthly_sal%TYPE;
    v_my_hire_date DATE  := TO_DATE('02/07/2002', 'DD/MM/YYYY');
    v_my_total_months NUMBER(6);
BEGIN
    -- To get tomorrow's date we need to add 1 day to today's date
    v_tomorrow:=v_today +1;
    /* To compute the annual salary,
       we need to multiply monthly salary by 12 */
    v_my_annual_sal := v_my_monthly_sal * 12;
    /* To get the length of the v_my_annual_sal number,
       we can use SQL functions */ 
    v_my_annual_sel_size := LENGTH(v_my_annual_sal);
    -- To get the number of months an employee has worked:
    v_my_total_months := MONTHS_BETWEEN ( CURRENT_DATE, v_my_hire_date);
    -- To compute the salary for the whole employment period:
    v_my_total_sal :=  v_my_monthly_sal * v_my_total_months;
    DBMS_OUTPUT.PUT_LINE('Today is : '              || v_today ||
                         ' and tomorrow will be : ' || v_tomorrow
                        );
    DBMS_OUTPUT.PUT_LINE('My monthly salary is : '  || v_my_monthly_sal ||
                         '$ My annual income is : ' || v_my_annual_sal  ||
                         '$, it has '               || v_my_annual_sel_size ||
                         ' digits '
                         );   
    DBMS_OUTPUT.PUT_LINE('I have been with the company for the: '  || v_my_total_months ||
                         ' months and earned: '                    || v_my_total_sal    ||
                         '$'
                         );
END;
/

-- NLS_DATE_FORMAT specifies the default date format
select * from nls_session_parameters where parameter = 'NLS_DATE_FORMAT';

-- Data Type Conversion
DECLARE
    -- Implicit data type conversion
    v_my_salary         VARCHAR(20)  := '9000';
    -- Explicit data type conversion
    v_my_salary_number  NUMBER(6)    := TO_NUMBER(v_my_salary,'9999');
    -- Implicit data type conversion    
    v_my_hire_date1     DATE         := '02-Jul-2002';
    -- Explicit data type conversion
    v_my_hire_date2     DATE         := TO_DATE('02/07/2002', 'DD/MM/YYYY');
    -- Error in data type conversion
    v_my_hire_date3     DATE         := 'July-02-2002';
    -- Explicit data type conversion
    v_my_hire_date_char VARCHAR(20)  := TO_CHAR(v_my_hire_date2, 'DD/MM/YYYY');    
BEGIN
    DBMS_OUTPUT.PUT_LINE('v_my_salary_number : '        || TO_NUMBER(v_my_salary,'9999'));
    DBMS_OUTPUT.PUT_LINE('v_my_hire_date_date : '       || v_my_hire_date2);
    DBMS_OUTPUT.PUT_LINE('v_my_hire_date_char : '       || TO_CHAR(v_my_hire_date2, 'DD/MM/YYYY'));
    DBMS_OUTPUT.PUT_LINE('v_my_hire_date_timestamp : '  || TO_TIMESTAMP(v_my_hire_date2, 'YYYY/MM/DD HH:MI:SS'));
END;
/

-- SELECT statements in PL/SQL
DECLARE
    v_firstname VARCHAR2(20);
    v_lastname  VARCHAR2(25);
    v_employee_id employees.employee_id%TYPE :=100;
BEGIN
    SELECT first_name, last_name INTO v_firstname, v_lastname FROM employees WHERE employee_id=v_employee_id;
    DBMS_OUTPUT.PUT_LINE('Employee First Name: '  || v_firstname);
    DBMS_OUTPUT.PUT_LINE('Employee Last Name: '   || v_lastname);
END;
/

-- INSERT statements in PL/SQL
BEGIN
    INSERT INTO employees
        (employee_id, first_name, last_name, email, hire_date, job_id, department_id, salary)
    VALUES
        (employees_seq.NEXTVAL, 'Phoebe', 'Buffay', 'phoebe@gmail.com', CURRENT_DATE, 'SH_CLERK', 50, 5000);
END;
/
SELECT * FROM employees WHERE last_name = 'Buffay';

-- UPDATE statement in PL/SQL
DECLARE
    v_sal_increase employees.salary%TYPE :=1000;
BEGIN
    UPDATE employees SET salary = salary + v_sal_increase WHERE job_id = 'IT_PROG';
END;
/

-- DELETE statement in PL/SQL
DECLARE
    v_lastname employees.last_name%TYPE := 'Buffay';
BEGIN
    DELETE FROM employees WHERE last_name = v_lastname;
END;
/
SELECT * FROM employees WHERE last_name = 'Buffay';
commit;

-- Nested Blocks
DECLARE
    v_outer_variable VARCHAR2(20) := 'GLOBAL VARIABLE';
BEGIN
    DECLARE
        v_inner_variable VARCHAR(20) := 'LOCAL VARIABLE';
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Inner Block, v_outer_variable: ' || v_outer_variable);
        DBMS_OUTPUT.PUT_LINE('Inner Block, v_inner_variable: ' || v_inner_variable);
    END;
    DBMS_OUTPUT.PUT_LINE('Outer Block, v_outer_variable: ' || v_outer_variable);
    -- If we uncoment below line, we get an error:
    -- PLS-00201: identifier 'V_INNER_VARIABLE' must be declared
    -- DBMS_OUTPUT.PUT_LINE('Outer Block, v_inner_variable: ' || v_inner_variable);
END;
/