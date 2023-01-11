-- Oracle CASE expression allows you to add if-else logic to SQL statements 
-- without having to call a procedure. The CASE expression evaluates a list 
-- of conditions and returns one of the multiple possible results.

-- Simple CASE expression
SELECT
    last_name,
    job_id,
    salary,
    CASE job_id
        WHEN 'AD_VP'       THEN 1.05*salary -- if job_id is AD_VP, the salary increase 5%
        WHEN 'FI_ACCOUNT'  THEN 1.20*salary -- if job_id is FI_ACCOUNT, the salary increase 20%   
        WHEN 'IT_PROG'     THEN 1.35*salary -- if job_id is IT_PROG, the salary increase 35%
        WHEN 'SA_REP'      THEN 1.40*salary -- if job_id is SA_REP, the salary increase 40%   
        ELSE salary -- no increase in salary for other job roles
    END "NEW_SALARY"
FROM
    employees;

-- You can use the CASE expression in statements such as 
-- SELECT, UPDATE, or DELETE, and in clauses like SELECT, WHERE, HAVING, and ORDER BY
-- The following query uses the CASE expression in the ORDER BY clause 
-- to determine the sort order of rows based on column value:

SELECT * FROM locations 
ORDER BY country_id,
         CASE country_id
            WHEN 'US' THEN state_province
            WHEN 'CA' THEN state_province
            ELSE city
         END;

   
-- The Oracle searched CASE expression evaluates a list of Boolean expressions 
-- to determine the result.
SELECT
    last_name,
    salary,
    CASE
        WHEN salary<5000  THEN 'Low'
        WHEN salary<10000 THEN 'Medium'
        WHEN salary<20000 THEN 'Good'
        ELSE 'Excelent'
    END salary_evaluation
FROM
    employees;

-- The following UPDATE statement uses the CASE expression 
SELECT * FROM employees WHERE last_name in ('King','Kochhar','Austin','Sullivan');
UPDATE
    employees
SET
    salary =
    CASE
        WHEN salary<5000  THEN 2*salary
        WHEN salary<10000 THEN 1.25*salary
        WHEN salary<20000 THEN 1.15*salary
        ELSE salary/2
    END;
SELECT * FROM employees WHERE last_name in ('King','Kochhar','Austin','Sullivan');    
rollback;

-- Oracle provides DECODE function that is similar to CASE expressions 
-- The DECODE function decodes an expression in a way similar to the IF-THEN-ELSE logic
SELECT
    last_name,
    job_id,
    salary,
    DECODE(job_id, 'AD_VP',      1.05*salary, -- if job_id is AD_VP, the salary increase 5%
                   'FI_ACCOUNT', 1.20*salary, -- if job_id is FI_ACCOUNT, the salary increase 20%   
                   'IT_PROG',    1.35*salary, -- if job_id is IT_PROG, the salary increase 35%
                   'SA_REP',     1.40*salary, -- if job_id is SA_REP, the salary increase 40%  
           salary)  -- no increase in salary for other job roles
    NEW_SALARY
FROM
    employees;    
    
    
-- HOME ASSIGNMENT    
-- 1. Using the CASE function, write a query that displays the continent of all countries
--    based on the value of country_name in the countries table
--    Example:
--    COUNTRY_NAME CONTINENT
--    Italy	       Europe
--    Japan	       Asia

SELECT
    country_name,
    CASE
        WHEN country_name IN ('Italy','United Kingdom','Switzerland','Netherlands','France','Germany') THEN 'Europe'
        WHEN country_name IN ('Japan','China','Singaore') THEN 'Asia'
        ELSE 'Other'
    END Continent
FROM
    countries;
    