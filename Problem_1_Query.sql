--Autocheck Data Engineer Excercise
--Create new datawarehouse and create the database schemas

CREATE DATABASE autochek_db;

-- Create all the tables needed for the data warehouse

CREATE TABLE borrower_table (
    Borrower_id SERIAL PRIMARY KEY,
    State VARCHAR(255),
    City VARCHAR(255),
    zip_code VARCHAR(20)
);

CREATE TABLE loan_table (
    Loan_id SERIAL PRIMARY KEY,
    Borrower_id INT,
    Date_of_release DATE,
    Term INT,
    InterestRate DECIMAL,
    LoanAmount DECIMAL,
    Downpayment DECIMAL,
    Payment_frequency VARCHAR(255),
    Maturity_date DATE,
    FOREIGN KEY (Borrower_id) REFERENCES borrower_table(Borrower_id)
);

CREATE TABLE payment_schedule (
    schedule_id SERIAL PRIMARY KEY,
    loan_id INT,
    Expected_payment_date DATE,
    Expected_payment_amount DECIMAL,
    FOREIGN KEY (loan_id) REFERENCES loan_table(Loan_id)
);

CREATE TABLE loan_payment (
    payment_id SERIAL PRIMARY KEY,
    loan_id INT,
    Amount_paid DECIMAL,
    Date_paid DATE,
    FOREIGN KEY (loan_id) REFERENCES loan_table(Loan_id)
);


