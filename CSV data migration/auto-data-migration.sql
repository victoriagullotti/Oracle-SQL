-- 1. Generated API token in OCI console
--    my auth token password: fW0xeGHyd9843GJKF)(

-- 2. Create a new DB user and grant required permissions 
show user;
create user atp_dwh identified by "oracle_4U_sales";

grant dwrole, oml_developer, create table, create view to atp_dwh;
grant read, write on directory data_pump_dir to atp_dwh;
grant execute on dbms_cloud to atp_dwh;

alter user atp_dwh quota unlimited on data;

-- 3. Login as an "atp_dwh" user and create a new credential.
-- BEGIN
--  DBMS_CLOUD.CREATE_CREDENTIAL(
--    credential_name => 'api_token',
--    username => '<cloud userid>', 
--    password => '<generated auth token password>'
--  );
-- END;
-- /
show user;
BEGIN
  DBMS_CLOUD.CREATE_CREDENTIAL(
    credential_name => 'api_token',
    username => '@gmail.com', 
    password => 'fW0xeGHyd7UQ;}j8Vw)('
  );
END;
/

-- 4. Copy the SALES table from the SH schema to the ATP_DWH schema 

create table sales as select * from sh.sales;
alter table sales add(last_update_date date);


-- 5. Confirm that credentials your created earlier work
SELECT * FROM DBMS_CLOUD.LIST_OBJECTS('API_TOKEN', 'https://objectstorage.us-ashburn-1.oraclecloud.com/n/idolzfhys41u/b/dwh_files/o/');

-- 6. Create an externale table that reads data from the file in the bucket.
drop table new_sales_ext;
BEGIN
 DBMS_CLOUD.CREATE_EXTERNAL_TABLE(
 table_name =>'new_sales_ext',
 credential_name =>'api_token',
 file_uri_list =>'https://objectstorage.us-ashburn-1.oraclecloud.com/n/idolzfhys41u/b/dwh_files/o/sales_january.csv',
 format => json_object('delimiter' value ',', 'removequotes' value 'true','ignoremissingcolumns' value 'true','blankasnull' value 'true','skipheaders' value '1'),
 column_list => 'prod_id number, cust_id number, time_id date, channel_id number, promo_id number, quantity_sold number, amount_sold number, last_update_date date');
END;
/

select * from new_sales_ext;

-- 7. Create LOG
create table sales_update_log (
prod_id number
, cust_id number
, time_id date
, channel_id number
, promo_id number
, old_quantity_sold number
, new_quantity_sold number
, old_amount_sold number
, new_amount_sold number
, update_date date);

create table load_log (
load_type varchar2(100),
file_processed varchar2(1000),
rows_processed number,
load_date date);

-- 8. Create triggers to log changes to the SALES table
-- SALES_TRG captures new and old versions of data in the SALES_UPDATE_LOG table
CREATE OR REPLACE TRIGGER sales_trg
AFTER UPDATE OF quantity_sold, amount_sold ON sales
FOR EACH ROW
BEGIN
INSERT INTO sales_update_log
   ( prod_id,
     cust_id,
     time_id,
     channel_id,
     promo_id,
     old_quantity_sold,
     new_quantity_sold,
     old_amount_sold,
     new_amount_sold,
     update_date)
   VALUES
   ( :new.prod_id,
     :new.cust_id,
     :new.time_id,
     :new.channel_id,
     :new.promo_id,
     :old.quantity_sold,
     :new.quantity_sold,
     :old.amount_sold,
     :new.amount_sold,
     sysdate );
END;
/

-- The SALES_TRG2 trigger captures change date/time stamp. 
CREATE OR REPLACE TRIGGER sales_trg2
BEFORE UPDATE ON sales
FOR EACH ROW
BEGIN
:new.last_update_date := sysdate;
END;
/

-- 9. Create a LOAD_SALES stored procedure to loop through all the files in the dwh_files bucket 
--    and for each file to re-create the external table and then load and log the data. 

create or replace procedure load_sales as
v_row_count number;
begin
-- loop through files in dwh_files bucket
for f in (SELECT object_name FROM DBMS_CLOUD.LIST_OBJECTS('API_TOKEN', 'https://objectstorage.us-ashburn-1.oraclecloud.com/n/idolzfhys41u/b/dwh_files/o/'))
loop
-- drop external table
begin
execute immediate 'drop table new_sales_ext';
exception when others then null;
end;

-- re-create external table
begin
 DBMS_CLOUD.CREATE_EXTERNAL_TABLE(
 table_name =>'new_sales_ext',
 credential_name =>'api_token',
 file_uri_list =>'https://objectstorage.us-ashburn-1.oraclecloud.com/n/idolzfhys41u/b/dwh_files/o/'||f.object_name,
 format => json_object('delimiter' value ',', 'removequotes' value 'true','ignoremissingcolumns' value 'true','blankasnull' value 'true','skipheaders' value '1'),
 column_list => 'prod_id number, cust_id number, time_id date, channel_id number, promo_id number, quantity_sold number, amount_sold number, last_update_date date');
exception when others then null;
end;

select count(*) into v_row_count from new_sales_ext;
-- for each file load daily data
insert into sales select a.* from new_sales_ext a;
commit;

-- delete existing external table
begin
DBMS_CLOUD.DELETE_OBJECT('API_TOKEN', 'https://objectstorage.us-ashburn-1.oraclecloud.com/n/idolzfhys41u/b/dwh_files/o/'||f.object_name);
exception when others then null;
end;

insert into load_log values('Load', f.object_name, v_row_count, sysdate);
commit;

end loop;

end load_sales;
/

-- 10. Create a stored procedure UPDATE_SALES to
--     loop through all the files in the dwh_files bucket and 
--     for each file re-create the external table and then update and log the data.

create or replace procedure update_sales as
v_row_count number;
type sales_t is table of new_sales_ext%rowtype index by pls_integer;
l_sales sales_t;
begin
-- loop through files in dwh_files bucket
for f in (SELECT object_name FROM DBMS_CLOUD.LIST_OBJECTS('API_TOKEN', 'https://objectstorage.us-ashburn-1.oraclecloud.com/n/idolzfhys41u/b/dwh_files/o/'))
loop

-- drop external table
begin
execute immediate 'drop table new_sales_ext';
exception when others then null;
end;

-- re-create external table
begin
 DBMS_CLOUD.CREATE_EXTERNAL_TABLE(
 table_name =>'new_sales_ext',
 credential_name =>'api_token',
 file_uri_list =>'https://objectstorage.us-ashburn-1.oraclecloud.com/n/idolzfhys41u/b/dwh_files/o/'||f.object_name,
 format => json_object('delimiter' value ',', 'removequotes' value 'true','ignoremissingcolumns' value 'true','blankasnull' value 'true','skipheaders' value '1'),
 column_list => 'prod_id number, cust_id number, time_id date, channel_id number, promo_id number, quantity_sold number, amount_sold number, last_update_date date');
exception when others then null;
end;

select count(*) into v_row_count from new_sales_ext;

-- for each file update daily data

select * bulk collect into l_sales from new_sales_ext;

forall i2 in 1 .. l_sales.last

update sales
set quantity_sold = l_sales(i2).quantity_sold
    , amount_sold = l_sales(i2).amount_sold
    , last_update_date = sysdate
where prod_id = l_sales(i2).prod_id
and cust_id = l_sales(i2).cust_id
and time_id = l_sales(i2).time_id
and channel_id = l_sales(i2).channel_id
and promo_id = l_sales(i2).promo_id;
commit;

-- delete existing external table
begin
DBMS_CLOUD.DELETE_OBJECT('API_TOKEN', 'https://objectstorage.us-ashburn-1.oraclecloud.com/n/idolzfhys41u/b/dwh_files/o/'||f.object_name);
exception when others then null;
end;

insert into load_log values('Update', f.object_name, v_row_count, sysdate);
commit;

end loop; 

end update_sales;
/

-- 11. Create a scheduler job to periodically ( every 5 minutes in my case ) check 
--     and upload files in the dwh_files bucket 

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => 'LOAD_SALES_JOB',
            job_type => 'STORED_PROCEDURE',
            job_action => 'ATP_DWH.LOAD_SALES',
            number_of_arguments => 0,
            start_date => '17-DEC-22 06.50.00 PM Australia/Perth',
            repeat_interval => 'FREQ=MINUTELY;INTERVAL=5;',
            end_date => NULL,
            enabled => TRUE,
            auto_drop => FALSE,
            comments => '');

    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => 'LOAD_SALES_JOB', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);

-- enable
DBMS_SCHEDULER.enable(
             name => 'LOAD_SALES_JOB');
END;
/


-- 12. Wait 5 minutes

-- 13. Here you are some views to check scheduled jobs by ATP_DWH user
SELECT * FROM all_scheduler_jobs;
SELECT job_name, session_id, running_instance, elapsed_time FROM all_scheduler_running_jobs;
select * from ALL_SCHEDULER_JOB_RUN_DETAILS;
select * from ALL_SCHEDULER_JOB_LOG order by LOG_DATE desc;
select schedule_name, schedule_type, start_date, repeat_interval from all_scheduler_schedules;

-- 14. Check that our log table has been populated with load action for each file in the bucket
select * from load_log;
alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS';

-- 15. Disable and Remove scheduled job
execute dbms_scheduler.disable('atp_dwh.load_sales_job');
execute dbms_scheduler.drop_job('atp_dwh.load_sales_job');

-- 16. load March file to bucket again and execute update_sales procedure manually
execute update_sales;

-- 17. Check sales_update_log table
select * from sales_update_log;

