--Autocheck Data Engineer Excercise
--Create new datawarehouse and create the database schemas

CREATE DATABASE autochek_db;

-- Create all the tables needed for the data warehouse
-- Define the database schema and tables to house the database

CREATE TABLE borrower_table (
    Borrower_Id VARCHAR(50) PRIMARY KEY,
    State VARCHAR(50),
    City VARCHAR(50),
    Zip_Code VARCHAR(10),
    Borrower_Credit_Score text
);

-- Create loan table that house information about the loan issued to borrowers
CREATE TABLE loan_table (
    Loan_id VARCHAR(50) PRIMARY KEY,
    Borrower_id VARCHAR(50),
    Date_of_release DATE,
    Term INT,
    InterestRate DECIMAL,
    LoanAmount DECIMAL,
    Downpayment DECIMAL,
    Payment_frequency VARCHAR(255),
    Maturity_date DATE,
    FOREIGN KEY (Borrower_id) REFERENCES borrower_table(Borrower_id)
);

--Create a table show infomation about how borrower pay their principal and their loan periodically
CREATE TABLE payment_schedule (
    schedule_id VARCHAR(50) PRIMARY KEY,
    loan_id VARCHAR(50),
    Expected_payment_date DATE,
    Expected_payment_amount DECIMAL,
    FOREIGN KEY (loan_id) REFERENCES loan_table(Loan_id)
);

-- Create a table that show infomation about the borrower's loan payments 
CREATE TABLE loan_payment (
    payment_id VARCHAR(50) PRIMARY KEY,
    loan_id VARCHAR(50),
    Amount_paid DECIMAL,
    Date_paid DATE,
    FOREIGN KEY (loan_id) REFERENCES loan_table(Loan_id)
);

-- Load the data into the tables created
-- Load data into borrower table as downloaded from google drive

COPY public.borrower_table (borrower_id, state, city, zip_code, borrower_credit_score) 
FROM 'C:/Users/LENOVO/Desktop/Autochek/BORROWER_TABLE.CSV' 
DELIMITER ',' 
CSV HEADER 
QUOTE '"';

COPY public.loan_table (loan_id, borrower_id, date_of_release, term, interestrate, loanamount, downpayment, payment_frequency, maturity_date) 
FROM 'C:/Users/LENOVO/Desktop/Autochek/LOAN_TABLE.CSV' 
DELIMITER ',' 
CSV HEADER 
QUOTE '"';

COPY public.payment_schedule (schedule_id, loan_id, expected_payment_date, expected_payment_amount) 
FROM 'C:/Users/LENOVO/Desktop/Autochek/PAYMENT_SCHEDULE.CSV' 
DELIMITER ',' 
CSV HEADER 
QUOTE '"';

COPY public.loan_payment (payment_id, loan_id, amount_paid, date_paid) 
FROM 'C:/Users/LENOVO/Desktop/Autochek/LOAN_PAYMENT.CSV' 
DELIMITER ',' 
CSV HEADER 
QUOTE '"';

/*
Calculate PAR Days - Par Days means the number of days the loan was not paid in full. 
E.g., If the loan repayment was due on the 10th Feb 2022 and payment was made on the 15th Feb 2022 
the par days would be 5 days*/

-- Write out queries that profer solutions to the problem statement 1

SELECT
  b.Borrower_id,
  b.State,
  b.City,
  b.zip_code,
  l.Loan_id,
  l.Date_of_release,
  l.Term,
  l.InterestRate,
  l.LoanAmount,
  l.Downpayment,
  l.Payment_frequency,
  l.Maturity_date,
  ps.Expected_payment_date,
  ps.Expected_payment_amount,
  lp.Date_paid,
  lp.Amount_paid,
  (lp.Date_paid - ps.Expected_payment_date) AS PAR_Days,
  SUM(ps.Expected_payment_amount) OVER (PARTITION BY l.Loan_id ORDER BY ps.Expected_payment_date RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_Amount_Due,
  SUM(lp.Amount_paid) OVER (PARTITION BY l.Loan_id ORDER BY lp.Date_paid RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_Amount_Paid,
  CASE
    WHEN lp.Date_paid > ps.Expected_payment_date THEN SUM(ps.Expected_payment_amount) OVER (PARTITION BY l.Loan_id ORDER BY ps.Expected_payment_date RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) - SUM(lp.Amount_paid) OVER (PARTITION BY l.Loan_id ORDER BY lp.Date_paid RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
    ELSE 0
  END AS Amount_at_Risk
FROM
  borrower_table b
JOIN
  loan_table l ON b.Borrower_id = l.Borrower_id
LEFT JOIN
  payment_schedule ps ON l.Loan_id = ps.loan_id
LEFT JOIN
  loan_payment lp ON l.Loan_id = lp.loan_id
ORDER BY
  b.Borrower_id, l.Loan_id, ps.Expected_payment_date;