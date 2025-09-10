FROM python:3.11
WORKDIR /app
COPY . .
RUN pip install --upgrade pip && pip install -r requirements.txt && rm -rf /root/.cache/pip
EXPOSE 8000
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
CMD ["/bin/bash", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]