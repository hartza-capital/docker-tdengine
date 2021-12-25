FROM debian:stable-slim

RUN apt-get update
RUN apt-get install -y gcc g++ unzip make cmake

WORKDIR /tmp

COPY ./code.zip ./tdengine.zip
RUN unzip ./tdengine.zip -d .

RUN mv ./TDengine-ver-2.2.2.11 ./tdengine
RUN cd tdengine && cmake . && cmake --build .