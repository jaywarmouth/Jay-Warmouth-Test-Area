# cloud_data_warehouse.upipatientmatchresults

> **Schema:** cloud_data_warehouse | **Columns:** 45

## Overview

_Add business description here._

## Columns

| # | Column | Data Type | Nullable | Default | Notes |
|---|--------|-----------|----------|---------|-------|
| 1 | meta_sur_key | VARCHAR(256) | YES |  |  |
| 2 | facilityid | VARCHAR(25) | YES |  |  |
| 3 | sourcesystemid | VARCHAR(25) | YES |  |  |
| 4 | personid | CHAR(10) | YES |  |  |
| 5 | enterprisepersonnumber | CHAR(20) | NO |  | Required |
| 6 | patientsourceissuer | INTEGER | YES |  |  |
| 7 | firstname | CHAR(15) | NO |  | Required |
| 8 | middlename | CHAR(1) | NO |  | Required |
| 9 | lastname | CHAR(20) | NO |  | Required |
| 10 | namesuffix | VARCHAR(25) | YES |  |  |
| 11 | dob | DATE | NO |  | Required |
| 12 | ssn | VARCHAR(25) | NO |  | Required |
| 13 | gender | CHAR(1) | NO |  | Required |
| 14 | maritalstatus | VARCHAR(25) | YES |  |  |
| 15 | emailaddress | VARCHAR(35) | YES |  |  |
| 16 | addressline1 | CHAR(40) | NO |  | Required |
| 17 | addressline2 | CHAR(40) | NO |  | Required |
| 18 | city | CHAR(20) | NO |  | Required |
| 19 | state | CHAR(2) | NO |  | Required |
| 20 | country | VARCHAR(25) | YES |  |  |
| 21 | zipcode | VARCHAR(5) | NO |  | Required |
| 22 | primaryindicator | VARCHAR(25) | YES |  |  |
| 23 | phonenumber | VARCHAR(25) | YES |  |  |
| 24 | mrn | VARCHAR(25) | YES |  |  |
| 25 | hic | VARCHAR(25) | YES |  |  |
| 26 | driverslicensenumber | VARCHAR(25) | YES |  |  |
| 27 | driverslicensestate | VARCHAR(25) | YES |  |  |
| 28 | patientinsurancememberid | CHAR(10) | YES |  |  |
| 29 | patientinsurancegroupid | CHAR(20) | YES |  |  |
| 30 | patientinsurancefamilysequence | CHAR(2) | YES |  |  |
| 31 | patientinsurancerelationshipcode | VARCHAR(2) | YES |  |  |
| 32 | insurancerxbinnumber | VARCHAR(25) | YES |  |  |
| 33 | additionalcpi1 | VARCHAR(25) | YES |  |  |
| 34 | additionalcpi2 | VARCHAR(25) | YES |  |  |
| 35 | additionalcpi3 | VARCHAR(25) | YES |  |  |
| 36 | additionalcpi4 | VARCHAR(25) | YES |  |  |
| 37 | additionalcpi5 | VARCHAR(25) | YES |  |  |
| 38 | upi | VARCHAR(40) | YES |  |  |
| 39 | lid | VARCHAR(40) | YES |  |  |
| 40 | matchscore | VARCHAR(40) | YES |  |  |
| 41 | pdmisubmitdate | TIMESTAMP | YES |  |  |
| 42 | pdmisubmitfilename | VARCHAR(100) | YES |  |  |
| 43 | expreturndate | TIMESTAMP | YES |  |  |
| 44 | expreturnfilename | VARCHAR(100) | YES |  |  |
| 45 | meta_eff_date | TIMESTAMP | YES |  |  |
