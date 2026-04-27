{{ config(materialized='table') }}

WITH date_spine AS (
    {{  dbt_utils.date_spine(
        datepart="day",
        start_date="(SELECT MIN(sale_date) FROM " ~ ref('staging_daily_sales') ~ ")",
        end_date="(SELECT MAX(sale_date) FROM " ~ ref('staging_daily_sales') ~ ")"
    ) }}
),

dim_date AS (
    SELECT
        date_day                                                AS date_day,
        TO_CHAR(date_day, 'YYYYMMDD')::INT                      AS date_sk,
        EXTRACT(DOW FROM date_day)                              AS day_of_week_num,
        TO_CHAR(date_day, 'Day')                                AS day_of_week_name,
        EXTRACT(DAY FROM date_day)                              AS day_of_month,
        EXTRACT(WEEK FROM date_day)                             AS week_of_year,
        EXTRACT(MONTH FROM date_day)                            AS month_num,
        TO_CHAR(date_day, 'Month')                              AS month_name,
        EXTRACT(QUARTER FROM date_day)                          AS quarter,
        EXTRACT(YEAR FROM date_day)                             AS year,
        CASE WHEN EXTRACT(DOW FROM date_day) IN (0, 6)
             THEN TRUE ELSE FALSE END                           AS is_weekend,
        CASE
            WHEN EXTRACT(MONTH FROM date_day) IN (12, 1, 2)     THEN 'Summer'
            WHEN EXTRACT(MONTH FROM date_day) IN (3, 4, 5)      THEN 'Autumn'
            WHEN EXTRACT(MONTH FROM date_day) IN (6, 7, 8)      THEN 'Winter'
            WHEN EXTRACT(MONTH FROM date_day) IN (9, 10, 11)    THEN 'Spring'
        END                                                     AS season 
    FROM date_spine
)

SELECT * FROM dim_date