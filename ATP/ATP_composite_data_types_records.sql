-- To enable output, we need to execute the following command
SET SERVEROUTPUT ON

-- PL/SQL record example:
DECLARE
    -- define a record type
    TYPE rt_myrec 
    IS 
        RECORD 
        (
            v_department_id NUMBER (6) default 0,
            v_end_date job_history.end_date%type,
            v_rec1 job_history%rowtype
        );
    -- declare a record        
    v_myrec rt_myrec;
BEGIN
    v_myrec.v_department_id := v_myrec.v_department_id + 10;
    DBMS_OUTPUT.PUT_LINE('v_myrec.v_department_id: ' || v_myrec.v_department_id);
    v_myrec.v_end_date := sysdate;
    DBMS_OUTPUT.PUT_LINE('v_myrec.v_end_date: ' ||  v_myrec.v_end_date);
    SELECT * INTO v_myrec.v_rec1 FROM job_history WHERE employee_id = 102;
    DBMS_OUTPUT.PUT_LINE('v_myrec.v_rec1.department_id: ' || v_myrec.v_rec1.department_id);
    DBMS_OUTPUT.PUT_LINE('v_myrec.v_rec1.employee_id: ' || v_myrec.v_rec1.employee_id);
    DBMS_OUTPUT.PUT_LINE('v_myrec.v_rec1.job_id: ' || v_myrec.v_rec1.job_id);
    DBMS_OUTPUT.PUT_LINE('v_myrec.v_rec1.start_date: ' || v_myrec.v_rec1.start_date);
    DBMS_OUTPUT.PUT_LINE('v_myrec.v_rec1.end_date: ' || v_myrec.v_rec1.end_date);
    v_myrec.v_rec1.end_date:=CURRENT_DATE;
    UPDATE job_history SET ROW = v_myrec.v_rec1 WHERE employee_id =102;
END;
/

SELECT * FROM job_history WHERE employee_id=102;
rollback;

-- SELECT 5 employees with longest career at HR company
SELECT
    e.employee_id,
    e.department_id,
    e.first_name,
    e.last_name,
    e.hire_date EMPLOYMENT_START,
    SYSDATE CURRENT_TIME,
    ROUND(MONTHS_BETWEEN(SYSDATE, e.hire_date)) DURATION_OF_EMPLOYMENT_IN_MONTHS,
    ROUND(MONTHS_BETWEEN(SYSDATE, e.hire_date)/12) DURATION_OF_EMPLOYMENT_IN_YEARS
FROM
    employees e
LEFT JOIN
    job_history h on e.employee_id = h.employee_id 
WHERE
    h.employee_id IS NULL
ORDER BY
    DURATION_OF_EMPLOYMENT_IN_MONTHS DESC
FETCH NEXT 5 ROWS ONLY;

-- Make sure employee with id 203 is not retired yet
SELECT * FROM job_history WHERE employee_id=203;

-- PL/SQL record INSERT example 
DECLARE
    v_emp_rec employees%ROWTYPE;
BEGIN
    SELECT * INTO v_emp_rec FROM employees WHERE employee_id = 203;
    INSERT INTO job_history(employee_id,start_date,end_date,job_id,department_id)
    VALUES (v_emp_rec.employee_id,v_emp_rec.hire_date,CURRENT_DATE,v_emp_rec.job_id,v_emp_rec.department_id);
END;
/

-- Check that employee with id 203 has been retired
SELECT * FROM job_history WHERE employee_id=203;
rollback;

-- PL/SQL record another INSERT example 
DECLARE
    v_emp_rec job_history%ROWTYPE;
BEGIN
    SELECT employee_id,hire_date start_date,CURRENT_DATE end_date,job_id,department_id INTO v_emp_rec FROM employees WHERE employee_id = 203;
    INSERT INTO job_history VALUES v_emp_rec;
END;
/

SELECT * FROM job_history WHERE employee_id=203;
rollback;

-- HOME ASSIGNMENT
-- 1. Declare a PL/SQL record "v_country_record" based on the structure of countries table
-- 2. Declare a varchar variable "v_country_id" and assign 'UK' value to it
-- 3. Save "SELECT * FROM countries WHERE country_id = v_country_id" to the PL/SQL record "v_country_record" created in step 1
-- 4. Display selected information about the country

DECLARE 
    v_country_id varchar2(20):='UK';
    v_country_record countries%ROWTYPE;
BEGIN
    SELECT * INTO v_country_record FROM countries WHERE country_id = UPPER(v_country_id);
    DBMS_OUTPUT.PUT_LINE('Country ID: '   || v_country_record.country_id ||
                        ' Country Name: ' || v_country_record.country_name);
END;
/