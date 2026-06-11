from airflow import DAG
from airflow.operators.trigger_dagrun import TriggerDagRunOperator

import pendulum
from datetime import datetime, timedelta

from videos_status import (
    get_playlist_id,
    get_video_ids,
    extract_video_details,
    save_to_json,
)

from datawarehouse.dwh import staging_table, core_table


# Morocco timezone
local_tz = pendulum.timezone("Africa/Casablanca")

# Default arguments
default_args = {
    "owner": "dataengineers",
    "depends_on_past": False,
    "email": "data@engineers.com",
    "email_on_failure": False,
    "email_on_retry": False,
    "max_active_runs": 1,
    "dagrun_timeout": timedelta(hours=1),
    "start_date": datetime(2025, 1, 1, tzinfo=local_tz),
}


# ── DAG 1 : Produce JSON ─────────────────────────────────────────────────────

with DAG(
    dag_id="produce_json",
    default_args=default_args,
    description="DAG to produce JSON file with raw YouTube data",
    schedule="0 14 * * *",
    catchup=False,
    tags=["youtube", "etl", "json"],
) as dag_produce:

    playlist_id     = get_playlist_id()
    video_ids       = get_video_ids(playlist_id)
    extract_data    = extract_video_details(video_ids)
    save_to_json_task = save_to_json(extract_data)

    trigger_dwh = TriggerDagRunOperator(
        task_id="trigger_load_datawarehouse",
        trigger_dag_id="load_datawarehouse",   # doit correspondre au dag_id ci-dessous
        wait_for_completion=False,             # DAG 1 ne attend pas la fin de DAG 2
    )

    playlist_id >> video_ids >> extract_data >> save_to_json_task >> trigger_dwh


# ── DAG 2 : Load Data Warehouse ──────────────────────────────────────────────

with DAG(
    dag_id="load_datawarehouse",
    default_args=default_args,
    description="DAG to load staging and core tables in PostgreSQL",
    schedule=None,          # pas de schedule : déclenché uniquement par DAG 1
    catchup=False,
    tags=["youtube", "etl", "postgres"],
) as dag_dwh:

    staging = staging_table()
    core    = core_table()

    staging >> core