INSERT INTO churn.payments (customer_id, payment_date, amount, payment_status)
SELECT
    c.customer_id,
    CURRENT_DATE - (FLOOR(random() * 180))::INT AS payment_date,
    ROUND((299 + random() * 1200)::numeric, 2) AS amount,
    CASE 
        WHEN random() < 0.9 THEN 'Success'
        ELSE 'Failed'
    END AS payment_status
FROM churn.customers c,
     generate_series(1, 4);
