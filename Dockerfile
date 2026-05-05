# Use the official Airflow image as the base
FROM apache/airflow:latest

ENV PATH="/home/airflow/.local/bin:$PATH"

# Install the Docker provider for Airflow
RUN pip install \
    apache-airflow-providers-docker \
    apache-airflow-providers-standard \
    docker