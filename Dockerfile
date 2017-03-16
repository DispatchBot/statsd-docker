FROM node:6.10.0-alpine

ENV STATSD_PORT 8125
ENV STATSD_DUMP_MSG false
ENV STATSD_DEBUG false
ENV STATSD_FLUSH_INTERVAL 10000
ENV ELASTICSEARCH_PORT 9200

EXPOSE 8125/udp

RUN mkdir /etc/statsd

RUN wget https://s3.amazonaws.com/dispatchbot-devops/ca-chain.cert.pem && \
  mv ca-chain.cert.pem /usr/local/share/ca-certificates/dispatchbot-ca-chain.cert.crt && \
  cp /usr/local/share/ca-certificates/dispatchbot-ca-chain.cert.crt /etc/ssl/certs/. && \
  update-ca-certificates

RUN apk update && \
  apk add git && \
  git clone git://github.com/etsy/statsd.git /usr/local/src/statsd && \
  npm install git://github.com/DispatchBot/statsd-elasticsearch-backend.git && \
  apk del git

WORKDIR /usr/local/src/statsd

ADD config.js /etc/statsd/statsd.js

CMD node /usr/local/src/statsd/stats.js /etc/statsd/statsd.js
