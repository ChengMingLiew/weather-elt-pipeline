{{ config(materialized='table') }}

WITH source AS (
    SELECT * FROM {{ source('postgres_db', 'raw_daily_sales') }}
),

cleaned_sales AS (
    SELECT
        date::DATE                          AS sale_date,
        MD5(LOWER(TRIM(email)))             AS customer_id,                            
        INITCAP(TRIM(category))             AS category,
        INITCAP(TRIM(product_name))         AS product_name,
        price::NUMERIC(10,2)                AS price,
        UPPER(TRIM(currency))               AS currency,
        TRIM(address)                       AS address,
        TRIM(address_line_2)                AS address_line_2,
        postcode
    FROM source
    WHERE 
        date IS NOT NULL 
        AND price > 0
        AND email IS NOT NULL
),

sales_with_city AS (
    SELECT
        *,
        {{ postcode_to_city('postcode') }} AS city
    FROM cleaned_sales
)

SELECT * FROM  sales_with_city