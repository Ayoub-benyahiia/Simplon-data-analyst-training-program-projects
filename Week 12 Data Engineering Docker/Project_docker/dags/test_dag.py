from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime


def hello():
    print("Hello Airflow !")


with DAG(
    dag_id="test_dag",
    start_date=datetime(2026, 1, 1),
    schedule="@daily",
    catchup=False,
    tags=["test"],
) as dag:

    task_hello = PythonOperator(
        task_id="hello_task",
        python_callable=hello,
    )

    task_hello