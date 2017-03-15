FROM node:6.10.0-alpine

RUN apk update && \
  apk add git && \
  git clone git://github.com/etsy/statsd.git /usr/local/src/statsd && \
  apk del git

RUN mkdir /etc/statsd

ADD config.js /etc/stastd/statsd.js

ENV GRAPHITE_GLOBAL_PREFIX stats
ENV GRAPHITE_LEGACY_NAMESPACE false

ENV STATSD_PORT 8125
ENV STATSD_DUMP_MSG false
ENV STATSD_DEBUG false
ENV STATSD_FLUSH_INTERVAL 10000

EXPOSE 8125/udp

CMD node /usr/local/src/statsd/stats.js /etc/default/statsd.js
