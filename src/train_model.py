import pandas as pd
import joblib
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from db import get_engine
import psycopg2
import os

def train_churn_model():
    engine = get_engine()

    # 👇 get raw psycopg2 connection from SQLAlchemy
    raw_conn = engine.raw_connection()

    try:
        df = pd.read_sql("""
            SELECT
                c.customer_id,
                c.age,
                f.tenure_months,
                f.avg_monthly_spend,
                f.total_sessions,
                f.avg_session_time,
                f.support_ticket_count,
                f.failed_payment_count,
                CASE 
                    WHEN cr.churn_probability >= 0.5 THEN 1
                    ELSE 0
                END AS churned
            FROM churn.customer_feature_snapshots f
            JOIN churn.customers c ON f.customer_id = c.customer_id
            LEFT JOIN churn.churn_risk_history cr ON f.customer_id = cr.customer_id
        """, raw_conn)
    finally:
        raw_conn.close()

    X = df.drop(columns=["churned"])
    y = df["churned"]


    model = RandomForestClassifier(
        n_estimators=200,
        max_depth=6,
        random_state=42
    )
    model.fit(X, y)

    BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    MODEL_DIR = os.path.join(BASE_DIR, "models")
    os.makedirs(MODEL_DIR, exist_ok=True)

    model_path = os.path.join(MODEL_DIR, "churn_model.pkl")
    joblib.dump(model, model_path)
