FROM python:3.11

# Install system dependencies for SSL
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements and install Python packages
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt && rm -rf /root/.cache/pip

# Copy application code
COPY mysite/ .

# SSL Certificate Configuration
# Copy your custom certificate
COPY MyCertAuth.crt /usr/share/ca-certificates/
RUN echo MyCertAuth.crt >> /etc/ca-certificates.conf

# Update CA certificates
RUN update-ca-certificates

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
ENV SSL_CERT_DIR=/etc/ssl/certs

EXPOSE 8000

CMD ["/bin/bash", "-c", "python manage.py runserver 0.0.0.0:8000"]