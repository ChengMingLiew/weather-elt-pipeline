# ELT Pipeline for Clothing Sales and Weather Data

This project is done using OpenMeteo weather API, and a synthesized data for a fictitious clothing company. End goal of this project is to do analysis on how the weather would affect the sales of the clothing company, and this is a pipeline to ingest the sales data and weather data that are available to us day by day. The medallion architecture is used as it is simple to differentiate the different layers of the data that we have, and do any inspections of those layers if need be.

### Tools that are used:
- dbt Transformations
- PostgreSQL
- Airflow Orchestration

## Repository Structure

1. docker-compose.yml.: This file contains the configuration for Docker Compose which is used to orchestrate multiple containers. It defines a few services listed down below:
   - postgres_db: Our PostgreSQL database, where it will store all our layers of data.
   - airflow_db: A PostgreSQL database for airflow to store metadata.
   - init-airflow: Initialises and sets up the required schema in airflow_db.
   - webserver: Hosts the Airflow UI and internal API.
   - scheduler: Core orchestration engine that watches for DAGS to run, queue tasks and track success or failure.
   - dag-processor: Parses DAG definitions and registers them in Airflow.
   - superset: Dashboard for visualisation of the data that is in postgres_db
2. source_db_init/init.sql: This initialises the SQL tables in our Postgres.
3. postgres_transformation: This is where all our dbt transformations happen between the layers of our architecture.
4. ingestion: Holds all of our python scripts that will load the sales and weather data into our Postgres
5. airflow/dags/elt_dag.py: Defines the DAG of our project so that it can run ingestion and our transformations.
6. superset/superset_config.py: This connects postgres_db to superset with python scripts and holds the someconfiguration for superset.

## Getting Started
1. Ensure that you have Docker installed in your local machine.
2. Clone this repository and navigate to the project directory.
3. Run `docker compose up --build`.
4. After all the services have been completed, you can:
   - Run `docker exec -it weather-elt-pipeline-postgres_db-1 psql -U user -d weather_db` to run sql queries and inspect the SQL tables.
   - Go to localhost:8080 and run the DAGs manually, and see the execution of it. (Please check the webserver logs for the admin user password)
   - Go to localhost:8088 for the superset UI. This allows for SQL queries and visualisation of the data that is being loaded into PostgreSQL.
