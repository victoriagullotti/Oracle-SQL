--CREATING TABLES WITH CONSTRAINTS
CREATE TABLE countries (
    country_id   CHAR(2)
        CONSTRAINT country_id_nn NOT NULL,
    country_name VARCHAR2(40),
    region_id    NUMBER,
    CONSTRAINT country_id_pk PRIMARY KEY ( country_id )
);

desc countries;

CREATE TABLE locations (
    location_id CHAR(2)
        CONSTRAINT location_l_id_pk NOT NULL,
    country_id  CHAR(2)
        CONSTRAINT country_id_nn NOT NULL,
    address     VARCHAR2(40),
    CONSTRAINT "LOC_C_ID_FK" FOREIGN KEY ( country_id )
        REFERENCES "COUNTRIES" ( "COUNTRY_ID" )
    ENABLE
);

desc locations;