FROM python:3.11-slim

WORKDIR /app

COPY ingestion.py .
COPY requirements.txt .

RUN pip install -r requirements.txt
RUN pip install openmeteo-requests
RUN pip install requests-cache retry-requests numpy pandas

CMD [ "python", "ingestion.py" ]
