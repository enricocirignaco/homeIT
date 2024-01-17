FROM debian:stable-slim

RUN apt update && apt-get install -y
RUN apt install ffmpeg file -y

WORKDIR /workspace
#build image
#docker build -t ffmpeg .

#build container
#docker run -it --name videoconverter -v $(pwd):/workspace ffmpeg
