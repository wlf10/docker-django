# docker-django

Create Dockerfile in Django project
```
FROM bitwolff/django:latest

WORKDIR /app/src
COPY . /app/src/
```

Create docker-composer
```
version: '3'

services:
  web:
    restart: always
    build: ./app/
    command: gunicorn app.wsgi:application --bind 0.0.0.0:8000
    ports:
      - 8000:8000
    environment:
      - DB_USER=user_name
      - DB_NAME=db_name
      - DB_PASSWORD=password
      - DB_HOST=localhost
      - DB_PORT=5432
      - SECRET_KEY=a1a6&ze3zgmwje4xzvm5931c9q%ijy6w&qs&rtazcvg&hs7mii
```

Run
```
docker-compose up -d --force-recreate --build
```
