# docker-django

## Simple run
```
docker run -p 8000:8000 -v /local/path/to/django:/app/src bitwolff/django
```

## Production
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

Install and settings nginx with Let's Encrypt
```
server {
    listen 80;
    server_name mysite.com;

    location /.well-known {
        root /var/www/html;
    }

    return 301 https://mysite.com$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    server_name mysite.com;

    ssl on;
    ssl_certificate /etc/letsencrypt/live/mysite.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/mysite.com/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/mysite.com/chain.pem;

    ssl_stapling on;
    ssl_stapling_verify on;
    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 10s;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_session_cache shared:SSL:5m;
    ssl_session_timeout 10m;
    ssl_buffer_size 16k;

    ssl_prefer_server_ciphers  on;
    ssl_ciphers EECDH:+AES256:-3DES:RSA+AES:RSA+3DES:!NULL:!RC4;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;

    include /etc/nginx/gzip;

    location /static {
        root /path/to/django;
        access_log   off;
        expires      30d;
    }

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header X-Real-IP  $remote_addr;
        proxy_set_header REMOTE_ADDR $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Forwarded-Port 443;
        proxy_set_header Host $host;
    }
}
```
