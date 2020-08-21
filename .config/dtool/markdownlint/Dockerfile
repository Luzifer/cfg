FROM node:alpine

ARG UID=1000

RUN set -ex \
 && yarn --cwd /tmp global add markdownlint-cli

ENTRYPOINT ["markdownlint"]
