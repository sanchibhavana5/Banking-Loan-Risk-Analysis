
/*=========================================
PHASE 3: SQL BUSINESS ANALYSIS
=========================================*/

--Module 1: Portfolio Overview

--- Business Query 1:How many loan applications has the company received?

SELECT COUNT(*) AS Total_Loan_Applications
FROM loan_data;

-- Business Insight:
-- The company has received a total of 9,578 loan applications.
-- This represents the total loan portfolio analyzed and serves as the
-- foundation for evaluating loan performance and customer risk.


-- Business Query 2: How many customers fully repaid their loans, and how many defaulted?
SELECT
    not_fully_paid,
    COUNT(*) AS Total_Customers
FROM loan_data
GROUP BY not_fully_paid;

-- Business Insight:
-- Out of 9,578 loan applications, 8,045 customers successfully
-- repaid their loans, while 1,533 customers defaulted.
-- This indicates that the majority of borrowers fulfilled their
-- repayment obligations.


--Business Query 3 Overall Loan Default Rate?

SELECT
    COUNT(*) AS Total_Loans,
    COUNT(CASE WHEN not_fully_paid = 1 THEN 1 END) AS Defaulted_Loans,
    ROUND(
        COUNT(CASE WHEN not_fully_paid = 1 THEN 1 END) * 100.0 / COUNT(*),
        2
    ) AS Default_Rate_Percentage
FROM loan_data;


-- Business Insight:
-- The overall loan default rate is approximately 16%, meaning
-- about 1 out of every 6 borrowers failed to fully repay their loan.
-- This KPI helps the bank evaluate the overall credit risk of its
-- lending portfolio.


--Business Query 4 What percentage of customers successfully repaid their loans?

SELECT
    COUNT(*) AS Total_Loans,
    COUNT(CASE WHEN not_fully_paid = 0 THEN 1 END) AS Fully_Paid_Loans,
    ROUND(
        COUNT(CASE WHEN not_fully_paid = 0 THEN 1 END) * 100.0 / COUNT(*),
        2
    ) AS Repayment_Rate_Percentage
FROM loan_data;


-- Business Insight:
-- Out of 9,578 loan applications, 8,045 customers fully repaid
-- their loans, resulting in an overall repayment rate of
-- approximately 84%. This indicates that the majority of
-- borrowers successfully met their repayment obligations.

--Business Query 5 How many customers defaulted on their loans?


SELECT
    COUNT(*) AS Total_Defaulted_Loans
FROM loan_data
WHERE not_fully_paid = 1;

-- Business Insight:
-- A total of 1,533 customers failed to fully repay their loans.
-- This represents the high-risk segment of the loan portfolio.

--Module 2: Customer Risk Analysis

--Business Query 6 Do customers with higher FICO scores have lower default rates?


SELECT
    not_fully_paid,
    ROUND(AVG(fico), 2) AS Average_FICO
FROM loan_data
GROUP BY not_fully_paid;

-- Business Insight:
-- Customers who fully repaid their loans had an average FICO score of 713,
-- whereas customers who defaulted had an average FICO score of 693.
-- This indicates that borrowers with higher credit scores are less likely
-- to default, making FICO an important factor in loan approval decisions.


--Business Query 7  Do customers with higher Debt-to-Income (DTI) ratios default more?

SELECT
    not_fully_paid,
    ROUND(AVG(dti), 2) AS Average_DTI
FROM loan_data
GROUP BY not_fully_paid;

-- Business Insight:
-- Customers who defaulted had a higher average Debt-to-Income (DTI) ratio
-- of 13.20 compared to 12.49 for customers who fully repaid their loans.
-- This suggests that customers with higher debt burdens are more likely
-- to default, making DTI an important factor in credit risk assessment.


--Business Query 8 Does meeting the lender's credit policy reduce loan defaults?

SELECT
    credit_policy,
    not_fully_paid,
    COUNT(*) AS Total_Customers
FROM loan_data
GROUP BY
    credit_policy,
    not_fully_paid
ORDER BY
    credit_policy,
    not_fully_paid;

-- Business Insight:
-- Customers who did not meet the lender's credit policy had a default rate
-- of 27.78%, whereas customers who met the credit policy had a much lower
-- default rate of 13.15%. This shows that the lender's credit policy is
-- effective in identifying lower-risk borrowers and reducing loan defaults.


--Business Query 9 Which FICO score category has the highest number of loan defaults?


SELECT
    CASE
        WHEN fico >= 800 THEN 'Excellent'
        WHEN fico >= 740 THEN 'Very Good'
        WHEN fico >= 670 THEN 'Good'
        WHEN fico >= 580 THEN 'Fair'
        ELSE 'Poor'
    END AS FICO_Category,

    COUNT(*) AS Total_Customers,

    SUM(CASE WHEN not_fully_paid = 1 THEN 1 ELSE 0 END) AS Defaulted_Customers,

    ROUND(
        SUM(CASE WHEN not_fully_paid = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS Default_Rate_Percentage

FROM loan_data

GROUP BY
    CASE
        WHEN fico >= 800 THEN 'Excellent'
        WHEN fico >= 740 THEN 'Very Good'
        WHEN fico >= 670 THEN 'Good'
        WHEN fico >= 580 THEN 'Fair'
        ELSE 'Poor'
    END

ORDER BY Default_Rate_Percentage DESC;

-- Business Insight:
-- Customers in the Fair FICO category have the highest loan default risk,
-- while customers with Excellent and Very Good FICO scores have the lowest
-- default risk. This confirms that stronger credit scores are associated
-- with better repayment behavior and lower lending risk.

--Business Query 10 Who are the high-risk customers?


SELECT
    fico,
    dti,
    revol_util,
    purpose,
    int_rate,
    not_fully_paid
FROM loan_data
WHERE
    fico < 700
    AND dti > 15
    AND revol_util > 70
ORDER BY fico ASC;

-- Business Insight:
-- Customers with low FICO scores, high DTI, and high revolving credit utilization
-- represent a high-risk segment. These borrowers are more likely to default and
-- should be monitored more closely during the loan approval process.

--Module 3: Loan Analysis

--Business Query 11 Which loan purpose has the highest default rate?
SELECT
    purpose,
    COUNT(*) AS Total_Loans,
    SUM(CASE WHEN not_fully_paid = 1 THEN 1 ELSE 0 END) AS Defaulted_Loans,
    ROUND(
        SUM(CASE WHEN not_fully_paid = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS Default_Rate_Percentage
FROM loan_data
GROUP BY purpose
ORDER BY Default_Rate_Percentage DESC;

-- Business Insight:
-- Small Business loans have the highest default rate (27.79%),
-- followed by Educational loans (20.12%). In contrast, Major Purchase
-- and Credit Card loans have the lowest default rates, indicating
-- lower credit risk. The bank should closely monitor higher-risk loan
-- categories and consider stricter approval criteria for these purposes.

--Business Query 12 Do higher interest rates lead to more loan defaults?

SELECT
    not_fully_paid,
    ROUND(AVG(int_rate) * 100, 2) AS Average_Interest_Rate_Percentage
FROM loan_data
GROUP BY not_fully_paid;

-- Business Insight:
-- Customers who defaulted on their loans paid a higher average interest
-- rate (13.25%) compared to customers who successfully repaid their loans
-- (12.08%). This suggests that higher interest rates are associated with
-- higher default risk, indicating that riskier borrowers are typically
-- charged higher interest rates.

--Business Query 13 Do customers with higher loan installments default more?

SELECT
    not_fully_paid,
    ROUND(AVG(installment), 2) AS Average_Installment
FROM loan_data
GROUP BY not_fully_paid;

-- Business Insight:
-- Customers who defaulted on their loans had a higher average monthly
-- installment (342.79) compared to customers who fully repaid their
-- loans (314.57). This suggests that higher monthly repayment obligations
-- may increase the likelihood of loan default.

--Business Query 14 Do customers with higher annual income have lower loan default rates?

SELECT
    not_fully_paid,
    ROUND(AVG(log_annual_inc), 2) AS Average_Log_Annual_Income
FROM loan_data
GROUP BY not_fully_paid;

-- Business Insight:
-- Customers who fully repaid their loans had a slightly higher
-- average annual income (log value: 10.94) compared to customers
-- who defaulted (log value: 10.89). This suggests that borrowers
-- with higher incomes may have a better ability to repay loans,
-- although the difference in this dataset is relatively small.

--Business Query 15 Which loan purpose is the safest for the bank?

SELECT
    purpose,
    COUNT(*) AS Total_Loans,
    SUM(CASE WHEN not_fully_paid = 1 THEN 1 ELSE 0 END) AS Defaulted_Loans,
    CAST(
        ROUND(
            SUM(CASE WHEN not_fully_paid = 1 THEN 1 ELSE 0 END) * 100.0
            / COUNT(*),
            2
        ) AS DECIMAL(5,2)
    ) AS Default_Rate_Percentage
FROM loan_data
GROUP BY purpose
ORDER BY Default_Rate_Percentage ASC;

-- Business Insight:
-- Major Purchase loans have the lowest default rate (11.21%),
-- followed by Credit Card loans (11.57%), making them the safest
-- loan categories in the portfolio. In contrast, Small Business
-- loans have the highest default rate (27.79%) and require
-- stricter credit evaluation.

--Module 4  Credit Behaviour Analysis
--Business Query 16 Do customers with higher revolving balances default more?


SELECT
    not_fully_paid,
    ROUND(AVG(revol_bal), 2) AS Average_Revolving_Balance
FROM loan_data
GROUP BY not_fully_paid;

-- Business Insight:
-- Customers who defaulted had a higher average revolving balance
-- (21,066) compared to customers who fully repaid their loans
-- (16,122). This indicates that borrowers carrying larger
-- outstanding credit balances are more likely to default,
-- making revolving balance an important credit risk indicator.


--Business Query 17 Do customers with higher revolving credit utilization default more?

SELECT
    not_fully_paid,
    ROUND(AVG(revol_util), 2) AS Average_Revolving_Utilization
FROM loan_data
GROUP BY not_fully_paid;

-- Business Insight:
-- Customers who defaulted had a higher average revolving credit
-- utilization (52.26%) compared to customers who fully repaid
-- their loans (45.76%). This suggests that borrowers using a
-- larger portion of their available credit are more likely to
-- default, making credit utilization an important risk indicator.


--Business Query 18 Do customers with more recent credit inquiries default more?

SELECT
    not_fully_paid,
    ROUND(AVG(inq_last_6mths), 2) AS Average_Credit_Inquiries
FROM loan_data
GROUP BY not_fully_paid;

-- Business Insight:
-- Customers who defaulted had an average of 2 credit inquiries
-- in the last six months, compared to an average of 1 inquiry
-- for customers who fully repaid their loans. This suggests that
-- borrowers with more frequent recent credit inquiries are more
-- likely to default, making credit inquiries a useful indicator
-- of credit risk.


--Business Query 19 Do customers with previous delinquencies default more?

SELECT
    not_fully_paid,
    AVG(CAST(delinq_2yrs AS DECIMAL(10,2))) AS Average_Previous_Delinquencies
FROM loan_data
GROUP BY not_fully_paid;

-- Business Insight:
-- The average number of previous delinquencies is very low for both
-- fully paid and defaulted customers. This suggests that previous
-- delinquencies alone do not strongly differentiate borrowers in
-- this dataset and should be analyzed together with other risk factors
-- such as FICO score, DTI, and credit utilization.


--Business Query 20 Do customers with public records default more?

SELECT
    not_fully_paid,
    ROUND(AVG(pub_rec), 2) AS Average_Public_Records
FROM loan_data
GROUP BY not_fully_paid;

-- Business Insight:
-- The average number of public records is very low for both
-- fully paid and defaulted customers. This indicates that
-- negative public records are relatively uncommon in this
-- dataset and, by themselves, are not a strong indicator of
-- loan default risk.

--Advanced SQL (Module 5)

--Business Query 21 Which loan purpose has the highest default rate? (Using a CTE)

WITH LoanPurposeSummary AS
(
    SELECT
        purpose,
        COUNT(*) AS Total_Loans,
        SUM(CASE WHEN not_fully_paid = 1 THEN 1 ELSE 0 END) AS Defaulted_Loans,
        CAST(
            ROUND(
                SUM(CASE WHEN not_fully_paid = 1 THEN 1 ELSE 0 END) * 100.0
                / COUNT(*),
                2
            ) AS DECIMAL(5,2)
        ) AS Default_Rate
    FROM loan_data
    GROUP BY purpose
)

SELECT *
FROM LoanPurposeSummary
ORDER BY Default_Rate DESC;

-- Business Insight:
-- The CTE produces the same business result as the previous query
-- but with improved readability and maintainability. Using CTEs
-- makes complex SQL queries easier to understand and modify.


--Business Query 22 Identify the top 10 highest-risk customers based on Debt-to-Income ratio (DTI).

SELECT *
FROM (
    SELECT
        fico,
        dti,
        revol_util,
        int_rate,
        not_fully_paid,

        ROW_NUMBER() OVER (
            ORDER BY dti DESC
        ) AS risk_rank

    FROM loan_data
) ranked_customers
WHERE risk_rank <= 10;

-- Business Insight:
-- The top 10 customers with highest DTI represent the highest-risk
-- segment in the loan portfolio. These borrowers should be closely
-- monitored or subjected to stricter credit checks.


--Business Query 23 Rank customers based on risk using multiple credit factors (DTI + FICO).

SELECT
    fico,
    dti,
    revol_util,
    int_rate,
    not_fully_paid,

    (dti * 0.5 + revol_util * 0.3 + (700 - fico) * 0.2) AS risk_score,

    RANK() OVER (
        ORDER BY (dti * 0.5 + revol_util * 0.3 + (700 - fico) * 0.2) DESC
    ) AS risk_rank

FROM loan_data;


-- Business Insight:
-- The risk ranking system combines multiple credit factors
-- (DTI, revol_util, and FICO) to identify high-risk borrowers.
-- Customers with higher risk scores should be monitored closely
-- or considered for stricter loan approval criteria.

--Business Query 24 Find the Top 10 High-Risk Customers using DENSE_RANK()

SELECT *
FROM (
    SELECT
        fico,
        dti,
        revol_util,
        int_rate,
        not_fully_paid,

        (dti * 0.5 + revol_util * 0.3 + (700 - fico) * 0.2) AS risk_score,

        DENSE_RANK() OVER (
            ORDER BY (dti * 0.5 + revol_util * 0.3 + (700 - fico) * 0.2) DESC
        ) AS risk_rank

    FROM loan_data
) ranked_customers
WHERE risk_rank <= 10
ORDER BY risk_rank;

-- Business Insight:
-- DENSE_RANK ensures continuous risk grouping without gaps,
-- making it ideal for credit risk segmentation. The top-ranked
-- customers represent the highest-risk borrowers based on
-- combined financial indicators (DTI, FICO, and utilization).


--Business Query 25  Segment customers into High, Medium, and Low risk groups

SELECT
    fico,
    dti,
    revol_util,

    CASE
        WHEN (dti * 0.5 + revol_util * 0.3 + (700 - fico) * 0.2) >= 80 THEN 'High Risk'
        WHEN (dti * 0.5 + revol_util * 0.3 + (700 - fico) * 0.2) >= 50 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_segment

FROM loan_data;

-- Business Insight:
-- Customers are grouped into risk categories based on combined credit behavior.
-- High Risk customers require stricter lending rules or rejection.
-- Medium Risk customers may require higher interest rates.
-- Low Risk customers are ideal for loan approval.


--Business Query 26 Find Top 10 highest-risk customers

SELECT *
FROM (
    SELECT
        fico,
        dti,
        revol_util,

        (dti * 0.5 + revol_util * 0.3 + (700 - fico) * 0.2) AS risk_score,

        DENSE_RANK() OVER (
            ORDER BY (dti * 0.5 + revol_util * 0.3 + (700 - fico) * 0.2) DESC
        ) AS risk_rank

    FROM loan_data
) t
WHERE risk_rank <= 10;

-- Business Insight:
-- Top 10 customers represent the most financially stressed borrowers.
-- These accounts should be reviewed before loan approval or renewal.


--Business Query 27 Find customers whose DTI is above average using subquery

SELECT *
FROM loan_data
WHERE dti >
(
    SELECT AVG(dti)
    FROM loan_data
);

-- Business Insight:
-- Customers above average DTI represent higher financial burden
-- and increased probability of default.


--Business Query 28 Combine multiple rules to identify high-risk borrowers

SELECT
    fico,
    dti,
    revol_util,
    inq_last_6mths,
    delinq_2yrs,

    CASE
        WHEN fico < 650 AND dti > 20 AND revol_util > 70 THEN 'VERY HIGH RISK'
        WHEN fico < 700 AND dti > 15 THEN 'HIGH RISK'
        WHEN dti BETWEEN 10 AND 15 THEN 'MEDIUM RISK'
        ELSE 'LOW RISK'
    END AS risk_category

FROM loan_data;


-- Business Insight:
-- This model classifies borrowers into risk tiers using a rule-based
-- credit scoring logic combining FICO score, Debt-to-Income ratio (DTI),
-- and revolving credit utilization.

-- VERY HIGH RISK customers show multiple stress signals simultaneously
-- (low credit score, high debt burden, and high credit utilization),
-- indicating a significantly higher probability of default.

-- HIGH RISK customers may not meet all extreme conditions but still
-- exhibit weak credit strength, requiring stricter underwriting.

-- MEDIUM RISK customers show moderate financial stress and may require
-- adjusted loan terms such as higher interest rates or lower loan amounts.

-- LOW RISK customers represent stable borrowers suitable for standard
-- loan approval with minimal restrictions.

