FROM node:alpine AS codeclimate

WORKDIR /work

COPY local/codeclimate-jscpd /usr/local/bin/codeclimate-jscpd
COPY local/app-package.json package.json
COPY local/engine.json ./

RUN adduser --uid 9000 --gecos "" --disabled-password app \
    && apk --no-cache add --virtual build-deps \
    jq \
    && npm i -g \
    cosmiconfig \
    glob \
    jscpd \
    && rm package.json \
    && chown -Rf app:app /usr/local/lib/node_modules \
    && VERSION="$(jscpd --version)" \
    && jq --arg version "$VERSION" '.version = $version' > /engine.json < ./engine.json \
    && rm ./engine.json \
    && apk del build-deps

USER app

VOLUME /code
WORKDIR /code

CMD ["codeclimate-jscpd"]

ARG BUILD_DATE
ARG REVISION
ARG VERSION

LABEL maintainer="Megabyte Labs <help@megabyte.space>"
LABEL org.opencontainers.image.authors="Brian Zalewski <brian@megabyte.space>"
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.description="A slim jscpd standalone linter / CodeClimate engine for GitLab CI"
LABEL org.opencontainers.image.documentation="https://github.com/megabyte-labs/codeclimate-jscpd/blob/master/README.md"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.revision=$REVISION
LABEL org.opencontainers.image.source="https://github.com/megabyte-labs/codeclimate-jscpd.git"
LABEL org.opencontainers.image.url="https://megabyte.space"
LABEL org.opencontainers.image.vendor="Megabyte Labs"
LABEL org.opencontainers.image.version=$VERSION
LABEL space.megabyte.type="codeclimate"

FROM codeclimate AS jscpd

WORKDIR /work

USER root

RUN rm -f /engine.json /usr/local/bin/codeclimate-jscpd

COPY --from=node:alpine /usr/local/lib/node_modules /usr/local/lib/node_modules

ENTRYPOINT ["jscpd"]
CMD ["--version"]

LABEL space.megabyte.type="linter"
