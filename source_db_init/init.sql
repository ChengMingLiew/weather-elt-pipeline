CREATE TABLE IF NOT EXISTS bronze_raw_hourly_weather(
    temperature_2m DECIMAL,
    date TIMESTAMP WITH TIME ZONE,
    wind_speed_10m DECIMAL,
    cloud_cover_mid DECIMAL,
    precipitation DECIMAL,
    relative_humidity_2m DECIMAL,
    apparent_temperature DECIMAL,
    city VARCHAR(50)
);