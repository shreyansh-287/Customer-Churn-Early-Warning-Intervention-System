INSERT INTO churn.usage_events (customer_id, event_date, sessions_count, avg_session_time, support_tickets)
SELECT
    c.customer_id,
    CURRENT_DATE - (FLOOR(random() * 30))::INT AS event_date,
    (1 + FLOOR(random() * 25))::INT AS sessions_count,
    ROUND((5 + random() * 60)::numeric, 2) AS avg_session_time,
    FLOOR(random() * 6)::INT AS support_tickets
FROM churn.customers c,
     generate_series(1, 8);
