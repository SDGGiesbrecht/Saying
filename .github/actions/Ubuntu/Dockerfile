FROM ubuntu:20.04
RUN apt-get update --assume-yes
RUN apt-get install --assume-yes gcc
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
