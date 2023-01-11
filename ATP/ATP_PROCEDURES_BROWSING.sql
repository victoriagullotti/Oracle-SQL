SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  v_source  VARCHAR2(32767);
  v_wrap    VARCHAR2(32767);
BEGIN
  v_source := 'create or replace PROCEDURE add_dept_encrypt ' ||
              '(in_department_id departments.department_id%TYPE ' ||
              ',in_department_name departments.department_name%TYPE ' ||
              ',in_manager_id departments.manager_id%TYPE ' ||
              ',in_location_id departments.location_id%TYPE ' ||
              ') ' ||
              'IS ' ||
              'BEGIN ' ||
              'INSERT INTO departments(department_id,department_name,manager_id,location_id) ' ||
              'VALUES(in_department_id,in_department_name,in_manager_id,in_location_id); ' ||
              'END; ';
 
  v_wrap := SYS.DBMS_DDL.WRAP(ddl => v_source);
  DBMS_OUTPUT.put_line(v_wrap);
  DBMS_OUTPUT.put_line(v_source);
END;
/

create or replace PROCEDURE add_dept_encrypt wrapped 
a000000
369
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
7
182 f7
fUye0J3Ohsh+WeyrCsbsb9FpSs8wgzJp2Z4VfC/SXjNmIS/kN0HgA4lnA72hxTCe4CONZu3O
/sUcm2mu2bn/ikfYMslnrdpGDPJ/Yh5vnAWB+VR4fY7p9CtTDvfmw9PAwSg9ySz/bzexNtOr
tcwZmFklrNvj4o2FhnSQR8qsZXfgbTpbR2dCVwZN545C9e5crD6tTJQ3eLkwK8GVUjlJf9d9
nUFO78+kO1JyI2fxAIpBWYtIpw==

/

execute add_dept_encrypt(290,'New Department',205,1700);
rollback;


SELECT *  FROM all_procedures  WHERE object_type='PROCEDURE';
SELECT DISTINCT name FROM all_source WHERE text not like '%wrapped%' and type='PROCEDURE';
SELECT text FROM all_source WHERE name='DBMS_FEATURE_OBJECT' ORDER BY line;
desc all_source;


DECLARE
    feature_boolean number := 0;
    aux_count number := 0;
    feature_info clob;
    l_apex_schema   dbms_id := null;
    l_num_apps      number := 0;
    l_num_views     number := 0;
    l_num_workspace number := 0;
    l_num_users     number := 0;
begin
    /* Determine current schema for Application Express
       Note: this will only return one row              */
    for c1 in (select schema
                 from dba_registry
                where comp_id = 'APEX' ) loop
        l_apex_schema := dbms_assert.enquote_name(c1.schema, FALSE);
    end loop;

    /* If not found, then APEX is not installed */
    if l_apex_schema is null then
        feature_boolean := 0;
        aux_count := 0;
        feature_info := to_clob('APEX usage not detected');
        return;
    end if;
    DBMS_OUTPUT.PUT_LINE('l_apex_schema: ' || l_apex_schema);
end;
/