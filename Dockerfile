FROM crystallang/crystal:1.16.3-alpine as base

RUN apk add sqlite-dev

WORKDIR /twitch-event-proxy

FROM base as dev

COPY shard* .

RUN shards install

FROM dev as build

COPY . .

RUN shards build --production --release --progress

FROM base as release

COPY --from=build /twitch-event-proxy/bin/twitch-event-proxy .

CMD [ "/twitch-event-proxy/twitch-event-proxy" ]

EXPOSE 3000