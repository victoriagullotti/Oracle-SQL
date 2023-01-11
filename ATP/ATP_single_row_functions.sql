-- Single-Row functions are used to customise output

SELECT
    employee_id,
    last_name,
    department_id
FROM
    employees;

SELECT
    employee_id,
    last_name,
    department_id
FROM
    employees
WHERE
    last_name='chen';

-- Character functions
-- LOWER function converts value to lowercase
SELECT
    employee_id,
    last_name,
    department_id
FROM
    employees
WHERE
    LOWER(last_name) = LOWER('cHen');

-- UPPER function converts value touppercase    
SELECT
    employee_id,
    last_name,
    LOWER(last_name),
    UPPER(last_name)
FROM
    employees;

-- LENGTH function returns the number of characters
-- CONCAT function concatenates 2 columns
-- LPAD/RPAD functions return an expression left/right padded to the specified length, with specified characters
-- SUBSTR returns specified number of characters at specified position
-- INSTR returns the numeric position of a named string
SELECT
    employee_id,
    first_name,
    last_name,
    LENGTH(last_name),
    CONCAT(first_name,last_name),
    SUBSTR(last_name,1,3),
    SUBSTR(last_name,3,2),
    SUBSTR(last_name,3),
    INSTR(last_name, 'a'),
    LPAD(first_name,13,'*'),
    RPAD(last_name,13,'*')
FROM
    employees;    

-- Instead of CONCAT function I prefer to use concatenation operator (||)    
select 
    first_name || ' ' || last_name || ' : ' || job_id
from 
    employees
where
    substr(job_id,1,2)='AD';

-- It can be used to prepare administration commands
-- This select should be run from the ADMIN user    
select 
    'alter database tempfile '''||f.file_name||''' AUTOEXTEND ON MAXSIZE '||greatest(4*power(1024,3), bytes) stmt, bytes, maxbytes
from dba_temp_files f; 

-- Sometimes you can have request to provide select results with masked sensitive data
-- One option for this task is to use character functions
SELECT
    employee_id,
    last_name,
     LPAD(SUBSTR(phone_number,5),LENGTH(phone_number),'X'),
    phone_number,
    'XXXXX' || SUBSTR(phone_number,5,3) || 'XX' || SUBSTR(phone_number,10,1) 
FROM
    employees;

-- NUMERIC FUNCTIONS
-- MOD function returns the reminder of division
-- ROUND function rounds value to the specified decimal
-- CEIL function returns the smallest whole number greater than or equal to a specified number
-- FLOOR function returns the largest whole number equla to or less than a specified number
-- TRUNC function truncates the column value to N decimal places
SELECT
    employee_id,
    last_name,
    department_id,
    MOD(salary,300),
    salary,
    salary * 1.259002 "25.9002% Increased Salary",
    ROUND(salary * 1.259002,2),
    CEIL(salary * 1.259002),
    FLOOR(salary * 1.259002),
    TRUNC(salary * 1.259002,2)
FROM
    employees;

-- DATE Arithmetic Operations and Functions

-- DUAL is a public table you can use to view results from functions and calculations
-- SYSDATE is a data function that returns the system date
-- CURRENT_DATE returns the current date from the user session
-- CURRENT_TIMESTAMP returns current date and tme from the user session
SELECT sysdate,current_date,current_timestamp,sessiontimezone FROM dual;

-- You can change the way that a date or timestamp column is display at any time 
-- by altering your session to re-set nls_date_format.
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
SELECT sysdate,current_date,current_timestamp,sessiontimezone FROM dual;

-- Because Database stores dates as numbers you can perform Arithmetic with Dates
-- Add/Subtract/Multiply etc
SELECT
    last_name,
    hire_date,
    (SYSDATE-hire_date)/365,
    ROUND((SYSDATE-hire_date)/365,2) AS YEARS,
    ROUND((SYSDATE-hire_date)/7,2) AS WEEKS
FROM
    employees;

-- Several examples of the Date-Manipulation Functions    
SELECT
    last_name,
    hire_date,
    SYSDATE,
    MONTHS_BETWEEN(SYSDATE,hire_date),
    LAST_DAY(SYSDATE),
    LAST_DAY(hire_date),
    ADD_MONTHS(SYSDATE,3),
    ADD_MONTHS(hire_date,1)
FROM
    employees;    

-- HOME ASSIGNMENT (Solutions provided after questions):

-- 1. The HR department needs a report to display employee number, last name,
--    salary, and salary increased by 15.5% ( rounded to a whole number ) for each employee

-- 2. Modify above query to add a column that subtracts the old salary from the new salary

-- 3. 15% salary rise was approved by management to all employees due to inflation
-- It was also decided not to increase salary for the King employee
-- Please write an UPDATE statement that will perform required changes and
-- use LOWER function in WHERE clause to exclude King from the update

-- 4. The HR department requested a report to show the duration of the employment for each employee. 

-- Run and analyze the result for the following 2 queries
SELECT SUBSTR('ABCDEFG',3,4) "Substring" FROM DUAL;
SELECT SUBSTR('ABCDEFG',-5,4) "Substring" FROM DUAL;
-- 5. Write a query to select department number, and department name
--    Filter the resutl to include only rows with department names ending with 'ing'
--    Use SUSTR function ( negative position ) Link to the documentation:
--    https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/SUBSTR.html#GUID-C8A20B57-C647-4649-A379-8651AA97187E

-- 6. Write a query to select location number, 20 characters of the street_address,
--    city, postal_code from the "locations" table

-- 7. Use INSTR function to locate departments which have 'ing' 3 letters
--   in their name

-- 8. Use REGEXP_INSTR function to select all locations that satisfy the following pattern:
--   '.*[V].*[SR]'
--   REGEXP stands for regular expression, a regex is a string of text that 
--   allows you to create patterns that help match, locate, and manage text. 
--   For example:
--   '.*'   - any number of characters ( even zero )
--   '[V]   - an uppercase V
--   '[SR]' - an uppercase S or an uppercase R
-- Documentation for the REGEXP_INSTR:
-- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/REGEXP_INSTR.html#GUID-D21B53A1-83E2-4722-9BBB-638470715DD6

-- 9. Write a query to select employee_id,last_name,salary,hire_date from
--    employees table and filter result to include only rows with employees hired
--    after 2008-01-01. Include into the select list another column that shows
--    when employee will celebrate (or celebrated) 10 year anniversary 

-- SOLUTIONs:

-- 1. The HR department needs a report to display employee number, last name,
--    salary, and salary increased by 15.5% ( rounded to a whole number ) for each employee
SELECT
    employee_id,
    last_name,
    salary,
    ROUND(salary * 1.155, 0) New_salary
FROM 
    employees;
    
-- 2. Modify above query to add a column that subtracts the old salary from the new salary
SELECT
    employee_id,
    last_name,
    salary,
    ROUND(salary * 1.155, 0) New_salary,
    ROUND(salary * 1.155, 0) - salary Increase
FROM 
    employees;

-- 3. 15% salary rise was approved by management to all employees due to inflation
-- It was also decided not to increase salary for the King employee
-- Please write an UPDATE statement that will perform required changes and
-- use LOWER function in WHERE clause to exclude King from the update

-- Check the current salary and pin query result ( red pin button )
select first_name,last_name,salary from employees;

-- Update salary
UPDATE 
    employees
SET
    salary=salary*1.15
WHERE
    LOWER(last_name) != LOWER('kiNg');

-- Check the salary has been increased by 15% ( Check with pinned before result )
select first_name,last_name,salary from employees;

-- Rollback or Commit changes
rollback;

-- 4. The HR department requested a report to show the duration of the employment for each employee. 
SELECT
    first_name,
    last_name,
    hire_date EMPLOYMENT_START,
    SYSDATE CURRENT_TIME,
    ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) DURATION_OF_EMPLOYMENT_IN_MONTHS,
    ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)/12) DURATION_OF_EMPLOYMENT_IN_YEARS
FROM
    employees
ORDER BY
    DURATION_OF_EMPLOYMENT_IN_MONTHS DESC;

-- 5. Write a query to select department number, and department name
--    Filter the resutl to include only rows with department names ending with 'ing'
--    Use SUSTR function ( negative position ) Link to the documentation:
--    https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/SUBSTR.html#GUID-C8A20B57-C647-4649-A379-8651AA97187E
SELECT
    department_id,
    department_name
FROM
    departments
WHERE
    SUBSTR(department_name, -3) = 'ing';
    
-- 6. Write a query to select location number, 20 characters of the street_address,
--    city, postal_code from the "locations" table
SELECT
    location_id,
    SUBSTR(street_address,1,20) abbr_street,
    city,
    postal_code
FROM
    locations;
    
--7. Use INSTR function to locate departments which have 'ing' 3 letters
--   in their name
SELECT
    department_id,
    department_name
FROM
    departments
WHERE
    INSTR(department_name,'ing') > 0;
    
--8. Use REGEXP_INSTR function to select all locations that satisfy the following pattern:
--   '.*[V].*[SR]'
--   REGEXP stands for regular expression, a regex is a string of text that 
--   allows you to create patterns that help match, locate, and manage text. 
--   For example:
--   '.*'   - any number of characters ( even zero )
--   '[V]   - an uppercase V
--   '[SR]' - an uppercase S or an uppercase R
-- Documentation for the REGEXP_INSTR:
-- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/REGEXP_INSTR.html#GUID-D21B53A1-83E2-4722-9BBB-638470715DD6
SELECT
    location_id,
    street_address,
    city,
    postal_code
FROM
    locations
WHERE
    REGEXP_INSTR(street_address,'.*[V].*[SR]') = 1;
    
-- 9. Write a query to select employee_id,last_name,salary,hire_date from
--    employees table and filter result to include only rows with employees hired
--    after 2008-01-01. Include into the select list another column that shows
--    when employee will celebrate (or celebrated) 10 year anniversary 
SELECT
    employee_id,
    last_name,
    salary,
    hire_date,
    add_months(hire_date,120) ten_year_anniversary
FROM
    employees
WHERE
    hire_date > DATE '2008-01-01';