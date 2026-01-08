INSERT INTO churn.churn_risk_delta (customer_id, current_month, previous_month, risk_change, risk_trend)
SELECT
    curr.customer_id,
    curr.snapshot_month AS current_month,
    prev.snapshot_month AS previous_month,
    curr.churn_probability - COALESCE(prev.churn_probability,0) AS risk_change,
    CASE
        WHEN curr.churn_probability - COALESCE(prev.churn_probability,0) > 0.1 THEN 'Increasing'
        WHEN curr.churn_probability - COALESCE(prev.churn_probability,0) < -0.1 THEN 'Decreasing'
        ELSE 'Stable'
    END AS risk_trend
FROM churn.churn_risk_history curr
LEFT JOIN churn.churn_risk_history prev
    ON curr.customer_id = prev.customer_id
    AND curr.snapshot_month = prev.snapshot_month + INTERVAL '1 month';
