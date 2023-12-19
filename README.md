### Autocheck Loan and Exchange Rate Data

> This repository proffers solutions to the two main problems; first being being loan payment at risk and 
second being the exchange rate of 7 countries data scheduler pulling data from XE currency data exchange.

## Problem Statement 1, 

This [SQL script](Problem_1_Query.sql) is a comprehensive SQL setup for creating a data warehouse for Autochek's loan management system. It includes the creation of a new database, the definition of necessary tables, and the loading of data from CSV files. Additionally, it contains queries for calculating PAR Days and generating a detailed report. Here's a breakdown and explanation of the script:

### Database Creation
- `CREATE DATABASE autochek_db;`: This command creates a new database named `autochek_db`.

### Table Definitions
1. [Borrower Table](Borrower_table.csv): Holds borrower information. Includes columns for borrower ID, state, city, zip code, and credit score.
2. [Loan Payment](Loan_payment.csv): Records actual payments made against loans.
3. [Loan Table](Loan_table.csv): Contains details about loans. Includes foreign key relationship with `borrower_table`.
4. [Payment Schedule](Payment_Schedule.csv): Stores payment schedules for each loan.

These were used to create schema and populate the data wareshouse created in Postgres 15.
The relationship between these table are capture in below:

[Loan Data Entity Relationship Diagram](Autochek ERD.png)

### Data Loading
- The `COPY` commands are used to load data into each table from CSV files stored on a local machine. These commands are specific to PostgreSQL and rely on the CSV files being formatted correctly.

### Calculating PAR Days
This [solution 1 query](Problem_1_Query.sql) was used to generate data for *Loan Payment at Risk* based on the informational schema
as it simulated the query to achieve the end results. The resulting output is [Loan PAR Days xlsx](Loan Par Days Calculation.xlsx) or
[Loan PAR Days csv](Loan Par Days Calculation.xlsx)

### Running the Script
1. Connect to your PostgreSQL server using a client like pgAdmin or the psql command-line tool.
2. Execute each command in the script sequentially.
3. Verify that the data is loaded correctly and that the queries return the expected results.

*This script provides a solid foundation for managing and analyzing loan-related data within Autochek's system.*



## Problem Statement 2
Based on the stakeholder's requirement to get all our exchange rate from one source, code up a script that gets the rate of 7 countries 
and a scheduler to pull this rate 2 times a day, first at 1am and second at 11pm while keeping the rates saved per day meaning, 
no duplicate records for a single date.

## Overview
This Python script name [#Autochek Country Currencies.py](#Autochek Country Currencies.py) automatically fetches exchange rates for seven specific currencies relative to the US Dollar (USD) from the XE Currency Data API. It is scheduled to perform this task twice a day, at 1 AM and 11 PM, and saves the data in a CSV file.

## Dependencies
The script requires the following Python packages:
- `requests`: For making HTTP requests to the XE API.
- `datetime`: For timestamping each data entry.
- `pandas`: For data manipulation and saving the data to a CSV file.
- `schedule`: For scheduling the script to run at specified times.
- `time`: For creating a delay in the while loop.

## Functionality

### fetch_exchange_rates Function
This function is the core of the script. It performs the following tasks:
1. Makes a GET request to the XE Currency Data API to fetch the latest exchange rates.
2. Parses the JSON response to extract the required data.
3. Creates a list of exchange rates, including the timestamp, base currency (USD), exchange rate to and from USD, and the target currency code.
4. Converts this list into a pandas DataFrame.
5. Appends the DataFrame to a CSV file named `exchange_rates.csv`.

### Scheduling
The script uses the `schedule` package to run the `fetch_exchange_rates` function at two specific times each day:
- 1:00 AM
- 11:00 PM

### Infinite Loop
A while loop runs indefinitely, executing scheduled tasks at their defined times and sleeping for 1 second between each iteration.

## Usage Instructions

1. **Install Required Packages**: Ensure all required packages are installed. You can install them using pip:
   ```bash
   pip install requests datetime pandas schedule
   ```
2. **Set API Key**: Replace `[Your-API-Key]` in the `headers` dictionary with your actual XE Currency Data API key.

3. **Running the Script**: Execute the script in a Python environment. It will continue running and will execute the scheduled tasks at the specified times.

4. **Output**: The exchange rate data is saved in `exchange_rates.csv` in the script's directory. The file is appended with new data at each scheduled run.

## Limitions Encountered Due to XE API

 **I was unable to test out my Python script that was written to generate exchange rate data for 7 countries whose Autochek is present it
 due payment issues I had. I made several attempts to use the 7-day trial to generate the data and I input my international debit card, XE made attempt to deduct $799.00 
 from my card which was declined and subsquent attempts were equally denied by the card issuing company** 
 Below is the screenshot of failed attempt to get the API:
 [Failed XE Tranx.png](Failed XE Tranx.png).

**Authored by: 
Habeeb Adewale Abdulrasaq**
 

