import os
import pandas as pd
from sqlalchemy import create_engine

DB_USER = os.getenv('DB_USER')
DB_PASSWORD = os.getenv('DB_PASSWORD')
DB_HOST = os.getenv('DB_HOST')
DB_PORT = os.getenv('DB_PORT')
DB_NAME = os.getenv('DB_NAME')

engine = create_engine(
    f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

sales_df = pd.read_csv("/app/sales_data/sales_data_clothes.csv", parse_dates=['date'])

sales_df.to_sql(
    name="raw_daily_sales",
    con=engine,
    schema="bronze",
    if_exists="replace",
    index=False,
    chunksize=500
)

print(f"Ingested {len(sales_df)} rows into PostgreSQL bronze.raw_daily_sales")