/*=========================================
 BANKING LOAN RISK & CUSTOMER ANALYTICS
=========================================*/


/*=========================================
PHASE 1: DATABASE SETUP
=========================================*/

create database loan_risk_analysis;
use loan_risk_analysis;


CREATE TABLE loan_data (
    credit_policy BIT,
    purpose VARCHAR(50),
    int_rate DECIMAL(5,4),
    installment DECIMAL(10,2),
    log_annual_inc DECIMAL(10,4),
    dti DECIMAL(10,2),
    fico INT,
    days_with_cr_line DECIMAL(10,2),
    revol_bal INT,
    revol_util DECIMAL(5,2),
    inq_last_6mths INT,
    delinq_2yrs INT,
    pub_rec INT,
    not_fully_paid BIT
);


SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='loan_data';