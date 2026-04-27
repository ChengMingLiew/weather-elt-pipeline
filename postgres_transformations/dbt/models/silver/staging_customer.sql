{{ config(materialized='table') }}

WITH source AS (
    SELECT * FROM {{ source('postgres_db', 'raw_daily_sales') }}
),

cleaned_customer AS (
    SELECT
        date::DATE                                                  AS sale_date,
        MD5(LOWER(TRIM(email)))                                     AS customer_id,  
        INITCAP(TRIM(first_name))                                   AS first_name,
        INITCAP(TRIM(last_name))                                    AS last_name,
        CONCAT('****-****-****-', RIGHT(creditcard_num::TEXT, 4))   AS card_last_four,
        UPPER(TRIM(creditcard_type))                                AS card_type
    FROM 
        source
    WHERE 
        date IS NOT NULL 
        AND email IS NOT NULL
        AND price IS NOT NULL
),

deduped AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY sale_date DESC
        ) AS rn
    FROM cleaned_customer
)

SELECT * FROM  deduped
WHERE rn = 1