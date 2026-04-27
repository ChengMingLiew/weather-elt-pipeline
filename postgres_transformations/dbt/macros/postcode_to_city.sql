{% macro postcode_to_city(postcode_col) %}
CASE
    -- NSW
    WHEN {{ postcode_col }} BETWEEN 2000 AND 2099 THEN 'Sydney'
    WHEN {{ postcode_col }} BETWEEN 2100 AND 2145 THEN 'Sydney'
    WHEN {{ postcode_col }} BETWEEN 2150 AND 2166 THEN 'Parramatta'
    WHEN {{ postcode_col }} BETWEEN 2167 AND 2177 THEN 'Liverpool'
    WHEN {{ postcode_col }} BETWEEN 2200 AND 2234 THEN 'Sydney'
    WHEN {{ postcode_col }} BETWEEN 2560 AND 2570 THEN 'Sydney'
    WHEN {{ postcode_col }} IN (2558, 2559)        THEN 'Liverpool'
    WHEN {{ postcode_col }} BETWEEN 2740 AND 2770 THEN 'Penrith'
    WHEN {{ postcode_col }} BETWEEN 2278 AND 2340 THEN 'Newcastle'
    WHEN {{ postcode_col }} BETWEEN 2259 AND 2267 THEN 'Newcastle'
    WHEN {{ postcode_col }} BETWEEN 2500 AND 2530 THEN 'Wollongong'
    -- VIC
    WHEN {{ postcode_col }} BETWEEN 3000 AND 3198 THEN 'Melbourne'
    WHEN {{ postcode_col }} BETWEEN 3800 AND 3810 THEN 'Melbourne'
    WHEN {{ postcode_col }} BETWEEN 3770 AND 3799 THEN 'Melbourne'
    WHEN {{ postcode_col }} BETWEEN 3199 AND 3201 THEN 'Frankston'
    WHEN {{ postcode_col }} BETWEEN 3930 AND 3944 THEN 'Frankston'
    WHEN {{ postcode_col }} BETWEEN 3211 AND 3222 THEN 'Geelong'
    WHEN {{ postcode_col }} BETWEEN 3224 AND 3241 THEN 'Geelong'
    WHEN {{ postcode_col }} BETWEEN 3350 AND 3357 THEN 'Ballarat'
    WHEN {{ postcode_col }} BETWEEN 3550 AND 3560 THEN 'Bendigo'
    -- QLD
    WHEN {{ postcode_col }} BETWEEN 4000 AND 4179 THEN 'Brisbane'
    WHEN {{ postcode_col }} BETWEEN 4280 AND 4306 THEN 'Brisbane'
    WHEN {{ postcode_col }} BETWEEN 4205 AND 4208 THEN 'Brisbane'
    WHEN {{ postcode_col }} BETWEEN 4209 AND 4228 THEN 'Gold Coast'
    WHEN {{ postcode_col }} = 4270                THEN 'Gold Coast'
    WHEN {{ postcode_col }} BETWEEN 4550 AND 4575 THEN 'Sunshine Coast'
    WHEN {{ postcode_col }} BETWEEN 4350 AND 4352 THEN 'Toowoomba'
    WHEN {{ postcode_col }} BETWEEN 4810 AND 4825 THEN 'Townsville'
    WHEN {{ postcode_col }} BETWEEN 4868 AND 4879 THEN 'Cairns'
    -- WA
    WHEN {{ postcode_col }} BETWEEN 6159 AND 6164 THEN 'Fremantle'
    WHEN {{ postcode_col }} BETWEEN 6210 AND 6215 THEN 'Mandurah'
    WHEN {{ postcode_col }} BETWEEN 6230 AND 6233 THEN 'Bunbury'
    WHEN {{ postcode_col }} BETWEEN 6000 AND 6199 THEN 'Perth'
    -- SA
    WHEN {{ postcode_col }} = 5290                THEN 'Mount Gambier'
    WHEN {{ postcode_col }} BETWEEN 5600 AND 5608 THEN 'Whyalla'
    WHEN {{ postcode_col }} BETWEEN 5000 AND 5199 THEN 'Adelaide'
    -- ACT
    WHEN {{ postcode_col }} BETWEEN 2600 AND 2620 THEN 'Canberra'
    WHEN {{ postcode_col }} BETWEEN 2900 AND 2914 THEN 'Canberra'
    -- NT
    WHEN {{ postcode_col }} BETWEEN 800  AND 832  THEN 'Darwin'
    WHEN {{ postcode_col }} BETWEEN 870  AND 872  THEN 'Alice Springs'
    -- TAS
    WHEN {{ postcode_col }} BETWEEN 7000 AND 7054 THEN 'Hobart'
    WHEN {{ postcode_col }} BETWEEN 7150 AND 7171 THEN 'Hobart'
    WHEN {{ postcode_col }} BETWEEN 7248 AND 7325 THEN 'Launceston'
    ELSE NULL
END
{% endmacro %}