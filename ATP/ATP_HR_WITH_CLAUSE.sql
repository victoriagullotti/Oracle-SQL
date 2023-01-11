-- Example 1:
WITH temporaryTable(averageValue) AS (
     SELECT 
        AVG(salary)
     FROM employees
)
SELECT 
    employee_id,
    first_name,
    last_name,
    job_id,
    salary 
FROM 
    employees, temporaryTable 
WHERE 
    employees.salary > temporaryTable.averageValue;

-- Example 2:    
WITH dep_avg(department_id, number_of_emp, avg_salary) AS (
     SELECT 
        department_id,
        COUNT(1) as number_of_emp,
        AVG(salary) avg_salary
     FROM 
        employees
     GROUP BY
        department_id
)
SELECT 
    employee_id,
    first_name,
    last_name,
    job_id,
    salary,
    ROUND(avg_salary,1) dep_avg_salary,
    number_of_emp
FROM 
    employees
INNER JOIN dep_avg ON employees.department_id = dep_avg.department_id 
WHERE 
    employees.salary > dep_avg.avg_salary;    
    
-- Example 3:
CREATE TABLE emp_dep2
AS
WITH d(id,name) AS (
     SELECT '10' , 'Administration' FROM dual UNION ALL
     SELECT '60' , 'IT' FROM dual UNION ALL
     SELECT '20' , 'Marketing' FROM dual
)
SELECT 
    employee_id,
    first_name,
    last_name,
    job_id,
    salary,
    department_id,
    d.name
FROM 
    d 
INNER JOIN employees ON employees.department_id = d.id;

DROP TABLE emp_dep2;