FROM ghcr.io/dbt-labs/dbt-postgres:1.7.4

WORKDIR /usr/app/dbt
COPY postgres_transformations/dbt .

RUN dbt deps