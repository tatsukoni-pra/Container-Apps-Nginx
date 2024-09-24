FROM nginx:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
  procps \
  vim \
  jq \
  dumb-init && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/app
COPY . /var/www/app
RUN chmod +x /var/www/app/container_start.sh

EXPOSE 80

ENTRYPOINT [ "dumb-init", "/var/www/app/container_start.sh" ]
