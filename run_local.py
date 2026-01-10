from datetime import date
from src.snapshot_builder import build_monthly_snapshot
from src.train_model import train_churn_model
from src.predict_churn import predict_churn

snapshot_date = date(2026, 1, 1)

build_monthly_snapshot(snapshot_date)
train_churn_model()
predict_churn(snapshot_date)

print("Pipeline executed successfully")
