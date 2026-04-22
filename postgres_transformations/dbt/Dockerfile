FROM ghcr.io/dbt-labs/dbt-postgres:1.7.4

WORKDIR /usr/app/dbt
COPY . .

RUN dbt deps 