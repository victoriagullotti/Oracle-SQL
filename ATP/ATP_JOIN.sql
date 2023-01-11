--  Join tables with the NATURAL JOIN clause   
SELECT * FROM departments NATURAL JOIN locations;    

-- Join tables with the USING clause
SELECT 
    *
FROM
    departments JOIN locations
USING (location_id);

-- Join tables with the ON clause
SELECT
    *
FROM
    departments d
JOIN
    locations l ON d.location_id=l.location_id;
    
-- Joining 3 tables with additional condition data
SELECT
    d.department_id,
    d.department_name,
    e.first_name,
    e.last_name,
    e.salary,
    l.location_id,
    l.country_id,
    l.state_province,
    l.city,
    l.street_address
FROM
    departments d
JOIN
    locations l ON d.location_id=l.location_id
JOIN 
    employees e ON e.department_id=d.department_id
WHERE
    d.department_id=60;

-- Self-join

SELECT
    worker.job_id worker_job,
    worker.employee_id worker_employee_id,
    worker.last_name worker_name,
    worker.salary worker_salary,
    manager.job_id manager_job,
    manager.employee_id manager_employee_id,
    manager.last_name manager_name,
    manager.salary manager_salary
FROM
    employees worker 
JOIN
    employees manager on worker.manager_id = manager.employee_id
WHERE 
   worker.employee_id=206;

-- LEFT JOIN example    
SELECT
    worker.job_id worker_job,
    worker.employee_id worker_employee_id,
    worker.last_name worker_name,
    worker.salary worker_salary,
    manager.job_id manager_job,
    manager.employee_id manager_employee_id,
    manager.last_name manager_name,
    manager.salary manager_salary
FROM
    employees worker 
LEFT JOIN
    employees manager on worker.manager_id = manager.employee_id
WHERE 
    worker.employee_id=100;  
    
-- HOME ASSIGNMENT
--1. Join JOBS and EMPLOYEES table using 3 different ways
--   Limit the output only for rows which have department_id 60 or 30

-- 2. Join COUNTRIES and REGIONS tables. SELECT country_id,country_name,
--    region_id, region_name. Exclude countries with names starting with "B" letter

-- 3. The HR department needs a report of employees in Seattle.
--    Display the last_name, job_id, department_id, and department name
--    for all employees who work in Seattle

-- 4. After an internal investigation in large tech company, cases of unfair appointment of managers were revealed
-- To help with the case, you need to write a query to find out employees who were hired before their managers

-- 5. HR department requests a report that shows employee name, department name,
--    and all employees who work in the same department with employee


--1. Join JOBS and EMPLOYEES table using 3 different ways
--   Limit the output only for rows which have department_id 60 or 30

SELECT
    employee_id,
    first_name,
    job_id,
    job_title
FROM
    employees
NATURAL JOIN
    jobs
WHERE
    department_id in (30,60);
    
SELECT
    employee_id,
    first_name,
    job_id,
    job_title
FROM
    employees
JOIN
    jobs USING (job_id)
WHERE
    department_id in (30,60);
    
SELECT
    e.employee_id,
    e.first_name,
    j.job_id,
    j.job_title
FROM
    employees e
JOIN
    jobs j on e.job_id=j.job_id
WHERE
    e.department_id in (30,60);    


-- 2. Join COUNTRIES and REGIONS tables. SELECT country_id,country_name,
--    region_id, region_name. Exclude countries with names starting with "B" letter
SELECT
    country_id,
    country_name,
    c.region_id,
    region_name
FROM
    countries c
INNER JOIN
    regions r ON c.region_id = r.region_id
WHERE
    country_name not like 'B%'
ORDER BY region_name;

-- 3. The HR department needs a report of employees in Seattle.
--    Display the last_name, job_id, department_id, and department name
--    for all employees who work in Seattle.
SELECT
    e.last_name,
    e.job_id,
    e.department_id,
    d.department_name
FROM
    employees e 
INNER JOIN  
    departments d on e.department_id = d.department_id
INNER JOIN
    locations l on l.location_id = d.location_id
WHERE
    LOWER(l.city) = LOWER('SeaTtLE');
    
-- 4. After an internal investigation in large tech company, cases of unfair appointment of managers were revealed
-- To help with the case, you need to write a query to find out employees who were hired before their managers
SELECT
    w.first_name,
    w.last_name,
    w.hire_date,
    m.first_name,
    m.last_name,
    m.hire_date
FROM
    employees w 
JOIN
    employees m ON w.manager_id = m.employee_id
WHERE
    w.hire_date < m.hire_date;
    
-- 5. HR department requests a report that shows employee name, department name,
--    and all employees who work in the same department with employee
SELECT
    e.department_id,
    d.department_name,
    e.last_name employee,
    c.last_name colleague
FROM
    employees e
JOIN
    employees c ON e.department_id = c.department_id
JOIN
    departments d on d.department_id=e.department_id
WHERE
    e.employee_id != c.employee_id
ORDER BY
    e.department_id, e.last_name, c.last_name;
    
    