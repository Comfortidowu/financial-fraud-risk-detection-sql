use financial_fraud_schema;

-- Stored Procedure + Transaction Control
-- Design a stored procedure that inserts a new transaction into the transactions table.
-- If any required field is missing or the amount is invalid, the procedure should ROLLBACK the transaction and return an error message; otherwise, it should COMMIT.
DELIMITER $$

CREATE PROCEDURE transaction_procedure(
IN p_transaction_id INT ,
IN p_account_no VARCHAR(20),
IN p_customer_id INT,
IN p_vendor_id INT,
IN p_employee_id INT,
IN p_transaction_date DATE, 
IN p_transaction_time TIME, 
IN p_amount INT, 
IN p_transaction_type VARCHAR(10),
IN p_channel VARCHAR(20),
IN p_status VARCHAR(20) 
)
BEGIN
START TRANSACTION;
IF p_amount <=0 or p_amount=null THEN
ROLLBACK;
SELECT 'transaction failed:the amount is too low or invalid' AS message;

ELSE
INSERT INTO transactions(transaction_id,account_no ,customer_id,vendor_id ,employee_id ,transaction_date , transaction_time , amount , transaction_type ,channel ,status )
VALUES(p_transaction_id ,p_account_no ,p_customer_id ,p_vendor_id ,p_employee_id ,p_transaction_date ,p_transaction_time ,p_amount ,p_transaction_type ,p_channel ,p_status);
COMMIT ;
SELECT "transaction successful" AS message;
END IF;

END$$

DELIMITER ;

CALL transaction_procedure(1022,'ACCT1020',1,101,201,'2025-01-10','09:10:00',0,'Transfer','Mobile','Success');

DROP procedure transaction_procedure;

-- BEFORE INSERT Trigger – Data Validation
-- Create a BEFORE INSERT trigger on the transactions table that prevents:
-- negative transaction amounts, transactions dated in the future, The insert should fail with a meaningful error message.
DELIMITER $$

CREATE TRIGGER before_insert_transaction BEFORE INSERT ON transactions
FOR EACH ROW
BEGIN
IF NEW.amount < 1 THEN
INSERT INTO mesagelogs(amount,message)
VALUES(NEW.amount,'the amount is too low or invalid');
ELSE 
SET NEW.amount = NEW.amount;
END IF;
END$$
DELIMITER ;

SELECT * FROM transactions;
SELECT * FROM mesagelogs;

DELETE FROM transactions
where transaction_id=1024;

DROP TRIGGER before_insert_transaction;

-- AFTER INSERT Trigger – Fraud Alert Logging
-- Create an AFTER INSERT trigger that automatically logs a record into fraud_alerts when: a transaction amount is significantly higher than the account’s usual behavior The trigger should not block the original transaction.
DELIMITER $$

CREATE TRIGGER after_insert_trigger AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
DECLARE account VARCHAR(20);
DECLARE current_amount int;
DECLARE previous_amount int;
SELECT account_no ,amount, last_transaction_amount INTO account, current_amount, previous_amount FROM
(SELECT account_no, amount,
LAG(amount) OVER(PARTITION BY account_no ORDER BY amount) AS last_transaction_amount
from transactions)t;

IF previous_amount< current_amount THEN
INSERT INTO logs(account,amount, message)
VALUES(new.account_no,new.amount,'this account should be monitored due to high transaction');
END IF;
END$$


DELIMITER $$

CREATE TRIGGER after_insert_trigger AFTER INSERT ON transactions
FOR EACH ROW
BEGIN

DECLARE avg_amount DECIMAL(10,2);
SELECT AVG(amount) INTO avg_amount FROM transactions
WHERE account_no=NEW.account_no
AND transaction_id<>NEW.transaction_id;

IF NEW.amount > (avg_amount*3) THEN
INSERT INTO logs(account,amount, message)
VALUES(new.account_no,new.amount,'this account should be monitored due to high transaction');

ELSE

INSERT INTO logs(account,amount, message)
VALUES(new.account_no,new.amount, 'transaction amount is within range');
END IF;

END$$

DELIMITER ;

SELECT * FROM logs;
DROP TRIGGER after_insert_trigger;

DELETE FROM transactions
WHERE transaction_id=1029;

-- Stored Procedure – Bulk Transaction Ingestion
-- Create a stored procedure that inserts multiple transactions at once and ensures that:either all transactions are successfully inserted, or none are inserted if any single insert fails
-- Use proper transaction handling.
DELIMITER $$
CREATE PROCEDURE multiple_transaction_procedure (
IN p_transaction_id INT ,
IN p_account_no VARCHAR(20),
IN p_customer_id INT,
IN p_vendor_id INT,
IN p_employee_id INT,
IN p_transaction_date DATE, 
IN p_transaction_time TIME, 
IN p_amount INT, 
IN p_transaction_type VARCHAR(10),
IN p_channel VARCHAR(20),
IN p_status VARCHAR(20) ,
IN p_transaction_no INT
)
BEGIN

DECLARE i INT DEFAULT 0;
DECLARE transaction_count INT DEFAULT (p_transaction_no);

START TRANSACTION;

	WHILE i<transaction_count DO

		INSERT INTO transactions(transaction_id,account_no ,customer_id,vendor_id ,employee_id ,transaction_date , transaction_time , amount , transaction_type ,channel ,status )
		VALUES(p_transaction_id ,p_account_no ,p_customer_id ,p_vendor_id ,p_employee_id ,p_transaction_date ,p_transaction_time ,p_amount ,p_transaction_type ,p_channel ,p_status);
    
		SET i=i+1;
	END WHILE;
	COMMIT;

END //

DELIMITER ;

CALL multiple_transaction_procedure(1029,'ACCT1016',16,101,201,'2025-01-10','09:10:00',10000,'Transfer','Mobile','Success',1);
