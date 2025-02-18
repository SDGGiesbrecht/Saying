FROM ubuntu:20.04
RUN apt-get update --assume-yes
RUN DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes build-essential pkg-config
RUN DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes libglib2.0-dev
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
