FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
COPY postgresload.sh .
COPY sales_ingestion.py .
COPY weather_ingestion.py .

RUN pip install -r requirements.txt
RUN pip install openmeteo-requests
RUN pip install requests-cache retry-requests numpy pandas
RUN chmod +x postgresload.sh

CMD [ "./postgresload.sh" ]
