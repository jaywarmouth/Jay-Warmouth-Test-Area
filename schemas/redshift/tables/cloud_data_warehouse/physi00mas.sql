-- =============================================
-- Table: cloud_data_warehouse.physi00mas
-- Columns: 34
-- Schema Source: Enterprise Data Warehouse Data Schema.csv
-- =============================================

CREATE TABLE cloud_data_warehouse.physi00mas (
    sponsornumber INTEGER NOT NULL,
    physiciannumber CHAR(14) NOT NULL,
    lastname CHAR(25),
    firstname CHAR(14),
    middleinitial CHAR(1),
    street1 CHAR(40),
    stree2 CHAR(40),
    city CHAR(15),
    state CHAR(2),
    zip INTEGER,
    zip4 SMALLINT,
    specialty CHAR(10),
    secondaryspecialty1 CHAR(10),
    secondaryspecialty2 CHAR(10),
    secondaryspecialty3 CHAR(10),
    secondaryspecialty4 CHAR(10),
    stateid CHAR(14),
    ohiomedicalid CHAR(14),
    deanumber CHAR(14),
    effectivedate DATE,
    termdate DATE,
    status CHAR(1),
    printflag CHAR(1),
    systemphysicianidnumber CHAR(14),
    phone1 CHAR(14),
    effectivedate1 INTEGER,
    phone2 CHAR(14),
    effectivedate2 INTEGER,
    phone3 CHAR(14),
    effectivedate3 INTEGER,
    individualgroup CHAR(3),
    manualdate DATE,
    filedate DATE,
    zipcode INTEGER
);
