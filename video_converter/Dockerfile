FROM debian:stable-slim

RUN apt update && apt-get install -y
RUN apt install ffmpeg file -y

WORKDIR /workspace
ADD script.sh ../script.sh
RUN chmod +x ../script.sh

ENV MEDIA_POOL=data
ENV BIN=bin
ENV CONVERTED_TAG=converted
ENV END_TIME=5

ENTRYPOINT ["../script.sh"]