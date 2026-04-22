{{ config(materialized='table') }}

WITH source AS (
    SELECT * FROM {{ source('postgres_db', 'raw_daily_sales') }}
),

cleaned_sales AS (
    SELECT
        date::DATE                              AS sale_date,

        -- identity protection
        MD5(LOWER(TRIM(email)))                 AS customer_id,  
        INITCAP(TRIM(first_name))               AS first_name,
        INITCAP(TRIM(last_name))                AS last_name,
        CONCAT('****-****-****-', RIGHT(creditcard_num::TEXT, 4)) AS card_last_four,
        UPPER(TRIM(creditcard_type))            AS card_type,

        -- products
        INITCAP(TRIM(category))                 AS category,
        INITCAP(TRIM(product_name))             AS product_name,

        -- transaction
        price::NUMERIC(10,2)                    AS price,
        UPPER(TRIM(currency))                   AS currency,

        -- location
        TRIM(address)                           AS address,
        TRIM(address_line_2)                    AS address_line_1
    FROM source
    WHERE 
        date IS NOT NULL 
        AND email IS NOT NULL
        AND price IS NOT NULL
        AND price > 0
)

SELECT * FROM  cleaned_sales