import openmeteo_requests
import pandas as pd
import requests_cache
import os
from retry_requests import retry
from sqlalchemy import create_engine

DB_USER     = os.getenv('DB_USER')
DB_PASSWORD = os.getenv('DB_PASSWORD')
DB_HOST     = os.getenv('DB_HOST')
DB_PORT     = os.getenv('DB_PORT')
DB_NAME     = os.getenv('DB_NAME')

engine = create_engine(
    f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

cache_session = requests_cache.CachedSession('.cache', expire_after=-1)
retry_session = retry(cache_session, retries=5, backoff_factor=0.2)
openmeteo = openmeteo_requests.Client(session=retry_session)

url = "https://archive-api.open-meteo.com/v1/archive"
params = {
    "latitude": [
		# NSW
		-33.8688, -33.8148, -33.9200, -33.7510, -32.9283, -34.4278,
		# VIC
		-37.8136, -38.1499, -37.5622, -36.7570, -38.1440,
		# QLD
		-27.4698, -28.0167, -26.6500, -19.2590, -16.9186, -27.5598,
		# WA
		-31.9505, -32.0569, -32.5270, -33.3271,
		# SA
		-34.9285, -37.8318, -33.0350,
		# ACT
		-35.2809,
		# NT
		-12.4634, -23.6980,
		# TAS
		-42.8821, -41.4332,
	],
	"longitude": [
		# NSW
		151.2093, 151.0017, 150.9200, 150.6942, 151.7817, 150.8931,
		# VIC
		144.9631, 144.3617, 143.8503, 144.2794, 145.1260,
		# QLD
		153.0251, 153.4000, 153.0667, 146.8169, 145.7781, 151.9507,
		# WA
		115.8605, 115.7439, 115.7210, 115.6414,
		# SA
		138.6007, 140.7795, 137.5847,
		# ACT
		149.1300,
		# NT
		130.8456, 133.8807,
		# TAS
		147.3272, 147.1441,
	],
    "start_date": "2025-01-01",
    "end_date":   "2025-12-31",
    "daily": [
        "weather_code",
        "temperature_2m_mean",
        "temperature_2m_max",
        "apparent_temperature_mean",
        "rain_sum",
        "precipitation_sum",
        "precipitation_hours",
        "wind_speed_10m_max",
        "wind_gusts_10m_max"
    ],
}

cities = [
    # NSW
    "Sydney", "Parramatta", "Liverpool", "Penrith", "Newcastle", "Wollongong",
    # VIC
    "Melbourne", "Geelong", "Ballarat", "Bendigo", "Frankston",
    # QLD
    "Brisbane", "Gold Coast", "Sunshine Coast", "Townsville", "Cairns", "Toowoomba",
    # WA
    "Perth", "Fremantle", "Mandurah", "Bunbury",
    # SA
    "Adelaide", "Mount Gambier", "Whyalla",
    # ACT
    "Canberra",
    # NT
    "Darwin", "Alice Springs",
    # TAS
    "Hobart", "Launceston",
]

responses = openmeteo.weather_api(url, params=params)

for i, response in enumerate(responses):
    print(f"\nProcessing {cities[i]}")
    print(f"Coordinates: {response.Latitude()}°N {response.Longitude()}°E")
    print(f"Elevation: {response.Elevation()} m asl")

    daily = response.Daily()
    daily_data = {
        "date": pd.date_range(
            start=pd.to_datetime(daily.Time(), unit="s", utc=True),
            end=pd.to_datetime(daily.TimeEnd(), unit="s", utc=True),
            freq=pd.Timedelta(seconds=daily.Interval()),
            inclusive="left"
        ),
        "weather_code":               daily.Variables(0).ValuesAsNumpy(),
        "temperature_2m_mean":        daily.Variables(1).ValuesAsNumpy(),
        "temperature_2m_max":         daily.Variables(2).ValuesAsNumpy(),
        "apparent_temperature_mean":  daily.Variables(3).ValuesAsNumpy(),
        "rain_sum":                   daily.Variables(4).ValuesAsNumpy(),
        "precipitation_sum":          daily.Variables(5).ValuesAsNumpy(),
        "precipitation_hours":        daily.Variables(6).ValuesAsNumpy(),
        "wind_speed_10m_max":         daily.Variables(7).ValuesAsNumpy(),
        "wind_gusts_10m_max":         daily.Variables(8).ValuesAsNumpy(),
    }

    daily_dataframe = pd.DataFrame(data=daily_data)
    daily_dataframe['city'] = cities[i]

    daily_dataframe.to_sql(
        name="raw_daily_weather",
        con=engine,
        if_exists="append",
        schema='bronze',
        index=False
    )
    print(f"Loaded {len(daily_dataframe)} rows for {cities[i]}")