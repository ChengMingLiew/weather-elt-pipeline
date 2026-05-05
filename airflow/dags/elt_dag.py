from datetime import datetime
from airflow.decorators import dag
from airflow.providers.docker.operators.docker import DockerOperator
from docker.types import Mount
import os

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
}

@dag(
    dag_id='elt_and_dbt',
    default_args=default_args,
    description='An ELT workflow with dbt',
    start_date=datetime(2026, 1, 1),
    schedule='@daily',
    catchup=False,
    is_paused_upon_creation=False,
)
def elt_and_dbt():

    run_ingestion = DockerOperator(

        environment={
            'DB_HOST': 'postgres_db',
            'DB_PORT': '5432',
            'DB_USER': 'user',
            'DB_PASSWORD': 'password',
            'DB_NAME': 'weather_db',
        },
        mount_tmp_dir=False,
        task_id='run_ingestion',
        image='weather-elt-pipeline-ingestion:latest',
        command=["sh", "-c", "python sales_ingestion.py && python weather_ingestion.py"],
        auto_remove='force',
        docker_url="unix://var/run/docker.sock",
        network_mode="weather-elt-pipeline_elt_network",
        mounts=[
            Mount(
                source=os.environ.get("PROJECT_ROOT") + "/sales_data",
                target='/app/sales_data',
                type='bind'
            ),
        ],
    )

    dbt_run = DockerOperator(
        task_id='dbt_run',
        image='ghcr.io/dbt-labs/dbt-postgres:1.7.4',
        mount_tmp_dir=False,
        command=[
            "run",
            "--profiles-dir", "/usr/app/dbt",   # matches docker-compose dbt volume
            "--project-dir", "/usr/app/dbt",     # matches docker-compose dbt volume
            "--full-refresh"
        ],
        mounts=[
            Mount(
                source= os.environ.get("PROJECT_ROOT")+ "/postgres_transformations/dbt",
                target="/usr/app/dbt",
                type="bind"
            )
        ],
        auto_remove='force',
        docker_url="unix://var/run/docker.sock",
        network_mode="weather-elt-pipeline_elt_network",
    )

    run_ingestion >> dbt_run

elt_and_dbt()