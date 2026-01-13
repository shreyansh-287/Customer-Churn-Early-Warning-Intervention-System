# Customer Churn Early Warning & Intervention System

## 1. Project Overview

This project is an end-to-end **Data Engineering + Machine Learning + Apache Airflow** pipeline designed to proactively identify customers at risk of churn and recommend business actions to retain them.

It simulates a real-world **subscription-based business use case** where customer data is continuously analyzed to prevent revenue loss.

The system:
- Collects customer data
- Builds monthly feature snapshots
- Trains a churn prediction model
- Predicts churn probability
- Categorizes customers into risk buckets
- Generates business recommendations
- Is fully automated using Apache Airflow

---

## 2. Business Problem Statement

Customer churn directly impacts revenue and growth. Most companies react **after churn happens**, which is too late.

### Business Goal:
To create an **early warning system** that:
- Identifies customers likely to churn
- Quantifies churn risk
- Enables proactive retention strategies

### Business Value:
- Reduce revenue loss
- Improve customer lifetime value
- Enable targeted retention campaigns
- Support data-driven decision making

---

## 3. What Are We Trying To Achieve?

For every customer, every month, we want to answer:
- Is this customer likely to churn?
- How risky is this customer? (Low / Medium / High)
- What action should the business take?

This allows:
- Retention teams to intervene early
- Marketing teams to target campaigns
- Support teams to prioritize high-risk users

---

## 4. High Level Architecture

PostgreSQL (Raw Tables)
        |
        v
Feature Engineering (SQL + Python)
        |
        v
ML Model Training (Scikit-learn)
        |
        v
Churn Prediction
        |
        v
Recommendation Engine
        |
        v
PostgreSQL (Risk + Recommendations Tables)
        |
        v
Apache Airflow Orchestration

---

## 5. Technology Stack

- Python
- PostgreSQL
- Apache Airflow
- Scikit-learn
- Pandas
- SQLAlchemy
- Joblib

---

## 6. Database Tables & Meaning

### 6.1 churn.customers
Stores customer demographic and profile data.

Purpose: Identify who the customer is.

Columns:
- customer_id: Unique identifier
- gender: Customer gender
- age: Customer age
- geography: Region or country
- signup_date: When customer joined
- contract_type: Monthly/Quarterly/Annual
- payment_method: Mode of payment
- is_active: Whether customer is active

---

### 6.2 churn.subscriptions
Stores subscription plan information.

Purpose: Understand what plan the customer is on.

Columns:
- subscription_id
- customer_id
- plan_type
- monthly_charges
- start_date
- end_date
- status

---

### 6.3 churn.usage_events
Tracks how customers use the product.

Purpose: Behavioral analysis.

Columns:
- usage_id
- customer_id
- event_date
- sessions_count
- avg_session_time
- support_tickets

This data is extremely important for churn prediction.

---

### 6.4 churn.payments
Tracks payment history.

Purpose: Identify failed payments and revenue patterns.

Columns:
- payment_id
- customer_id
- payment_date
- amount
- payment_status
- payment_method

Failed payments are a strong churn signal.

---

### 6.5 churn.customer_feature_snapshots (Auto Generated)

Purpose: Monthly aggregated feature table used for ML.

Features include:
- Tenure in months
- Average monthly spend
- Total sessions
- Average session time
- Support ticket count
- Failed payment count

This is the **ML-ready feature table**.

---

### 6.6 churn.churn_risk_history (Auto Generated)

Purpose: Store churn predictions.

Columns:
- snapshot_month
- customer_id
- churn_probability
- risk_bucket

---

### 6.7 churn.churn_recommendations (Auto Generated)

Purpose: Store business actions.

Columns:
- snapshot_month
- customer_id
- risk_bucket
- recommended_action

---

## 7. Feature Engineering Logic

We calculate:
- Tenure = months since signup
- Avg monthly spend = average payments
- Total sessions = sum of sessions
- Avg session time = average usage duration
- Support ticket count = number of tickets
- Failed payment count = payment_status = 'Failed'

These features are industry-standard churn indicators.

---

## 8. Machine Learning Model

Model Used: **Random Forest Classifier**

Why Random Forest:
- Handles non-linear relationships
- Works well with mixed data types
- Robust to noise
- Minimal preprocessing required
- Excellent baseline model for churn problems

---

## 9. Risk Buckets

Based on churn probability:
- 0.0 – 0.4 → Low Risk
- 0.4 – 0.7 → Medium Risk
- 0.7 – 1.0 → High Risk

---

## 10. Recommendation Logic

Business rules:

- Low Risk → "No action needed"
- Medium Risk → "Send discount or engagement email"
- High Risk → "Immediate retention call and offer"

---

## 11. Apache Airflow Pipeline

DAG Name: **churn_early_warning_pipeline**

Schedule: Monthly

Task Flow:

build_feature_snapshot  
↓  
train_churn_model  
↓  
predict_churn  
↓  
generate_recommendations  

Each task is a PythonOperator calling project functions.

---

## 12. Airflow Concepts Used

- DAG: Defines workflow
- PythonOperator: Runs Python functions
- op_kwargs / op_args: Pass execution date
- Scheduler: Triggers tasks
- Webserver: UI
- DagBag: Loads DAGs
- TaskInstance: Execution of each task

---

## 13. Major Airflow Commands Used

Setup:
- airflow db init
- airflow users create
- airflow webserver -D
- airflow scheduler -D

Debugging:
- airflow dags list
- airflow dags list-import-errors
- airflow tasks clear <dag_id>
- airflow config get-value core dags_folder
- pkill -f airflow

---

## 14. Major Challenges Faced & Solutions

### Challenge 1: DAG Not Appearing
Cause: Wrong dags_folder path  
Solution: Set AIRFLOW__CORE__DAGS_FOLDER correctly

---

### Challenge 2: Import Errors in DAG
Cause: Python path issues  
Solution: Dynamically added src/ to sys.path

---

### Challenge 3: SQL Syntax Errors (:, % issues)
Cause: Mixing SQLAlchemy and psycopg2 syntax  
Solution: Standardized on SQLAlchemy text() + parameters

---

### Challenge 4: Pandas + SQLAlchemy Conflicts
Cause: Passing engine instead of connection  
Solution: Used engine.begin() and raw execution

---

### Challenge 5: Feature Mismatch in ML
Cause: Different features at train vs predict  
Solution: Aligned feature engineering logic

---

### Challenge 6: Table Not Found Errors
Cause: Table not created before insert  
Solution: Explicitly created all tables

---

### Challenge 7: Model Save Path Error
Cause: models/ folder did not exist  
Solution: Created directory before saving model

---

## 15. What This Project Demonstrates

- Data modeling
- Feature engineering
- Machine learning integration
- Airflow orchestration
- Business thinking
- Production-style pipeline design

---

## 16. How To Explain This Project In Interviews

"I built an end-to-end churn prediction system using PostgreSQL, Python, and Apache Airflow.  
The pipeline builds monthly customer features, trains a machine learning model, predicts churn probability, categorizes customers into risk buckets, and generates business recommendations automatically."

---

## 17. Author

Shreyansh Pathak  
AI / Data Analyst | Data Engineering | ML Systems
