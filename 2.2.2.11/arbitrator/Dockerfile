FROM quay.io/arktos-venture/tdengine-build:2.2.2.11 AS build
FROM debian:stable-slim

ARG VERSION

LABEL org.opencontainers.image.title=tdengine
LABEL org.opencontainers.image.description="An open-source big data platform designed and optimized for the Internet of Things (IoT)."
LABEL org.opencontainers.image.authors="Aurelien Perrier <aperrier@universe.sh>"
LABEL org.opencontainers.image.source=https://github.com/arktos-venture/docker-tdengine
LABEL org.opencontainers.image.version=2.2.2.11
# LABEL org.opencontainers.image.created={{ time "2006-01-02T15:04:05Z07:00" }}
# LABEL org.opencontainers.image.revision={{ .FullCommit }}

RUN useradd -m -u 10001 tdengine

RUN mkdir -p /var/log/taos
RUN chown -R tdengine:tdengine /var/log/taos

WORKDIR /home/tdengine
USER tdengine

COPY --chown=tdengine:tdengine --from=build /build/bin/tarbitrator .

VOLUME [ "/var/log/taos" ]

EXPOSE 6042

ENTRYPOINT [ "./tarbitrator", "-g", "/var/log/taos" ]