📉 Customer Churn Early Warning & Intervention System

An end-to-end, production-style customer churn prediction and intervention pipeline built using PostgreSQL, Python, Machine Learning, and Apache Airflow.
This project demonstrates realistic data modeling, SQL-based feature engineering, ML training, scheduled orchestration, and business-driven recommendations.

🚀 Overview

This project builds an automated system to identify customers at risk of churning before they leave and recommend appropriate retention actions.

The system:

Stores raw customer, subscription, usage, and payment data in PostgreSQL

Builds monthly feature snapshots using SQL

Trains a machine learning churn model

Predicts churn probability and risk category for each customer

Generates business-friendly recommendations

Runs the entire pipeline automatically using Apache Airflow

This closely mirrors how churn prevention systems are built in telecom, SaaS, fintech, OTT, and subscription businesses.

🧠 Problem Statement

Customer churn is one of the biggest revenue killers for subscription businesses.

Most companies:

Detect churn after the customer leaves

Lose recurring revenue

Spend heavily on re-acquisition

The goal of this project is to shift from:

Reactive churn handling → Proactive churn prevention

🎯 Business Objective

The system is designed to:

Monitor customer behavior continuously

Detect early warning signals of churn

Predict churn risk before the customer leaves

Categorize customers into risk levels

Recommend business actions for retention

So that business teams can:

Act early on high-risk customers

Offer discounts, support, or incentives

Reduce churn and increase customer lifetime value

🏗️ Architecture
PostgreSQL (customers, subscriptions, usage, payments)
        ↓
SQL Feature Engineering (monthly snapshots)
        ↓
Python (ML training + prediction)
        ↓
Risk Classification (Low / Medium / High)
        ↓
Recommendation Engine (business actions)
        ↓
Apache Airflow (monthly orchestration)

📁 Project Structure
Customer-Churn-Early-Warning-Intervention-System/
│
├── dags/
│   └── churn_ml_pipeline_dag.py        # Airflow DAG
│
├── src/
│   ├── db.py                           # DB connection
│   ├── snapshot_builder.py            # Feature snapshot logic
│   ├── train_model.py                 # ML training
│   ├── predict_churn.py               # Churn prediction
│   └── recommend_actions.py           # Recommendation logic
│
├── models/
│   └── churn_model.pkl                # Trained model
│
└── README.md

🗄️ Database Schema (Simplified)

Base Tables (Raw Data):

customers – customer profile

subscriptions – plan details

usage_events – product usage behavior

payments – payment history

Derived Tables (Pipeline Output):

customer_feature_snapshots – monthly engineered features

churn_risk_history – churn probability & risk bucket

churn_recommendations – business actions

🔬 Feature Engineering (SQL)

Each month, raw data is transformed into meaningful features such as:

Tenure (months)

Average monthly spend

Total sessions

Average session time

Support ticket count

Failed payment count

These features are stored in customer_feature_snapshots and used for ML.

🤖 Model
Churn Prediction Model (Random Forest Classifier)

The model learns patterns such as:

Low usage + high support tickets → higher churn risk

Failed payments + short tenure → higher churn risk

Why Random Forest?

Handles non-linear relationships well

Works with mixed feature types

Robust to noise

Strong baseline model for churn problems in industry

The trained model is saved and reused for prediction.

📊 Risk Classification

Each customer is classified into:

Risk Bucket	Meaning
Low	Healthy customer
Medium	Potential risk
High	Likely to churn

This makes predictions business-readable, not just technical.

💡 Recommendation Engine

Based on risk category:

Risk Level	Recommended Action
Low	No action needed
Medium	Send offer / engagement email
High	Immediate retention call

These are stored in churn_recommendations and can be directly used by:

Retention teams

Marketing teams

Customer support

⏱️ Orchestration (Apache Airflow)

The entire pipeline is automated using Airflow:

Build monthly feature snapshot

Train churn model

Predict churn probability

Generate recommendations

Runs on a monthly schedule.

🖥️ Visuals
Airflow DAG View

(Add screenshot here)

Database Tables

(Add screenshot here)

Churn Predictions Output

(Add screenshot here)

⚙️ Setup & Run
1. Create Virtual Environment
python3 -m venv airflow_env
source airflow_env/bin/activate

2. Install Dependencies
pip install apache-airflow pandas scikit-learn psycopg2-binary sqlalchemy joblib

3. Set Airflow DAGs Folder
export AIRFLOW__CORE__DAGS_FOLDER=/path/to/Customer-Churn-Early-Warning-Intervention-System/dags

4. Start Airflow
airflow webserver -D
airflow scheduler -D

🧪 Usage

Trigger the DAG manually from Airflow UI or let it run on schedule.
After execution, check:

customer_feature_snapshots

churn_risk_history

churn_recommendations

💡 Key Learnings

Designing realistic data schemas for churn analysis

SQL-based feature engineering for ML

Training and deploying churn models

Business-driven risk segmentation

Orchestrating ML pipelines using Airflow

Debugging real-world Airflow, SQL, and path issues

📌 Resume Highlight

Built an end-to-end customer churn early warning system using PostgreSQL, SQL feature engineering, machine learning, and Apache Airflow to predict churn risk and generate business-ready retention recommendations.

👤 Author

Shreyansh Pathak
