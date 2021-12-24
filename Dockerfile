ARG VERSION=2.2.2.11

FROM debian:stretch-slim AS build

ARG VERSION

RUN apt-get update
RUN apt-get install -y gcc g++ unzip make cmake

WORKDIR /tmp

COPY ./code/TDengine-ver-${VERSION}.zip ./tdengine.zip
RUN unzip ./tdengine.zip -d .

RUN mv ./TDengine-ver-${VERSION} ./tdengine
RUN cd tdengine && cmake . && cmake --build .

FROM debian:stretch-slim

ARG VERSION

LABEL org.opencontainers.image.title=tdengine
LABEL org.opencontainers.image.description="An open-source big data platform designed and optimized for the Internet of Things (IoT)."
LABEL org.opencontainers.image.authors="Aurelien Perrier <aperrier@universe.sh>"
LABEL org.opencontainers.image.source=https://github.com/arktos-venture/docker-tdengine
LABEL org.opencontainers.image.version=${VERSION}
# LABEL org.opencontainers.image.created={{ time "2006-01-02T15:04:05Z07:00" }}
# LABEL org.opencontainers.image.revision={{ .FullCommit }}

RUN useradd -m -u 10001 tdengine

RUN mkdir -p /usr/lib/tdengine /var/log/taos /var/lib/taos /etc/taos
RUN chown -R tdengine:tdengine /var/log/taos /var/lib/taos /etc/taos

COPY --from=build /tmp/tdengine/build/lib/libtaos.so.${VERSION} /usr/lib/tdengine/libtaos.so
RUN echo "/usr/lib/tdengine/" > tdengine.conf 
RUN mv tdengine.conf /etc/ld.so.conf.d/tdengine.conf
RUN ldconfig

WORKDIR /home/tdengine
USER tdengine

COPY --chown=tdengine:tdengine --from=build /tmp/tdengine/build/bin/taos .
COPY --chown=tdengine:tdengine --from=build /tmp/tdengine/build/bin/taosd .
COPY --chown=tdengine:tdengine --from=build /tmp/tdengine/build/bin/taosdump .

COPY --chown=tdengine:tdengine ./taos.cfg /etc/taos/taos.cfg

VOLUME [ "/var/lib/taos", "/var/log/taos" ]

ENTRYPOINT [ "./taosd" ]