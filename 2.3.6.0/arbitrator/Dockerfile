FROM quay.io/arktos-venture/tdengine-build:2.3.6.0 AS build
FROM debian:stable-slim

LABEL org.opencontainers.image.title=arbitrator
LABEL org.opencontainers.image.description="An open-source big data platform designed and optimized for the Internet of Things (IoT)."
LABEL org.opencontainers.image.authors="Aurelien Perrier <aperrier@universe.sh>"
LABEL org.opencontainers.image.source=https://github.com/arktos-venture/docker-tdengine
LABEL org.opencontainers.image.version=2.3.6.0
# LABEL org.opencontainers.image.created={{ time "2006-01-02T15:04:05Z07:00" }}
# LABEL org.opencontainers.image.revision={{ .FullCommit }}

RUN useradd -m -u 10001 tdengine

RUN mkdir -p /var/log/taos
RUN chown -R tdengine:tdengine /var/log/taos

COPY --from=build /build/bin/tarbitrator /usr/bin/tarbitrator

WORKDIR /var/log/taos
USER tdengine

VOLUME [ "/var/log/taos" ]

EXPOSE 6042

ENTRYPOINT [ "tarbitrator", "-g", "/var/log/taos" ]