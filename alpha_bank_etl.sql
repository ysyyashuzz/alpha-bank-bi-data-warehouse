-- Step 1: Create Dimension Tables

CREATE TABLE dim_customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    occupation VARCHAR(50),
    marital_status VARCHAR(20),
    education VARCHAR(50),
    credit_score INT
);

CREATE TABLE dim_branch (
    branch_id VARCHAR(10) PRIMARY KEY,
    region VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE dim_date (
    date_id DATE PRIMARY KEY,
    day INT,
    month INT,
    year INT
);

-- Step 2: Create Fact Table

CREATE TABLE fact_loan (
    loan_id INT PRIMARY KEY,
    customer_id INT,
    branch_id VARCHAR(10),
    date_id DATE,
    loan_amount DECIMAL(12,2),
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    FOREIGN KEY (branch_id) REFERENCES dim_branch(branch_id),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id)
);

-- Step 3: Simulated Insert Data

INSERT INTO dim_customer VALUES
(101, 'Alice', 'Engineer', 'Single', 'Graduate', 720),
(102, 'Bob', 'Teacher', 'Married', 'Postgraduate', 680),
(103, 'Carol', 'Doctor', 'Single', 'Graduate', 610);

INSERT INTO dim_branch VALUES
('NY001', 'Northeast', 'New York'),
('PA002', 'Mid-Atlantic', 'Philadelphia');

INSERT INTO dim_date VALUES
('2024-01-15', 15, 1, 2024),
('2024-02-01', 1, 2, 2024);

INSERT INTO fact_loan VALUES
(2001, 101, 'NY001', '2024-01-15', 100000, 'Approved'),
(2002, 102, 'PA002', '2024-02-01', 150000, 'Rejected');

-- Step 4: Sample Transformation – High-Risk Customers

SELECT
    dc.customer_id,
    dc.name,
    dc.credit_score,
    fl.loan_amount,
    fl.status
FROM fact_loan fl
JOIN dim_customer dc ON fl.customer_id = dc.customer_id
WHERE dc.credit_score < 650;

-- Step 5: Sample Aggregate – Total Loans by Occupation

SELECT
    dc.occupation,
    COUNT(fl.loan_id) AS num_loans,
    SUM(fl.loan_amount) AS total_loaned
FROM fact_loan fl
JOIN dim_customer dc ON fl.customer_id = dc.customer_id
GROUP BY dc.occupation;
