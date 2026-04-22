CREATE SCHEMA IF NOT EXISTS bronze;

DROP TABLE IF EXISTS bronze.raw_daily_weather;
DROP TABLE IF EXISTS bronze.raw_daily_sales;

CREATE TABLE IF NOT EXISTS bronze.raw_daily_weather(
    weather_code VARCHAR(10),
    date TIMESTAMP WITH TIME ZONE,
    wind_speed_10m_max DECIMAL,
    temperature_2m_mean DECIMAL,
    temperature_2m_max DECIMAL,
    rain_sum DECIMAL,
    apparent_temperature_mean DECIMAL,
    precipitation_sum DECIMAL,
    precipitation_hours DECIMAL,
    wind_gusts_10m_max DECIMAL,
    city VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS bronze.raw_daily__sales(
    date DATE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL,
    product_name VARCHAR(50),
    creditcard_num VARCHAR(20),
    creditcard_type VARCHAR(20),
    currency VARCHAR(10),
    address VARCHAR(50),
    address_line_2 VARCHAR(50)
);

