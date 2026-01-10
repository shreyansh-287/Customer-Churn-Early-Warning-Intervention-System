import pandas as pd
import joblib
from sqlalchemy import text
from db import get_engine
from datetime import datetime
import os

def predict_churn(snapshot_date):
    engine = get_engine()

    BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    model_path = os.path.join(BASE_DIR, "models", "churn_model.pkl")

    model = joblib.load(model_path)


    snapshot_month = datetime.strptime(snapshot_date, "%Y-%m-%d").date()

    delete_query = """
        DELETE FROM churn.churn_risk_history
        WHERE snapshot_month = :snapshot_month
    """

    select_query = """
        SELECT
            f.snapshot_month,
            c.customer_id,
            c.age,
            f.tenure_months,
            f.avg_monthly_spend,
            f.total_sessions,
            f.avg_session_time,
            f.support_ticket_count,
            f.failed_payment_count
        FROM churn.customer_feature_snapshots f
        JOIN churn.customers c ON f.customer_id = c.customer_id
        WHERE f.snapshot_month = :snapshot_month
    """

    insert_query = """
        INSERT INTO churn.churn_risk_history (
            snapshot_month,
            customer_id,
            churn_probability,
            risk_bucket
        )
        VALUES (
            :snapshot_month,
            :customer_id,
            :churn_probability,
            :risk_bucket
        )
    """

    with engine.begin() as conn:
        # 1️⃣ Delete existing predictions
        conn.execute(text(delete_query), {"snapshot_month": snapshot_month})

        # 2️⃣ Load snapshot data
        result = conn.execute(text(select_query), {"snapshot_month": snapshot_month})
        rows = result.fetchall()
        columns = result.keys()

        if not rows:
            print("⚠️ No data found for snapshot_month:", snapshot_month)
            return

        df = pd.DataFrame(rows, columns=columns)

        # 3️⃣ Prepare features (must match training exactly)
        features = df.drop(columns=["snapshot_month"])

        # 4️⃣ Predict
        df["churn_probability"] = model.predict_proba(features)[:, 1]

        df["risk_bucket"] = pd.cut(
            df["churn_probability"],
            bins=[0, 0.4, 0.7, 1],
            labels=["Low", "Medium", "High"]
        )

        # 5️⃣ Insert predictions manually (NO pandas to_sql)
        records = df[[
            "snapshot_month",
            "customer_id",
            "churn_probability",
            "risk_bucket"
        ]].to_dict(orient="records")

        conn.execute(text(insert_query), records)

    print("✅ Churn predictions generated for", snapshot_month)
