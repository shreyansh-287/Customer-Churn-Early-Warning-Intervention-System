INSERT INTO churn.customers (gender, age, geography, signup_date, contract_type, payment_method, is_active)
SELECT
    CASE WHEN random() < 0.5 THEN 'Male' ELSE 'Female' END AS gender,
    (18 + FLOOR(random() * 50))::INT AS age,
    (ARRAY['India', 'USA', 'UK', 'Germany', 'Canada', 'Australia'])[FLOOR(random()*6)+1] AS geography,
    CURRENT_DATE - (FLOOR(random() * 900))::INT AS signup_date,
    (ARRAY['Monthly', 'Quarterly', 'Yearly'])[FLOOR(random()*3)+1] AS contract_type,
    (ARRAY['Credit Card', 'Debit Card', 'UPI', 'Net Banking'])[FLOOR(random()*4)+1] AS payment_method,
    CASE WHEN random() < 0.85 THEN TRUE ELSE FALSE END AS is_active
FROM generate_series(1, 500);
