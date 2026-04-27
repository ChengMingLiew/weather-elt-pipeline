-- depends_on: {{ ref('staging_daily_sales') }}

{{ config(materialized='table') }}

WITH source AS (
    SELECT * FROM {{ ref('staging_daily_sales') }}
),

fact_daily_sales AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['s.sale_date', 's.customer_id', 'p.product_sk']) }}    AS sale_sk,
        s.sale_date,
        TO_CHAR(s.sale_date, 'YYYYMMDD')::INT                                     AS date_fk,
        s.customer_id                                                             AS customer_fk,
        loc.location_sk                                                         AS location_fk,
        w.weather_sk                                                            AS weather_fk,
        p.product_sk                                                            AS product_fk,
        s.price
    FROM 
        source s
    LEFT JOIN {{ ref('dim_location') }} loc
        ON s.city = loc.city
    LEFT JOIN {{ ref('dim_daily_weather') }} w
        ON TO_CHAR(s.sale_date, 'YYYYMMDD')::INT = w.date_fk
        AND loc.location_sk = w.location_fk
    LEFT JOIN {{ ref('dim_product') }} p
        ON p.product_name = s.product_name
        AND p.category = s.category
)

SELECT  * FROM fact_daily_sales
