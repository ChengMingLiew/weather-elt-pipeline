{{ config(materialized='table') }}

WITH source AS (
    SELECT * FROM {{ ref('staging_daily_weather') }}
),

dim_daily_weather AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['weather_date' , 's.city']) }}     AS weather_sk,
        TO_CHAR(weather_date::date, 'YYYYMMDD')::INT                            AS date_fk,
        loc.location_sk                                                         AS location_fk,
        weather_code                                                            AS weather_code,
        temp_mean_c,
        temp_max_c,
        apparent_temp_mean_c,
        rain_sum_mm,
        precipitation_sum_mm,
        precipitation_hours,
        wind_speed_max_kmh,
        wind_gusts_max_kmh
    FROM source s
    LEFT JOIN {{ ref('dim_location') }} loc
        ON s.city = loc.city
    WHERE 
        weather_date IS NOT NULL
)

SELECT * FROM dim_daily_weather