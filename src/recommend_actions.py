import pandas as pd
from sqlalchemy import text
from datetime import datetime
from db import get_engine


def generate_recommendations(snapshot_date):
    engine = get_engine()

    snapshot_month = datetime.strptime(snapshot_date, "%Y-%m-%d").date()

    select_query = """
        SELECT
            customer_id,
            risk_bucket,
            churn_probability
        FROM churn.churn_risk_history
        WHERE snapshot_month = :snapshot_month
    """

    insert_query = """
        INSERT INTO churn.churn_recommendations (
            snapshot_month,
            customer_id,
            risk_bucket,
            recommended_action
        )
        VALUES (
            :snapshot_month,
            :customer_id,
            :risk_bucket,
            :recommended_action
        )
    """

    with engine.begin() as conn:
        # 1. Fetch churn risk data
        result = conn.execute(
            text(select_query),
            {"snapshot_month": snapshot_month}
        )
        rows = result.fetchall()
        columns = result.keys()

        if not rows:
            print(f"⚠️ No churn risk data found for {snapshot_month}")
            return

        df = pd.DataFrame(rows, columns=columns)
        df["risk_bucket"] = df["risk_bucket"].fillna("Low")

        # 2. Generate recommendations
        def recommend(row):
            if row["risk_bucket"] == "High":
                return "Offer 20% discount + priority support"
            elif row["risk_bucket"] == "Medium":
                return "Send engagement email + feature tips"
            else:
                return "No action needed"

        df["recommended_action"] = df.apply(recommend, axis=1)

        # 3. Insert recommendations
        for _, row in df.iterrows():
            conn.execute(
                text(insert_query),
                {
                    "snapshot_month": snapshot_month,
                    "customer_id": int(row["customer_id"]),
                    "risk_bucket": row["risk_bucket"],
                    "recommended_action": row["recommended_action"]
                }
            )

    print(f"✅ Recommendations generated for {snapshot_month}")
