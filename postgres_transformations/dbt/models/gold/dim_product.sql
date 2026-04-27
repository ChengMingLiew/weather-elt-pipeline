{{ config(materialized='table') }}

WITH source AS (
    SELECT * FROM {{ ref('staging_daily_sales') }}
),

dim_product AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['product_name', 'category']) }} AS product_sk,
        product_name,
        category,
        CASE
            WHEN AVG(price) < 50   THEN 'Budget'
            WHEN AVG(price) < 150  THEN 'Mid-range'
            ELSE 'Premium'
        END                                                                 AS price_band,
        AVG(price)::NUMERIC(10,2)                                           AS avg_historical_price,
        MIN(price)::NUMERIC(10,2)                                           AS min_historical_price,
        MAX(price)::NUMERIC(10,2)                                           AS max_historical_price
    FROM source
    GROUP BY product_name, category
)

SELECT * FROM dim_product