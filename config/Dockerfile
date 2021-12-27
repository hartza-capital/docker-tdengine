FROM golang:1.17.5 AS build

RUN useradd -m -u 10001 tdengine

RUN mkdir -p /etc/taos && touch /etc/taos/taos.cfg

WORKDIR /go/src/github.com/arktos-venture/docker-tdengine/config
COPY . .
RUN env GOOS=linux GOARCH=amd64 go build -ldflags "-s -w" -o init-config


FROM scratch

LABEL org.opencontainers.image.title=init-config
LABEL org.opencontainers.image.description="An open-source big data platform designed and optimized for the Internet of Things (IoT)."
LABEL org.opencontainers.image.authors="Aurelien Perrier <aperrier@universe.sh>"
LABEL org.opencontainers.image.source=https://github.com/arktos-venture/docker-tdengine
LABEL org.opencontainers.image.version=2.3.6.0
# LABEL org.opencontainers.image.created={{ time "2006-01-02T15:04:05Z07:00" }}
# LABEL org.opencontainers.image.revision={{ .FullCommit }}

COPY --from=build /etc/passwd /etc/passwd

USER tdengine

COPY --chown=tdengine --from=build /etc/taos/taos.cfg /etc/taos/taos.cfg
COPY --chown=tdengine --from=build /go/src/github.com/arktos-venture/docker-tdengine/config/init-config .

ENTRYPOINT [ "./init-config" ]