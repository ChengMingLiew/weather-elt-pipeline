{{ config(materialized='table') }}

WITH source AS (
    SELECT * FROM {{ ref('staging_customer') }}
),

dim_customer AS (
    SELECT
        customer_id,
        first_name,
        last_name,
        card_last_four,
        card_type,
        sale_date       AS first_seen_date
    FROM 
        source
    ORDER BY 
        customer_id,
        sale_date ASC
)

SELECT * FROM dim_customer