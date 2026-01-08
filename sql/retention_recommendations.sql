INSERT INTO churn.retention_recommendations (customer_id, snapshot_month, risk_level, churn_reason, recommended_action, priority)
SELECT
    r.customer_id,
    r.snapshot_month,
    rh.risk_bucket AS risk_level,
    rc.primary_reason AS churn_reason,
    CASE
        WHEN rh.risk_bucket='High' AND rc.primary_reason='Payment Failure' THEN 'Send Payment Reminder + Offer Incentive'
        WHEN rh.risk_bucket='High' AND rc.primary_reason='Low Usage' THEN 'Engagement Email + Discount'
        WHEN rh.risk_bucket='Medium' AND rc.primary_reason='Support Issue' THEN 'Personalized Support Call'
        ELSE 'Monitor Customer'
    END AS recommended_action,
    CASE
        WHEN rh.risk_bucket='High' THEN 1
        WHEN rh.risk_bucket='Medium' THEN 2
        ELSE 3
    END AS priority
FROM churn.churn_reason_codes rc
JOIN churn.churn_risk_history rh
    ON rc.customer_id = rh.customer_id AND rc.snapshot_month = rh.snapshot_month
JOIN churn.customer_feature_snapshots r
    ON r.customer_id = rc.customer_id AND r.snapshot_month = rc.snapshot_month;
