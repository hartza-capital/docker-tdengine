FROM golang:1.14 AS build

RUN apt-get update
RUN apt-get install -y gcc g++ make cmake git libjansson-dev libsnappy-dev liblzma-dev libz-dev pkg-config

WORKDIR /go/src/github.com/taosdata/TDengine

RUN git clone -b ver-2.3.6.0 https://github.com/taosdata/TDengine .
RUN git submodule update --init --recursive

RUN cmake . && cmake --build . && make install
RUN cd ./src/plugins/taosadapter && go build -o /go/src/github.com/taosdata/TDengine/build/bin/taosadapter

FROM scratch

COPY --from=build /go/src/github.com/taosdata/TDengine/build /build
COPY --from=build /usr/include /usr/include 