FROM apache/airflow:3.2.1

ENV PATH="/home/airflow/.local/bin:$PATH"

RUN pip install \
    apache-airflow-providers-docker \
    apache-airflow-providers-standard 