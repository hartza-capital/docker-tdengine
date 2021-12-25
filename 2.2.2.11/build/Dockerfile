FROM debian:stable-slim AS build

RUN apt-get update
RUN apt-get install -y gcc g++ make cmake git

WORKDIR /tmp

RUN git clone -b ver-2.2.2.11 https://github.com/taosdata/TDengine .
RUN cmake . && cmake --build . && make install

FROM scratch

COPY --from=build /tmp/build /build
COPY --from=build /usr/include /usr/include 