# Financial Fraud Risk Detection Using SQL
## Project Overview

This project analyzes financial transaction data to detect fraud risks using advanced SQL techniques such as:
Window functions (LAG, RANK, COUNT OVER)
CTEs (Common Table Expressions)
Statistical anomaly detection (Z-score logic)
Transaction frequency analysis
Employee insider risk detection
Failure rate analysis

### Key Fraud Detection Techniques Implemented
- Duplicate Transaction Detection
- Successful duplicates
- Failed duplicates
- Mixed status duplicates

### High-Risk Account by Transaction Frequency
- Rapid transactions within 5 minutes
- Time-based anomaly detection

### Abnormal Large Transactions
- Z-score based anomaly (per account)
- Global transaction anomaly detection

### Sudden Spending Spikes
-  Day-over-day percentage growth
-  200% increase flagged

### Employee Insider Risk
-  Highest transaction per employee
-  Highest per department (RANK)

### High Failure Rate Accounts
Accounts with >30% failure rate

7️⃣ Fraud Risk Score per Account

Duplicate transaction weighted scoring

Normalized fraud risk score (0–100)

🧠 Skills Demonstrated

Advanced SQL

Window Functions

Risk Modeling

Anomaly Detection

Fraud Analytics

Data Aggregation & Ranking

Statistical Analysis in SQL

🛠 Database Used

MySQL

📌 Business Impact

This system helps financial institutions:

Detect suspicious account behavior

Identify internal insider threats

Flag abnormal transaction spikes

Score accounts based on fraud likelihood
