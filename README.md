# ELT Pipeline for Clothing Sales and Weather Data

This project is done using OpenMeteo weather API, and a synthesized data for a fictitious clothing company. End goal of this project is to do analysis on how the weather would affect the sales of the clothing company, and this is a pipeline to ingest the sales data and weather data that are available to us day by day.

### Tools that are used:
- dbt Transformations
- PostgreSQL
- Airflow Orchestration

## Repository Structure

1. docker-compose.yml.: This file contains the configuration for Docker Compose which is used to orchestrate multiple containers. It defines a few services listed down below:
- - thish
