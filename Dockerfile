# Use a slim Python base for small image size
FROM python:3.12.8-slim

# Set work directory inside container
WORKDIR /pki_mn_cal

# Install system dependencies (if your CSV parsing needs extra libs)
# Add curl/netcat ONLY if you plan health checks or debugging
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
 && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# Copy API source code (no CouchDB config now)
COPY app.py ./
# Copy your DATA directory with ship/tank CSV files
COPY DATA ./DATA

# Expose FastAPI default port
EXPOSE 8002

# Use uvicorn with explicit reload off for production
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8002"]

