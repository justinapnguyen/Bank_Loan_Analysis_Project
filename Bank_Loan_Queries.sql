SELECT 
    *
FROM
    bank_loan.loan_data;

SELECT 
    COUNT(*)
FROM
    loan_data;

ALTER TABLE loan_data
ADD COLUMN con_issue_date DATE;

-- Converting the date values in the 'issue_date' column into a valid date format and adding the values into the column 'con_issue_date

UPDATE loan_data 
SET 
    con_issue_date = CASE
        WHEN issue_date LIKE '__/__/____' THEN STR_TO_DATE(issue_date, '%d/%m/%Y')
        WHEN issue_date LIKE '__-__-____' THEN STR_TO_DATE(issue_date, '%d-%m-%Y')
        WHEN issue_date LIKE '____-__-__' THEN STR_TO_DATE(issue_date, '%Y-%m-%d')
        ELSE NULL
    END;

SELECT 
    *
FROM
    loan_data;

ALTER TABLE loan_data
DROP COLUMN issue_date;

ALTER TABLE loan_data
CHANGE COLUMN con_issue_date issue_date DATE;

-- Adding column as 'con_date_credit_pull_date' to the table

ALTER table loan_data
ADD column con_last_credit_pull_date DATE;

UPDATE loan_data 
SET 
    con_last_credit_pull_date = CASE
        WHEN last_credit_pull_date LIKE '__/__/____' THEN STR_TO_DATE(last_credit_pull_date, '%d/%m/%Y')
        WHEN last_credit_pull_date LIKE '__-__-____' THEN STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y')
        WHEN last_credit_pull_date LIKE '____-__-__' THEN STR_TO_DATE(last_credit_pull_date, '%Y-%m-%d')
        ELSE NULL
    END;

ALTER TABLE loan_data
DROP COLUMN last_credit_pull_date;

ALTER TABLE loan_data
CHANGE COLUMN con_last_credit_pull_date last_credit_pull_date DATE;

-- Repeating the same steps for the 'next_payment_date' column

ALTER TABLE loan_data
ADD COLUMN con_next_payment_date DATE;

UPDATE loan_data 
SET 
    con_next_payment_date = CASE
        WHEN next_payment_date LIKE '__/__/____' THEN STR_TO_DATE(next_payment_date, '%d/%m/%Y')
        WHEN next_payment_date LIKE '__-__-____' THEN STR_TO_DATE(next_payment_date, '%d-%m-%Y')
        WHEN next_payment_date LIKE '____-__-__' THEN STR_TO_DATE(next_payment_date, '%Y-%m-%d')
        ELSE NULL
    END;

ALTER TABLE loan_data
DROP COLUMN next_payment_date;

ALTER TABLE loan_data
CHANGE COLUMN con_next_payment_date next_payment_date DATE;

-- Repeating the same steps for the 'last_payment_date' column

ALTER TABLE loan_data
ADD COLUMN con_last_payment_date DATE;

UPDATE loan_data 
SET 
    con_last_payment_date = CASE
        WHEN last_payment_date LIKE '__/__/____' THEN STR_TO_DATE(last_payment_date, '%d/%m/%Y')
        WHEN last_payment_date LIKE '__-__-____' THEN STR_TO_DATE(last_payment_date, '%d-%m-%Y')
        WHEN last_payment_date LIKE '____-__-__' THEN STR_TO_DATE(last_payment_date, '%Y-%m-%d')
        ELSE NULL
    END;

ALTER TABLE loan_data
DROP COLUMN last_payment_date;

ALTER TABLE loan_data
CHANGE COLUMN con_last_payment_date last_payment_date DATE;

SELECT 
    *
FROM
    loan_data;

-- Calculating the total applications received

SELECT 
    COUNT(id) AS Total_Loan_Applications
FROM
    loan_data;

-- Calculating MTD total loan applications

SELECT 
    COUNT(id) AS MTD_Total_Loan_Applications
FROM
    loan_data
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021;-- 4314

SELECT 
    COUNT(id) AS PMTD_Total_Loan_Applications
FROM
    loan_data
WHERE
    MONTH(issue_date) = 11
        AND YEAR(issue_date) = 2021; -- 4035

-- Calculating the month over month (MoM) total loan applications

WITH MTD_app AS (
select count(id) as MTD_Total_Loan_Applications
from loan_data
where month(issue_date) = 12 AND year(issue_date) = 2021),
PMTD_app AS (
select count(id) as PMTD_Total_Loan_Applications
from loan_data
where month(issue_date) = 11 AND year(issue_date) = 2021)

select ((MTD.MTD_Total_Loan_Applications - PMTD.PMTD_Total_Loan_Applications)/PMTD.PMTD_Total_Loan_Applications)*100 AS MoM_Total_Loan_Applications
from MTD_app MTD, PMTD_app PMTD;-- 6.9145

SELECT 
    SUM(loan_amount) AS Total_Funded_Amount
FROM
    loan_data;-- 435757075

SELECT 
    SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM
    loan_data
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021;-- 53981425

SELECT 
    SUM(loan_amount) AS PMTD_Total_Funded_Amount
FROM
    loan_data
WHERE
    MONTH(issue_date) = 11
        AND YEAR(issue_date) = 2021; -- 47754825

-- Calculating the MoM Total Funded Amount

WITH MTD_funded AS (
select sum(loan_amount) as MTD_Total_Funded_Amount
from loan_data
where month(issue_date) = 12 AND year(issue_date) = 2021),
PMTD_funded AS (
select sum(loan_amount) as PMTD_Total_Funded_Amount
from loan_data
where month(issue_date) = 11 AND year(issue_date) = 2021)

select ((MTD.MTD_Total_Funded_Amount - PMTD.PMTD_Total_Funded_Amount)/PMTD.PMTD_Total_Funded_Amount)*100 AS MoM_Total_Funded_Amount
from MTD_funded MTD, PMTD_funded PMTD;-- 13.0387

SELECT 
    SUM(total_payment) AS Total_Amount_Received
FROM
    loan_data;-- 473070933

SELECT 
    SUM(total_payment) AS MTD_Total_Amount_Received
FROM
    loan_data
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021;-- 58074380

SELECT 
    SUM(total_payment) AS PMTD_Total_Amount_Received
FROM
    loan_data
WHERE
    MONTH(issue_date) = 11
        AND YEAR(issue_date) = 2021; -- 50132030

-- Calculating the MoM Total Amount Received

WITH MTD_payment AS (
SELECT 
	SUM(total_payment) AS MTD_Total_Amount_Received
FROM 
	loan_data
WHERE 
	MONTH(issue_date) = 12 
		AND YEAR(issue_date) = 2021),
PMTD_payment AS (
SELECT 
	SUM(total_payment) AS PMTD_Total_Amount_Received
FROM 
	loan_data
WHERE 
	MONTH(issue_date) = 11 
		AND YEAR(issue_date) = 2021)

SELECT 
	((MTD.MTD_Total_Amount_Received - PMTD.PMTD_Total_Amount_Received)/PMTD.PMTD_Total_Amount_Received)*100 AS MoM_Total_Amount_Received
FROM 
	MTD_payment MTD, PMTD_payment PMTD;-- 15.8429

SELECT 
    AVG(int_rate) * 100 AS Avg_Interest_Rate
FROM
    loan_data;-- 12.048831397760178

SELECT 
    AVG(int_rate) * 100 AS MTD_Avg_Interest_Rate
FROM
    loan_data
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021;-- 12.356040797403738

SELECT 
    AVG(int_rate) * 100 AS PMTD_Avg_Interest_Rate
FROM
    loan_data
WHERE
    MONTH(issue_date) = 11
        AND YEAR(issue_date) = 2021; -- 11.941717472118796

-- Calculating the MoM Avg Interest Rate

WITH MTD_avg_int AS (
SELECT 
	AVG(int_rate)*100 AS MTD_Avg_Interest_Rate
FROM 
	loan_data
WHERE 
	MONTH(issue_date) = 12 
		AND YEAR(issue_date) = 2021),
PMTD_avg_int AS (
SELECT 
	AVG(int_rate)*100 AS PMTD_Avg_Interest_Rate
FROM 
	loan_data
WHERE 
	MONTH(issue_date) = 11 
		AND YEAR(issue_date) = 2021)

SELECT 
	((MTD.MTD_Avg_Interest_Rate - PMTD.PMTD_Avg_Interest_Rate)/PMTD.PMTD_Avg_Interest_Rate)*100 AS MoM_Avg_Interest_Rate
FROM 
	MTD_avg_int MTD, PMTD_avg_int PMTD;-- 3.469545534403177

SELECT 
    AVG(dti) * 100 AS Avg_DTI
FROM
    loan_data;-- 13.32743311903776

SELECT 
    AVG(dti) * 100 AS MTD_Avg_DTI
FROM
    loan_data
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021;-- 13.66553778395922

SELECT 
    AVG(dti) * 100 AS PMTD_Avg_DTI
FROM
    loan_data
WHERE
    MONTH(issue_date) = 11
        AND YEAR(issue_date) = 2021; -- 13.302733581164853

-- Calculating the MoM Avg DTI

WITH MTD_DTI AS (
SELECT
	AVG(dti)*100 AS MTD_Avg_DTI
FROM
	loan_data
WHERE
	MONTH(issue_date) = 12 
		AND YEAR(issue_date) = 2021),
PMTD_DTI AS (
SELECT
	AVG(dti)*100 AS PMTD_Avg_DTI
FROM
	loan_data
WHERE
	MONTH(issue_date) = 11 
		AND YEAR(issue_date) = 2021)

SELECT
	((MTD.MTD_Avg_DTI - PMTD.PMTD_Avg_DTI)/PMTD.PMTD_Avg_DTI)*100 AS MoM_Avg_DTI
FROM
	MTD_DTI MTD, PMTD_DTI PMTD;-- 2.727290602196649

SELECT 
    (COUNT(CASE
        WHEN
            loan_status = 'Fully Paid'
                OR loan_status = 'Current'
        THEN
            id
    END) * 100) / COUNT(id) AS Good_Loan_Percentage
FROM
    loan_data;-- 86.1753

SELECT 
    COUNT(id) AS Good_Loan_Applications
FROM
    loan_data
WHERE
    loan_status = 'Fully Paid'
        OR loan_status = 'Current';-- 33243

SELECT 
    SUM(loan_amount) AS Good_Loan_Funded_Amount
FROM
    loan_data
WHERE
    loan_status = 'Fully Paid'
        OR loan_status = 'Current';-- 370224850

SELECT 
    SUM(total_payment) AS Good_Loan_Amount_Received
FROM
    loan_data
WHERE
    loan_status = 'Fully Paid'
        OR loan_status = 'Current';-- 435786170

SELECT 
    (COUNT(CASE
        WHEN loan_status = 'Charged Off' THEN id
    END) * 100) / COUNT(id) AS Bad_Loan_Percentage
FROM
    loan_data;-- 13.8247

SELECT 
    COUNT(id) AS Bad_Loan_Applications
FROM
    loan_data
WHERE
    loan_status = 'Charged Off';-- 5333

SELECT 
    SUM(loan_amount) AS Bad_Loan_Funded_Amount
FROM
    loan_data
WHERE
    loan_status = 'Charged Off';-- 65532225

SELECT 
    SUM(total_payment) AS Bad_Loan_Amount_Received
FROM
    loan_data
WHERE
    loan_status = 'Charged Off';-- 37284763
    
SELECT 
    loan_status,
    COUNT(id) AS Loan_Count,
    SUM(total_payment) AS Total_Amount_Received,
    SUM(loan_amount) AS Total_Funded_Amount,
    AVG(int_rate) * 100 AS Interest_Rate,
    AVG(dti) * 100 AS DTI
FROM
    loan_data
GROUP BY loan_status;

-- Calculating MTD_Total_Amount_Received, MTD_Total_Funded_Amount based on loan_status

SELECT 
    loan_status,
    SUM(total_payment) AS MTD_Total_Amount_Received,
    SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM
    loan_data
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021
GROUP BY loan_status;

-- Calculating monthly Total_Loan_Applications, Total_Funded_Amount, and Total_Amount_Received
-- BANK LOAN REPORT | OVERVIEW - MONTH

SELECT 
    MONTH(issue_date) AS Month_Number,
    MONTHNAME(issue_date) AS Month_Name,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM
    loan_data
GROUP BY MONTH(issue_date) , MONTHNAME(issue_date)
ORDER BY MONTH(issue_date);

-- BANK LOAN REPORT | OVERVIEW - STATE

SELECT 
    address_state AS State,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM
    loan_data
GROUP BY address_state
ORDER BY address_state;

-- BANK LOAN REPORT | OVERVIEW - TERM

SELECT 
    term AS Term,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM
    loan_data
GROUP BY term
ORDER BY term;

-- BANK LOAN REPORT | OVERVIEW - EMPLOYEE LENGTH

SELECT 
    emp_length AS Employee_Length,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM
    loan_data
GROUP BY emp_length
ORDER BY emp_length;

-- BANK LOAN REPORT | OVERVIEW - PURPOSE

SELECT 
    purpose AS Purpose_of_Loan,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM
    loan_data
GROUP BY purpose
ORDER BY purpose;

-- BANK LOAN REPORT | OVERVIEW - HOME OWNERSHIP

SELECT 
    home_ownership AS Home_Ownership,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM
    loan_data
GROUP BY home_ownership
ORDER BY home_ownership;