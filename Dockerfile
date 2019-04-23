# pull official base image
FROM python:3.7-alpine

RUN apk update && apk add libpq && pip install --upgrade pip && pip install --upgrade pipenv

RUN apk add --no-cache --virtual .build-deps \
    gcc \
    python3-dev \
    musl-dev \
    postgresql-dev \
    && pip install --no-cache-dir psycopg2 \
    && apk del --no-cache .build-deps

RUN addgroup -S -g 1001 app && adduser -S -D -h /app -u 1001 -G app app

# set environment varibles
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN mkdir -p /app/src
WORKDIR /app/src

RUN chown -R app.app /app/

COPY Pipfile Pipfile.lock /app/src/

# install dependencies
RUN pipenv install --deploy --system

# Server
EXPOSE 8000

#STOPSIGNAL SIGINT
#ENTRYPOINT ["python", "manage.py"]
#CMD ["runserver", "0.0.0.0:8000"]
