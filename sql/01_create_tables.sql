CREATE OR REPLACE PROCEDURE churn.create_churn_tables()
LANGUAGE plpgsql
AS $$
BEGIN

CREATE TABLE churn.customers (
    customer_id        SERIAL PRIMARY KEY,
    gender             VARCHAR(10),
    age                INT,
    geography          VARCHAR(50),
    signup_date        DATE,
    contract_type      VARCHAR(20),
    payment_method     VARCHAR(30),
    is_active          BOOLEAN
);

CREATE TABLE churn.subscriptions (
    subscription_id    SERIAL PRIMARY KEY,
    customer_id        INT REFERENCES churn.customers(customer_id),
    plan_type          VARCHAR(30),
    monthly_charges    NUMERIC(10,2),
    start_date         DATE,
    end_date           DATE,
    status             VARCHAR(20)
);

CREATE TABLE churn.usage_events (
    usage_id           SERIAL PRIMARY KEY,
    customer_id        INT REFERENCES churn.customers(customer_id),
    event_date         DATE,
    sessions_count     INT,
    avg_session_time   NUMERIC(6,2),
    support_tickets    INT
);

CREATE TABLE churn.payments (
    payment_id         SERIAL PRIMARY KEY,
    customer_id        INT REFERENCES churn.customers(customer_id),
    payment_date       DATE,
    amount_paid        NUMERIC(10,2),
    payment_status     VARCHAR(20)
);

CREATE TABLE churn.customer_feature_snapshots (
    snapshot_month            DATE,
    customer_id               INT REFERENCES churn.customers(customer_id),

    tenure_months             INT,
    avg_monthly_spend         NUMERIC(10,2),
    total_sessions            INT,
    avg_session_time          NUMERIC(6,2),
    support_ticket_count      INT,
    failed_payment_count      INT,
    last_activity_date        DATE,

    PRIMARY KEY (snapshot_month, customer_id)
);

CREATE TABLE churn.churn_risk_history (
    snapshot_month      DATE,
    customer_id         INT REFERENCES churn.customers(customer_id),
    churn_probability   NUMERIC(5,4),
    risk_bucket         VARCHAR(20),

    PRIMARY KEY (snapshot_month, customer_id)
);

CREATE TABLE churn.churn_risk_delta (
    customer_id         INT REFERENCES churn.customers(customer_id),
    current_month       DATE,
    previous_month      DATE,
    risk_change         NUMERIC(5,4),
    risk_trend          VARCHAR(20),

    PRIMARY KEY (customer_id, current_month)
);

CREATE TABLE churn.churn_reason_codes (
    snapshot_month      DATE,
    customer_id         INT REFERENCES churn.customers(customer_id),
    primary_reason      VARCHAR(50),
    secondary_reason    VARCHAR(50),

    PRIMARY KEY (snapshot_month, customer_id)
);

CREATE TABLE churn.retention_recommendations (
    customer_id           INT REFERENCES churn.customers(customer_id),
    snapshot_month        DATE,
    risk_level            VARCHAR(20),
    churn_reason          VARCHAR(50),
    recommended_action    VARCHAR(100),
    priority              INT,

    PRIMARY KEY (customer_id, snapshot_month)
);

CREATE TABLE churn.model_metrics (
    model_version    VARCHAR(20),
    metric_name      VARCHAR(30),
    metric_value     NUMERIC(6,4),
    run_date         DATE
);

END;
$$;