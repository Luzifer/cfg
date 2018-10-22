FROM alpine:3.8

ARG UID=1000

RUN set -ex \
 && adduser -u $UID -D work \
 && apk add --no-update imagemagick

