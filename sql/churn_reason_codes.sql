INSERT INTO churn.churn_reason_codes (snapshot_month, customer_id, primary_reason, secondary_reason)
SELECT
    c.snapshot_month,
    c.customer_id,
    CASE
        WHEN failed_payment_count > 0 THEN 'Payment Failure'
        WHEN total_sessions < 5 THEN 'Low Usage'
        WHEN support_ticket_count > 2 THEN 'Support Issue'
        ELSE 'Tenure Risk'
    END AS primary_reason,
    CASE
        WHEN total_sessions < 5 AND failed_payment_count > 0 THEN 'Low Usage'
        WHEN support_ticket_count > 2 AND total_sessions < 5 THEN 'Support & Low Usage'
        ELSE NULL
    END AS secondary_reason
FROM churn.customer_feature_snapshots c;
