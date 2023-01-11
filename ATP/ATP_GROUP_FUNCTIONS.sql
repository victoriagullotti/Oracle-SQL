-- Group functions operates on sets of rows
-- to give one result per group

-- We can use the following GROUP FUNCTIONS to find out the highest, the lowest,
-- average, and sum of monthly salaries for all employes
SELECT
    MAX(salary),
    MAX(hire_date),
    MIN(salary),
    MIN(hire_date),
    AVG(salary),
    SUM(salary),
    COUNT(*)
FROM
    employees;

-- Pay attention that only MIN and MAX functions can be used with DATE data types
-- The following query fails because I used AVG function with DATE data type
SELECT
    MAX(salary),
    MAX(hire_date),
    MIN(salary),
    MIN(hire_date),
    AVG(salary),
    AVG(hire_date),
    SUM(salary),
    COUNT(*)
FROM
    employees;    

-- With the following query we can check the same information 
-- but only for the IT programmers
SELECT
    MAX(salary),
    MAX(hire_date),
    MIN(salary),
    MIN(hire_date),
    AVG(salary),
    SUM(salary),
    COUNT(*)
FROM
    employees
WHERE
    job_id='IT_PROG';
    
-- With GROUP BY clause we can divide the result set of information into smaller groups
-- In the following example we divide information by job_id groups
SELECT
    job_id,
    MAX(salary),
    MAX(hire_date),
    MIN(salary),
    MIN(hire_date),
    AVG(salary),
    SUM(salary),
    COUNT(*)
FROM
    employees
GROUP BY 
    job_id
ORDER BY
    AVG(salary);

-- You can GROUP BY more than one column   
SELECT
    department_id,
    job_id,
    MAX(salary),
    MAX(hire_date),
    MIN(salary),
    MIN(hire_date),
    AVG(salary),
    SUM(salary),
    COUNT(*)
FROM
    employees
GROUP BY 
    department_id,job_id
ORDER BY
    AVG(salary);    
    
-- What is not allowed with GROUP BY? And how you can workaround it.

-- 1. Using column or expression in the SELECT list that is not an aggregate function
-- or not present in the GROUP BY clause
SELECT
    job_id,
    count(*)
FROM
    employees;
    
SELECT
    job_id,
    department_id,
    count(*)
FROM
    employees
GROUP BY
    job_id;

-- Sometimes we need to include columns that are not used in the GROUP BY
-- For this purposes I use LISTAGG function
-- LISTAGG orders data within each group specified in the ORDER BY clause and then concatenates the values of the measure column

-- The following single-set aggregate example lists all of the employees 
-- in Department 30 in the hr.employees table, ordered by hire date and last name

SELECT 
    LISTAGG(last_name, '; ')
         WITHIN GROUP (ORDER BY hire_date, last_name) "Emp_list",
    MIN(hire_date) "Earliest"
FROM 
    employees
WHERE 
    department_id = 30;

-- The following group-set aggregate example lists, 
-- for each department ID in the hr.employees table, 
-- the employees in that department in order of their hire date:  

SELECT 
    department_id "Dept.",
    LISTAGG(last_name, '; ') WITHIN GROUP (ORDER BY hire_date) "Employees"
FROM 
    employees
GROUP BY 
    department_id
ORDER BY 
    department_id;  

-- 2.  The WHERE clause can not be used to filter result output for the group functions
SELECT
    job_id,
    AVG(salary),
    COUNT(*)
FROM
    employees
WHERE
    AVG(salary) > 9000
GROUP BY
    job_id;
    
-- You should use HAVING clause to filter output based on the group function result
SELECT
    job_id,
    AVG(salary),
    COUNT(*)
FROM
    employees
GROUP BY
    job_id
HAVING AVG(salary) > 9000;

-- HOME ASSIGNMENT
-- 1. Display employees number hired after 01-SEP-2003
--    Use TO_DATE function 

-- 2. Display how many employees were hired for each JOB_ID after 01-SEP-2003
--    Sort result by employees number in descending order

-- 3. Display the jobs and average slaries for jobs with a maximum salary greater than $15,000

-- 4. Find the highest,lowest,sum,average salary, and number of people for all employees. 
--    Round you result to the nearest whole number

-- 5. Modify the query in the above task to see the same information for each job type

-- 6. Find the difference between the highest and lowest salaries for each JOB_ID
-- Sort the result by this difference

-- 7. Your manager asked you to create a report to display
--    the manager's id and the salary of the lowest-paid employee for that manager

-- 8. Your manager asked you to find out the total number of employees hired each year
-- Use EXTRACT function to extract year from a hire_date
-- EXTRACT function extracts and returns the value of a specified datetime field from a datetime or interval expression.
-- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/EXTRACT-datetime.html#GUID-36E52BF8-945D-437D-9A3C-6860CABD210E

-- 1. Display employees number hired after 01-SEP-2003
--    Use TO_DATE function 
SELECT 
    COUNT(*) number_of_employees
FROM
    employees
WHERE
    hire_date > TO_DATE('2003-09-01','YYYY-MM-DD');
-- Pay attention that we can use GROUP functions without GROUP BY clause
-- In this case all table is considered as a one group

-- It is also easier to use DATE function to filter result by date    
SELECT 
    COUNT(*) number_of_employees
FROM
    employees
WHERE
    hire_date > DATE '2003-09-01';


-- 2. Display how many employees were hired for each JOB_ID after 01-SEP-2003
--    Sort result by employees number in descending order
SELECT
    job_id,
    COUNT(*) number_of_employees
FROM
    employees
WHERE
    hire_date > DATE '2003-09-01'
GROUP BY
    job_id
ORDER BY 2 DESC;

-- 3. Display the jobs and average slaries for jobs with a maximum salary greater than $15,000
SELECT
    job_id,
    AVG(salary)
FROM
    employees
GROUP BY 
    job_id
HAVING MAX(salary) > 15000;

-- 4. Find the highest,lowest,sum,average salary, and number of people for all employees. 
--    Round you result to the nearest whole number
SELECT
    ROUND(MAX(salary),0),
    ROUND(MIN(salary),0),
    ROUND(AVG(salary),0),
    ROUND(SUM(salary),0),
    COUNT(*)
FROM
    employees;    
    
-- 5. Modify the query in the above task to see the same information for each job type
SELECT
    job_id,
    ROUND(MAX(salary),0),
    ROUND(MIN(salary),0),
    ROUND(AVG(salary),0),
    ROUND(SUM(salary),0),
    COUNT(*)
FROM
    employees
GROUP BY
    job_id;

-- 6. Find the difference between the highest and lowest salaries for each JOB_ID
-- Sort the result by this difference
SELECT
    job_id,
    MIN(salary),
    MAX(salary),
    MAX(salary) - MIN(salary) DIFFERENCE
FROM
    employees
GROUP BY 
    job_id
ORDER BY DIFFERENCE;

    
-- 7. Your manager asked you to create a report to display
--    the manager's id and the salary of the lowest-paid employee for that manager
SELECT
    manager_id,
    MIN(salary)
FROM
    employees
GROUP BY
    manager_id;
    
    
-- 8. Your manager asked you to find out the total number of employees hired each year
-- Use EXTRACT function to extract year from a hire_date
-- EXTRACT function extracts and returns the value of a specified datetime field from a datetime or interval expression.
-- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/EXTRACT-datetime.html#GUID-36E52BF8-945D-437D-9A3C-6860CABD210E
SELECT
    EXTRACT(YEAR from hire_date),
    count(*)
FROM
    employees
GROUP BY
    EXTRACT(YEAR from hire_date);
    
-- 9. This is an example of Analytic function. We will learn about it later in the course
-- For each employee hired earlier than September 1, 2003, 
-- show the employee's department, hire date, 
-- and all other employees in that department also hired before September 1, 2003

SELECT 
    department_id "Dept", 
    hire_date "Date", 
    last_name "Name",
    LISTAGG(last_name, '; ') WITHIN GROUP (ORDER BY hire_date, last_name)
         OVER (PARTITION BY department_id) as "Emp_list"
FROM 
    employees
WHERE 
    hire_date < '01-SEP-2003'
ORDER BY 
    "Dept", "Date", "Name";
    