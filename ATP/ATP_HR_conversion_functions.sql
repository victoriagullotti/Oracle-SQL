-- Implicit Data Type Conversion
-- An example of implicit conversion of the '01-Jan-91' string to a date
SELECT * FROM employees WHERE hire_date > '01-Jan-91';

-- Oracle can convert VARCHAR2 or CHAR to NUMBER
-- But the next statement fails because some records in the
-- LOCATIONS table do not contain valid numbers in the postal_code column. 
-- For example: "M5V 2L7", "OX9 9ZB", "01307-002", etc
SELECT * FROM locations WHERE postal_code = 11932;

-- For the demonstration purposes let's remove these records from location table and try again
-- But at first we need to assign another locations for records in the departments 
-- not to violate FK constraint
UPDATE departments set location_id=1500 WHERE location_id IN (1800,1900,2400,2500,2800,3100);
DELETE FROM locations WHERE location_id IN (1800,1900,2400,2500,2800,3100);

-- Now implicit conversion works (VARCHAR2 -> NUMBER)
SELECT * FROM locations WHERE postal_code = 11932;
rollback;


-- Although implicit data type conversion is available, it is recommended
-- that you do the explicit data type conversion to ensure reliability of
-- your SQL statement. An explicit data type conversion converts a value 
-- from one data type to another. There are 3 main functions to convert a value
-- from one data type to another: TO_CHAR, TO_NUMBER, and TO_DATE
SELECT * FROM locations WHERE postal_code = TO_CHAR(11932);

-- Let's maker sure that after we rolled back our changes the following 
-- query fails again:
SELECT * FROM locations WHERE postal_code = 11932;

-- For the same reason fails the explicit conversion of the postal_code values
-- Some values can't be converted to numbers ("M5V 2L7", "OX9 9ZB", "01307-002")
SELECT location_id FROM locations WHERE TO_NUMBER(postal_code) = 11932;

-- We can workaround this issue by using a DEFAULT option on conversion error
-- for the TO_NUMBER function:
SELECT 
    * 
FROM 
    locations 
WHERE  
    TO_NUMBER(postal_code DEFAULT -1 ON CONVERSION ERROR) = 11932;

-- If we move our TO_NUMBER expression from WHERE clause to SELECT clause
-- we can see what values can't be converted to NUMBER 
SELECT 
    location_id,
    postal_code,
    TO_NUMBER(postal_code DEFAULT -1 ON CONVERSION ERROR)
FROM 
    locations;    


-- TO_CHAR converts a datetime data type to a value of VARCHAR2 data type
-- in the format specified by format_model(see attached table)
SELECT
    last_name,
    TO_CHAR(hire_date, 'YYYY/MM/DAY') Day_Hired_v1,
    TO_CHAR(hire_date, 'DD') || ' of ' || TO_CHAR(hire_date, 'MONTH')  Day_Hired_v2
FROM 
    employees;

-- When working with number values, sometimes you want to convert those numbers
-- to the character data type using the TO_CHAR function (NUMBER->VARCHAR2)
-- We can use format elements to display a number value as a character:
-- 9 represents number
-- 0 Forces a zero to be displayed
-- $ Places a floating dollar sign
-- . Prints a decimal point
-- , Prints a comma as a thousand indicator
SELECT
    last_name,
    TO_CHAR(salary, '999999') SALARY_V1,
    TO_CHAR(salary, '099999') SALARY_V2,
    TO_CHAR(salary, '$999,999,999.99') SALARY_V3
FROM
    employees;

-- TO_DATE function converts a character string to a date format    
SELECT
    last_name,
    hire_date
FROM
    employees
WHERE
    hire_date < TO_DATE('01-Jan-91','DD-Mon-yy');
    
    
-- Home Assignment
-- 1. Create a report that prints for each employee his current salary
--    and desired salary (which is current salary X 2). Use TO_CHAR function
--    and the following format for a salary: $999,999.99
--    Use concatenation to print one line per each employee in the following format:
--    "King earns   $24,000.00 monthly, Desired salary:   $48,000.00"

--2. Write a query to select last_name, hire_date, and salary review date,
--   which is the first Monday after 18 months of service
--   Use TO_CHAR,ADD_MONTHS and NEXT_DAY functions.
--   Example output:
--   Last_Name     Hire_Date    Salary_Review
--   King	       17-JUN-03	Monday, the 20 of December, 2004

-- 1. Create a report that prints for each employee his current salary
--    and desired salary (which is current salary X 2). Use TO_CHAR function
--    and the following format for a salary: $999,999.99
--    Use concatenation to print one line per each employee in the following format:
--    "King earns   $24,000.00 monthly, Desired salary:   $48,000.00"
SELECT
    last_name 
    || ' earns: '
    || TO_CHAR(salary, '$999,999.99')
    || ' monthly, Desired salary: '
    || TO_CHAR(salary*2, '$999,999.99')
FROM
    employees;
    
--2. Write a query to select last_name, hire_date, and salary review date,
--   which is the first Monday after 18 months of service
--   Use TO_CHAR,ADD_MONTHS and NEXT_DAY functions.
--   Example output:
--   Last_Name     Hire_Date    Salary_Review
--   King	       17-JUN-03	Monday, the 20 of December, 2004
SELECT
    last_name,
    hire_date,
    TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date,18), 'MONDAY'), 'Day, "the" DD "of" Month, YYYY') SALARY_REVIEW
FROM
    employees;