use financial_fraud_schema;

SELECT * FROM customers;
SELECT * FROM vendors;
SELECT * FROM employees;
SELECT * FROM transactions;



-- duplicate transaction

-- successful duplicate transaction
SELECT
	customer_id, 
    account_no,
    vendor_id,
    transaction_date,
    amount,
    COUNT(*) AS duplicate_transactions 
FROM transactions
WHERE status="success"
GROUP BY customer_id, account_no, vendor_id, transaction_date,amount
HAVING COUNT(*) > 1;


-- attempted duplicate transaction
SELECT
	customer_id, 
    account_no,
    vendor_id,
    transaction_date,
    amount,
    COUNT(*) AS duplicate_transactions 
FROM transactions
WHERE status="failed"
GROUP BY customer_id, account_no, vendor_id, transaction_date,amount
HAVING COUNT(*) > 1;


-- successful and failed duplicate transaction
WITH success_transaction AS(
SELECT 
	customer_id, 
    account_no, 
    vendor_id,
    transaction_date,
    amount, 
    COUNT(*) OVER(PARTITION BY customer_id, account_no,vendor_id, transaction_date,amount  ) AS succesful_duplicate_transactions 
FROM transactions
WHERE status="success"
),
failed_transaction AS (
SELECT 
	customer_id, 
    account_no, 	
    vendor_id,
	transaction_date,
	amount, 
	COUNT(*) OVER(PARTITION BY customer_id, account_no, vendor_id, transaction_date, amount  ) AS failed_duplicate_transactions 
FROM transactions
WHERE status="failed"
)
SELECT DISTINCT s.customer_id, 
    s.account_no, 
    s.vendor_id,
    s.transaction_date,
    s.amount, 
    s.succesful_duplicate_transactions,
    f.failed_duplicate_transactions
FROM success_transaction s
LEFT JOIN failed_transaction f 
ON s.customer_id= f.customer_id
AND s.account_no = f.account_no
AND s.vendor_id = f.vendor_id
AND s.transaction_date = f.transaction_date
AND s.amount = f.amount;


-- high risk account by transaction frequency
WITH transaction_time_diff AS(
	SELECT 
		transaction_id,
		account_no,
		transaction_date,transaction_time,
		amount,
		LAG(transaction_time) OVER(PARTITION BY account_no, transaction_date ORDER BY transaction_time)AS previous_time,
		TIMESTAMPDIFF(MINUTE,LAG(transaction_time) OVER(PARTITION BY account_no,transaction_date ORDER BY transaction_time),transaction_time) AS time_diff
FROM transactions
)
SELECT 
	transaction_id, 
    account_no ,
	time_diff 
FROM transaction_time_diff 
WHERE time_diff <=5;

-- abnormal large transaction
-- based on the account normal transaction
SELECT 
	account_no,
	amount 
FROM
	(SELECT 
		account_no,
		amount,
		(amount-AVG(amount) OVER(PARTITION BY account_no))/STDDEV(amount) OVER(PARTITION BY account_no) AS large_Transaction
	FROM transactions)t
WHERE large_transaction >=1;

-- based on the amount
SELECT 
	account_no,
	amount 
FROM
	(SELECT 
		account_no,
		amount,
		(amount-AVG(amount) OVER())/STDDEV(amount) OVER() AS large_Transaction
	FROM transactions)t
WHERE large_transaction >=1;

-- sudden spending spikes(day_over_Day change)
SELECT 
	account_no,
    amount,
    previous_amount,
    CONCAT(growth_increase ,"%") as growth_percentage 
FROM
	(SELECT 
    account_no,
    amount,
    LAG(amount) OVER (
						PARTITION BY 
							account_no 
						ORDER BY 
							transaction_date
						) AS previous_amount,
	ROUND(
		((amount-LAG(amount) OVER (PARTITION BY account_no ORDER BY transaction_date)) * 100
        /
        LAG(amount) OVER (PARTITION BY account_no ORDER BY transaction_date)),0) AS growth_increase
	FROM transactions)t
WHERE growth_increase > 200;


-- Employee insider risk detection
SELECT 
	e.employee_id, 
    e.employee_name, 
    t.amount 
FROM employees e
INNER JOIN transactions t 
ON e.employee_id= t.employee_id
ORDER BY amount DESC
LIMIT 1;

-- transaction higher than colleague
WITH employee_detail AS(
	SELECT 
		e.employee_id, 
		e.employee_name, 
		e.department, 
		t.amount 
    FROM employees e
	INNER JOIN transactions t ON e.employee_id= t.employee_id
),
higher_transaction AS(
	SELECT 	
		employee_name, 
        department,
        amount, 
        RANK() OVER(PARTITION BY department ORDER BY amount DESC) AS rank_per_department 
	FROM employee_detail 
)
SELECT 
	employee_name, 
    department,
    amount 
FROM higher_transaction
WHERE rank_per_department = 1;

-- transaction outside business hour


-- account with unusal high failure rate
WITH successful_trans AS(
	SELECT 
		account_no, 
		count(*) AS successful_trans 
	FROM transactions
	WHERE status ='success'
	GROUP BY account_no
),
failed_trans AS(
	SELECT 
		account_no, 
        count(*) AS failed_trans  
	FROM transactions
	WHERE status ='failed'
	GROUP BY account_no
),
total_transaction AS(
	SELECT 
		account_no, 
		count(*) AS total_transaction 
	FROM transactions
	GROUP BY account_no
)
SELECT 
	s.account_no,
    t.total_transaction, 
    s.successful_trans, 
    f.failed_trans,
	CONCAT( ROUND((failed_trans/total_Transaction)*100,0) , "%") AS failure_rate
FROM successful_trans s
LEFT JOIN failed_trans f ON s.account_no = f.account_no
JOIN total_transaction t ON s.account_no = t.account_no
WHERE ROUND((failed_trans/total_Transaction)*100,0) >30;

-- Account Transaction Frequency Risk Ranking
WITH no_of_transaction AS(
	SELECT 
		account_no, 
        COUNT(*) OVER(PARTITION BY account_no ORDER BY transaction_date)no_of_transaction 
	FROM transactions
),
duplicate_transaction AS(
	SELECT 
		account_no, 
        COUNT(no_of_transaction) AS duplicate_count 
	FROM no_of_transaction
	WHERE no_of_transaction >1
	GROUP BY account_no
)
SELECT 
	account_no, 
    RANK() OVER(ORDER BY duplicate_count DESC) AS account_risk_score 
FROM duplicate_transaction;


-- create a fraud risk score per account
WITH duplicate_transactions AS (
    SELECT
        account_no,
        COUNT(*) - 1 AS duplicate_count
    FROM transactions
    GROUP BY account_no, amount, transaction_date
    HAVING COUNT(*) > 1
),

account_duplicate_summary AS (
    SELECT
        account_no,
        SUM(duplicate_count) AS total_duplicates
    FROM duplicate_transactions
    GROUP BY account_no
)

SELECT
    account_no,
    total_duplicates,
    ROUND(
        (total_duplicates * 1.0 /
         MAX(total_duplicates) OVER ()) * 100,
    2) AS fraud_risk_score
FROM account_duplicate_summary
ORDER BY fraud_risk_score DESC;


--  a transaction amount is significantly higher than the account’s usual behavior
SELECT 
	account_no,
    amount, 
    amount-previous_amount AS difference 
    
FROM
	(SELECT 
		account_no ,
		amount,
		LAG(amount) OVER(PARTITION BY account_no order by amount) AS previous_amount
	FROM transactions)t
WHERE amount> previous_amount*2;