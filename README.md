# Customer Churn Early Warning & Intervention System

## Project Overview

This project is an end-to-end **Customer Churn Early Warning System** built to help businesses identify customers who are likely to stop using their services and take proactive action to retain them.

In subscription-based businesses (telecom, SaaS, OTT, fintech, etc.), customer churn directly impacts revenue. Waiting until a customer leaves is costly and ineffective. This system focuses on **predicting churn before it happens** and enabling **timely intervention**.

The entire pipeline is automated and runs on a monthly basis.

---

## Business Problem

Customer churn is one of the biggest challenges for any subscription-based business.  
Losing customers means:
- Loss of recurring revenue  
- Increased acquisition costs  
- Reduced customer lifetime value  

Most businesses react after the customer has already churned. This project is designed to **shift from reactive to proactive retention**.

---

## Business Objective

The goal of this project is to:

- Continuously monitor customer behavior  
- Identify early signs of churn  
- Predict churn risk for each customer  
- Categorize customers into risk levels  
- Recommend appropriate business actions  

So that business teams can:
- Engage high-risk customers early  
- Offer discounts, support, or incentives  
- Reduce churn and increase retention  

---

## What This Project Does

Every month, the system automatically:

1. **Collects customer data**  
   - Profile information  
   - Subscription details  
   - Product usage behavior  
   - Payment history  

2. **Builds a monthly feature snapshot**  
   - Tenure  
   - Average spend  
   - Usage frequency  
   - Support interactions  
   - Failed payments  

3. **Trains a churn prediction model** using historical data  

4. **Predicts churn probability** for each customer  

5. **Assigns a risk category**  
   - Low Risk  
   - Medium Risk  
   - High Risk  

6. **Generates business recommendations** such as:
   - No action needed  
   - Send engagement email / discount  
   - Immediate retention call  

All results are stored in the database for reporting and action.

---

## Business Use Case Example

For a telecom or SaaS company:

- A customer with declining usage, multiple support tickets, and failed payments is flagged as **High Risk**
- The system recommends **immediate retention action**
- The retention team contacts the customer with an offer or support
- Churn is prevented before it happens

This directly impacts:
- Revenue protection  
- Customer satisfaction  
- Long-term business growth  

---

## Key Outputs of the System

The system produces two critical business tables:

### 1. Churn Risk History
Contains:
- Customer ID  
- Month  
- Churn probability  
- Risk category (Low / Medium / High)  

This helps business teams understand:
- Who is at risk
- How risk is changing over time

---

### 2. Churn Recommendations
Contains:
- Customer ID  
- Risk category  
- Recommended business action  

This table is directly usable by:
- Retention teams  
- Marketing teams  
- Customer support teams  

---

## Why This Project Matters

This project demonstrates how data engineering and machine learning can be combined to solve a **real business problem**.

It shows:
- How raw customer data can be transformed into insights  
- How machine learning can drive business decisions  
- How automation can replace manual analysis  
- How businesses can become proactive instead of reactive  

---

## Tech Stack Used

- **Python** – Data processing and machine learning  
- **PostgreSQL** – Data storage and analytics  
- **Apache Airflow** – Workflow orchestration and automation  
- **Pandas** – Data manipulation  
- **Scikit-learn** – Machine learning model  
- **SQLAlchemy** – Database connectivity  

---


---

## Architecture Explanation (Step-by-Step)

### 1. Data Layer (PostgreSQL)

This is where all raw business data lives:
- Customer profile data  
- Subscription details  
- Usage events  
- Payment records  

This simulates a real production database in a company.

<img width="3420" height="2144" alt="image" src="https://github.com/user-attachments/assets/f5dc27d4-c287-4be5-9533-6d33f7d69001" />

---

### 2. Feature Engineering Layer

A monthly snapshot is built using SQL logic to convert raw data into meaningful features such as:
- Tenure in months  
- Average monthly spend  
- Total sessions  
- Average session time  
- Number of support tickets  
- Failed payment count  

This creates a **clean, ML-ready dataset**.

---

### 3. Machine Learning Layer

A churn prediction model is trained using historical feature data.

The model learns patterns such as:
- Low usage + high support tickets = higher churn risk  
- Failed payments + short tenure = higher churn risk  

The trained model is saved and reused for prediction.

---

### 4. Prediction Layer

For each monthly snapshot:
- The model predicts **churn probability** for every customer  
- Each customer is classified into:
  - Low Risk  
  - Medium Risk  
  - High Risk  

This converts data into **actionable insight**.

---

### 5. Recommendation Layer

Based on risk category, business actions are generated:

| Risk Level | Recommended Action |
|-----------|---------------------|
| Low       | No action needed    |
| Medium    | Send offer / email  |
| High      | Immediate retention call |

This makes the system **business-usable**, not just analytical.

---

### 6. Orchestration Layer (Airflow)

Apache Airflow automates the entire pipeline:

<img width="3420" height="1898" alt="image" src="https://github.com/user-attachments/assets/e68b5828-70ec-48b7-b2ff-c51d4f7120b0" />

---

## Summary

This project is a complete **business-focused churn prediction and intervention system** that:
- Identifies customers at risk
- Quantifies churn probability
- Suggests actions to retain customers
- Runs automatically on a schedule

It is designed to reflect how churn prevention systems are built and used in real companies.
