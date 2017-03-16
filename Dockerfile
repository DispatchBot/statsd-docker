FROM node:6.10.0-alpine

ENV STATSD_PORT 8125
ENV STATSD_DUMP_MSG false
ENV STATSD_DEBUG false
ENV STATSD_FLUSH_INTERVAL 10000
ENV ELASTICSEARCH_PORT 9200

EXPOSE 8125/udp

RUN mkdir /etc/statsd

RUN apk update && \
  apk add git && \
  git clone git://github.com/etsy/statsd.git /usr/local/src/statsd && \
  apk del git

WORKDIR /usr/local/src/statsd
RUN npm install git://github.com/markkimsal/statsd-elasticsearch-backend.git

ADD config.js /etc/statsd/statsd.js

CMD node /usr/local/src/statsd/stats.js /etc/statsd/statsd.js
