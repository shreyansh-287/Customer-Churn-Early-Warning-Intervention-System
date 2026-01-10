from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import sys
import os

# Dynamically add project src/ to path

DAG_DIR = os.path.dirname(os.path.abspath(__file__))

PROJECT_ROOT = os.path.abspath(os.path.join(DAG_DIR, ".."))

SRC_PATH = os.path.join(PROJECT_ROOT, "src")



if SRC_PATH not in sys.path:

    sys.path.insert(0, SRC_PATH)

from snapshot_builder import build_monthly_snapshot
from train_model import train_churn_model
from predict_churn import predict_churn
from recommend_actions import generate_recommendations


default_args = {
    "owner": "shreyansh",
    "start_date": datetime(2024, 1, 1),
    "retries": 1,
}

with DAG(
    dag_id="churn_early_warning_pipeline",
    default_args=default_args,
    schedule_interval="@monthly",
    catchup=False,
    tags=["churn", "ml", "production"],
) as dag:

    snapshot_task = PythonOperator(
        task_id="build_feature_snapshot",
        python_callable=build_monthly_snapshot,
        op_kwargs={"snapshot_date": "{{ ds }}"}
    )

    train_task = PythonOperator(
        task_id="train_churn_model",
        python_callable=train_churn_model
    )

    predict_task = PythonOperator(
        task_id="predict_churn",
        python_callable=predict_churn,
        op_kwargs={"snapshot_date": "{{ ds }}"}
    )

    recommend_task = PythonOperator(
        task_id="generate_recommendations",
        python_callable=generate_recommendations,
        op_args=["{{ ds }}"]
    )

    snapshot_task >> train_task >> predict_task >> recommend_task

