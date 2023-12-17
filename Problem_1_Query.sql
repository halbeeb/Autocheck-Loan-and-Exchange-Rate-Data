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

select * from loan_payment;

-- Load the data into the tables created
-- Load data into borrower table as downloaded from google drive
COPY borrower_table FROM 'C:\Users\LENOVO\Desktop\Autochek\Borrower_table.csv' DELIMITER ',' CSV HEADER;

-- Load data into loan table table as downloaded from google drive
COPY loan_table FROM '/path/to/your/loan_table.csv' DELIMITER ',' CSV HEADER;

-- Load data into payment schedule as downloaded from google drive
COPY payment_schedule FROM 'C:\Users\LENOVO\Desktop\Autochek\Payment_Schedule.csv' DELIMITER ',' CSV HEADER;

-- Load data into loan payment as downloaded from google drive
COPY loan_payment FROM 'C:\Users\LENOVO\Desktop\Autochek\Loan_payment.csv' DELIMITER ',' CSV HEADER;


COPY borrower_table (Borrower_id, State, City, zip_code) FROM 'C:\Users\LENOVO\Desktop\Autochek\Borrower_table.csv' WITH (FORMAT csv, HEADER);


select *
from borrower_table;

