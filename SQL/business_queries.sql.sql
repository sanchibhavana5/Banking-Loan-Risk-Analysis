

/*=========================================
PHASE 2: DATA VALIDATION
=========================================*/



--Validation 1: Total Records
--How many loan applications are available for analysis?

SELECT COUNT(*) AS Total_Loan_Applications
FROM loan_data;

--The dataset contains 9,578 loan applications, which will be used for the loan risk analysis.

---Validation 2: Total Columns
--What information is available in the dataset?
select * from loan_data;

--The dataset contains customer demographics, credit history, loan details, 
--and repayment status, providing sufficient information for credit risk analysis.

--Validation 3: Check Missing Values
--Does the dataset contain any missing values?

SELECT
SUM(CASE WHEN credit_policy IS NULL THEN 1 
ELSE 0 
END) AS credit_policy,
SUM(CASE WHEN purpose IS NULL THEN 1 
ELSE 0 
END) AS purpose,
SUM(CASE WHEN int_rate IS NULL THEN 1 
ELSE 0 
END) AS int_rate,
SUM(CASE WHEN installment IS NULL THEN 1 
ELSE 0 
END) AS installment,
SUM(CASE WHEN log_annual_inc IS NULL THEN 1 
ELSE 0 
END) AS log_annual_inc,
SUM(CASE WHEN dti IS NULL THEN 1 
ELSE 0 
END) AS dti,
SUM(CASE WHEN fico IS NULL THEN 1 
ELSE 0 
END) AS fico,
SUM(CASE WHEN days_with_cr_line IS NULL THEN 1 
ELSE 0 
END) AS days_with_cr_line,
SUM(CASE WHEN revol_bal IS NULL THEN 1 
ELSE 0 
END) AS revol_bal,
SUM(CASE WHEN revol_util IS NULL THEN 1 
ELSE 0 
END) AS revol_util,
SUM(CASE WHEN inq_last_6mths IS NULL THEN 1 
ELSE 0 
END) AS inq_last_6mths,
SUM(CASE WHEN delinq_2yrs IS NULL THEN 1 
ELSE 0 
END) AS delinq_2yrs,
SUM(CASE WHEN pub_rec IS NULL THEN 1 
ELSE 0 
END) AS pub_rec,
SUM(CASE WHEN not_fully_paid IS NULL THEN 1 
ELSE 0 
END) AS not_fully_paid
FROM loan_data;

--Validation 4: Check Duplicate Records

SELECT *,
COUNT(*) AS Duplicate_Count
FROM loan_data
GROUP BY
credit_policy,
purpose,
int_rate,
installment,
log_annual_inc,
dti,
fico,
days_with_cr_line,
revol_bal,
revol_util,
inq_last_6mths,
delinq_2yrs,
pub_rec,
not_fully_paid
HAVING COUNT(*) > 1;


--Validation 5: Min & Max Values
SELECT
MIN(int_rate) AS Min_Interest_Rate,
MAX(int_rate) AS Max_Interest_Rate,
MIN(dti) AS Min_DTI,
MAX(dti) AS Max_DTI,
MIN(fico) AS Min_FICO,
MAX(fico) AS Max_FICO
FROM loan_data;
