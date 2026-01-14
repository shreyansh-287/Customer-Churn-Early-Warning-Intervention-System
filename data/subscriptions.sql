INSERT INTO churn.subscriptions (customer_id, plan_type, monthly_charges, start_date, end_date, status)
SELECT
    c.customer_id,
    (ARRAY['Basic', 'Standard', 'Premium'])[FLOOR(random()*3)+1] AS plan_type,
    ROUND((299 + random() * 1200)::numeric, 2) AS monthly_charges,
    c.signup_date,
    CASE 
        WHEN random() < 0.8 THEN NULL
        ELSE c.signup_date + (FLOOR(random() * 400))::INT
    END AS end_date,
    CASE 
        WHEN random() < 0.8 THEN 'Active'
        ELSE 'Cancelled'
    END AS status
FROM churn.customers c;
