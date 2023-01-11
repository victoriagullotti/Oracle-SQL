-- Create a list of employees who were hired after Peter Vargas employee using JOIN operation

SELECT
    w.first_name,
    w.last_name,
    w.hire_date,
    vargas.first_name,
    vargas.last_name,
    vargas.hire_date
FROM
    employees w 
JOIN
    employees vargas ON vargas.last_name = 'Vargas' AND vargas.hire_date < w.hire_date
ORDER BY w.last_name;
    
-- Create a list of employees who were hired after Peter Vargas employee using a Subquery

SELECT
    w.first_name,
    w.last_name,
    w.hire_date,
    ( SELECT d.department_name FROM departments d WHERE d.department_id = w.department_id ) dep_name 
FROM
    employees w 
WHERE
    w.hire_date > ( SELECT hire_date FROM employees WHERE last_name = 'Vargas')
ORDER BY
    w.last_name;

-- What happens if subquery returns more than 1 row?  
SELECT MIN(salary) FROM employees GROUP BY department_id;

SELECT
    w.first_name,
    w.last_name,
    w.hire_date,
    w.salary,
    w.department_id
FROM
    employees w 
WHERE
    w.salary > ( SELECT MIN(salary) FROM employees GROUP BY department_id)
ORDER BY
    w.last_name;    
    
-- We got an error: ORA-01427: single-row subquery returns more than one row
-- If subquery returns more than 1 row by design we should use multiple-row comparison operators:
-- * IN
-- * ANY
-- * ALL

SELECT
    w.first_name,
    w.last_name,
    w.hire_date,
    w.salary,
    w.department_id
FROM
    employees w 
WHERE
    w.salary > ANY ( SELECT MIN(salary) FROM employees GROUP BY department_id)
ORDER BY
    w.last_name; 

-- Run the above query with ANY/ALL/IN multiple-row operators
-- Try to understand result returned by each operator

-- To display all employees with lowest salary in each department
-- we will use multiple-column subquery

SELECT
    department_id,
    first_name,
    last_name,
    salary
FROM
    employees
WHERE
    ( department_id, salary ) IN ( SELECT department_id, min(salary) FROM employees GROUP BY department_id);
    

-- Home Assignment

--1. Create a report that displays the employee_id, last_name, salary of all employees
--   who earn more than the average salary. Sort the result by salary

--2. Write a query that returns employee_id, last_name of all employees
--   who work in a department with any employees whose last name starts with
--   letter "A"

--3. Write a query that displays the last_name, salary of every employee
--   who reports to a King manager

--4. Create a report that displays a list of all employees whose salary is more than
--   the salary of any employee from department 90.

--5. Find the employee with the lowest sallary, and department where he works. 
--   Use subquery to solve this task

--6. Create a report that contains the following columns: department_id, department_name min_salary, max_salary
--   include only departments with minimum salary greater than minimun salary in the Marketing department 


--1. Create a report that displays the employee_id, last_name, salary of all employees
--   who earn more than the average salary. Sort the result by salary
SELECT
    employee_id,
    last_name,
    salary
FROM
    employees
WHERE
    salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary;

--2. Write a query that returns employee_id, last_name of all employees
--   who work in a department with any employees whose last name starts with
--   letter "A"
SELECT
    employee_id, 
    last_name
FROM
    employees
WHERE
    department_id IN (SELECT department_id FROM employees WHERE last_name like 'A%');
    
--3. Write a query that displays the last_name, salary of every employee
--   who reports to a King manager
SELECT
    last_name,
    salary
FROM 
    employees
WHERE
    manager_id IN ( SELECT employee_id FROM employees WHERE last_name='King');
    
--4. Create a report that displays a list of all employees whose salary is more than
--   the salary of any employee from department 90.
SELECT
    last_name
FROM
    employees
WHERE
    salary > ANY (SELECT salary FROM employees WHERE department_id=70);

--5. Find the employee with the lowest sallary, and department where he works. 
--   Use subquery to solve this task
SELECT
    ( SELECT d.department_name FROM departments d WHERE d.department_id = e.department_id ) dep_name,
    e.first_name,
    e.last_name,
    e.hire_date,
    e.salary
FROM
    employees e
WHERE
    salary = ( SELECT MIN(salary) FROM employees);
    
--6. Create a report that contains the following columns: department_id, department_name min_salary, max_salary
--   include only departments with minimum salary greater than minimun salary in the Marketing department  

SELECT
    w.department_id,
    ( SELECT d.department_name FROM departments d WHERE d.department_id = w.department_id ) dep_name,
    MIN(w.salary),
    MAX(w.salary)
FROM
    employees w
GROUP BY
    w.department_id
HAVING
    MIN(w.salary) >
(
SELECT
    MIN(salary)
FROM
    departments d
JOIN
    employees e ON d.department_id=e.department_id AND department_name='Marketing'
);
 


