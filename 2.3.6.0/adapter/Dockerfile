FROM quay.io/arktos-venture/tdengine-build:v2.3.6.0 AS build
FROM debian:stable-slim

ARG VERSION

LABEL org.opencontainers.image.title=tdengine
LABEL org.opencontainers.image.description="An open-source big data platform designed and optimized for the Internet of Things (IoT)."
LABEL org.opencontainers.image.authors="Aurelien Perrier <aperrier@universe.sh>"
LABEL org.opencontainers.image.source=https://github.com/arktos-venture/docker-tdengine
LABEL org.opencontainers.image.version=2.3.6.0
# LABEL org.opencontainers.image.created={{ time "2006-01-02T15:04:05Z07:00" }}
# LABEL org.opencontainers.image.revision={{ .FullCommit }}

RUN useradd -m -u 10001 tdengine

RUN mkdir -p /usr/lib/tdengine /var/log/taos /var/lib/taos /etc/taos
RUN chown -R tdengine:tdengine /var/log/taos /var/lib/taos /etc/taos

WORKDIR /home/tdengine
USER tdengine

COPY --chown=tdengine:tdengine --from=build /build/bin/taosadapter .

ENTRYPOINT [ "./taosadapter" ]