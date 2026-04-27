{{ config(materialized='table') }}

WITH source AS (
    SELECT * FROM {{ ref('staging_daily_sales') }}
    WHERE city IS NOT NULL
),

dim_location AS (
    SELECT DISTINCT
        {{ dbt_utils.generate_surrogate_key(['city']) }}                    AS location_sk,
        city,
        CASE
            WHEN city IN ('Sydney', 'Parramatta', 'Liverpool',
                          'Penrith', 'Newcastle', 'Wollongong')   THEN 'NSW'
            WHEN city IN ('Melbourne', 'Frankston',
                          'Geelong', 'Ballarat', 'Bendigo')       THEN 'VIC'
            WHEN city IN ('Brisbane', 'Gold Coast', 'Sunshine Coast',
                          'Toowoomba', 'Townsville', 'Cairns')    THEN 'QLD'
            WHEN city IN ('Perth', 'Fremantle',
                          'Mandurah', 'Bunbury')                  THEN 'WA'
            WHEN city IN ('Adelaide', 'Mount Gambier', 'Whyalla') THEN 'SA'
            WHEN city = 'Canberra'                                THEN 'ACT'
            WHEN city IN ('Darwin', 'Alice Springs')              THEN 'NT'
            WHEN city IN ('Hobart', 'Launceston')                 THEN 'TAS'
            ELSE NULL
        END                                                                 AS state
    FROM
        source
    WHERE city IS NOT NULL
)

SELECT * FROM dim_location