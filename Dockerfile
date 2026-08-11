FROM python as builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip \
 && pip install --prefix=/install -r requirements.txt

FROM python:3.10-slim
WORKDIR /app
ENV PYTHONUNBUFFERED=1
COPY --from=builder /install /usr/local
COPY . .
EXPOSE 8000
CMD python manage.py migrate && gunicorn notesapp.wsgi:application --bind 0.0.0.0:8000
