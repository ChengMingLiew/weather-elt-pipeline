{{ config(materialized='table') }}

WITH source AS (
    SELECT * FROM {{ source('postgres_db', 'raw_daily_weather') }}
),

cleaned_weather AS (
    SELECT
        date::DATE                          AS weather_date,
        city,
        weather_code::INT                   AS weather_code,

        -- temperatures
        temperature_2m_mean::NUMERIC(5,2)   AS temp_mean_c,
        temperature_2m_max::NUMERIC(5,2)    AS temp_max_c,
        apparent_temperature_mean::NUMERIC(5,2) AS apparent_temp_mean_c,

        -- precipitation
        rain_sum::NUMERIC(6,2)              AS rain_sum_mm,
        precipitation_sum::NUMERIC(6,2)     AS precipitation_sum_mm,
        precipitation_hours::NUMERIC(5,1)   AS precipitation_hours,

        -- wind
        wind_speed_10m_max::NUMERIC(6,2)    AS wind_speed_max_kmh,
        wind_gusts_10m_max::NUMERIC(6,2)    AS wind_gusts_max_kmh

    FROM source
    WHERE 
        date IS NOT NULL
        AND city IS NOT NULL
)

SELECT * FROM cleaned_weather