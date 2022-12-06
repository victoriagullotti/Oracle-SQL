SELECT
    *
FROM
    all_users;

SELECT
    *
FROM
    sh.countries;

SELECT DISTINCT
    ( country_region )
FROM
    sh.countries;

SELECT
    COUNT(*)
FROM
    sh.countries;

ALTER SESSION SET current_schema = SH;

--CREATE TABLE FROM ANOTHER TABLE - STRUCTURE AND DATA
CREATE TABLE v_countries
    AS
        SELECT
            *
        FROM
            sh.countries;

-- ONLY STRUCTURE !!!
CREATE TABLE vg_countries
    AS
        SELECT
            *
        FROM
            v_countries
        WHERE
            1 = 0;

CREATE TABLE vg1_countries
    AS
        SELECT
            *
        FROM
            countries
        WHERE
            1 = 0;
SELECT
    *
FROM
    v_countries;

SELECT
    *
FROM
    vg1_countries;


SELECT
    *
FROM
    vg_countries
    order by country_subregion;

--INSERT DATA
INSERT INTO v_countries VALUES (
    9999,
    'RU',
    'Russia',
    'Eastern europe',
    9999,
    'Asia',
    9999,
    'World total',
    9999,
    NULL
);

INSERT INTO v_countries (
    country_id,
    country_iso_code,
    country_name,
    country_subregion
) VALUES (
    9999,
    'RU',
    'Russia',
    'Eastern europe'
);

insert into vg_countries 
select * from v_countries; where country_subregion = 'Asia';

SELECT
    *
FROM
    v_countries
WHERE
    country_id = 9999;

--Insert All
insert all 
into vg_countries
SELECT * FROM countries
where country_name = 'Poland';

ROLLBACK;

COMMIT;