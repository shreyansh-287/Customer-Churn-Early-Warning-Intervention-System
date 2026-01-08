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
    DATE_TRUNC('month', CURRENT_DATE) AS snapshot_month,
    c.customer_id,
    EXTRACT(MONTH FROM AGE(CURRENT_DATE, c.signup_date))::INT AS tenure_months,
    COALESCE(AVG(s.monthly_charges), 0) AS avg_monthly_spend,
    COALESCE(SUM(u.sessions_count), 0) AS total_sessions,
    COALESCE(AVG(u.avg_session_time), 0) AS avg_session_time,
    COALESCE(SUM(u.support_tickets), 0) AS support_ticket_count,
    COALESCE(SUM(CASE WHEN p.payment_status='Failed' THEN 1 ELSE 0 END), 0) AS failed_payment_count,
    MAX(u.event_date) AS last_activity_date
FROM churn.customers c
LEFT JOIN churn.subscriptions s ON c.customer_id = s.customer_id
LEFT JOIN churn.usage_events u ON c.customer_id = u.customer_id
LEFT JOIN churn.payments p ON c.customer_id = p.customer_id
GROUP BY c.customer_id;
