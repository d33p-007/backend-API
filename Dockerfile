# Use an official, lightweight Python runtime
FROM python:3.11-slim-buster

# Optimize Python inside Docker container
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory inside the container
WORKDIR /app

# Copy requirements file first to maximize build layer caching
COPY app/requirements.txt .

# Install Python requirements and production server
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application files (app.py, templates/, static/)
COPY app/ .

# Create a non-root system user for GCP security baseline compliance
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser


# Cloud Run injects the PORT variable at runtime.
# We map Gunicorn to listen to "$PORT" dynamically instead of hardcoding 5000.
CMD exec gunicorn --bind 0.0.0.0:$PORT --workers 1 --threads 8 --timeout 0 app:app