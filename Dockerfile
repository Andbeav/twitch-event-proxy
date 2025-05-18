FROM crystallang/crystal:1.16.3-alpine

RUN apk add sqlite-dev

WORKDIR /twitch-event-proxy

COPY . .

RUN shards install

EXPOSE 3000