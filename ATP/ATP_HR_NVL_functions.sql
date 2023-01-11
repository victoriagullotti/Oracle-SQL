-- If a column in a row has no value, then the column is said to be NULL,
-- or to contain NULL. NULLs can appear in columns of any datatype that are not 
-- restricted by NOT NULL or PRIMARY KEY integrity constraints. 
-- NULL is special in the sense that it is not a value like a number,
-- character string, or datetime, therefore, you cannot compare it with any 
-- other values like zero (0) or an empty string (''). 
-- Generally speaking, NULL is even not equal to NULL.
-- The following SELECT statement attempts to return all employees
-- which do not have a manager by using comparison operator (=) to compare 
-- the values from the manager_id column with NULL, which is not correct
SELECT * FROM employees WHERE manager_id = NULL;

-- To check if a value is NULL or not, you should use the IS NULL and
-- IS NOT NULL operators:
SELECT * FROM employees WHERE manager_id IS NULL;
SELECT * FROM employees WHERE manager_id IS NOT NULL;

-- The Oracle NVL() function allows you to replace NULL  with a more meaningful
-- alternative in the results of a query.
SELECT
    last_name,
    hire_date
    ,NVL(hire_date,SYSDATE)
    ,manager_id
    ,NVL(manager_id,0)
    ,salary
    ,commission_pct
    ,NVL(commission_pct,0)
    ,(salary*12 + commission_pct*salary*12) annual_salary1
    ,(salary*12 + NVL(commission_pct,0)*salary*12) annual_salary2
FROM
    employees
WHERE
    employee_id IN (100,145);
-- Any arithmetic expression containing a NULL always evaluates to NULL. 
-- For example, NULL added to 10 is NULL. Notice that in the 
-- ANNUAL_SALARY1 column we lost Mr King's salary. To protect our query from
-- such behaviour we used NVL function in ANNUAL_SALARY2 column

-- The NVL2 function examines the 1st expression. If the 1st expression IS NOT NULL,
-- the NVL2 function returns the 2nd expression. If the 1st expression IS NULL,
-- the 3rd expression is returned
SELECT
    last_name,
    hire_date
    ,NVL2(hire_date,1,0)
    ,manager_id
    ,NVL2(manager_id,'YES', 'NO')
    ,salary
    ,commission_pct
    ,NVL2(commission_pct,'Salary + Commission','Salary')
    ,NVL2(commission_pct, salary*12 + commission_pct*salary*12, salary*12) annual_salary
FROM
    employees
WHERE
    employee_id IN (100,145);

-- The COALESCE function    
SELECT
    last_name
    ,salary
    ,commission_pct
    ,COALESCE((salary*12 + commission_pct*salary*12), salary*12) annual_salary
FROM
    employees
WHERE
    employee_id IN (100,145);    
    
-- The NULLIF function compares 2 expressions. If they are equal,
-- NULLIF functions returns NULL. If they are not equal, function returns 1st expression
SELECT
    first_name,
    LENGTH(first_name),
    last_name,
    LENGTH(last_name),
    NULLIF(LENGTH(first_name), LENGTH(last_name))
FROM
    employees;
    