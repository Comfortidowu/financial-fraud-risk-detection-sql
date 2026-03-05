CREATE TABLE customers(
customer_id INT PRIMARY KEY,
customer_name VARCHAR(20),
customer_type VARCHAR(20),
risk_rating VARCHAR(10)
);

CREATE TABLE vendors(
vendor_id INT PRIMARY KEY AUTO_INCREMENT,
vendor_name VARCHAR(50),
industry VARCHAR(20)
) AUTO_INCREMENT=100;

CREATE TABLE employees(
employee_id INT PRIMARY KEY ,
employee_name VARCHAR(20),
department VARCHAR(20),
role VARCHAR(50)
);

CREATE TABLE transactions(
transaction_id INT PRIMARY KEY ,
account_no VARCHAR(20),
customer_id INT,
vendor_id INT,
employee_id INT,
transaction_date DATE, 
transaction_time TIME, 
amount INT, 
transaction_type VARCHAR(10),
channel VARCHAR(20),
status VARCHAR(20) 
);

CREATE TABLE mesagelogs(
log_id INT PRIMARY KEY auto_increment,
amount INT,
message VARCHAR(50)
);

CREATE TABLE logs(
log_id INT PRIMARY KEY auto_increment,
account VARCHAR(20),
amount bigINT,
message VARCHAR(100)
);

