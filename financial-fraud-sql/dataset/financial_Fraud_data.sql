
INSERT INTO customers (customer_id, customer_name, customer_type, risk_rating) 
VALUES
(1,'Ade Motors Ltd','Corporate','High'),
(2,'Blessing Okoye','Retail','Medium'),
(3,'Tunde Balogun','Retail','Low'),
(4,'Zara Holdings','Corporate','High'),
(5,'Ibrahim Musa','Retail','Low'),
(6,'GreenField Farms','Corporate','Medium'),
(7,'Chiamaka Nwoye','Retail','Medium'),
(8,'Delta Traders','Corporate','High'),
(9,'Samuel Lawal','Retail','Low'),
(10,'Bright Future Ltd','Corporate','Medium'),
(11,'Oluwaseun Ajayi','Retail','Low'),
(12,'Prime Stores','Corporate','Medium'),
(13,'Hadiza Sule','Retail','Low'),
(14,'NextGen Tech','Corporate','High'),
(15,'Yusuf Bello','Retail','Medium'),
(16,'Royal Logistics','Corporate','High'),
(17,'Amina Garba','Retail','Low'),
(18,'Sunrise Ventures','Corporate','Medium'),
(19,'Peter Okonkwo','Retail','Low'),
(20,'Unity Services Ltd','Corporate','High');


INSERT INTO vendors (vendor_name, industry) 
VALUES
('SwiftPay Services','FinTech'),
('Prime Logistics','Logistics'),
('Alpha IT Solutions','Technology'),
('PayLink Africa','FinTech'),
('Metro Transport','Transport'),
('CloudCore Systems','Technology'),
('SecurePay Ltd','FinTech'),
('FastMove Couriers','Logistics'),
('DataWave Tech','Technology'),
('TrustPay','FinTech'),
('City Haulage','Logistics'),
('TechBridge','Technology'),
('EasyPay','FinTech'),
('NorthLine Movers','Logistics'),
('InnovaSoft','Technology'),
('QuickFunds','FinTech'),
('BlueRoute','Logistics'),
('NextByte','Technology'),
('CashFlow Africa','FinTech'),
('Urban Freight','Logistics');


INSERT INTO employees (employee_id, employee_name, department, role) 
VALUES
(201,'Samuel Adebayo','Operations','Payment Officer'),
(202,'Fatima Bello','Finance','Reconciliation Analyst'),
(203,'John Okorie','IT','System Admin'),
(204,'Mary Johnson','Operations','Payment Officer'),
(205,'Ahmed Sule','Finance','Risk Analyst'),
(206,'Grace Obi','IT','Data Analyst'),
(207,'Daniel Peters','Operations','Supervisor'),
(208,'Aisha Mohammed','Finance','Auditor'),
(209,'Victor Uche','IT','Security Analyst'),
(210,'Esther Brown','Operations','Payment Officer'),
(211,'Kabiru Sadiq','Finance','Accountant'),
(212,'Ruth Williams','IT','Support Engineer'),
(213,'Joseph Ade','Operations','Team Lead'),
(214,'Zainab Ali','Finance','Compliance Officer'),
(215,'Michael Ojo','IT','Developer'),
(216,'Hassan Lawal','Operations','Payment Officer'),
(217,'Linda Green','Finance','Risk Analyst'),
(218,'Sola Akin','IT','Database Admin'),
(219,'Paul James','Operations','Supervisor'),
(220,'Halima Abubakar','Finance','Fraud Analyst');


INSERT INTO transactions (
transaction_id, account_no, customer_id, vendor_id, employee_id,
transaction_date, transaction_time, amount, transaction_type, channel, status
) 
VALUES
(1001,'ACCT1001',1,101,201,'2025-01-01','09:10:00',50000,'Transfer','Mobile','Success'),
(1002,'ACCT1001',1,101,201,'2025-01-01','09:11:00',50000,'Transfer','Mobile','Success'), 
(1003,'ACCT1002',2,104,202,'2025-01-02','10:30:00',30000,'POS','POS','Success'),
(1004,'ACCT1003',3,103,203,'2025-01-03','11:45:00',45000,'Transfer','Web','Success'),
(1005,'ACCT1004',4,110,204,'2025-01-04','12:15:00',60000,'Transfer','Mobile','Success'),
(1006,'ACCT1005',5,107,205,'2025-01-05','13:00:00',70000,'Transfer','Web','Failed'),
(1007,'ACCT1005',5,107,205,'2025-01-05','13:05:00',70000,'Transfer','Web','Failed'),
(1008,'ACCT1005',5,107,205,'2025-01-05','13:10:00',70000,'Transfer','Web','Success'),
(1009,'ACCT1006',6,109,206,'2025-01-06','14:20:00',200000,'Transfer','Web','Success'),
(1010,'ACCT1006',6,109,206,'2025-01-07','14:25:00',900000,'Transfer','Web','Success'), 
(1011,'ACCT1007',7,113,207,'2025-01-08','15:00:00',25000,'POS','POS','Success'),
(1012,'ACCT1008',8,114,208,'2025-01-09','16:40:00',80000,'Transfer','Mobile','Success'),
(1013,'ACCT1009',9,116,209,'2025-01-10','17:10:00',120000,'Transfer','Web','Success'),
(1014,'ACCT1010',10,118,210,'2025-01-11','18:00:00',95000,'Transfer','Mobile','Success'),
(1015,'ACCT1011',11,119,211,'2025-01-12','19:30:00',40000,'POS','POS','Success'),
(1016,'ACCT1012',12,120,212,'2025-01-13','22:45:00',300000,'Transfer','Web','Success'),
(1017,'ACCT1013',13,101,213,'2025-01-14','09:05:00',55000,'Transfer','Mobile','Success'),
(1018,'ACCT1014',14,102,214,'2025-01-15','10:15:00',60000,'Transfer','Web','Success'),
(1019,'ACCT1015',15,103,215,'2025-01-16','11:25:00',65000,'Transfer','Mobile','Success'),
(1020,'ACCT1016',16,104,216,'2025-01-17','12:35:00',500000,'Transfer','Web','Success');

INSERT INTO transactions (
transaction_id, account_no, customer_id, vendor_id, employee_id,
transaction_date, transaction_time, amount, transaction_type, channel, status
) 
VALUES
(1029,'ACCT1016',16,101,201,'2025-01-10','09:10:00',10000,'Transfer','Mobile','Success');
