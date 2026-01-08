INSERT INTO churn.churn_risk_history (snapshot_month, customer_id, churn_probability, risk_bucket)
SELECT
    snapshot_month,
    customer_id,
    -- Simple risk score (0 to 1)
    LEAST(
        1.0,
        (
            (CASE WHEN churn_label=1 THEN 0.5 ELSE 0 END) +
            (failed_payment_count * 0.1) +
            (CASE WHEN total_sessions < 5 THEN 0.2 ELSE 0 END) +
            (CASE WHEN support_ticket_count > 2 THEN 0.1 ELSE 0 END)
        )
    ) AS churn_probability,
    -- Risk bucket
    CASE
        WHEN LEAST(
            1.0,
            (
                (CASE WHEN churn_label=1 THEN 0.5 ELSE 0 END) +
                (failed_payment_count * 0.1) +
                (CASE WHEN total_sessions < 5 THEN 0.2 ELSE 0 END) +
                (CASE WHEN support_ticket_count > 2 THEN 0.1 ELSE 0 END)
            )
        ) >= 0.7 THEN 'High'
        WHEN LEAST(
            1.0,
            (
                (CASE WHEN churn_label=1 THEN 0.5 ELSE 0 END) +
                (failed_payment_count * 0.1) +
                (CASE WHEN total_sessions < 5 THEN 0.2 ELSE 0 END) +
                (CASE WHEN support_ticket_count > 2 THEN 0.1 ELSE 0 END)
            )
        ) >= 0.4 THEN 'Medium'
        ELSE 'Low'
    END AS risk_bucket
FROM churn.customer_feature_snapshots;
