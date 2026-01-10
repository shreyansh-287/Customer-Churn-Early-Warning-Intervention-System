from sqlalchemy import text
from db import get_engine

def build_monthly_snapshot(snapshot_date):
    engine = get_engine()

    query = f"""
        INSERT INTO churn.customer_feature_snapshots (
            snapshot_month,
            customer_id,
            tenure_months,
            avg_monthly_spend,
            total_sessions,
            avg_session_time,
            support_ticket_count,
            failed_payment_count,
            last_activity_date
        )
        SELECT
            DATE_TRUNC('month', '{snapshot_date}'::DATE)::DATE,
            c.customer_id,
            EXTRACT(MONTH FROM AGE('{snapshot_date}'::DATE, c.signup_date))::INT,
            COALESCE(AVG(s.monthly_charges),0),
            COALESCE(SUM(u.sessions_count),0),
            COALESCE(AVG(u.avg_session_time),0),
            COALESCE(SUM(u.support_tickets),0),
            COALESCE(SUM(CASE WHEN p.payment_status='Failed' THEN 1 ELSE 0 END),0),
            MAX(u.event_date)
        FROM churn.customers c
        LEFT JOIN churn.subscriptions s ON c.customer_id = s.customer_id
        LEFT JOIN churn.usage_events u ON c.customer_id = u.customer_id
        LEFT JOIN churn.payments p ON c.customer_id = p.customer_id
        GROUP BY c.customer_id
        ON CONFLICT DO NOTHING;
    """

    with engine.begin() as conn:
        conn.execute(query, {"snapshot_date": snapshot_date})
