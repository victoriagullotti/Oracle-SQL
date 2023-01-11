CREATE TABLE locations_new(
    "LOCATION_ID" NUMBER(4,0), 
	"STREET_ADDRESS" VARCHAR2(40), 
	"POSTAL_CODE" VARCHAR2(12), 
	"CITY" VARCHAR2(30), 
	"STATE_PROVINCE" VARCHAR2(25), 
	"COUNTRY_ID" CHAR(2)
    );
    
-- 1. We can use OS commands to prepare INSERT statements from our CSV file    
-- cat locations_file.csv | sed "s/\"/'/g" | awk -F',' '{print "INSERT INTO locations_new VALUES("$1","$2","$3","$4","$5","$6");"}' >> locations_file.sql
-- export TNS_ADMIN=$HOME
-- (us-ashburn-1)$ sqlplus hr/Oracle4U_2022@pdb1_high

-- 2. Another way to load data from external file is to use External table functional ( non-cloud env )
ALTER SESSION SET CURRENT_SCHEMA=HR;
create directory pdb1_directory as '/u01/app/oracle/user_dirs/pdb1_dir_tmp';
SELECT * FROM all_directories;
-- drop directory pdb1_directory;

create table locations_file(
    "LOCATION_ID" NUMBER(4,0), 
	"STREET_ADDRESS" VARCHAR2(40), 
	"POSTAL_CODE" VARCHAR2(12), 
	"CITY" VARCHAR2(30), 
	"STATE_PROVINCE" VARCHAR2(25), 
	"COUNTRY_ID" CHAR(2)
)
organization external (
    type oracle_loader
    default directory pdb1_directory
    access parameters (
        fields terminated by ','
    )
    location ('locations_file.csv')
)
parallel 10; 
-- drop table locations_file;

SELECT
    t.department_id,
    t.department_name,
    f.location_id,
    f.street_address,
    f.country_id
FROM
    departments t
INNER JOIN locations_file f on t.location_id=f.location_id;


-- 3. Create External Table for ATP DB ( cloud env )
-- Use DBMS_CLOUD to Automate Loading Data into Autonomous Database (ADB)
BEGIN
  DBMS_CLOUD.CREATE_CREDENTIAL(
    credential_name => 'api_token',
    username => '<cloud userid>', 
    password => '<generated auth token password>'
  );
END;
/

BEGIN
   DBMS_CLOUD.CREATE_EXTERNAL_TABLE(
    table_name =>'LOCATIONS_EXT',
    credential_name =>'api_token',
    file_uri_list =>'https://objectstorage.us-ashburn-1.oraclecloud.com/n/idolzfhys41u/b/bucket_for_pdb1/o/locations_file3.csv',
    format => json_object('delimiter' value ','),
    column_list => 'LOCATION_ID NUMBER, STREET_ADDRESS VARCHAR2(40), POSTAL_CODE VARCHAR2(12), CITY VARCHAR2(30), STATE_PROVINCE VARCHAR2(25),  COUNTRY_ID CHAR(2)' );
END;
/

BEGIN
DBMS_CLOUD.DROP_CREDENTIAL(
credential_name => 'api_token'
);
END;
/
















